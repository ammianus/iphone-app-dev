//
//  BRNotificationTimeViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRNotificationTimeViewController.h"

@interface BRNotificationTimeViewController ()

@end

@implementation BRNotificationTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Actions

/**
 * Action for timePicker value change
 */
- (IBAction)didChangeTime:(id)sender {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self.timePicker.date];
    
    NSLog(@"Changed time to %d:%d",components.hour,components.minute);
    
    
    
}
@end
