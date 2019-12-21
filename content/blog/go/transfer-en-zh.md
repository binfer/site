---
title: "Transfer en Zh"
date: 2019-12-06T17:48:02+08:00
tags: ["go"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Transfer-en-Zh>&color=green&style=for-the-badge&logo=appveyor)

#### cli 翻译

```go

package main

import (

  "encoding/xml"
  "github.com/bndr/gotabulate"
  "github.com/fatih/color"
  "fmt"
  "io/ioutil"
  "net/http"
  "net/url"
  "os"
  "strings"
)

type ParseXmlData struct {

  XMLName     xml.Name     `xml:"yodaodict"`

  RawInput    string       `xml:"return-phrase"`

  CustomTrans CustomNode   `xml:"custom-translation"`

  WebTrans    WebTransList `xml:"yodao-web-dict"`

}

type CustomNode struct {

  Type        string        `xml:"type"`

  Translation []Translation `xml:"translation"`

}

type WebTransList struct {

  TransNode []WebTransNode `xml:"web-translation"`

}

type WebTransNode struct {

  Key   string      `xml:"key"`

  Trans []TransNode `xml:"trans"`

}

type TransNode struct {

  Value string `xml:"value,CDATA"`

}

type Translation struct {

  Content string `xml:"content,CDATA"`

}

func HttpGet(url string, ch chan []byte) {

  resp, err := http.Get(url)
  if err == nil {
    defer resp.Body.Close()
  }
  if err != nil {
    color.Red("please enter ctrl+c ,request error: %s \n", err)
  }
  body, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    color.Red("please enter ctrl+c ,io read error: %s \n", err)
  }
  ch <- body
}



func main() {

  args := os.Args[1:]

  if len(args) < 1 {
    color.Red("please input the translation word : %s \n", "---")
    color.GreenString("example: dict hello\n\n")
    os.Exit(0)
  }
  word := strings.Join(args, " ")

  requestUrl := fmt.Sprintf("https://dict.youdao.com//fsearch?client=deskdict&keyfrom=chrome.extension&q=%s&pos=-1&doctype=xml&xmlVersion=3.2&dogVersion=1.0&vendor=unknown&appVer=3.1.17.4208&le=eng", url.QueryEscape(word))

  ch := make(chan []byte)
  go HttpGet(requestUrl, ch)
  xmlObject := ParseXmlData{}
  _ = xml.Unmarshal(<-ch, &xmlObject)
  color.Blue("**************************** [ 英汉翻译 ]****************************** %s \n\n", word)
  for _, v := range xmlObject.CustomTrans.Translation {
    _, _ = color.New(color.BgCyan).Add(color.Bold).Println(strings.TrimSpace(v.Content),"\n")
  }
  color.Green("**************************** [ 网络释义 ]****************************** %s \n\n", word)
  result := [][]string{}
  for _, v := range xmlObject.WebTrans.TransNode {
    key := strings.TrimSpace(v.Key)
    for _, vv := range v.Trans {
      value := strings.TrimSpace(vv.Value)
      result = append(result, []string{key, value})
      /*_, _ = color.New(color.Bold).Println(key, ":\t\t\t", value)*/
      break
    }
  }

  // Create Object
  tabulate := gotabulate.Create(result)
  tabulate.SetAlign("left")
  tabulate.SetWrapStrings(true)
  // Set Headers
  tabulate.SetHeaders([]string{"KEY", "VALUE"})
  // Render
  _, _ = color.New(color.BgBlue).Add(color.Bold).Println(tabulate.Render("grid"))

}

```