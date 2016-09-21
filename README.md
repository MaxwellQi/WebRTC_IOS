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