---
title: "Release"
date: 2020-01-17T10:54:59+08:00

---
```text

2020-01-16


1. 更新内容 
     * 更新风控模型
       -   

2. 清理缓存 ：  php artisan cache:clear
 
3. 队列:
    php artisan queue:restart  
    php artisan queue:work --queue='{safe_module_job}' --timeout=10 --tries=2
        

4. 添加权限 ： 
        
4. 备注：
    

已推 release

```

2020-01-21


1. 更新内容 
     * 前端AppMemberApi  ：  发送短信添加图形验证码验证
       - 
     * 总控： 配置 -> 会员配置 -> 会员短信 -> 添加开启验证码验证开关，默认开启 1
     
     >>> 添加开关：
         短信 api 防机器人刷
         会员基本配置
         开关按钮
         会员短信
         qclound_sms_app_swith
         2  #默认关闭
         Integer
         短信 api 防机器人刷
     
2. 清理缓存 ：  
 
3. 队列:          

4. 添加权限 ： 
        
4. 备注：
    

已推 release
```text






```

