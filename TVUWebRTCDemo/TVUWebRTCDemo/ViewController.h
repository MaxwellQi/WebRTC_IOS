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
@property (weak, nonatomic) IBOutlet UITextField *rtcField;
@property (weak, nonatomic) IBOutlet UILabel *logintipLabel;


- (IBAction)onpressedbuttonLogin:(id)sender;
- (IBAction)onpressedbuttonCall:(id)sender;

@end

