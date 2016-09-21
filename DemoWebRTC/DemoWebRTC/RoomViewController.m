//
//  RoomViewController.m
//  
//
//  Created by zhangqi on 14/9/2016.
//
//

#import "RoomViewController.h"
#import "RoomTextInputViewCell.h"
#import "VideoChatViewController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RoomTextInputViewCell *cell = (RoomTextInputViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RoomInputCell" forIndexPath:indexPath];
        [cell setDelegate:self];
        
        return cell;
    }
    
    return nil;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VideoChatViewController *viewController = (VideoChatViewController *)[segue destinationViewController];
    [viewController setRoomName:sender];
}

#pragma mark - RoomTextInputViewCellDelegate Methods

- (void)roomTextInputViewCell:(RoomTextInputViewCell *)cell shouldJoinRoom:(NSString *)room {
    [self performSegueWithIdentifier:@"VideoChatViewController" sender:room];
}

@end
