//
//  ViewController.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "socketio/SocketIOOperation.h"
extern int socketioStatus;
@interface ViewController ()
@property(nonatomic) SocketIOOperation *socketOperation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _socketOperation = new SocketIOOperation();
    _socketOperation->beginConnection("heheda"); // connection
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
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
