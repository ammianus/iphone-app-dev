//
//  BRSettingsViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/10/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRSettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *tableCellDaysBefore;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableCellNotificationTime;
- (IBAction)didClickDoneButton:(id)sender;

@end
