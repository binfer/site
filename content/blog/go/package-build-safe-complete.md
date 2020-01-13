---
title: "Package Build Safe Complete"
date: 2020-01-10T17:56:05+08:00
tags: ["go"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Package-Build-Safe-Complete>&color=green&style=for-the-badge&logo=appveyor)
```go

// tcp防止粘包，封装
package packet

import (
	"bytes"
	"encoding/binary"
	"fmt"
)

const (
	DEFAULE_HEADER           = "[**********]"
	DEFAULT_HEADER_LENGTH    = 12
	DEFAULT_SAVE_DATA_LENGTH = 4
)

type Packet struct {
	Header         string
	HeaderLengh    int32
	SaveDataLength int32
	Data           []byte
}

//set delimiter header
func (self *Packet) SetHeader(header string) *Packet {
	self.Header = header
	self.HeaderLengh = int32(len([]byte(header)))
	return self
}

//create default package
func NewDefaultPacket(data []byte) *Packet {
	return &Packet{DEFAULE_HEADER, DEFAULT_HEADER_LENGTH, DEFAULT_SAVE_DATA_LENGTH, data}
}

//convert to net package
func (self *Packet) Packet() []byte {
	fmt.Println(self.Header, string(self.IntToBytes(int32(len(self.Data)))))
	return append(append([]byte(self.Header), self.IntToBytes(int32(len(self.Data)))...), self.Data...)
}

//return value is sticky data
func (self *Packet) UnPacket(readerChannel chan []byte) []byte {
	dataLen := int32(len(self.Data))
	var i int32
	for i = 0; i < dataLen; i++ {
		//Termiate for loop when the remaining data is insufficient .
		if dataLen < i+self.HeaderLengh+self.SaveDataLength {
			break
		}
		//find Header
		if string(self.Data[i:i+self.HeaderLengh]) == self.Header {
			saveDataLenBeginIndex := i + self.HeaderLengh
			actualDataLen := self.BytesToInt(self.Data[saveDataLenBeginIndex : saveDataLenBeginIndex+self.SaveDataLength])
			//The remaining data is less than one package
			if dataLen < i+self.HeaderLengh+self.SaveDataLength+actualDataLen {
				break
			}
			//Get a packet
			packageData := self.Data[saveDataLenBeginIndex+self.SaveDataLength : saveDataLenBeginIndex+self.SaveDataLength+actualDataLen]
			//send pacakge data to reader channel
			readerChannel <- packageData
			//get next package index
			i += self.HeaderLengh + self.SaveDataLength + actualDataLen - 1
		}
	}
	//Reach the end
	if i >= dataLen {
		return []byte{}
	}
	//Returns the remaining data
	return self.Data[i:]
}

func (self *Packet) IntToBytes(i int32) []byte {
	byteBuffer := bytes.NewBuffer([]byte{})
	_ = binary.Write(byteBuffer, binary.BigEndian, i)
	return byteBuffer.Bytes()
}

func (self *Packet) BytesToInt(data []byte) int32 {
	var val int32
	byteBuffer := bytes.NewBuffer(data)
	_ = binary.Read(byteBuffer, binary.BigEndian, &val)
	return val
}



```

```text

Package Build Safe Complete

###service

readerChannel := make(chan []byte, 1024)
    //Store truncated data
    remainBuffer := make([]byte, 0)
    //read unpackage data from buffered channel
    go func(reader chan []byte) {
        for {
            packageData := <-reader
            //....balabala....
        }
    }(readerChannel)
  remainBuffer =   NewDefaultPacket(append(remainBuffer,recvData)


###client

dataPackage := NewDefaultPacket([]byte(jsonString)).Packet()
  Client.Write(dataPackage)

```