//
//  BRNotificationTimeViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRCoreViewController.h"

@interface BRNotificationTimeViewController : BRCoreViewController
@property (weak, nonatomic) IBOutlet UILabel *whatTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
- (IBAction)didChangeTime:(id)sender;

@end
