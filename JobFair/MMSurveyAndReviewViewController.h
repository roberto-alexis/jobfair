//
//  MMSurveyAndReviewViewController.h
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBasePageViewController.h"

extern NSString* const SURVEY_PARSE_ENTITY_NAME;
extern NSString* const REVIEW_PARSE_ENTITY_NAME;

@interface MMSurveyAndReviewViewController : MMBasePageViewController

@property (strong, nonatomic) IBOutlet DCRoundSwitch *surveySwitch;
@property (strong, nonatomic) IBOutlet DCRoundSwitch *reviewSwitch;
- (IBAction)selectionChanged:(id)sender;

@end
