//
//  BRDModel.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/29/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRDModel.h"
#import "BRDBirthday.h"
#import <AddressBook/AddressBook.h>
#import "BRDBirthdayImport.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>


//Facebook Social API
typedef enum : int {
    FacebookActionGetFriendsBirthdays = 1,
    FacebookActionPostToWall
}FacebookAction;

@interface BRDModel()

@property (strong) ACAccount *facebookAccount;
@property FacebookAction currentFacebookAction;
@property (nonatomic,strong) NSString *postToFacebookMessage;
@property (nonatomic,strong) NSString *postToFacebookID;

@end

@implementation BRDModel

static BRDModel * _sharedInstance = nil;

+ (BRDModel *) sharedInstance {
    if(!_sharedInstance){
        _sharedInstance = [[BRDModel alloc] init];
    }
    return _sharedInstance;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BirthdayReminder" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BirthdayReminder.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

-(void)saveChanges{
    NSError *error = nil;
    if([self.managedObjectContext hasChanges]){
        if(![self.managedObjectContext save:&error]){
            //save failed
            NSLog(@"Save failed: %@",[error localizedDescription]);
        }else{
            NSLog(@"Save succeeded");
        }
    }
}

-(void)cancelChanges{
    [self.managedObjectContext rollback];
}

-(NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    //NSPredicates are used to  filter results sets.
    //this predicateNSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BRDBirthday" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid IN %@", uids];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if(![fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    
    NSInteger resultCount = 0;
    
    if(fetchedObjects != nil){
      resultCount = [fetchedObjects count];
    }
    
    if(resultCount ==0){
        return [NSMutableDictionary dictionary];//nothing in the Core Data store
    }
    
    BRDBirthday *birthday;
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    int i;
    for (i=0;i<resultCount;i++){
        birthday = fetchedObjects[i];
        tmpDict[birthday.uid] = birthday;
    }
    
    return tmpDict;
    
}

#pragma mark - Application's Documents Directory
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "year.six.CoreDataExample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Address Book
// AddressBook functions use C, not Objective-C
-(void) fetchAddressBookBirthdays {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if(granted){
                    NSLog(@"Access to the Address Book has been granted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                            //completion handler can occur in a background thread and this call will update the UI on the main thread
                        [self extractBirthdaysFromAddressBook:ABAddressBookCreateWithOptions(NULL,NULL)];
                    });
                }else{
                    NSLog(@"Access to the Address Book has been denied");
                }
            });
            break;
        }
        case kABAuthorizationStatusAuthorized:
        {
            NSLog(@"User has already granted access to the Address Book");
            [self extractBirthdaysFromAddressBook:addressBook];
            break;
        }
        case kABAuthorizationStatusRestricted:
        {
            NSLog(@"User has restricted access to the Address Book possibly due to parental controls");
            break;
        }
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"User has denied access to the Address Book");
            break;
        }
        default:
            NSLog(@"Default");
            break;
    }//end switch ABAddressBookGetAuthorizationStatus
    
    CFRelease(addressBook);
}

-(void) extractBirthdaysFromAddressBook:(ABAddressBookRef)addressBook{
    NSLog(@"extractBirthdaysFromAddressBook");
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    CFIndex peopleCount = ABAddressBookGetPersonCount(addressBook);
    
    BRDBirthdayImport *birthday;
    
    //this is just a placeholder for now - we'll get the array populated later in the chapter
    NSMutableArray *birthdays = [NSMutableArray array];
    
    for (int i=0; i < peopleCount; i++) {
        ABRecordRef addressBookRecord = CFArrayGetValueAtIndex(people, i);
        CFDateRef birthdate = ABRecordCopyValue(addressBookRecord, kABPersonBirthdayProperty);
        if(birthdate == nil) continue;
        CFStringRef firstName = ABRecordCopyValue(addressBookRecord, kABPersonFirstNameProperty);
        if(firstName == nil){
            CFRelease(birthdate);
            continue;
        }
        NSLog(@"Found contact with birthday: %@, %@",firstName,birthdate);
        
        birthday = [[BRDBirthdayImport alloc] initWithAddressBookRecord:addressBookRecord];
        [birthdays addObject:birthday];
        
        CFRelease(firstName);
        CFRelease(birthdate);
    }
    CFRelease(people);
    
    //order the birthdays alphabetically by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [birthdays sortUsingDescriptors:sortDescriptors];
    
    //dispatch a notification with an array of birthday objects
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:birthdays,@"birthdays", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BRNotificationAddressBookBirthdaysDidUpdate object:self userInfo:userInfo];
}


/**
 * Following is the logic of this method:
 * 1. Loop through the birthdays to import and collect their unique ids
 * 2. Pass the unique ids to getExistingBirthdaysWithUIDs: to retrieve dictionary of existing birthdays
 * 3. Loop through the birthdays to import again, either creating or updating stored Core Data birthday entities
 * 4. Save our updates
 *
 */
