---
title: "Slice与unsafe"
date: 2020-07-31T15:02:15+08:00
tags : ["go"]
---

```textmate

var o []byte
sliceHeader := (*reflect.SliceHeader)((unsafe.Pointer(&o)))
sliceHeader.Cap = length
sliceHeader.Len = length
sliceHeader.Data = uintptr(ptr)


```