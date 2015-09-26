//
//  BRBirthdayTableViewCell.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/30/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRBirthdayTableViewCell.h"
#import "BRDBirthday.h"
#import "BRDBirthdayImport.h"
#import "BRStyleSheet.h"

@implementation BRBirthdayTableViewCell

#pragma mark override outlet methods
-(void) setIconView:(UIImageView *)iconView{
    _iconView = iconView;
    if(_iconView){
        [BRStyleSheet styleRoundCorneredView:_iconView];
    }
}

-(void) setNameLabel:(UILabel *)nameLabel{
    _nameLabel = nameLabel;
    if(_nameLabel){
        [BRStyleSheet styleLabel:_nameLabel withType:BRLabelTypeName];
    }
}

-(void) setBirthdayLabel:(UILabel *)birthdayLabel{
    _birthdayLabel = birthdayLabel;
    if(_birthdayLabel){
        [BRStyleSheet styleLabel:_birthdayLabel withType:BRLabelTypeBirthdayDate];
    }
}

-(void) setRemainingDaysLabel:(UILabel *)remainingDaysLabel{
    _remainingDaysLabel = remainingDaysLabel;
    if(_remainingDaysLabel){
        [BRStyleSheet styleLabel:_remainingDaysLabel withType:BRLabelTypeDaysUntilBirthday];
    }
}

-(void) setRemainingDaysSubTextLabel:(UILabel *)remainingDaysSubTextLabel{
    _remainingDaysSubTextLabel = remainingDaysSubTextLabel;
    if(_remainingDaysSubTextLabel){
        [BRStyleSheet styleLabel:_remainingDaysSubTextLabel withType:BRLabelTypeDaysUntilBirthdaySubText];
    }
}


-(void) setBirthday:(BRDBirthday *)birthday {
    _birthday = birthday;
    self.nameLabel.text = _birthday.name;
    
    int days = _birthday.remainingDaysUntilNextBirthday;
    
    if(days == 0){
        //Birthday is today!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }else {
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-days-remaining.png"];
    }
    
    self.birthdayLabel.text = _birthday.birthdayTextToDisplay;
}

-(void) setBirthdayImport:(BRDBirthdayImport *)birthdayImport {
    _birthdayImport = birthdayImport;
    self.nameLabel.text = _birthdayImport.name;
    
    int days = _birthdayImport.remainingDaysUntilNextBirthday;
    
    if(days == 0){
        //Birthday is today!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }else {
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-days-remaining.png"];
    }
    
    self.birthdayLabel.text = _birthdayImport.birthdayTextToDisplay;
}

@end
