---
title: "Command"
date: 2020-01-22T16:13:18+08:00
draft: true
---


```linux
http://www.embeddedlinux.org.cn/emb-linux/entry-level/201609/28-5701.html


通过执行以下命令，可以在1分钟内对系统资源使用情况有个大致的了解。

uptime

dmesg | tail

vmstat 1

mpstat -P ALL 1

pidstat 1

iostat -xz 1

free -m

sar -n DEV 1

sar -n TCP,ETCP 1

top


```

