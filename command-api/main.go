package main

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

// Request 定义客户端请求格式，binding:"required" 确保字段必填
type Request struct {
	Cmd  string   `json:"cmd" binding:"required"`
	Args []string `json:"args"`
}

// whitelist 存储允许的命令列表，whitelistEnabled 指示是否启用白名单
var (
	whitelist        map[string]bool
	whitelistEnabled bool
)

func init() {
	// 从环境变量读取白名单，使用逗号分隔
	if env := os.Getenv("WHITELIST_CMDS"); env != "" {
		whitelistEnabled = true
		whitelist = make(map[string]bool)
		for _, cmd := range strings.Split(env, ",") {
			cmd = strings.TrimSpace(cmd)
			if cmd != "" {
				whitelist[cmd] = true
			}
		}
	}
}

func main() {
	r := gin.Default()
	r.POST("/execute", executeHandler)
	r.Run()
}

// executeHandler 流式执行命令，若启用白名单则校验
func executeHandler(c *gin.Context) {
	var req Request
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 如果启用了白名单，则验证命令
	if whitelistEnabled {
		if !whitelist[req.Cmd] {
			c.JSON(http.StatusForbidden, gin.H{"error": fmt.Sprintf("command '%s' not allowed", req.Cmd)})
			return
		}
	}

	// 使用带超时的上下文，防止命令无限挂起（可根据需求调整）
	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Minute)
	defer cancel()

	cmd := exec.CommandContext(ctx, req.Cmd, req.Args...)

	// 获取输出管道
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// 启动命令
	if err := cmd.Start(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// 流式输出
	reader := bufio.NewReader(io.MultiReader(stdout, stderr))
	c.Writer.Header().Set("Content-Type", "text/plain; charset=utf-8")
	c.Writer.Header().Set("Transfer-Encoding", "chunked")
	c.Stream(func(w io.Writer) bool {
		line, err := reader.ReadString('\n')
		if len(line) > 0 {
			w.Write([]byte(line))
		}
		return err == nil
	})

	// 等待命令完成
	cmd.Wait()
}
