//
//  BRDBirthdayImport.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 9/26/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface BRDBirthdayImport : NSObject

@property (nonatomic, strong) NSNumber *addressBookID;
@property (nonatomic, strong) NSNumber *birthDay;
@property (nonatomic, strong) NSNumber *birthMonth;
@property (nonatomic, strong) NSNumber *birthYear;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *nextBirthday;
@property (nonatomic, strong) NSNumber *nextBirthdayAge;
@property (nonatomic, strong) NSString *picURL;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, readonly) int remainingDaysUntilNextBirthday;
@property (nonatomic, readonly) NSString *birthdayTextToDisplay;
@property (nonatomic, readonly) BOOL isBirthdayToday;

-(id)initWithAddressBookRecord:(ABRecordRef)addressBookRecord;
-(id)initWithFacebookDictionary:(NSDictionary *)facebookDictionary;

@end
