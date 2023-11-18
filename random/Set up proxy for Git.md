# Set up proxy for Git

# Windows

[Windows 下为 Git 设置代理](https://solidspoon.xyz/2021/02/17/Windows%E4%B8%8B%E4%B8%BAGit%E8%AE%BE%E7%BD%AE%E4%BB%A3%E7%90%86/)

# WSL

WSL 的 `hostip` 不固定

`~/.ssh/config` 文件写入以下内容

使用环境变量版本： 

```bash
Host github.com
  User git
  ProxyCommand nc -x ${hostip}:7890 %h %p
```

直接 `cat` ：

```bash
Host github.com
  User git
  ProxyCommand nc -x $(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*'):7890 %h %p
```