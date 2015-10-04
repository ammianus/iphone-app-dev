//
//  BRPostToFacebookWallViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/4/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "BRCoreViewController.h"

@interface BRPostToFacebookWallViewController : BRCoreViewController<UITextViewDelegate>
- (IBAction)postToFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong,nonatomic) NSString *facebookID;
@property (strong,nonatomic) NSString *initialPostText;

@end
