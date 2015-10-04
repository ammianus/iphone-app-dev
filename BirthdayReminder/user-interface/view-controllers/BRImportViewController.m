//
//  BRImportViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 9/20/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRImportViewController.h"
#import "BRDBirthdayImport.h"
#import "BRBirthdayTableViewCell.h"
#import "BRDModel.h"

@interface BRImportViewController()
//Keeps track of selected rows
@property (nonatomic, strong) NSMutableDictionary *selectedIndexPathToBirthday;

@end

@implementation BRImportViewController

- (IBAction)didTapImportButton:(id)sender {
    NSArray *birthdaysToImport = [self.selectedIndexPathToBirthday allValues];
    [[BRDModel sharedInstance] importBirthdays:birthdaysToImport];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSelectAllButton:(id)sender {
    
    BRDBirthdayImport *birthdayImport;
    
    int maxLoop = [self.birthdays count];
    
    NSIndexPath *indexPath;
    
    for(int i=0; i<maxLoop; i++){
        birthdayImport = self.birthdays[i];
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //create the selection reference
        self.selectedIndexPathToBirthday[indexPath] = birthdayImport;
    }
    
    [self.tableView reloadData];
    [self updateImportButton];
    
}

- (IBAction)didTapSelectNoneButton:(id)sender {
    
    [self.selectedIndexPathToBirthday removeAllObjects];
    [self.tableView reloadData];
    [self updateImportButton];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateImportButton];
}

#pragma mark UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.birthdays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    BRDBirthdayImport *birthdayImport = self.birthdays[indexPath.row];
    
    BRBirthdayTableViewCell *brTableCell = (BRBirthdayTableViewCell *) cell;
    
    brTableCell.birthdayImport = birthdayImport;
    
    //if(birthdayImport.imageData == nil){
    //    brTableCell.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    //}else{
    //    brTableCell.iconView.image = [UIImage imageWithData:birthdayImport.imageData];
    //}
    
    UIImage *backgroundImage = (indexPath.row == 0) ? [UIImage imageNamed:@"table-row-background.png"] : [UIImage imageNamed:@"table-row-icing-background.png"];
    brTableCell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    //set the not selected icon on top of the cell
    //Table view cells have an accessoryView property that we can set to any view instance and our designated view will be displayed to the right of our table cell.
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-not-selected.png"]];
    //brTableCell.accessoryView = imageView;
    [self updateAccessoryForTableCell:brTableCell atIndexPath:indexPath];
    
    return cell;
}

-(NSMutableDictionary *) selectedIndexPathToBirthday {
    if(_selectedIndexPathToBirthday == nil){
        _selectedIndexPathToBirthday = [NSMutableDictionary dictionary];
    }
    return _selectedIndexPathToBirthday;
}

#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected = [self isSelectedAtIndexPath:indexPath];
    
    BRDBirthdayImport *birthdayImport = self.birthdays[indexPath.row];
    
    if(isSelected){//Already selected, so deselect
        [self.selectedIndexPathToBirthday removeObjectForKey:indexPath];
    }else{//not currently selected so select
        [self.selectedIndexPathToBirthday setObject:birthdayImport forKey:indexPath];
    }
    
    //update the accessory view image
    [self updateAccessoryForTableCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
    
    //enable/disable the import button
    [self updateImportButton];
}

#pragma mark private methods

//Enables/Disables the import button if there are zero rows selected
- (void) updateImportButton {
    self.importButton.enabled = [self.selectedIndexPathToBirthday count] > 0;
}

//Helper method to check whether a row is selected or not
-(BOOL) isSelectedAtIndexPath:(NSIndexPath *)indexPath {
    return self.selectedIndexPathToBirthday[indexPath] ? YES : NO;
}

//Refreshes the selection tick of a table cell
-(void)updateAccessoryForTableCell:(UITableViewCell *)tableCell atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView;
    if ([self isSelectedAtIndexPath:indexPath]){
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-selected.png"]];
    }else{
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-not-selected.png"]];
    }
    
    tableCell.accessoryView = imageView;
}

@end
