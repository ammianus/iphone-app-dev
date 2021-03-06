//
//  BRDModel.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/29/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#define BRNotificationAddressBookBirthdaysDidUpdate @"BRNotificationAddressBookBirthdaysDidUpdate"

#define BRNotificationFacebookBirthdaysDidUpdate @"BRNotificationFacebookBirthdaysDidUpdate"

#define BRNotificationCachedBirthdaysDidUpdate @"BRNotificationCachedBirthdaysDidUpdate"

#import <Foundation/Foundation.h>

/**
 * This class is a singleton to access the model
 */
@interface BRDModel : NSObject

+(BRDModel *)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveChanges;
-(void)cancelChanges;
-(NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids;
-(void)fetchAddressBookBirthdays;
-(void) importBirthdays:(NSArray *)birthdaysToImport;
-(void)fetchFacebookBirthdays;
-(void)postToFacebookWall:(NSString *)message withFacebookId:(NSString *)facebookID;
-(void) updateCachedBirthdays;
@end
