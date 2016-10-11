//
//  ViewController.h
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *rtcField;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *logintipLabel;

@property (weak, nonatomic) IBOutlet UIView *acceptCallView;



- (IBAction)onpressedbuttonLogin:(id)sender;
- (IBAction)onpressedbuttonCall:(id)sender;
- (IBAction)onpressedbuttonAcceptCall:(id)sender;
- (IBAction)onpressedbuttonRejectCall:(id)sender;



@end