-(void) importBirthdays:(NSArray *)birthdaysToImport
{
    int i;
    int max = [birthdaysToImport count];
    
    BRDBirthday *importBirthday;
    BRDBirthday *birthday;
    
    NSString *uid;
    NSMutableArray *newUIDs = [NSMutableArray array];
    
    for (i=0;i<max;i++)
    {
        importBirthday = birthdaysToImport[i];
        uid = importBirthday.uid;
        [newUIDs addObject:uid];
    }
    
    //use BRDModel's utility method to retrive existing birthdays with matching IDs
    //to the array of birthdays to import
    NSMutableDictionary *existingBirthdays = [self getExistingBirthdaysWithUIDs:newUIDs];
    
    NSManagedObjectContext *context = [BRDModel sharedInstance].managedObjectContext;
    
    for (i=0;i<max;i++)
    {
        importBirthday = birthdaysToImport[i];
        uid = importBirthday.uid;
        
        birthday = existingBirthdays[uid];
        if (birthday) {
            //a birthday with this udid already exists in Core Data, don't create a duplicate
        }
        else {
            birthday = [NSEntityDescription insertNewObjectForEntityForName:@"BRDBirthday" inManagedObjectContext:context];
            birthday.uid = uid;
            existingBirthdays[uid] = birthday;
        }
        
        //update the new or previously saved birthday entity
        birthday.name = importBirthday.name;
        birthday.uid = importBirthday.uid;
        birthday.picURL = importBirthday.picURL;
        birthday.imageData = importBirthday.imageData;
        birthday.addressBookID = importBirthday.addressBookID;
        birthday.facebookID = importBirthday.facebookID;
        
        birthday.birthDay = importBirthday.birthDay;
        birthday.birthMonth = importBirthday.birthMonth;
        birthday.birthYear = importBirthday.birthYear;
        
        [birthday updateNextBirthdayAndAge];
    }
    
    //save our new and updated changes to the Core Data store
    [self saveChanges];
    
}

#pragma mark Facebook birthdays

- (void)fetchFacebookBirthdays
{
    NSLog(@"fetchFacebookBirthdays");
    if (self.facebookAccount == nil) {
        self.currentFacebookAction = FacebookActionGetFriendsBirthdays;
        [self authenticateWithFacebook];
        return;
    }
    //We've got an authenticated Facebook Account if the code executes here
    // Facebook graph api documentation
    // http://developers.facebook.com/docs/reference/api
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    NSDictionary *params = @{ @"fields" : @"name,id,birthday"};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:params];
    
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting my Facebook friend birthdays: %@",error);
        }
        else
        {
            // Facebook's me/friends Graph API returns a root dictionary
            NSDictionary *resultD = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            NSLog(@"Facebook returned friends: %@",resultD);
            // with a 'data' key - an array of Facebook friend dictionaries
            NSArray *birthdayDictionaries = resultD[@"data"];
            
            int birthdayCount = [birthdayDictionaries count];
            NSDictionary *facebookDictionary;
            
            NSMutableArray *birthdays = [NSMutableArray array];
            BRDBirthdayImport *birthday;
            NSString *birthDateS;
            
            for (int i = 0; i < birthdayCount; i++)
            {
                facebookDictionary = birthdayDictionaries[i];
                birthDateS = facebookDictionary[@"birthday"];
                if (!birthDateS) continue;
                //create an instance of BRDBirthdayImport
                NSLog(@"Found a Facebook Birthday: %@",facebookDictionary);
                birthday = [[BRDBirthdayImport alloc] initWithFacebookDictionary:facebookDictionary];
                [birthdays addObject: birthday];
            }
            
            //Order the birthdays by name
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [birthdays sortUsingDescriptors:sortDescriptors];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //update the view on the main thread
                NSDictionary *userInfo = @{@"birthdays":birthdays};
                [[NSNotificationCenter defaultCenter] postNotificationName:BRNotificationFacebookBirthdaysDidUpdate object:self userInfo:userInfo];
            });
        }
    }];
}

- (void)postToFacebookWall:(NSString *)message withFacebookID:(NSString *)facebookID
{
    NSLog(@"postToFacebookWall");
    
    if (self.facebookAccount == nil) {
        //We're not authorized yet so store the Facebook message and id and start the authentication flow
        self.postToFacebookMessage = message;
        self.postToFacebookID = facebookID;
        self.currentFacebookAction = FacebookActionPostToWall;
        [self authenticateWithFacebook];
        return;
    }
    
    NSLog(@"We're authorized so post to Facebook!");
    
    NSDictionary *params = @{@"message":message};
    
    //Use the user's Facebook ID to call the post to friend feed Graph API path
    NSString *postGraphPath = [NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",facebookID];
    
    NSURL *requestURL = [NSURL URLWithString:postGraphPath];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:requestURL parameters:params];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error != nil) {
            NSLog(@"Error posting to Facebook: %@",error);
        }
        else
        {
            //Facebook returns a dictionary with the id of the new post - this might be useful for other projects
            NSDictionary *dict = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            NSLog(@"Successfully posted to Facebook! Post ID: %@",dict);
        }
    }];
    
}


- (void)authenticateWithFacebook {
    
    //Centralized iOS user Twitter, Facebook and Sina Weibo accounts are accessed by apps via the ACAccountStore
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    //TODO Replace with your Facebook.com app ID
    NSDictionary *options = @{ACFacebookAppIdKey: @"125381334264255",
                              ACFacebookPermissionsKey: @[@"publish_stream",@"friends_birthday"],ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
        if(granted) {
            //The completition handler may not fire in the main thread and as we are going to
            NSLog(@"Facebook Authorized!");
            NSArray *accounts = [accountStore accountsWithAccountType:accountTypeFacebook];
            self.facebookAccount = [accounts lastObject];
            
            //By checking what Facebook action the user was trying to perform before the authorization process we can complete the Facebook action when the authorization succeeds
            switch (self.currentFacebookAction) {
                case FacebookActionGetFriendsBirthdays:
                    [self fetchFacebookBirthdays];
                    break;
                case FacebookActionPostToWall:
                    //TODO - post to a friend's Facebook Wall
                    [self postToFacebookWall:self.postToFacebookMessage withFacebookID:self.postToFacebookID];
                    break;
            }
        } else {
            
            if ([error code] == ACErrorAccountNotFound) {
                NSLog(@"No Facebook Account Found");
            }
            else {
                NSLog(@"Facebook SSO Authentication Failed: %@",error);
            }
        }
    }];
}

@end
