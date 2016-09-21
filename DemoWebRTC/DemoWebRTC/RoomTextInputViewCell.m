//
//  RoomTextInputViewCell.m
//  
//
//  Created by zhangqi on 14/9/2016.
//
//

#import "RoomTextInputViewCell.h"

@implementation RoomTextInputViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.textField setDelegate:self];
    [self.textField becomeFirstResponder];
    [self.joinButton setBackgroundColor:[UIColor colorWithWhite:100.0f/255.0f alpha:1.0f]];
    [self.joinButton setEnabled:NO];
    [self.joinButton.layer setCornerRadius:3.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(roomTextInputViewCell:shouldJoinRoom:)]) {
        [self.delegate roomTextInputViewCell:self shouldJoinRoom:self.textField.text];
    }
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isBackspace = [string isEqualToString:@""] && range.length == 1;
    NSString *text = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (isBackspace && text.length > 1) {
        text = [text substringWithRange:NSMakeRange(0, text.length-2)];
    }
    if (text.length >= 5) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.joinButton setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:133.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            [self.joinButton setEnabled:YES];
            [self layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.joinButton setBackgroundColor:[UIColor colorWithWhite:100.0f/255.0f alpha:1.0f]];
            [self.joinButton setEnabled:NO];
            [self layoutIfNeeded];
        }];
    }
    return YES;
}

@end
