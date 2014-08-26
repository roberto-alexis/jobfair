//
//  MMBasePageViewController.h
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMViewController.h"
#import "DCRoundSwitch.h"

@interface MMBasePageViewController : UIViewController

@property (nonatomic) MMViewController *pageViewController;
- (IBAction)moveNextPage:(id)sender;
- (IBAction)movePreviousPage:(id)sender;
- (IBAction)medalliaClicked:(id)sender;

@end
