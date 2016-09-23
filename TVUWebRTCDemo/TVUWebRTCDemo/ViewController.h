//
//  ViewController.h
//  TVUWebRTCDemo
//
//  Created by zhangqi on 23/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)onpressedbuttonLogin:(id)sender;

@end

