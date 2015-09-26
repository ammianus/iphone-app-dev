//
//  BRBirthdayTableViewCell.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/30/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRDBirthday;
@class BRDBirthdayImport;

@interface BRBirthdayTableViewCell : UITableViewCell

@property(nonatomic, strong) BRDBirthday *birthday;
@property(nonatomic, strong) BRDBirthdayImport *birthdayImport;
@property(nonatomic, weak) IBOutlet UIImageView* iconView;
@property(nonatomic, weak) IBOutlet UIImageView* remainingDaysImageView;
@property(nonatomic, weak) IBOutlet UILabel* nameLabel;
@property(nonatomic, weak) IBOutlet UILabel* birthdayLabel;
@property(nonatomic, weak) IBOutlet UILabel* remainingDaysLabel;
@property(nonatomic, weak) IBOutlet UILabel* remainingDaysSubTextLabel;


@end
