---
title: "Two Search Method"
date: 2020-01-22T12:39:26+08:00
tags: ["php"]
---

#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Two-Search-Method>&color=yellowgreen&style=for-the-badge&logo=appveyor&suffix=download&?link=http://left&link=http://google.com)
```php

 private function sel($n) {
        $ls = range(1,999999);
        $min = 1;
        $max = count($ls);
        $mid = 0;
        $r   = '';
        while ($min<$max) {
            $mid = intval(($min+$max) / 2);

            switch ($ls[$mid]<=>$n) {
                case -1:
                    $max = $mid-1;
                    break;
                case 1:
                    $max = $mid+1;
                    break;
                case 0:
                    return $r = $ls[$mid];
                    break;
            }
        }
        return $r;
    }

```
