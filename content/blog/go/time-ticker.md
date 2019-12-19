---
title: "Time Ticker"
date: 2019-12-16T17:48:05+08:00
tags: ["go"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<TIME TICKER>&color=green&style=for-the-badge&logo=appveyor)

```go

// 定时器
func TimeTicker()  {

	tick := time.NewTicker(time.Second * 5)
	for range tick.C {
		fmt.Println("hello --")
	}

}
```

