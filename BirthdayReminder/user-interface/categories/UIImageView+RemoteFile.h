//
//  UIImageView+RemoteFile.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/4/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RemoteFile)

-(void)setImageWithRemoteFileURL:(NSString *)urlString placeHolderImage:(UIImage *)placeHolderImage;

@end
