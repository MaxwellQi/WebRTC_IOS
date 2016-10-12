//
//  ViewController.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "socketio/SocketIOOperation.h"
#import <libjingle_peerconnection/RTCICEServer.h>
#import <libjingle_peerconnection/RTCPeerConnection.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <libjingle_peerconnection/RTCMediaStream.h>
#import <libjingle_peerconnection/RTCAudioTrack.h>
#import <libjingle_peerconnection/RTCMediaConstraints.h>
#import <libjingle_peerconnection/RTCSessionDescriptionDelegate.h>
#import <libjingle_peerconnection/RTCPeerConnectionDelegate.h>
#import <libjingle_peerconnection/RTCPair.h>
#import <libjingle_peerconnection/RTCVideoCapturer.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <libjingle_peerconnection/RTCPeerConnectionInterface.h>
#import <libjingle_peerconnection/RTCAVFoundationVideoSource.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>
#import <libjingle_peerconnection/RTCICECandidate.h>
#import <libjingle_peerconnection/RTCSessionDescription.h>
#import <AppRTC/RTCICECandidate+JSON.h>
#import <AVFoundation/AVFoundation.h>
#import "Const.h"
extern std::string remoteSDP;
extern std::string remoteType;
extern std::string remoteSessionDes;
@interface ViewController ()<RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate>
@property(nonatomic) SocketIOOperation *socketOperation;

@property (nonatomic,strong)RTCPeerConnectionFactory *pcFactory;
@property (nonatomic,strong)RTCPeerConnection *peerConnection;
@property (nonatomic,strong) RTCMediaStream *localStream;
@property (nonatomic,strong) RTCAudioTrack *audioTrack;

@property (nonatomic,strong) NSString *m_strsdp;
@property (nonatomic,strong) NSString *m_stricecandidate;
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
    
         RTCConfiguration *config = [[RTCConfiguration alloc] init];
        _peerConnection = [self.pcFactory peerConnectionWithConfiguration:config constraints:nil delegate:self];
        
        [self.peerConnection addStream:self.localStream];
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
        
//        RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
//        if (localVideoTrack) {
//            [_localStream addVideoTrack:localVideoTrack];
//        }
        
    }
    return _localStream;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
//                                        @[[[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"]]
//                                                                             optionalConstraints: nil];
//
//    [self.peerConnection createOfferWithDelegate:self constraints:constraints];
}

- (void)beginAcceptCall
{
    // create answer
    NSString *remoteSessionDescription = [NSString stringWithUTF8String:remoteSessionDes.c_str()];
    if ([remoteSessionDescription length] > 0) {
        NSData *jsonData = [remoteSessionDescription dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
        NSString *sdpstr = [dic objectForKey:@"sdp"];
        NSString *sdptype = [dic objectForKey:@"type"];
        RTCSessionDescription *sessionDescription = [[RTCSessionDescription alloc] initWithType:sdptype sdp:sdpstr];
        NSLog(@"qizhang---set remote SessionDescription------%@",remoteSessionDescription.description);
        [self.peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:sessionDescription];
        
        
        RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                                            @[[[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"]]
                                                                                 optionalConstraints: nil];
        [self.peerConnection createAnswerWithDelegate:self constraints:constraints]; // create answer
    }
}

- (void)beginPostCall
{
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                                        @[[[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"]]
                                                                             optionalConstraints: nil];
    [self.peerConnection createAnswerWithDelegate:self constraints:constraints]; // create answer
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"------------have audio permission-----------");
        }else{
            NSLog(@"------------no audio permission-----------");
        }
    }];
    
    _socketOperation = new SocketIOOperation();
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshUIElements) userInfo:nil repeats:YES];
}

- (void)refreshUIElements
{
    // Check user is login or not
    if (_socketOperation->isLoginTVUWebrtc()) {
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = [UIColor grayColor];
        self.logintipLabel.text = @"Login success";
    }
    else
    {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = [UIColor blueColor];
        self.logintipLabel.text = @"Please login";
    }
    
    // Check if there is a phone call
    /* note: if reject a phone, should clear tvucallfromnumber */
    if (_socketOperation->getTvucallfromnumber().length() > 0) {
        self.acceptCallView.hidden = NO;
    }
    else
    {
        self.acceptCallView.hidden = YES;
    }
}

- (IBAction)onpressedbuttonLogin:(id)sender {
    NSString *userName = self.usernameField.text;
    if ([userName length] <= 0) {
        self.logintipLabel.text = @"Please input user name";
        return;
    }
    _socketOperation->setTvuusernumber(std::string([userName UTF8String]));
    dispatch_queue_t global_queue =  dispatch_queue_create("global_queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(global_queue, ^{
        _socketOperation->beginConnection("heheda"); // connection
    });
}

- (IBAction)onpressedbuttonCall:(id)sender {
    NSString *rtcNumber = self.rtcField.text;
    if ([rtcNumber length] <= 0) {
        self.calltipLabel.text = @"Please input rtc number";
        return;
    }
    dispatch_queue_t global_queue =  dispatch_queue_create("global_queue1", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(global_queue, ^{
         _socketOperation->postCallRequest(std::string([rtcNumber UTF8String]));
        

        [self beginPostCall];
        
    });
}

- (IBAction)onpressedbuttonAcceptCall:(id)sender {
    _socketOperation->postResponse(true);
    sleep(2); // wait a moment
    _socketOperation->setTvuIsAcceptCall(true);
    
    [self beginAcceptCall];
    self.endcallBtn.hidden = NO;
    self.acceptBtn.hidden = YES;
    self.rejectBtn.hidden = YES;
    self.calltipLabel.text = @"In call";
    
}

- (IBAction)onpressedbuttonRejectCall:(id)sender {
    _socketOperation->postResponse(false);
    sleep(3);
    _socketOperation->setTvuIsAcceptCall(false);
    
    _socketOperation->setTvucallfromnumber("");
    self.calltipLabel.text = @" ";
}

- (IBAction)onpressedbuttonEndCall:(id)sender {
}

#pragma mark -RTCSessionDescriptionDelegate
// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error
{
    if (sdp == NULL) {
        return;
    }
    NSLog(@"qizhang----debug-----enenenenenenenenenen-------%@",sdp.description);
//    [self.peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
//    self.m_strsdp = [sdp description];
//    _socketOperation->postanswer([[sdp description] UTF8String]);
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
 
    self.m_stricecandidate = [candidate description];
    NSData *data = [candidate JSONData];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
    NSString *candidateStr = (NSString *)[dict objectForKey:@"candidate"];
    NSLog(@"%@-----------%ld-----------%@",candidate.sdpMid,(long)candidate.sdpMLineIndex,candidateStr);
    _socketOperation->postice([candidateStr UTF8String], [candidate.sdpMid UTF8String], [[NSString stringWithFormat:@"%ld",(long)candidate.sdpMLineIndex] UTF8String]);
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
