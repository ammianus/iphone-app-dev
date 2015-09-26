//
//  BRStyleSheet.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 8/30/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {
    BRLabelTypeName = 0,
    BRLabelTypeBirthdayDate,
    BRLabelTypeDaysUntilBirthday,
    BRLabelTypeDaysUntilBirthdaySubText,
    BRLabelTypeLarge
}BRLabelType;

@interface BRStyleSheet : NSObject

+(void)styleLabel:(UILabel *)label withType:(BRLabelType)labelType;
+(void)styleRoundCorneredView:(UIView *)view;
+(void)styleTextView:(UITextView *)textView;

+(void)initStyles;


@end
