//
//  BRBirthdayEditViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRBirthdayEditViewController.h"

@interface BRBirthdayEditViewController ()

@end

@implementation BRBirthdayEditViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSaveButton];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextFieldDelegate

/**
 * Handles the nameTextField's Return (Done).
 * @param textField
 * @return BOOL NO
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    return NO;
}

#pragma mark UIControl Actions

/**
 * Action for the nameTextField change of text
 * @param sender id of sender
 */
- (IBAction)didChangeNameText:(id)sender {
    NSLog(@"The text was changed: %@",self.nameTextField.text);
    [self updateSaveButton];
}

/**
 * Action for the includeYearSwitch value change
 * @param sender id of sender
 */
- (IBAction)didToggleSwitch:(id)sender {
    if (self.includeYearSwitch.on) {
        NSLog(@"Include Year Switch ON");
    }else{
        NSLog(@"Include Year Switch OFF");
    }
}

/**
 * Action for the datePicker value change
 * @param sender id of sender 
 */
- (IBAction)didChangeDatePicker:(id)sender {
    NSLog(@"New Birthdate Selected: %@",self.datePicker.date);
}

- (IBAction)didTapPhoto:(id)sender {
    NSLog(@"Did Tap Photo!");
}

#pragma mark Private Methods

/**
 * Only enables the Save Bar Button when the Name Text Field
 * has text.
 */
- (void)updateSaveButton {
    self.saveButton.enabled = self.nameTextField.text.length > 0;
}
@end
