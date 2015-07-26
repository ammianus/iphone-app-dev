//
//  BRBirthdayEditViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCoreViewController.h"

@interface BRBirthdayEditViewController : BRCoreViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *includeYearLabel;
@property (weak, nonatomic) IBOutlet UISwitch *includeYearSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *picPhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picBackground;

- (IBAction)didChangeNameText:(id)sender;
- (IBAction)didToggleSwitch:(id)sender;
- (IBAction)didChangeDatePicker:(id)sender;
- (IBAction)didTapPhoto:(id)sender;

@end
