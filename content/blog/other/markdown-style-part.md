---
title: "Markdown Style Part"
date: 2019-12-04T11:12:58+08:00
tags: ["other"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Markdown-Style-Part>&color=green&style=for-the-badge&logo=appveyor)

##### MARKDOWN STYLE PART


- Iframe
<!-- 属性什么的不要错了，最好用双引号括住 -->
<!-- 网易云的iframe需要做些调整，调整如下 -->
<iframe src="//music.163.com/outchain/player?type=2&id=536096151&auto=0&height=66" frameborder="0" width="100%" height="86px"></iframe>
```html
<iframe src="//music.163.com/outchain/player?type=2&id=536096151&auto=0&height=66" frameborder="0" width="100%" height="86px"></iframe>
```
---
- css/html
<div id="htmldemo"></div>
<style>
  #htmldemo {
    height: 30px;
    width: 30px;
    background-color: #00aa9a;
    animation-name: moveX;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
    animation-fill-mode: both;
  }
  @keyframes moveX {
    0% {
      transform: translateX(1px);
    }
    100% {
      transform: translateX(750px);
    }
  }
</style>

```html
<div id="htmldemo"></div>
<style>
  #htmldemo {
    height: 30px;
    width: 30px;
    background-color: #00aa9a;
    animation-name: moveX;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
    animation-fill-mode: both;
  }
  @keyframes moveX {
    0% {
      transform: translateX(0px);
    }
    100% {
      transform: translateX(100px);
    }
  }
</style>
```
---
- 表格

| Tables        |      Are      |   Cool | Tables        |      Are      |   Cool |         Are      |
| ------------- | :-----------: | -----: | ------------- | :-----------: | -----: | :--------------: |
| col 3 is      | right-aligned | \$1600 | col 3 is      | right-aligned | \$1600 |    right-aligned |
| col 2 is      |   centered    |   \$12 | col 2 is      |   centered    |   \$12 |      centered    |
| zebra stripes |   are neat    |    \$1 | zebra stripes |   are neat    |    \$1 |      are neat    |

```text
| Tables        |      Are      |   Cool | Tables        |      Are      |   Cool |
| ------------- | :-----------: | -----: | ------------- | :-----------: | -----: |
| col 3 is      | right-aligned | \$1600 | col 3 is      | right-aligned | \$1600 |
| col 2 is      |   centered    |   \$12 | col 2 is      |   centered    |   \$12 |
| zebra stripes |   are neat    |    \$1 | zebra stripes |   are neat    |    \$1 |
```

- 分割线

---
```text
---
```
---

- 标记

A
---

- 引用

> abc
```html
> abc
```

- 字体
_斜体_
**粗体**
~~删除线~~
```html
_斜体_
**粗体**
~~删除线~~
```

- 代码行
这是一段文字`rm -rf /*`这是一段文字

```html
这是一段文字`rm -rf /*`这是一段文字
```

- 图片


![smoke][doge]
```html
<!-- 图片流 doge=pic-->
![smoke][doge]

[doge]:data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAADfMAAApyCAYAAADp/vULAAAACXBIWXMAAAsTAAALEwEAmpwYAAAgAElEQVR4nOzdaZRV9Zk+7JtiHsQIAsqsgBPihAOBRDEtiSaIQ0yMY2trwCHov40apLHVRNSOEBNRMTgRsdUYWztpE42COIsooEYQFRQEAgiCTMVUVL0feDmLsgoohJJ0e11rsbL3

[name](http:\\....) //超链接
```





