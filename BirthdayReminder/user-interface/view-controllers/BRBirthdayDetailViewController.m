//
//  BRBirthdayDetailViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRBirthdayDetailViewController.h"
#import "BRBirthdayEditViewController.h"
#import "BRNotesEditViewController.h"
#import "BRDBirthday.h"
#import "BRStyleSheet.h"
#import <AddressBook/AddressBook.h>
#import "BRDModel.h"
#import "UIImageView+RemoteFile.h"
#import "BRPostToFacebookWallViewController.h"
// When overriding UIViewController methods be sure to call the super method
// implementation to avoid problems at runtime
@interface BRBirthdayDetailViewController ()


@end

@implementation BRBirthdayDetailViewController

// Open First
// best place to put model data retained by the lifecycle of the controller
-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder");
    }
    return self;
}

// Close Third
-(void) dealloc {
    NSLog(@"dealloc");
}

//  Open Second
- (void)viewDidLoad {
    // viewDidLoad is the first point of access to your Interface Builder outlets. So when viewDidLoad is invoked, you should execute any view customization code.
    // can be called multiple times during the life of the view controller
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
    
    [BRStyleSheet styleRoundCorneredView:self.photoView];
    
    [BRStyleSheet styleLabel:self.birthdayLabel withType:BRLabelTypeLarge];
    [BRStyleSheet styleLabel:self.notesTitleLabel withType:BRLabelTypeLarge];
    [BRStyleSheet styleLabel:self.notesTextLabel withType:BRLabelTypeLarge];
    [BRStyleSheet styleLabel:self.remainingDaysLabel withType:BRLabelTypeDaysUntilBirthday];
    [BRStyleSheet styleLabel:self.remainingDaysSubTextLabel withType:BRLabelTypeDaysUntilBirthdaySubText];
}

//  Open Third

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");

    self.title = self.birthday.name;
    if(self.birthday.imageData == nil){
        if([self.birthday.picURL length] > 0){
            [self.photoView setImageWithRemoteFileURL:self.birthday.picURL placeHolderImage:[UIImage imageNamed:@"icon-birthday-cake.png"]];
        }else{
            self.photoView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
        }
    }else{
        self.photoView.image = [UIImage imageWithData:_birthday.imageData];
    }
    
    int days = self.birthday.remainingDaysUntilNextBirthday;
    
    if (days == 0) {
        //Birthday is today!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }else{
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-days-remaining.png"];
    }
    
    self.birthdayLabel.text = self.birthday.birthdayTextToDisplay;
    
    //notes text with line breaks
    NSString *notes = (self.birthday.notes && self.birthday.notes.length > 0) ? self.birthday.notes : @"";
    
    CGFloat cY = self.notesTextLabel.frame.origin.y;
    
    //iOS 7.0 sizeWithFont is deprecated
    CGSize notesLabelSize = [notes sizeWithFont:self.notesTextLabel.font constrainedToSize:CGSizeMake(300.f, 300.f) lineBreakMode:NSLineBreakByWordWrapping];
    //new method isn't the same...moving on
    //CGRect notesLabelSize = [notes boundingRectWithSize:CGSizeMake(300.f, 300.f) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:nil context:nil];
    
    CGRect frame = self.notesTextLabel.frame;
    frame.size.height = notesLabelSize.height;
    self.notesTextLabel.frame = frame;
    self.notesTextLabel.text = notes;
    
    cY += frame.size.height;
    cY += 10.f;
    
    CGFloat buttonGap = 6.f;
    
    cY += buttonGap * 2;
    
    NSMutableArray *buttonsToShow = [NSMutableArray arrayWithObjects:self.facebookButton,self.callButton,self.smsButton,self.emailButton,self.deleteButton, nil];
    
    NSMutableArray *buttonsToHide = [NSMutableArray array];
    if (self.birthday.facebookID == nil) {
        [buttonsToShow removeObject:self.facebookButton];
        [buttonsToHide addObject:self.facebookButton];
    }
    
    if ([self callLink] == nil) {
        [buttonsToShow removeObject:self.callButton];
        [buttonsToHide addObject:self.callButton];
    }
    
    if ([self smsLink] == nil) {
        [buttonsToShow removeObject:self.smsButton];
        [buttonsToHide addObject:self.smsButton];
    }
    
    if ([self emailLink] == nil) {
        [buttonsToShow removeObject:self.emailButton];
        [buttonsToHide addObject:self.emailButton];
    }
    
    UIButton *button;
    
    for(button in buttonsToHide){
        button.hidden = YES;
    }
    
    int i;
    
    for(i=0;i<[buttonsToShow count];i++){
        button = [buttonsToShow objectAtIndex:i];
        button.hidden = NO;
        frame = button.frame;
        frame.origin.y = cY;
        button.frame = frame;
        cY += button.frame.size.height + buttonGap;
    }
    
    self.scrollVIew.contentSize = CGSizeMake(320, cY);
}

