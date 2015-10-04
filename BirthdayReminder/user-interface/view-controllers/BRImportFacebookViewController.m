//
//  BRImportFacebookViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/4/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRImportFacebookViewController.h"
#import "BRDModel.h"

@interface BRImportFacebookViewController ()

@end

@implementation BRImportFacebookViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookBirthdaysDidUpdate:) name:BRNotificationFacebookBirthdaysDidUpdate object:[BRDModel sharedInstance]];
    [[BRDModel sharedInstance] fetchFacebookBirthdays];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRNotificationFacebookBirthdaysDidUpdate object:[BRDModel sharedInstance]];
}

//subscriber for BRNotificationFacebookBirthdaysDidUpdate
-(void) handleFacebookBirthdaysDidUpdate:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    self.birthdays = userInfo[@"birthdays"];
    [self.tableView reloadData];
}


@end
