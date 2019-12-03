---
title: "Grpc Go Use Builder"
date: 2019-12-03T13:22:29+08:00
---
#### 使用grpc

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
			Message:              "hello world",
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
			Data:                 byte(1),
			XXX_NoUnkeyedLiteral: struct{}{},
			XXX_unrecognized:     nil,
			XXX_sizecache:        0,
		})
	}
	fmt.Println("=====", point)
	_ = stream.Send(&proto.Feature{
		Message:              "hello ~~~~~",
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

