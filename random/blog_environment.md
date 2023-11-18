# blog environment

本文记录一下重新搭建博客环境的方法

安装 Node js 与 npm

```bash
sudo apt update
sudo apt install nodejs
sudo apt install npm
```

安装  Hexo

```bash
sudo npm install -g hexo-cli
```

克隆代码

```bash
git clone -b MyBlog2021 https://github.com/solidSpoon/solidSpoon.github.io.git
```

下载 npm 模块

```bash
cd solidSpoon.github.io
npm install
```

GitHub SSH Key

[Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```powershell
ssh-keygen -t ed25519 -C "cedarrival@outlook.com"
```

