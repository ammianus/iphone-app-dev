//
//  BRNotesEditViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRNotesEditViewController.h"

@interface BRNotesEditViewController ()

@end

@implementation BRNotesEditViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Make sure the Text View keyboard is onscreen when the view is loaded.
 * @param animated
 */
- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView{
    NSLog(@"User changed the notes text: %@", self.textView.text);
}

@end
