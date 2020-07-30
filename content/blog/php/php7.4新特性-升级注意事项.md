---
title: "Php7.4新特性,升级事项"
date: 2020-07-29T15:48:07+08:00
tags: ["php"]
---
### 升级7.4注意事项, 建议:如果升级最好选择7.2 或者 7.3 (7.4的新特性可以忽略不计)
``
- **Arch** 发行版的反馈, 其他版本没有反馈

1. php-fpm 的新选项 ProtectHome 会导致经典的 File not found 错误，
   - fixcode: 
        - _72510_ 
   - 引用: 
        - [php7.4 Commit](https://github.com/php/php-src/commit/40c4d7f1820df1872a71ab07fd26da45a203e37f#diff-c0605c0e7e1db864472acf66a9812d33R22)
   - 解决方案:
        - 使用 `systemctl edit php-fpm.service` 修改 `ProtectHome=false`，重启服务.
   
2. php 解释器会对 null 类型的下标访问直接报错 `Trying to access array offset on value of type null`。
   - 解决方案:
        - 修改代码解决 
        
3. php 中经常使用 inlcude，require 等来包含其它文件。而调试发现在某个 include 之后，php 直接停止执行并报错 `Trying to access array offset on value of type null`
  　- 解决方案：
        - 修改代码解决

``
---

### 新特性

 - 7.0-7.4 更多特性
    - 参考1: https://blog.p2hp.com/archives/6918 
    - 参考2: https://www.sky8g.com/technology/3208/#mcetoc_1dmqpf77a0

~~7.4~~:

1 属性添加限定类型
```php
<?php
class User {
  public int $age;
  public string $name;
}  
$user = new User();
$user->age = 10;
$user->name = "张三";
//error
$user->age = "zhang";//需要传递int
?>

````
2 箭头函数

```php
<?php
#这个特性基本上参考 Js 的 ES6 的语法。可以让我们的代码写的更少。如果你的代码有 fn 这个函数。可能会冲突
$factor = 10;
$nums = array_map(fn($n)=>$n * $factor,[1,2,3]);//[10,20,30]
//之前的写法
$nums = array_map(function($num)use($factor){
  return $num * $factor;
},[1,2,3])
?>
```

3 有限返回类型协变与参数类型逆变
```php

<?php     
# 仅当使用自动加载时，才提供完全协变 / 逆变支持。在单个文件中，只能使用非循环类型引用，因为所有类在被引用之前都必须可用。
class A {}
class B extends A {}

class Producer {
    public function method(): A {}
}
class ChildProducer extends Producer {
    public function method(): B {}
}
?>

```

4 数组解包
```php
<?php
#使用展开运算符... 解包数组
$parts = ['apple', 'pear'];
$fruits = ['banana', 'orange', ...$parts, 'watermelon'];//['banana', 'orange', 'apple', 'pear', 'watermelon'];
//老的写法
$fruits = array_merge(['banana', 'orange'],$parts,['watermelon']);

?>

```
5 空合并运算符赋值
```php
<?php

$array['key'] ??= computeDefault();
// 老的写法
if (!isset($array['key'])) {
    $array['key'] = computeDefault();
}
?>

```

6 数值文字分隔符
```php
<?php
#数字文字可以在数字之间包含下划线。
6.674_083e-11; // float
299_792_458;   // decimal
0xCAFE_F00D;   // hexadecimal
0b0101_1111;   // binary
?>

```

7 允许从 __toString() 抛出异常
```php
#现在允许从 __toString() 引发异常，以往这会导致致命错误，字符串转换中现有的可恢复致命错误已转换为 Error 异常。
```

8 Filter
```php
<?php
#新增 FILTER_VALIDATE_FLOAT
filter_var(1.00,FILTER_VALIDATE_FLOAT);
```

9 strip_tags 支持数组
```php
<?php
strip_tags($str,['p','a','div']);
//老的写法
strip_tags($str,"<p><a><div>");
```


---

### TP6和TP5对比

1 目录结构的异同 tp5核心框架是项目根目录thinkphp下 , tp6是vendor的topthink

2 安装方式不同,tp6仅能通过composer方式安装,进入组件堆积开发时代

3 类自动加载方式不同 tp6使用composer方式实现类自动加载, tp5 composer+自己实现了一套

4 tp6使用了php7严格模式

5 支持更多的PSR规范   [PSR](https://learnku.com/docs/psr)

6 组件的独立 ORM 模板引擎 

7 中间件改进 TP6开始使用了管道模式来实现中间件

8 引入Filesystem

9 对Swoole及单元测试做出更多的完善支持

10 底层脚手架注入[Symfony](https://symfony.com/）

11 组件化开发是当前的开发趋势，[packagist](https://packagist.org/)库让开发多样化，简易化。

11 仍然有不够完善的地方. 业务需求做到了基本的解耦，但是对于业务衍生的可拓展性支持依旧较弱。比如　对事件的


触发联动,无法根据注入关系是否决定进入队列等等。