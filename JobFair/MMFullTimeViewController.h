//
//  MMFullTimeViewController.h
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBasePageViewController.h"

extern NSString* const LOOKING_FOR_PARSE_ENTITY_NAME;

@interface MMFullTimeViewController : MMBasePageViewController

@property (strong, nonatomic) IBOutlet UILabel *fullTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *internshipLabel;
@property (strong, nonatomic) IBOutlet UILabel *justCheckingLabel;
@property (strong, nonatomic) IBOutlet UILabel *notInterestedLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
- (IBAction)touchEnded:(id)sender;
- (IBAction)valueChanged:(id)sender;

@end
