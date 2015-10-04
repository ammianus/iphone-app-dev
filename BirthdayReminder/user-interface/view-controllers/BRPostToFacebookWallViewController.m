//
//  BRPostToFacebookWallViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/4/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRPostToFacebookWallViewController.h"
#import "BRStyleSheet.h"
#import "UIImageView+RemoteFile.h"
#import "BRDModel.h"

@interface BRPostToFacebookWallViewController ()

@end

@implementation BRPostToFacebookWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BRStyleSheet styleRoundCorneredView:self.photoView];
    [BRStyleSheet styleTextView:self.textView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *facebookPicURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.facebookID];
    
    [self.photoView setImageWithRemoteFileURL:facebookPicURL placeHolderImage:[UIImage imageNamed:@"icon-birthday-cake.png"]];
    
    self.textView.text = self.initialPostText;
    
    [self.textView becomeFirstResponder];
    
    [self updatePostButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)postToFacebook:(id)sender {
    [[BRDModel sharedInstance] postToFacebookWall:self.textView.text withFacebookId:self.facebookID];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) updatePostButton{
    self.postButton.enabled = self.textView.text.length > 0;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self updatePostButton];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
