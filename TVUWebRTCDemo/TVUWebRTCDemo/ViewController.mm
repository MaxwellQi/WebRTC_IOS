//
//  ViewController.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "socketio/SocketIOOperation.h"
#import <RTCICEServer.h>
#import <RTCPeerConnection.h>
#import <RTCPeerConnectionFactory.h>
#import <RTCMediaStream.h>
#import <RTCAudioTrack.h>
#import <RTCMediaConstraints.h>
#import <RTCSessionDescriptionDelegate.h>
#import <RTCPair.h>
#import <RTCVideoCapturer.h>
#import <AVFoundation/AVFoundation.h>
#import "Const.h"
extern int socketioStatus;
@interface ViewController ()<RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate>
@property(nonatomic) SocketIOOperation *socketOperation;

@property (nonatomic,strong)RTCPeerConnectionFactory *pcFactory;
@property (nonatomic,strong)RTCPeerConnection *peerConnection;
@property (nonatomic,strong) RTCMediaStream *localStream;
@property (nonatomic,strong) RTCAudioTrack *audioTrack;
@end

@implementation ViewController

- (RTCPeerConnectionFactory *)pcFactory
{
    if (!_pcFactory) {
        _pcFactory = [[RTCPeerConnectionFactory alloc] init];
    }
    return _pcFactory;
}

- (RTCPeerConnection *)peerConnection
{
    if (!_peerConnection) {
        [RTCPeerConnectionFactory initializeSSL];
        _peerConnection = [self.pcFactory peerConnectionWithICEServers:[NSMutableArray arrayWithObject:[self defaultSTUNServer]] constraints:nil delegate:self];
        
//        [_peerConnection addStream:self.localStream];
    }
    return _peerConnection;
}

- (RTCICEServer *)defaultSTUNServer {
    NSURL *defaultSTUNServerURL = [NSURL URLWithString:@WebRTCServer];
    return [[RTCICEServer alloc] initWithURI:defaultSTUNServerURL
                                    username:@"111111"
                                    password:@""];
}

- (RTCVideoTrack *)createLocalVideoTrack {
    // The iOS simulator doesn't provide any sort of camera capture
    // support or emulation (http://goo.gl/rHAnC1) so don't bother
    // trying to open a local stream.
    // TODO(tkchin): local video capture for OSX. See
    // https://code.google.com/p/webrtc/issues/detail?id=3417.
    
    RTCVideoTrack *localVideoTrack = nil;
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE
    
    NSString *cameraID = nil;
    for (AVCaptureDevice *captureDevice in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            cameraID = [captureDevice localizedName];
            break;
        }
    }
    NSAssert(cameraID, @"Unable to get the front camera id");
    
    RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:cameraID];
    RTCMediaConstraints *mediaConstraints = [self defaultMediaStreamConstraints];
    RTCVideoSource *videoSource = [self.pcFactory videoSourceWithCapturer:capturer constraints:mediaConstraints];
    localVideoTrack = [self.pcFactory videoTrackWithID:@"ARDAMSv0" source:videoSource];
#endif
    return localVideoTrack;
}

#pragma mark - Defaults
- (RTCMediaConstraints *)defaultMediaStreamConstraints {
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:nil];
    return constraints;
}



- (RTCMediaStream *)localStream
{
    if (!_localStream) {
        _localStream = [self.pcFactory mediaStreamWithLabel:@"ARDAMS"];
        _audioTrack = [self.pcFactory audioTrackWithID:@"ARDAMSa0"];
        [_localStream addAudioTrack:_audioTrack];
        
        RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
        if (localVideoTrack) {
            [_localStream addVideoTrack:localVideoTrack];
        }
        
    }
    return _localStream;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                                        @[[[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"]]
                                                                             optionalConstraints: nil];
    
    [_peerConnection createOfferWithDelegate:self constraints:constraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _socketOperation = new SocketIOOperation();
    _socketOperation->beginConnection("heheda"); // connection
}

#pragma mark -RTCSessionDescriptionDelegate
// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error
{
    NSLog(@"qizhang-------------debug-----------");
    [self.peerConnection setLocalDescriptionWithDelegate:NULL sessionDescription:sdp];
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error
{
    NSLog(@"peerConnection-------error");
}

#pragma mark -RTCPeerConnectionDelegate
// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged
{
    NSLog(@"%s",__func__);
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream
{
    NSLog(@"%s",__func__);
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream
{
    NSLog(@"%s",__func__);
}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection
{
    NSLog(@"%s",__func__);
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState
{
    NSLog(@"%s",__func__);
}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState
{
    NSLog(@"%s",__func__);
}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate
{
    NSLog(@"%s",__func__);
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel
{
    NSLog(@"%s",__func__);
}

- (void)postResponse
{
    _socketOperation->postresponse_tvu();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onpressedbuttonCall:(id)sender {
//    _socketOperation->callPhone();
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(postResponse) userInfo:nil repeats:YES];
}

@end