//  Open Fourth
/**
 Called when this view finished appearing.
 @param animated
 */
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

// Close First
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

// Close Second
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *identifier = segue.identifier;
    NSLog(@"Segue: %@",identifier);
    
    if([identifier isEqualToString:@"EditBirthday"]){
        //Edit this birthday
        UINavigationController *navigationController = segue.destinationViewController;
        
        BRBirthdayEditViewController *birthdayEditViewController = (BRBirthdayEditViewController *) navigationController.topViewController;
        birthdayEditViewController.birthday = self.birthday;
    }else if([identifier isEqualToString:@"EditNotes"]){
        //Edit this birthday
        UINavigationController *navigationController = segue.destinationViewController;
        BRNotesEditViewController *birthdayNotesEditViewController = (BRNotesEditViewController *) navigationController.topViewController;
        birthdayNotesEditViewController.birthday = self.birthday;
    }
}




- (IBAction)facebookButtonTapped:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostToFacebookWall"];
    BRPostToFacebookWallViewController *facebookWallViewController = (BRPostToFacebookWallViewController *) navigationController.topViewController;
    facebookWallViewController.facebookID = self.birthday.facebookID;
    facebookWallViewController.initialPostText = @"Happy Birthday!";
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)callButtonTapped:(id)sender {
    NSString *link = [self callLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)smsButtonTapped:(id)sender {
    NSString *link = [self smsLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)emailButtonTapped:(id)sender {
    NSString *link = [self emailLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)deleteButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:[NSString stringWithFormat:@"Delete %@",self.birthday.name] otherButtonTitles:nil];
    [actionSheet showInView:self.view];
                                  
}

#pragma mark AddressBook contact helper methods

-(NSString *)telephoneNumber{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[self.birthday.addressBookID intValue]);
    
    ABMultiValueRef multi = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    NSString *telephone = nil;
    NSString *str1 = @"";
    
    if(ABMultiValueGetCount(multi)>0){
        //telephone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        //this works...
        //telephone = @"(781) 956-2409";
        NSLog(@"Before Telephone %@",telephone);
        //TODO Not working???
        telephone = [telephone stringByReplacingOccurrencesOfString:@" " withString:str1];
    }
    
    CFRelease(multi);
    CFRelease(addressBook);
    NSLog(@"After Telephone %@",telephone);
    return telephone;
}

#pragma mark URL links

//see http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html

-(NSString *)callLink
{
    if(!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) {return nil;}
    
    NSString *telephoneNumber = [self telephoneNumber];
    if(!telephoneNumber){ return nil; }
    
    NSString* callLink = [NSString stringWithFormat:@"tel:%@",telephoneNumber];
    NSLog(@"Call Link %@",callLink);
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callLink]]){
        return callLink;
    }
    return nil;
}

-(NSString *)smsLink
{
    if(!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) return nil;
    NSString *telephoneNumber = [self telephoneNumber];
    if(!telephoneNumber) return nil;
    
    NSString* callLink = [NSString stringWithFormat:@"sms:%@",telephoneNumber];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callLink]]){
        return callLink;
    }
    return nil;
}

-(NSString *)emailLink
{
    if(!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) return nil;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[self.birthday.addressBookID intValue]);
    
    ABMultiValueRef multi = ABRecordCopyValue(record, kABPersonEmailProperty);
    
    NSString *email = nil;
    
    if(ABMultiValueGetCount(multi)>0){//check if the contact ahs 1 or more emails assigned
        email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
    }
    
    CFRelease(multi);
    CFRelease(addressBook);
    
    if(email){
        NSString* emailLink = [NSString stringWithFormat:@"mailto:%@",email];
        //we can pre-populate the email subject with the words 'Happy Birthday'
        emailLink = [emailLink stringByAppendingString:@"?subject=Happy%20Birthday"];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:emailLink]]){
            return emailLink;
        }
    }
    
    return nil;
}

#pragma mark UIActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //check whether the user cancelled the delete instruction via the action sheet cancel button
    if(buttonIndex == actionSheet.cancelButtonIndex) return;
    
    //grab a reference to the core data managed object context
    NSManagedObjectContext *context = [BRDModel sharedInstance].managedObjectContext;
    //delete this birthday entity from the managed object context
    [context deleteObject:self.birthday];
    //save our changes to the persistent Core Data store
    [[BRDModel sharedInstance] saveChanges];
    
    //pop this view controller off the stack and slide back to the home screen
    [self.navigationController popViewControllerAnimated:YES];
}

@end
