//
//  BRHomeViewController.h
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCoreViewController.h"

@interface BRHomeViewController : BRCoreViewController

/**
 * @param segue to unwind
 */
-(IBAction)unwindActionMethodName:(UIStoryboardSegue *) segue;

@end