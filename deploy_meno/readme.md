

https://developer.aliyun.com/mirror/

sudo systemctl status docker

sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker-registry-cf.le2.tech"]
}
EOF

sudo systemctl daemon-reload && sudo systemctl restart docker


sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker-registry-cf.le2.tech","https://pkpmv3vv.mirror.aliyuncs.com"]
}
EOF

sudo docker system prune -a

time sudo docker pull nginx

sudo usermod -aG docker ecs-user
newgrp docker

安装指定版本的Docker-CE:
Step 1: 查找Docker-CE的版本:
apt-cache madison docker-ce
  docker-ce | 17.03.1~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
  docker-ce | 17.03.0~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
Step 2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.1~ce-0~ubuntu-xenial)
sudo apt-get -y install docker-ce=[VERSION]

cd /etc/apt/sources.list.d/
cat /etc/apt/sources.list

http://mirrors.cloud.aliyuncs.com/debian/

sudo apt-get -y remove docker-ce

https://developer.aliyun.com/mirror/

sudo rm -rf /var/lib/{apt,dpkg,cache,log}/
sudo rm -fr /var/cache/*


{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "debug": true,
  "experimental": false,
  "registry-mirrors": [
    "https://docker-registry-cf.le2.tech"
  ],
  "proxies": {
    "http-proxy": "http://host.docker.internal:20171",
    "https-proxy": "http://host.docker.internal:20171",
    "no-proxy": "*.test.example.com,.example.org,registry-vpc.cn-chengdu.aliyuncs.com,dockerauth-vpc.cn-chengdu.aliyuncs.com"
  }
}

curl -x socks5h://127.0.0.1:1088 https://www.google.com/
curl -x socks5h://127.0.0.1:1088 https://hub.docker.com/

curl --socks5-hostname 127.0.0.1:18088 https://www.google.com/
