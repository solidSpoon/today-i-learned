不用代理的话可能访问不到 `raw.githubusercontent.com` ，是因为 DNS 被污染了

在这个网站可以查询真实 IP

[ipaddress.com](https://www.ipaddress.com/)

查询 `raw.githubusercontent.com` 的真实 IP 

![image.png](https://cdn.nlark.com/yuque/0/2020/png/1548042/1591771411852-77dd3db8-0ebf-4303-a9c5-d511201db3ec.png)

**修改 hosts** 

```bash
sudo vim /etc/hosts
```

添加如下内容： 

```bash
199.232.28.133 raw.githubusercontent.com
```

 即可暂时解决