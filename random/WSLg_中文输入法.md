# WSLg 中文输入法

等来等去终于等来了 WSL 2 的 GUI 支持，最近我也终于解决了 中文输入法的问题，记录一下


下面是摘要

```bash
fcitx-config-gtk3
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
```

## 安装 fcitx 输入法

> [https://patrickwu.space/2019/10/28/wsl-fcitx-setup-cn/](https://patrickwu.space/2019/10/28/wsl-fcitx-setup-cn/)



下面的命令嗯会安装 CJK 字体与 fcitx 核心

```bash
sudo apt install fcitx fonts-noto-cjk fonts-noto-color-emoji dbus-x11
```

上面的教程中列举了很多 fcitx 输入法，本文之说明我所安装的输入法

```bash
sudo apt install fcitx-sunpinyin
```

## 配置环境

教程中说登陆 root 帐号，使用下面的命令生成 dbus 机器码

```bash
dbus-uuidgen > /var/lib/dbus/machine-id
```

可是不论是使用 `sudo` 还是使用 `su` 都会报权限不够，我查看 `/var/lib/dbus/machine-id` 这个文件里面有一个码，就暂时省略这一步。


用 root 帐号创建 `/etc/profile.d/fcitx.sh` 文件，内容如下：

```
#!/bin/bash
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx

#可选，fcitx 自启
fcitx-autostart &>/dev/null
```

这里我命令行用的是 zsh 实际测试下来发现启动后并不会加载上述文件，于是在 `.zshrc` 文件中添加下面一行：

```
source /etc/profile.d/fcitx.sh
```

输入 `fcitx-config-gtk3` ，启动配置面板，改一下快捷键。如下图：

![image.png](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/12/03/20211203-231847.png)

使用的时候按下 「Ctrl + M」就可以启动输入法了，同样 「shift」也是切换中英文的。