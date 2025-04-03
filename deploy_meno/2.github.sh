# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux


sudo apt-get install socat

ssh-keygen -t ed25519 -C "prod@le2.ltd"
ssh-keygen -t ed25519 -C "prod1@le2.fun"

# Generating public/private ed25519 key pair.
# Enter file in which to save the key (/home/ecs-user/.ssh/id_ed25519):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
# Your identification has been saved in /home/ecs-user/.ssh/id_ed25519
# Your public key has been saved in /home/ecs-user/.ssh/id_ed25519.pub
# The key fingerprint is:
# SHA256:Lv4QosKC6SNO1vlkVQ11wvf46aypzvdZswkJ2pKIHMw su@demo.com
# The key's randomart image is:
# +--[ED25519 256]--+
# |         .oo .   |
# |          o.o.   |
# |         . .. o  |
# |    o   .    . . |
# |    .E..S  .  . .|
# |o...o.+o. + . .o |
# |=+.o =o..+ . oo..|
# |*o  +. o  o  .oo*|
# |oo.  .... .+ooo= |
# +----[SHA256]-----+

cat ~/.ssh/id_ed25519.pub

# https://github.com/settings/keys

vim ~/.ssh/config

Host github.com
  HostName github.com
  User git
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_ed25519
  ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=1081

# git clone ssh://dfile/home/gitrepo/dfile.git

ssh -T github.com
# The authenticity of host 'github.com (20.205.243.166)' can't be established.
# ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
# This key is not known by any other names.
# Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
# Hi coolcry! You've successfully authenticated, but GitHub does not provide shell access.
