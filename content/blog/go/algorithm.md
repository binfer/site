---
title: "Algorithm"
date: 2020-07-30T15:04:19+08:00
tags : ["go"]
---

```
#给定 nums = [3,2,2,3], val = 3,
#函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。
#你不需要考虑数组中超出新长度后面的元素

func removeElement(nums []int, val int) int {
    for i := 0; i < len(nums);{
        if nums[i] == val {
            nums = append(nums[:i],nums[i+1:]...)
        }else{
            i++
        }
    }
    retunums)
}
```


```
#我们要想寻找最长公共前缀，那么首先这个前缀是公共的，我们可以从任意一个元素中找到它。假定我们现在就从一个数组中寻找最长公共前缀，那么首先，我们可以将第一个元素设置为基准元素x0。假如数组为["flow","flower","flight"]，flow就是我们的基准元素x0。

//GO
func longestCommonPrefix(strs []string) string {
    if len(strs) < 1 {
        return ""
    }
    prefix := strs[0]
    for _,k := range strs {
        for strings.Index(k,prefix) != 0 {
            if len(prefix) == 0 {
                return ""
            }
            prefix = prefix[:len(prefix) - 1]
        }
    }
    return prefix
}
```