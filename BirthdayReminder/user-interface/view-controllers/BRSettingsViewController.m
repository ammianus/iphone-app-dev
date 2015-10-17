//
//  BRSettingsViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/10/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRSettingsViewController.h"
#import "BRDSettings.h"
#import "BRDModel.h"
#import "BRStyleSheet.h"
#import "Appirater.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface BRSettingsViewController ()

@end

@implementation BRSettingsViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableCellNotificationTime.detailTextLabel.text = [[BRDSettings sharedInstance] titleForNotificationTime];
    self.tableCellDaysBefore.detailTextLabel.text = [[BRDSettings sharedInstance] titleForDaysBefore:[BRDSettings sharedInstance].daysBefore];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app-background.png"]];
    self.tableView.backgroundView = backgroundView;
}

- (IBAction)didClickDoneButton:(id)sender {
    [[BRDModel sharedInstance] updateCachedBirthdays];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *) createSectionHeaderWithLabel:(NSString *)text {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40.f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f,15.f, 300.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    [BRStyleSheet styleLabel:label withType:BRLabelTypeLarge];
    label.text = text;
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? [self createSectionHeaderWithLabel:@"Reminders"] : [self createSectionHeaderWithLabel:@"Share the Love"];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"didSelectRowAtIndexPath %d,%d",indexPath.section,indexPath.row);
    
    //ignore if the user tapped the Day Before or Alert Time table cells
    if(indexPath.section == 0){
        NSLog(@"Return section 0 selected");
        return;
    }
    
    NSString *text = @"Check out this iPhone App: Birthday Reminder";
    UIImage *image = [UIImage imageNamed:@"icon300x300.png"];
    NSURL *facebookPageLink = [NSURL URLWithString:@"http://www.facebook.com/apps/application.php?id=123956661050729"];
    NSURL *appStoreLink = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=489537509&mt=8"];
    
    SLComposeViewController *composeViewController;
    
    //we'll start a switch statement so that we can cater for future row taps in the project
    switch (indexPath.row) {
        case 0: { //Add an App Store Review!
            NSLog(@"switch case 0 - Appirater");
            [Appirater rateApp];
            break;
        }
        case 1: {//Share on Facebook
            NSLog(@"switch case 1 - Share on Facebook");
            if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                NSLog(@"No Facebook Account available for user");
                return;
            }
            composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [composeViewController addImage:image];
            [composeViewController setInitialText:text];
            [composeViewController addURL:appStoreLink];
            [self presentViewController:composeViewController animated:YES completion:nil];
            
            break;
        }
        case 2: { //Like on Facebook
            NSLog(@"switch case 2 - Like on Facebook");
            [[UIApplication sharedApplication] openURL:facebookPageLink];
            break;
        }
        case 3: { //Share on Twitter
            NSLog(@"switch case 3 - Share on Twitter");
            if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                NSLog(@"No Twitter Account available for user");
                return;
            }
            composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [composeViewController addImage:image];
            [composeViewController setInitialText:text];
            [composeViewController addURL:appStoreLink];
            [self presentViewController:composeViewController animated:YES completion:nil];
            
            break;
        }
        case 4:{ // Email a Friend
            NSLog(@"switch case 4 - Share on email");
            if(![MFMailComposeViewController canSendMail]){
                NSLog(@"Can't send email");
                return;
            }
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            
            //when adding attachments we have to convert the image into it's raw NSData representation
            [mailViewController addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"pic.png"];
            [mailViewController setSubject:@"Birthday Reminder"];
            
            //Combine the text and the app store link to create the email body
            NSString *textWithLink = [NSString stringWithFormat:@"%@\n\n%@",text,appStoreLink];
            
            [mailViewController setMessageBody:textWithLink isHTML:NO];
            mailViewController.mailComposeDelegate = self;
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
        case 5:{ // SMS a Friend
            NSLog(@"switch case 5 - Share on SMS");
            if(![MFMessageComposeViewController canSendText]){
                NSLog(@"Can't send SMS messages");
                return;
            }
            
            MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
            
            //Combine the text and the app store link to create the email body
            NSString *textWithLink = [NSString stringWithFormat:@"%@\n\n%@",text,appStoreLink];
            
            [messageViewController setBody:textWithLink];
            messageViewController.messageComposeDelegate = self;
            [self presentViewController:messageViewController animated:YES completion:nil];
        }
        default:
            NSLog(@"switch default");
            break;
    }

}

#pragma mark MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"mail composer cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"mail composer saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"mail composer sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"mail composer failed");
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MFMessageComposeViewControllerDelegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"message composer cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"message composer failed");
            break;
        case MessageComposeResultSent:
            NSLog(@"message composer sent");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
