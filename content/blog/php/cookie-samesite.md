---
title: "Cookie Samesite"
date: 2020-07-24T10:13:38+08:00
tags : ["php"]
---

#### ![*](https://img.shields.io/static/v1?label=smoke&message=<COOKIE-SAMESITE>&color=yellowgreen&style=for-the-badge&logo=appveyor&suffix=download&?link=http://left&link=http://google.com)


``
参考站: 
	1.	https://web.dev/samesite-cookies-explained/
	2.	https://tools.ietf.org/html/draft-ietf-httpbis-rfc6265bis-03#section-5.2

注意:
	Chrome80　版本后默认不允许跨站cookie操作，　如果要进行跨站cookie操作需要https请求。
	Chrome84  版本开始支持samesite=none属性，　但是必须在https下进行，并且要指定Secure

支持：
	chrome://flags/#cookies-without-same-site-must-be-secure


环境：　

	1. Chrome 版本 84.0.4147.89（正式版本） （64 位）
	2. php7.31
	3. 本地http, 无ssl证书，　跨站访问无法测试



特性:
	1. samesite=Lax		不设置SameSite属性，　默认为：　SameSite=Lax
	2. samesite=struct	仅限于当前站使用cookie
	3. samesite=none	上下文站点皆可使用cookie, none属性必须指定secure(以此表示是安全的关联站)



问题：　
	1.　解决内联站点被劫持的问题
	2.  解决内联站点互相读取cookie


方案:
	1. samesite=struct 仅限于当前站点使用
	2. samesite=none 允许安全的关联站使用


测试场景：
	打开 new.food 并从中请求 dev.food (跨站请求)

代码测试:
	
	1. Set-Cookie: promo_shown=1; SameSite=Strict
		结果: 仅限于当前站点
	2. Set-Cookie: promo_shown=1; SameSite=Lax
		结果: 跨站无法拿到对方cookie
	3. Set-Cookie: promo_shown=1; SameSite=None Struce	

结论：
``