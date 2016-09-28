//
//  ViewController.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "socketio/SocketIOOperation.h"
#import <AppRTC/ARDAppClient.h>
#import <AppRTC/RTCSessionDescription+JSON.h>
extern int socketioStatus;
@interface ViewController () <ARDAppClientDelegate>
@property(nonatomic) SocketIOOperation *socketOperation;

@property (strong, nonatomic) ARDAppClient *client;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Connect to the room

    self.client = [[ARDAppClient alloc] initWithDelegate:self];
    [self.client setServerHostUrl:@"http://10.12.23.232:9000"];
//    [self.client connectToRoomWithId:@"222222" options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    _socketOperation = new SocketIOOperation();
    _socketOperation->beginConnection("heheda"); // connection
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (socketioStatus == 1) {
        [RTCSessionDescription descriptionFromJSONDictionary:@{}];
        
    }
}

- (NSString *)getOfferParam
{
    RTCSessionDescription *rtcsession = [RTCSessionDescription descriptionFromJSONDictionary:NULL];
    NSDictionary *dict = @{@"to":@"222222",@"type":@"answer",@"sdp":rtcsession};
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *offer_json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return offer_json;
    }
    return NULL;
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

#pragma mark - ARDAppClientDelegate

- (void)appClient:(ARDAppClient *)client didChangeState:(ARDAppClientState)state {
    switch (state) {
        case kARDAppClientStateConnected:
            NSLog(@"Client connected.");
            break;
        case kARDAppClientStateConnecting:
            NSLog(@"Client connecting.");
            break;
        case kARDAppClientStateDisconnected:
            NSLog(@"Client disconnected.");
            
            break;
    }
}

- (void)appClient:(ARDAppClient *)client didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack {
 
}

- (void)appClient:(ARDAppClient *)client didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack {
   
}

- (void)appClient:(ARDAppClient *)client didError:(NSError *)error {
  
}

@end
