//
//  RoomTextInputViewCell.h
//  
//
//  Created by zhangqi on 14/9/2016.
//
//

#import <UIKit/UIKit.h>

@protocol RoomTextInputViewCellDelegate;

@interface RoomTextInputViewCell : UITableViewCell <UITextFieldDelegate>

@property (assign, nonatomic) id <RoomTextInputViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;


- (IBAction)touchButtonPressed:(id)sender;

@end

@protocol RoomTextInputViewCellDelegate<NSObject>
@optional
- (void)roomTextInputViewCell:(RoomTextInputViewCell *)cell shouldJoinRoom:(NSString *)room;
@end
