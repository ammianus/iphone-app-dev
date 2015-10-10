//
//  BRDSettings.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/10/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRDSettings.h"
#import "BRDBirthday.h"

@implementation BRDSettings

static BRDSettings *_sharedInstance = nil;
static NSDateFormatter *dateFormatter;

@synthesize notificationHour;
@synthesize notificationMinute;

//accessor method for the singleton instance
+ (BRDSettings*)sharedInstance {
    if( !_sharedInstance) {
        _sharedInstance = [[BRDSettings alloc] init];
    }
    return _sharedInstance;
}

-(int) notificationHour {
    //checks if user has saved a notification hour - if not, defaults to 9am
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *hour = [userDefaults objectForKey:@"notificationHour"];
    if(hour == nil){
        return 9;
    }
    return [hour intValue];
}

-(void) setNotificationHour:(int)notificationHourNew{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:notificationHourNew] forKey:@"notificationHour"];
    [userDefaults synchronize];
}

-(int) notificationMinute{
    //checks if user has saved a notification minute - if not, defaults to 0 minutes on the hour
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *minute = [userDefaults objectForKey:@"notificationMinute"];
    if(minute == nil){
        return 0;
    }
    return [minute intValue];
}

-(void) setNotificationMinute:(int)notificationMinuteNew{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:notificationMinuteNew] forKey:@"notificationMinute"];
    [userDefaults synchronize];
}

-(BRDaysBeforeType) daysBefore {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *daysBefore = [userDefaults objectForKey:@"daysBefore"];
    if(daysBefore == nil){
        return BRDaysBeforeTypeOnBirthday;
    }
    return [daysBefore intValue];
}

-(void) setDaysBefore:(BRDaysBeforeType)daysBefore{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:daysBefore] forKey:@"daysBefore"];
    [userDefaults synchronize];
}

-(NSString *) titleForDaysBefore:(BRDaysBeforeType)daysBefore {
    switch (daysBefore) {
        case BRDaysBeforeTypeOnBirthday:
            return @"On Birthday";
            break;
        case BRDaysBeforeTypeOneDay:
            return @"1 Day Before";
        case BRDaysBeforeTypeTwoDays:
            return @"2 Day Before";
        case BRDaysBeforeTypeThreeDays:
            return @"3 Day Before";
        case BRDaysBeforeTypeFiveDays:
            return @"5 Day Before";
        case BRDaysBeforeTypeOneWeek:
            return @"1 Week Before";
        case BRDaysBeforeTypeTwoWeeks:
            return @"2 Weeks Before";
        case BRDaysBeforeTypeThreeWeeks:
            return @"3 Weeks Before";
        default:
            break;
    }
    
    return @"";
}

-(NSString *) titleForNotificationTime {
    int hour = [BRDSettings sharedInstance].notificationHour;
    int minute = [BRDSettings sharedInstance].notificationMinute;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    components.hour = hour;
    components.minute = minute;
    
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    if(dateFormatter == nil){
        //create a single date formatter to return 9:00am, 2:00pm etc...
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
    }
    
    return [dateFormatter stringFromDate:date];
}

-(NSDate *) reminderDateForNextBirthday:(NSDate *)nextBirthday{
    NSTimeInterval timeInterval;
    NSTimeInterval secondsInOneDay = 60.f * 60.f * 24.f;
    
    //work out how many days to detract from the friend's next birthday for the reminder date
    switch (self.daysBefore) {
        case BRDaysBeforeTypeOnBirthday:
            timeInterval = 0.f;
            break;
        case BRDaysBeforeTypeOneDay:
            timeInterval = secondsInOneDay;
            break;
        case BRDaysBeforeTypeTwoDays:
            timeInterval = secondsInOneDay * 2.f;
            break;
        case BRDaysBeforeTypeThreeDays:
            timeInterval = secondsInOneDay * 3.f;
            break;
        case BRDaysBeforeTypeFiveDays:
            timeInterval = secondsInOneDay * 5.f;
            break;
        case BRDaysBeforeTypeOneWeek:
            timeInterval = secondsInOneDay * 7.f;
            break;
        case BRDaysBeforeTypeTwoWeeks:
            timeInterval = secondsInOneDay * 14.f;
            break;
        case BRDaysBeforeTypeThreeWeeks:
            timeInterval = secondsInOneDay * 21.f;
            break;
        default:
            break;
    }
    
    //this creates the day of the reminder at the time 00:00
    NSDate *reminderDate = [nextBirthday dateByAddingTimeInterval:-timeInterval];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:reminderDate];
    
    components.hour = self.notificationHour;
    components.minute = self.notificationMinute;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(NSString *) reminderTextForNextBirthday:(BRDBirthday *)birthday {
    NSString *text;
    
    if([birthday.nextBirthdayAge intValue] > 0){
        if(self.daysBefore == BRDaysBeforeTypeOnBirthday){
            //if the friend's birthday is the same day as the reminder e.g. "Joe is 30 today"
            text = [NSString stringWithFormat:@"%@ is %@",birthday.name, birthday.nextBirthdayAge];
        }else{
            text = [NSString stringWithFormat:@"%@ will be %@",birthday.name,birthday.nextBirthdayAge];
        }
    }else{
        text = [NSString stringWithFormat:@"It's %@'s Birthday",birthday.name];
    }
    
    switch (self.daysBefore){
        case BRDaysBeforeTypeOnBirthday:
            return [text stringByAppendingFormat:@"today!"];
        case BRDaysBeforeTypeOneDay:
            return [text stringByAppendingFormat:@"tomorrow!"];
        case BRDaysBeforeTypeTwoDays:
            return [text stringByAppendingFormat:@"in 2 days!"];
        case BRDaysBeforeTypeThreeDays:
            return [text stringByAppendingFormat:@"in 3 days!"];
        case BRDaysBeforeTypeFiveDays:
            return [text stringByAppendingFormat:@"in 5 days!"];
        case BRDaysBeforeTypeOneWeek:
            return [text stringByAppendingFormat:@"in 1 week!"];
        case BRDaysBeforeTypeTwoWeeks:
            return [text stringByAppendingFormat:@"in 2 weeks!"];
        case BRDaysBeforeTypeThreeWeeks:
            return [text stringByAppendingFormat:@"in 3 weeks!"];
        default:
                break;
    }
    
    return @"";
}


@end
