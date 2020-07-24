---
title: "Time Wait"
date: 2019-12-13T10:30:17+08:00
tags: ["tcp"]
---

![*](https://img.shields.io/static/v1?label=smoke&message=<TCP-TIME-WAIT>&color=yellowgreen&style=for-the-badge&logo=appveyor&suffix=download&?link=http://left&link=http://google.com)

![https://tools.ietf.org/html/rfc793](/images/tcp/ack.png)

#### socket 

- socket是全双工的工作模式，一个socket的关闭，是需要四次握手来完成的。
```textmate

1. 主动关闭方，调用close(), 协议层发送 FIN 包 
2. 被动关闭方收到 FIN包, 协议层回复 ACK， 然后被动关闭方进入 CLOSE_WAIT 状态， 主动关闭方一直等待对方关闭，
   进入 FIN_WAIT_2 状态； 此时关闭方等待， 被关闭方进入close() 状态

3. 被动关闭方处理完所有数据后, 调用close(), 此时协议层发送 FIN 包给主动关闭方， 等待对方的 ACK， 被动关闭方进入 LAST_ACK 状态
   （此时被动关闭处于LAST_ACK状态） 

4. 主动关闭方收到 FIN包， 协议层回复 ACK, 此时主动关闭方 进入 TIME_WAIT 状态，而被动关闭方进入 closed 状态

5. 等待2MSL  (2倍msl，为了防止被关闭方无法收到最后一个ACK， 报文生存时间 >= ttl), 主动关闭方 结束 TIME_WAIT, 进入closed 状态

---- 内核里，写死了这个MSL的时间为：30秒（有读者提醒，RFC里建议的MSL其实是2分钟，但是很多实现都是30秒），所以TIME_WAIT的即为1分钟：

TOOL:
- 通过 ss -tan state time-wait | wc -l 查看TIME_WAIT数量


分析：

- 主动关闭方关闭了连接，发送了FIN；

- 被动关闭方回复ACK同时也执行关闭动作，发送FIN包；此时，被动关闭的一方进入LAST_ACK状态

- 主动关闭的一方回去了ACK，主动关闭一方进入TIME_WAIT状态；

- 但是最后的ACK丢失，被动关闭的一方还继续停留在LAST_ACK状态

- 此时，如果没有TIME_WAIT的存在，或者说，停留在TIME_WAIT上的时间很短，则主动关闭的一方很快就进入了CLOSED状态，也即是说，如果此时新建一个连接，源随机端口如果被复用，在connect发送SYN包后，由于被动方仍认为这条连接【五元组】还在等待ACK，但是却收到了SYN，则被动方会回复RST

- 造成主动创建连接的一方，由于收到了RST，则连接无法成功



```

在TCP层，有个FLAGS字段，这个字段有以下几个标识：SYN, FIN, ACK, PSH, RST, URG.
其中，对于我们日常的分析有用的就是前面的五个字段。

它们的含义是：

URG:Urget pointer is valid (紧急指针字段值有效)

SYN: 表示建立连接

FIN: 表示关闭连接

ACK: 表示响应

PSH: 表示有 DATA数据传输

RST: 表示连接重置。


[reference1](https://blog.51cto.com/wushank/1135060)
[reference2](https://blog.csdn.net/hzrandd/article/details/74463313)
[reference3](https://tools.ietf.org/html/rfc793)