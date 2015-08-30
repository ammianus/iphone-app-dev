//
//  BRDBirthday.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/29/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRDBirthday.h"


@implementation BRDBirthday

//CoreData Entity
@dynamic birthDay;
@dynamic addressBookID;
@dynamic birthMonth;
@dynamic birthYear;
@dynamic facebookID;
@dynamic imageData;
@dynamic name;
@dynamic nextBirthday;
@dynamic nextBirthdayAge;
@dynamic notes;
@dynamic picURL;
@dynamic uid;


-(void)updateNextBirthdayAndAge {
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:dateComponents];
    
    dateComponents.day = [self.birthDay intValue];
    dateComponents.month = [self.birthMonth intValue];

    NSDate *birthdayThisYear = [calendar dateFromComponents:dateComponents];
    
    if([today compare:birthdayThisYear] == NSOrderedAscending){
        //birthday this year has passed so next birthday will be next year
        dateComponents.year++;
        self.nextBirthday = [calendar dateFromComponents:dateComponents];
        
    }else{
        self.nextBirthday = [birthdayThisYear copy];
    }
    
    if([self.birthDay intValue] > 0){
        self.nextBirthdayAge = [NSNumber numberWithInt:dateComponents.year - [self.birthYear intValue]];
    }else{
        self.nextBirthdayAge = [NSNumber numberWithInt:0];
    }
}

-(void)updateWithDefaults{
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    self.birthDay = @(dateComponents.day);
    self.birthMonth = @(dateComponents.month);
    self.birthYear = @(dateComponents.year);
    
    [self updateNextBirthdayAndAge];
    
}

#pragma mark read only methods

-(int) remainingDaysUntilNextBirthday {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    NSTimeInterval timeDiffSecs = [self.nextBirthday timeIntervalSinceDate:today];
    
    int days = floor(timeDiffSecs/60.f*60.f+24.f);
    
    return days;
}

-(BOOL) isBirthdayToday{
    return [self remainingDaysUntilNextBirthday] == 0;
}

- (NSString *) birthdayTextToDisplay{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    //calculates the difference from two dates (today, nextBirthday)
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:self.nextBirthday options:0];
    
    if(components.month == 0){
        if(components.day ==0 ){
            //today!
            
            if([self.nextBirthdayAge intValue] > 0){
                return [NSString stringWithFormat:@"%@ Today!",self.nextBirthdayAge];
            }else{
                return @"Today!";
            }
        }
        if(components.day == 1){
            //tomorrow!
            if([self.nextBirthdayAge intValue] >0){
                return [NSString stringWithFormat:@"%@ Tomorrow!",self.nextBirthdayAge];
            }else{
                return @"Tomorrow!";
            }
        }
    }
    
    NSString *text = @"";
    
    if([self.nextBirthdayAge intValue]>0) {
        text = [NSString stringWithFormat:@"%@ on ",self.nextBirthdayAge];
    }
    
    static NSDateFormatter *dateFormatterPartial;
    
    if(dateFormatterPartial == nil){
        dateFormatterPartial = [[NSDateFormatter alloc] init];
        [dateFormatterPartial setDateFormat:@"MMM d"];
    }
    
    return [text stringByAppendingFormat:@"%@", [dateFormatterPartial stringFromDate:self.nextBirthday]];
    
}

@end


