//
//  BRDBirthdayImport.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 9/26/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRDBirthdayImport.h"
#import "UIImage+Thumbnail.h"

@implementation BRDBirthdayImport

-(void)updateNextBirthdayAndAge {
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:dateComponents];
    
    dateComponents.day = [self.birthDay intValue];
    dateComponents.month = [self.birthMonth intValue];
    
    NSDate *birthdayThisYear = [calendar dateFromComponents:dateComponents];
    
    if([today compare:birthdayThisYear] == NSOrderedDescending){
        //birthday this year has passed so next birthday will be next year
        dateComponents.year++;
        self.nextBirthday = [calendar dateFromComponents:dateComponents];
    }else{
        self.nextBirthday = [birthdayThisYear copy];
    }
    
    if([self.birthYear intValue] > 0){
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
    NSLog(@"today %@ nextBirthday %@",today, self.nextBirthday);
    
    NSTimeInterval timeDiffSecs = [self.nextBirthday timeIntervalSinceDate:today];
    
    int days = floor(timeDiffSecs/(60.f*60.f*24.f));
    NSLog(@"remaining days %d",days);
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

-(id)initWithAddressBookRecord:(ABRecordRef)addressBookRecord
{
    self = [super init];
    if (self) {
        CFStringRef firstName = nil;
        CFStringRef lastName = nil;
        ABRecordID recordID;
        CFDateRef birthdate = nil;
        NSString *name = @"";
        
        //Attempt to populate core foundation string and date references
        recordID = ABRecordGetRecordID(addressBookRecord);
        firstName = ABRecordCopyValue(addressBookRecord, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(addressBookRecord, kABPersonLastNameProperty);
        birthdate  = ABRecordCopyValue(addressBookRecord, kABPersonBirthdayProperty);
        
        //combine first and last names into a single string
        if (firstName != nil) {
            name = [name stringByAppendingString:(__bridge NSString *)firstName];
            if (lastName != nil) {
                name = [name stringByAppendingFormat:@" %@",lastName];
            }
        }
        else if (lastName != nil) {
            name = (__bridge NSString *)lastName;
        }
        
        self.name = name;
        
        //we'll use this unique id to ensure that we never create duplicate imports in our Core Data store
        //if the user attempts to re-import this birthday address book contact
        self.uid = [NSString stringWithFormat:@"ab-%d",recordID];
        self.addressBookID = [NSNumber numberWithInt:recordID];
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:(__bridge NSDate *)birthdate];
        
        self.birthDay = @(dateComponents.day);
        self.birthMonth = @(dateComponents.month);
        self.birthYear = @(dateComponents.year);
        
        [self updateNextBirthdayAndAge];
        
        //just a precautionary measure incase the birthday date has been set more than 150 years ago!
        if ([self.nextBirthdayAge intValue] > 150) {
            self.birthYear = [NSNumber numberWithInt:0];
            self.nextBirthdayAge = [NSNumber numberWithInt:0];
        }
        
        
        //Check for Image Data associated with the user
        if (ABPersonHasImageData(addressBookRecord)) {
            CFDataRef imageData = ABPersonCopyImageData(addressBookRecord);
            
            UIImage *fullSizeImage = [UIImage imageWithData:(__bridge NSData *)imageData];
            
            CGFloat side = 71.f;
            side *= [[UIScreen mainScreen] scale];
            
            UIImage *thumbnail = [fullSizeImage createThumbnailToFillSize:CGSizeMake(side, side)];
            
            self.imageData = UIImageJPEGRepresentation(thumbnail, 1.f);
            
            CFRelease(imageData);
        }
        
        if (firstName) CFRelease(firstName);
        if (lastName) CFRelease(lastName);
        if (birthdate) CFRelease(birthdate);
    }
    return self;
}

-(id)initWithFacebookDictionary:(NSDictionary *)facebookDictionary{
    self = [super init];
    if(self){
        self.name = [facebookDictionary objectForKey:@"name"];
        self.uid = [NSString stringWithFormat:@"fb-%@",facebookDictionary[@"id"]];
        self.facebookID = [NSString stringWithFormat:@"%@",facebookDictionary[@"id"]];
        
        //Facebook provides a convenience URL for Facebook profile pics as long as you have the Facebook ID
        self.picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.facebookID];
        
        //Facebook returns birthdays in string format [month]/[day]/[year]
        NSString *birthDateString = [facebookDictionary objectForKey:@"birthday"];
        NSArray *birthdaySegments = [birthDateString componentsSeparatedByString:@"/"];
        
        self.birthDay = [NSNumber numberWithInt:[birthdaySegments[1] integerValue]];
        self.birthMonth = [NSNumber numberWithInt:[birthdaySegments[0] integerValue]];
        
        if([birthdaySegments count] > 2) { //includes year
            self.birthYear = [NSNumber numberWithInt:[birthdaySegments[2] integerValue]];
        }
        
        [self updateNextBirthdayAndAge];
    }
    
    return self;
}

@end
