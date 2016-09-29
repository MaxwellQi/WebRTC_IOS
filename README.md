# WebRTC_IOS
Voip based on webrtc

## 说明

该项目是voip通信的一个demo，voip通信基于webRTC，webRTC中间的信号传递又基于socket.io 。 所以这个demo就是webRTC和Socket.io的一个综合体。最后这个demo就是能够进行视频和语音通话。

## XCode版本

使用的是XCdoe7.3 。 需要注意在 Build Settings中修改Enable Bitcode 为 No

## 1.集成webrtc

### webrtc的库

由于webrtc的官方库非常大，我们自己去编译会消耗大量时间，所以我们就在github上找到一个直接封装编译后的webrtc库。
我是基于 [apprtc-ios](https://github.com/ISBX/apprtc-ios) 来进行集成的，Demo中的页面大都是直接拿它的直接用的。apprtc-ios提供了服务器端，可以很好地进行测试。

### 集成步骤

* 引入第三方库，使用cocopods方式.创建Podfile文件，在文件中输入

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.3'

target 'DemoWebRTC' do
	pod 'AppRTC'
end
```
* 在使用库的地方直接导入

```
#import <AppRTC/ARDAppClient.h>
```

## 2.集成Socket.io

具体步骤参照[Socket.io_Objective-C](https://github.com/MaxwellQi/Socket.io_Objective-C)

## 3.如何实现voip

实现voip功能，我们首先要明白一下几点：

* 使用socket.io和信令服务器进行通信，部分重要代码可以参考[socket.io-client-cpp](https://github.com/socketio/socket.io-client-cpp) ，该库是一个c++库。
* 使用webRTC主要是做音视频通话，我个人认为其最重要功能就是提供给我们能创建音视频通话的通道。其中最主要的就是搞清楚打电话时需要做什么操作；接电话时需要做什么操作；如何在恰当的时间创建一个answer/offer,创建了offer或answer之后，才能触发RTCSessionDescription的代理方法，在其代理方法中才能设置远端和本地的sdp信息。
* 如果是在一个局域网内实现voip，在使用webrtc时不需要建立iceserver；但是如果在公网下实现voip，则需要建立iceserver。
* 如果使用c++和Obejctive-c混编，那么就避免不了一个非常重要的问题，就是sdp信息的处理，因为在c++层面得到远端的sdp信息时，需要在oc层面设置remote sdp时，就牵扯到sdp传值与转化的问题。
* 有时候电脑需要插入耳机。
* app需要获取访问麦克风权限。

## 4.遇到的困难

* 无论c++层面的webrtc和OC层面的webrtc，其具体的sdp形式都是一样。所以，当我们使用socket.io往信令服务器传输消息的时候，其具体的参数都是通过json字符串传递的，不要犯了不同语言不同对象不知道如何在一个具体的方法中传递的糊涂。所有的参数，都是JSon字符串。
* Foundation到JSon字符串，一种JSON字符串到另一种JSON字符串的转化。


## 5.存在的问题以及以后优化的内容

* 代码逻辑比较混乱，不应该创建标准的c++类库，而应该使用OC，然后混编入C++。
* 部分c++的map对象取值取不出来，有待查资料弄清问题（收到offer回调时获取sdp信息）。
* c++中的回调方法都是一个个block，应该做简单的封装。
* 所有的socket.io的处理，应该抽出来一个操作类做统一处理。
* 所有关于webrtc功能的处理，应该抽出一个操作类做同一处理。
* 目前只实现了接电话，还有打电话和视频通话没有实现。并且是在一个局域网中完成的。