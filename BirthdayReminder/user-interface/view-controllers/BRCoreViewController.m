//
//  BRCoreViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRCoreViewController.h"

@interface BRCoreViewController ()

@end

@implementation BRCoreViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAndDismiss:(id)sender {
    NSLog(@"Cancel!");
    [self dismissViewControllerAnimated:YES completion:^{
        //any code we place inside this block
        //will run once the view controller had been dismissed
        NSLog(@"Dismiss complete!");
    }];
}

- (IBAction)saveAndDismiss:(id)sender {
    NSLog(@"Save!");
    [self dismissViewControllerAnimated:YES completion:^{
        //any code we place inside this block
        //will run once the view controller had been dismissed
        NSLog(@"Dismiss complete!");
    }];
}

@end
