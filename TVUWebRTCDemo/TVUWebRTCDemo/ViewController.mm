//
//  ViewController.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "socketio/SocketIOOperation.h"
@interface ViewController ()
@property(nonatomic) SocketIOOperation *socketOperation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _socketOperation = new SocketIOOperation();
    
}

- (void)postResponse
{
    _socketOperation->postresponse_tvu();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onpressedbuttonLogin:(id)sender {
    NSString *userName = self.userNameField.text;
//    NSArray *userNameArr = @[userName];
//    NSJSONSerialization *userNameJson = [NSJSONSerialization JE]
//    
//    NSDictionary *userNameDict = @{userName:};
    
    
    _socketOperation->beginConnection("heheda");
}

- (IBAction)onpressedbuttonCall:(id)sender {
//    _socketOperation->callPhone();
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(postResponse) userInfo:nil repeats:YES];
}
@end
