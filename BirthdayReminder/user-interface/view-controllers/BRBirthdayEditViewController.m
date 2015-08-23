//
//  BRBirthdayEditViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRBirthdayEditViewController.h"


@interface BRBirthdayEditViewController ()

//private property
@property (nonatomic, strong) UIImagePickerController *imagePicker;

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
    
    NSString *name = self.birthday[@"name"];
    NSDate *birthdate = self.birthday[@"birthdate"];
    UIImage *image = self.birthday[@"image"];
    
    self.nameTextField.text = name;
    self.datePicker.date = birthdate;
    if(image == nil){
        //default to birthday cake pic there's no birthday image
        self.photoView.image = [UIImage imageNamed:@"icon-birthdat-cake.png"];
    }else {
        self.photoView.image = image;
    }
    
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
    self.birthday[@"name"] = self.nameTextField.text;
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
    self.birthday[@"birthdate"] = self.datePicker.date;
}

/**
 * Action for the touchGesture
 * @param sender id of sender
 */
- (IBAction)didTapPhoto:(id)sender {
    NSLog(@"Did Tap Photo!");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSLog(@"No Camera detected!");
        //display photo library if no camera detected
        [self pickPhoto];
        
        return;
    }
    
    //use action sheet to prompt the user for two options:
    // Take a Photo
    // Pick from iPhone Photo Library
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo",@"Pick from Photo Library", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark Private Methods

/**
 * Only enables the Save Bar Button when the Name Text Field
 * has text.
 */
- (void)updateSaveButton {
    self.saveButton.enabled = self.nameTextField.text.length > 0;
}

-(UIImagePickerController *) imagePicker {
    if(_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

-(void) takePhoto {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil ];
}

-(void) pickPhoto {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil ];
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == actionSheet.cancelButtonIndex) return;
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self pickPhoto];
            break;
        default:
            NSLog(@"Default buttonIndex switch %d",buttonIndex);
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.photoView.image = image;
    
    self.birthday[@"image"] = image;
}



@end

