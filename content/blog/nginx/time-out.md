---
title: "Time Out"
date: 2020-07-24T10:11:25+08:00
draft: true
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<TimeOut>&color=orange&style=for-the-badge&logo=appveyor)


``
nginx 转发 fastCgi　生命周期测试

问题:

1. 测试客户端请求数据超时
2. 测试服务器响应数据超时
3. 测试nginx 连接　php-fpm 请求,响应


场景:

1. 客户端模拟上传100M文件　是否能在10秒内上传完毕。　
测试配置项: nginx - fastcgi_send_timeout 10; 

2. 模拟服务器30秒响应超时, sleep(29), sleep(30). 
	测试配置项: 	nginx - fastcgi_read_timeout 30;
	Note: 		此处继续模拟php内置时间超时方法  set_time_limit(10),set_time_limit(100);

3. 模拟关闭php-fpm, nginx 转发返回. 
测试配置项: nginx - fastcgi_connect_timeout 20;


对应场景结果:

1. 模拟上传匹配，10秒内上传完毕:200, 否则:504

2. 模拟服务器响应, 29秒成功:200，30+秒失败:504 (包含30秒)，　
	如果php代码设置set_time_limit(10),set_time_limit(100)，不会起作用。一切以fastcgi_read_timeout项为基准.

3. 服务端sleep(100), 关闭上游php-fpm, 抛出504, 继续访问抛出502. 
	504转502原因：抛出504,　启动重试机制, 重试失败返回502


需求结论:

 nginx: fastcgi_read_timeout 30; 配置项决定服务器响应时间

``