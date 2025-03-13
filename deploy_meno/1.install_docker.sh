# step 1: 安装必要的一些系统工具
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# step 2: 安装GPG证书
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo apt-key add -
# Step 3: 写入软件源信息
# sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable"
sudo add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] http://mirrors.cloud.aliyuncs.com/docker-ce/linux/debian $(lsb_release -cs) stable"
# Step 4: 更新并安装Docker-CE
sudo apt-get -y update
sudo apt-get -y install docker-ce

sudo usermod -aG docker ecs-user
newgrp docker

# 阿里云cr已经托管了镜像，所以无需做以下设置。
sudo tee /etc/docker/daemon.json << EOF
{
  "proxies": {
    "http-proxy": "socks5://127.0.0.1:1081",
    "https-proxy": "socks5://127.0.0.1:1081",
    "no-proxy": "*.test.example.com,.example.org,registry-vpc.cn-chengdu.aliyuncs.com,dockerauth-vpc.cn-chengdu.aliyuncs.com"
  }
}
EOF

sudo systemctl restart docker

docker pull nginx

# 采用了github ssh，所以不做git认证方式设置。
git config --global credential.helper store
