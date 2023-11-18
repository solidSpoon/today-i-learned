# exchange ESC and Caps Lock

# 对调

将下面代码保存成 `.reg` 文件

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=hex:00,00,00,00,00,00,00,00,03,00,00,00,3a,00,01,00,01,00,3a,00,00,00,00,00
```

运行然后重启

# 恢复

1. Win + R
2. 运行 `regedit`
3. 打开 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout`
4. 找到映射文件：Scancode Map，其之后跟着的一长串数字，即为当初修改按键映射的数字串。
5. 删除该映射文件，再重启电脑，键盘就可以恢复按键原本的位置了。

[windows中Esc与CapsLock、Alt与Ctrl调换位置_Ace's Blog-CSDN博客](https://blog.csdn.net/ace_shiyuan/article/details/81283065)