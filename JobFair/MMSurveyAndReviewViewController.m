//
//  MMSurveyAndReviewViewController.m
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMSurveyAndReviewViewController.h"
#import "DCRoundSwitch.h"
#import "MMData.h"

NSString* const SURVEY_PARSE_ENTITY_NAME = @"EverFilledASurvey";
NSString* const REVIEW_PARSE_ENTITY_NAME = @"EverFilledAReview";

@interface MMSurveyAndReviewViewController ()

@end

@implementation MMSurveyAndReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.surveySwitch.onText = @"YES!";
	self.surveySwitch.offText = @"No";
	self.reviewSwitch.onText = @"YES!";
	self.reviewSwitch.offText = @"No";
	[self selectionChanged:nil];
}

- (IBAction)selectionChanged:(id)sender {
	[[MMData sharedData].data setObject:[self stateToText:self.surveySwitch.isOn] forKey:SURVEY_PARSE_ENTITY_NAME];
	[[MMData sharedData].data setObject:[self stateToText:self.reviewSwitch.isOn] forKey:REVIEW_PARSE_ENTITY_NAME];
}

- (NSString *)stateToText:(BOOL)state {
	return state ? @"Yes" : @"No";
}

@end
