# AGENTS.md

## 通用约定

- 用中文交流和总结。
- 修改前先检查工作树，避免覆盖用户已有改动。
- 只改与当前任务相关的文件；不要触碰无关的 dirty files。
- 手工编辑文件使用 `apply_patch`。
- 优先遵循仓库既有目录结构、命名方式、Makefile 入口和构建参数，不为单次修改引入新的组织方式。

## Dockerfile 约定

- 保留仓库现有构建参数，尤其是：
  - `ARG IMAGE_MIRROR`
  - `ARG APT_REPOSITORY`
- 不要在 Dockerfile 中写死私有镜像域名，例如 `docker.le2.tech`。
- 不要写死 Dockerfile `# syntax=...` 镜像地址；该 directive 不支持 `ARG` 变量展开。
- 基础镜像变更要谨慎，优先选择明确版本或 slim 变体，避免无意扩大运行时行为差异。
- 安装 Debian 包时使用 `--no-install-recommends`；如果没有把 `/var/lib/apt` 作为 BuildKit cache mount，应在同一层清理 apt lists 和临时文件。
- 如需 apt 构建缓存，优先使用当前 Docker/BuildKit 默认 frontend 支持的写法：
  - `RUN --mount=type=cache,target=/var/cache/apt,sharing=locked`
  - `RUN --mount=type=cache,target=/var/lib/apt,sharing=locked`
- 使用 `/var/lib/apt` cache mount 时，不要在同一层删除 `/var/lib/apt/lists/*`，避免清空 apt metadata cache；必要时对 `DL3009` 做局部 hadolint ignore 并说明原因。
- 对非多阶段的运行镜像，不要为了 apt cache mount 删除 `/etc/apt/apt.conf.d/docker-clean`；保留 Debian/官方镜像默认清理策略，避免派生镜像后续 `apt install` 留下 `.deb` 缓存。
- 只有在独立 builder 阶段、或明确需要跨构建复用 apt 下载缓存且不会作为运行基础镜像继续派生时，才评估移除 `/etc/apt/apt.conf.d/docker-clean`。
- 下载源码或二进制产物时，优先保留版本参数和校验参数，例如版本号 `ARG`、SHA256 校验等。
- 不随意改变镜像对外接口，包括 `EXPOSE`、`USER`、`ENTRYPOINT`、`CMD`、`VOLUME`、工作目录和默认挂载路径。

## 镜像瘦身判断

- 先用 `docker history <image> --no-trunc` 和容器内 `du`、`dpkg-query` 定位真实大头，再决定优化方向。
- 如果 apt lists/cache 已经很小，继续清理 `/var/lib/apt/lists` 对最终镜像体积帮助有限，不应作为主要优化点。
- 优先评估基础镜像、apt 安装层、运行时依赖和大体积单文件工具，而不是只做表面清理。
- 如果只需要某个工具的少量二进制能力，可以评估 multi-stage build，只复制运行所需二进制和动态库；同时权衡维护成本。
- 对大体积单文件工具可以评估 UPX 压缩；注意启动性能、安全扫描兼容性和运行环境兼容性风险。
- 如果业务流程不再依赖某个大体积工具，移除它通常比继续清理缓存收益更明显。

## 构建与验证

- 优先使用对应目录已有的 `make build`、`make check`、`make test` 等入口验证，不绕开仓库既有流程。
- 修改 Dockerfile 后，如本地可用 `hadolint`，优先运行 `hadolint <Dockerfile>` 做静态检查；确需忽略的规则应局部说明原因。
- Docker 构建失败时先区分失败阶段：解析 frontend、拉取基础镜像、安装依赖、编译、运行时验证等。
- 涉及字体、locale、命令行工具或服务二进制的镜像，应在构建期或运行后增加针对性验证命令。
- 如果验证命令会改写仓库样例或产物，优先复制到临时目录再挂载验证。
- 非 TTY 环境下运行 `docker run -it` 可能失败；必要时使用等价的非交互命令验证。
- 完成修改后至少运行与改动范围匹配的最小验证；如果无法验证，要在总结中说明原因和失败阶段。

## 文档维护

- `AGENTS.md` 应保持通用、可复用，不记录某个特定 Dockerfile 的临时决策、历史总结或一次性排障结果。
- 特定镜像的设计取舍、排障记录和验收细节，应放在对应目录的 README、注释、提交信息或任务总结中。
- 新增规则应描述稳定约束或长期偏好，避免写入只适用于单个镜像、单次构建或单个网络环境的内容。
