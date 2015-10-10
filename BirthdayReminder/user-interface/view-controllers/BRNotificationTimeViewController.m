//
//  BRNotificationTimeViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRNotificationTimeViewController.h"
#import "BRStyleSheet.h"
#import "BRDSettings.h"

@interface BRNotificationTimeViewController ()

@end

@implementation BRNotificationTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BRStyleSheet styleLabel:self.whatTimeLabel withType:BRLabelTypeLarge];
    //Thanks IOS7 default behavior is the date picker has transparent background and dark text
    self.timePicker.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //retrieve the stored user settings for notification hour and minute
    int hour = [BRDSettings sharedInstance].notificationHour;
    int minute = [BRDSettings sharedInstance].notificationMinute;
    
    //Use NSDateComponents to create today's date with the hour/minute stored user notification settings
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    components.hour = hour;
    components.minute = minute;
    
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    self.timePicker.date = date;
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
    [BRDSettings sharedInstance].notificationHour = components.hour;
    [BRDSettings sharedInstance].notificationMinute = components.minute;
    
    
}
@end
