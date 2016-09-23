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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onpressedbuttonLogin:(id)sender {
    _socketOperation->beginConnection("heheda");
}
@end
