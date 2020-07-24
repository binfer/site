---
title: "Grpc Go Use Builder"
date: 2019-12-03T13:22:29+08:00
tags: ["go"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Grpc-Go-Use-Builder>&color=green&style=for-the-badge&logo=appveyor)

#### 使用grpc

[https://github.com/binfer-go/example-grpc](https://github.com/binfer-go/example-grpc)

Proto
```proto
//命令 protoc --go_out=plugins=grpc:. .\router.proto

syntax = "proto3";

package proto;
service RouteGuide{
    rpc Getfeature(Point) returns (Feature) {}                  // 普通
    rpc ListFeatures(Point) returns (stream Feature) {}         // 服务流
    rpc RecordRoute(stream Point) returns (Feature) {}          // 客户端流
    rpc RouteChat(stream Point) returns (stream Feature){}      // 双向流
}
message Point {
    int32 latitude  = 1;
    int32 longitude = 2;
}
message Feature{
    int32 id = 1;
    bytes data = 2;
}
```

1. 简单RPC

```go
// 服务端
var port = ":9900"

type routeGuideServer struct {
	//pb proto.UnimplementedRouteGuideServer
}

func (router *routeGuideServer) Getfeature(ctx context.Context, point  *proto.Point) (*proto.Feature, error) {
	fmt.Println("------ getfeature:", point.Longitude, point.Latitude)
	return &proto.Feature{Message:"getfeature"}, nil
}
func main()  {

	server, err := net.Listen("tcp", "127.0.0.1" + port)
	if err != nil {
		log.Fatalf("tcp listen error: %s \n", err)
	}
	grpcServer := grpc.NewServer()
	proto.RegisterRouteGuideServer(grpcServer, &routeGuideServer{})
	_ = grpcServer.Serve(server)
}


// 客户端
const (
	address     = "localhost:9900"
)
func main() {

	ctx, _ := context.WithTimeout(context.TODO(), time.Second)
	conn, err := grpc.DialContext(ctx, address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("client server error: %s \n", err)
	}
	defer conn.Close()
	routeServe := proto.NewRouteGuideClient(conn)
	feature, err := routeServe.Getfeature(context.Background())
	if err != nil {
		log.Printf("client feature error: %s \n", err)
	}
	fmt.Println(feature)

}

```
2. 服务器流式 RPC
```go
// 服务端

func (router *routeGuideServer) ListFeatures(point *proto.Point, server proto.RouteGuide_ListFeaturesServer) error {
	fmt.Println("------ listfeature:", point.Latitude, point.Longitude, server.Context())
	_ = server.Send(&proto.Feature{Message: "listfeature"})
	_ = server.RecvMsg(nil)
	return nil
}
func main()  {
	server, err := net.Listen("tcp", "127.0.0.1" + port)
	if err != nil {
		log.Fatalf("tcp listen error: %s \n", err)
	}
	grpcServer := grpc.NewServer()
	proto.RegisterRouteGuideServer(grpcServer, &routeGuideServer{})
	_ = grpcServer.Serve(server)
}

// 客户端
const (
	address     = "localhost:9900"
)
func main() {
	ctx, _ := context.WithTimeout(context.TODO(), time.Second)
	conn, err := grpc.DialContext(ctx, address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("client server error: %s \n", err)
	}
	defer conn.Close()
	routeServe := proto.NewRouteGuideClient(conn)
	feature, err := routeServe.RecordRoute(context.Background())
	if err != nil {
		log.Printf("client feature error: %s \n", err)
	}
	_ = feature.Send(&proto.Point{
		Latitude:             111,
		Longitude:            222,
		XXX_NoUnkeyedLiteral: struct{}{},
		XXX_unrecognized:     nil,
		XXX_sizecache:        0,
	})
	fmt.Println(feature.Recv())
}
```
3. 客户端流式 RPC
```go
// 服务端
func (router *routeGuideServer) RecordRoute(stream proto.RouteGuide_RecordRouteServer) error {
	fmt.Println("------ recordRoute:")
	point, err := stream.Recv()
	if err == io.EOF {
		_ = stream.SendAndClose(&proto.Feature{
            Id:                   1,  
			Data:                 []byte("hello"),
			XXX_NoUnkeyedLiteral: struct{}{},
			XXX_unrecognized:     nil,
			XXX_sizecache:        0,
		})
	}
	fmt.Println("=======", point)
	return nil
}
func main()  {
	server, err := net.Listen("tcp", "127.0.0.1" + port)
	if err != nil {
		log.Fatalf("tcp listen error: %s \n", err)
	}
	grpcServer := grpc.NewServer()
	proto.RegisterRouteGuideServer(grpcServer, &routeGuideServer{})
	_ = grpcServer.Serve(server)
}


// 客户端
func main() {
	ctx, _ := context.WithTimeout(context.TODO(), time.Second)
	conn, err := grpc.DialContext(ctx, address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("client server error: %s \n", err)
	}
	defer conn.Close()
	routeServe := proto.NewRouteGuideClient(conn)
	feature, err := routeServe.RecordRoute(context.Background())
	if err != nil {
		log.Printf("client feature error: %s \n", err)
	}
	_ = feature.Send(&proto.Point{
		Latitude:             111,
		Longitude:            222,
		XXX_NoUnkeyedLiteral: struct{}{},
		XXX_unrecognized:     nil,
		XXX_sizecache:        0,
	})
	fmt.Println(feature)

}
```
4. 双向流式 RPC
```go

// 服务端
func (router *routeGuideServer) RouteChat(stream proto.RouteGuide_RouteChatServer) error {
	fmt.Println("------ routeChat:")
	point, err := stream.Recv()
	if err != nil {
		return err
	}
	if err == io.EOF {
		_ = stream.Send(&proto.Feature{
			Id:                   1,
			Data:                 []byte("hello"),
			XXX_NoUnkeyedLiteral: struct{}{},
			XXX_unrecognized:     nil,
			XXX_sizecache:        0,
		})
	}
	fmt.Println("=====", point)
	_ = stream.Send(&proto.Feature{
		Id:                   1,  
        Data:                 []byte("hello"),
		XXX_NoUnkeyedLiteral: struct{}{},
		XXX_unrecognized:     nil,
		XXX_sizecache:        0,
	})
	return nil
}
func main()  {
	server, err := net.Listen("tcp", "127.0.0.1" + port)
	if err != nil {
		log.Fatalf("tcp listen error: %s \n", err)
	}
	grpcServer := grpc.NewServer()
	proto.RegisterRouteGuideServer(grpcServer, &routeGuideServer{})
	_ = grpcServer.Serve(server)
}


// 客户端
func main() {
	ctx, _ := context.WithTimeout(context.TODO(), time.Second)
	conn, err := grpc.DialContext(ctx, address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("client server error: %s \n", err)
	}
	defer conn.Close()
	routeServe := proto.NewRouteGuideClient(conn)
	feature, err := routeServe.RouteChat(context.Background())
	if err != nil {
		log.Printf("client feature error: %s \n", err)
	}
	_ = feature.Send(&proto.Point{
		Latitude:             111,
		Longitude:            222,
		XXX_NoUnkeyedLiteral: struct{}{},
		XXX_unrecognized:     nil,
		XXX_sizecache:        0,
	})
	fmt.Println(feature.Recv())
}

```

