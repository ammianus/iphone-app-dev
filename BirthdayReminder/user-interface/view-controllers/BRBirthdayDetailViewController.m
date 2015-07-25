//
//  BRBirthdayDetailViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRBirthdayDetailViewController.h"

// When overriding UIViewController methods be sure to call the super method
// implementation to avoid problems at runtime
@interface BRBirthdayDetailViewController ()

@end

@implementation BRBirthdayDetailViewController

// Open First
// best place to put model data retained by the lifecycle of the controller
-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder");
    }
    return self;
}

// Close Third
-(void) dealloc {
    NSLog(@"dealloc");
}

//  Open Second
- (void)viewDidLoad {
    // viewDidLoad is the first point of access to your Interface Builder outlets. So when viewDidLoad is invoked, you should execute any view customization code.
    // can be called multiple times during the life of the view controller
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
}

//  Open Third

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

//  Open Fourth
/**
 Called when this view finished appearing.
 @param animated
 */
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

// Close First
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

// Close Second
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
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
