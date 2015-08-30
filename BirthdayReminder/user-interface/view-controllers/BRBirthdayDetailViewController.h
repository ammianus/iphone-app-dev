//
//  BRBirthdayDetailViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCoreViewController.h"
@class BRDBirthday;

@interface BRBirthdayDetailViewController : BRCoreViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic,strong) BRDBirthday *birthday;
@end
