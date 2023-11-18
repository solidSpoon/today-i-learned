添加环境变量如下：

![image.png](https://cdn.nlark.com/yuque/0/2021/png/1548042/1613921181415-f92b260d-3ad6-4b27-a706-ac8e7df9428b.png)

# Python 报错

```
Missing dependencies for SOCKS support
```

此时直接 pip 下载依赖也不行，因为此时 pip 也需要 SOCKS dependencies


1. 切换成 http 代理或取消代理

```bash
cmd:
set http_proxy=http://127.0.0.1:7890 & set https_proxy=http://127.0.0.1:7890

PowerShell:
$Env:http_proxy="http://127.0.0.1:7890";$Env:https_proxy="http://127.0.0.1:7890"
```

2. 然后下载依赖

```bash
pip install pysocks
```

完成