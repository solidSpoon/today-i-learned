# Windows下区分服务进程
## 背景
同一台 Windows 服务器上部署了多个 tomcat 服务，任务管理器中的名字均叫做 java.exe，如何区分？

## 端口号

可以通过端口号来区分不同的进程

```powershell
#cmd
netstat -nao | find "10090"
------
  TCP    0.0.0.0:10090          0.0.0.0:0              LISTENING       968
  TCP    192.168.1.181:10090    180.106.151.210:57414  ESTABLISHED     968
  TCP    [::]:10090             [::]:0                 LISTENING       968
```

然后就可以在任务管理器中找到 PID 为 968 的进程

![image-20211202141219119](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20211202141238.png)

## 文件句柄
参照「[[Windows 删除或修改被占用的文件]]」，找到后右键 -> 结束进程