//
//  BRHomeViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCoreViewController.h"
#import "BRBlueButton.h"

@interface BRHomeViewController : BRCoreViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

/**
 * @param segue to unwind
 */
-(IBAction)unwindActionMethodName:(UIStoryboardSegue *) segue;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *importLabel;
@property (weak, nonatomic) IBOutlet BRBlueButton *addressBookButton;
@property (weak, nonatomic) IBOutlet BRBlueButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *importView;

- (IBAction)importFromAddressBookTapped:(id)sender;
- (IBAction)importFromFacebookTapped:(id)sender;


@end
