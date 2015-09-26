//
//  BRImportViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 9/20/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRCoreViewController.h"

@interface BRImportViewController : BRCoreViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
/**
 * Import screens will display a list of birthdays to import. We'll store
 * the data for this list in an array property of the Import controller.
 * As public it can be accessed by subclasses directly
 */
@property (strong, nonatomic) NSArray *birthdays;


- (IBAction)didTapImportButton:(id)sender;
- (IBAction)didTapSelectAllButton:(id)sender;
- (IBAction)didTapSelectNoneButton:(id)sender;

@end
