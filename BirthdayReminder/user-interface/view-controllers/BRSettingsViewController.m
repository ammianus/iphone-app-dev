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
    
    
    //we'll start a switch statement so that we can cater for future row taps in the project
    switch (indexPath.row) {
        case 0: { //Add an App Store Review!
            NSLog(@"switch case 1");
            [Appirater rateApp];
            break;
        }
        case 1: {//Share!
            NSLog(@"switch case 0");
            NSArray *activityItems = @[text,image,appStoreLink];
            
            //seems like this behaves differently than described in the book...
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList];
            [self presentViewController:activityViewController animated:YES completion:nil];
            
            break;
        }
        default:
            NSLog(@"switch default");
            break;
    }

}

@end
