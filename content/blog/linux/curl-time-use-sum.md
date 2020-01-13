---
title: "Curl Time Use Sum"
date: 2019-12-31T16:26:02+08:00
tags: ["linux"]
---

#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Curl-Time-Use-Sum>&color=red&style=for-the-badge&logo=appveyor)

```text

在开发过程中，有时候会需要对接口进行简单测速。这个接口可能是其它部门提供过来的，但是我们对于性能并不知情，需要进行下简单快速的测试，这里不是一个标准的性能测试流程。此刻，就非常需要一个工具来帮你做，而curl就是这么一个工具。

什么是curl?
curl是linux下的一个命令行工具，业界更多称作它为下载工具，支持文件上传和下载，支持包括HTTP、HTTPS、FTP等众多协议，还支持POST、COOKIES、认证、从指定偏移处下载部分文件、用户代理、网络测速、文件大小、进度条等功能。

可以说它是一个非常有用的网络命令行工具。

利用curl简单接口测速
curl -s -w '%{time_connect}:%{time_starttransfer}:%{time_total}\n' 'http://example.com/api/user'

# result 
0.081:0.272:0.779
上面示例用curl对example.com的某个api进行测速，-s 参数去掉所有状态信息，-w 参数让 curl 写出列出的计时器的状态信息。

计时器参数：

参数	一个普通标题
time_connect	客户端建立服务器TCP连接用时
time_starttransfer	发出请求后，服务器返回数据的第一个字节用时
time_total	完成请求用时
time_namelookup	DNS解析用时
speed_download	下载速度，单位-字节每秒
通过观察curl数据及其随时间变化的趋势,可以很好地了解接口的响应速度。以上变量会按CURL认为合适的格式输出，输出变量需要按照%{variable_name}的格式，如果需要输出%，double一下即可，即%%，同时，\n是换行，\r是回车，\t是TAB



```
