---
title: "Clear Time Machine"
date: 2019-12-05T14:23:52+08:00
tags: ["mac"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Clear Time Machine>&color=blue&style=for-the-badge&logo=appveyor) 

- 清理 Time machine 本地备份以释放硬盘空间

- 10.13之后的系统默认使用 APFS 文件格式，不能关闭本地快照。也就是说一旦你开启了 Time machine，每次备份时都会在你本地留下一份备份，日积月累占用的空间会越来越大


- 打开“终端”输入如下代码：`sudo tmutil listlocalsnapshots /`

- 接下来尝试删除第一个快照文件，后面的文件名需要根据自己的显示来改变：`tmutil deletelocalsnapshots 2017-12-18-093234`

- 如果成功，你会发现磁盘空间已经空出来了不少，接下来删除全部的文件快照：`sudo tmutil listlocalsnapshots /`