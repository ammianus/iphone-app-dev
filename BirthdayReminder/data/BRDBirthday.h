//
//  BRDBirthday.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/29/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BRDBirthday : NSManagedObject

//CoreData Entity BRDBirthday
@property (nonatomic, retain) NSNumber * birthDay;
@property (nonatomic, retain) NSNumber * addressBookID;
@property (nonatomic, retain) NSNumber * birthMonth;
@property (nonatomic, retain) NSNumber * birthYear;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * nextBirthday;
@property (nonatomic, retain) NSNumber * nextBirthdayAge;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * picURL;
@property (nonatomic, retain) NSString * uid;

//public methods

//Provides users with a day count until friend's next birthday
@property (nonatomic, readonly) int remainingDaysUntilNextBirthday;
//Human-readable text string such as "44 Tomorrow"
@property (nonatomic, readonly) NSString *birthdayTextToDisplay;
//If the birthday is today, display a cake image
@property (nonatomic, readonly) BOOL isBirthdayToday;

/**
 * Updates the nextBirthday and nextBirthdayAge
 */
-(void)updateNextBirthdayAndAge;
/**
 * Called when the Add Birthday button is tapped to set the basic attributes required by BRDBirthday entities.
 * Namely birthdayDay and birthMonth
 */
-(void)updateWithDefaults;

@end
