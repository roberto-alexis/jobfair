//
//  MMStatsViewController.m
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMStatsViewController.h"
#import "MMData.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MMLabel.h"

@interface MMStatsViewController () {
	NSMutableDictionary *data;
	NSArray *charts;
	NSMutableArray *labels;
	NSMutableDictionary *questionToChart;
}

@end

@implementation MMStatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	data = [NSMutableDictionary dictionary];
	charts = @[self.chartTopLeft,
			   self.chartTopCenter,
			   self.chartTopRight,
			   self.chartBottomLeft,
			   self.chartBottomRight];
	labels = [NSMutableArray array];
	int pos = 0;
	questionToChart = [NSMutableDictionary dictionary];
	for (NSString *questionKey in [MMData sharedData].titles) {
		[questionToChart setObject:[NSNumber numberWithInt:pos] forKey:questionKey];
		pos++;
	}
	for (XYPieChart *chart in charts) {
		NSString *questionKey = [self findQuestionForChart:chart];
		NSString *title = [[MMData sharedData].titles objectForKey:questionKey];
		[self initializeChart:chart withTitle:title];
	}
    [self getData];
}

- (void)initializeChart:(XYPieChart *)pieChart withTitle:(NSString *)title {
	[pieChart setDelegate:self];
	[pieChart setDataSource:self];
	[pieChart setStartPieAngle:M_PI_2];	//optional
	[pieChart setAnimationSpeed:1.0];	//optional
	[pieChart setLabelFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];	//optional
	[pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
	[pieChart setLabelShadowColor:[UIColor whiteColor]];	//optional, defaults to none (nil)
	[pieChart setLabelRadius:80];	//optional
	[pieChart setShowPercentage:NO];	//optional
	[pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
	int size = 40;
	UILabel *label = [[MMLabel alloc] initWithFrame:CGRectMake(pieChart.frame.size.width / 2 - size, pieChart.frame.size.height / 2 - size, size * 2, size * 2)];
	[label setBackgroundColor:[UIColor whiteColor]];
	[label setFont:[UIFont fontWithName:@"HelveticaNeue" size:21]];
	[label.layer setCornerRadius:size];
	label.layer.masksToBounds = YES;
	[label setNumberOfLines:3];
	[label setText:title];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setAdjustsFontSizeToFitWidth:YES];
	[pieChart addSubview:label];
	[labels addObject:label];
}

- (void)getData {
	PFQuery *query = [PFQuery queryWithClassName:AnswersParseEntityName];
	[query setLimit: 1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			[self updateData:objects];
		} else {
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)updateData:(NSArray *)objects {
	for (NSObject *datum in objects) {
		PFObject *object = (PFObject *)datum;
		for (NSString *questionKey in [MMData sharedData].titles) {
			NSString *questionValue = [object objectForKey:questionKey];
			if (!questionValue)
				continue;
			NSMutableDictionary *values = [data objectForKey:questionKey];
			if (!values) {
				values = [NSMutableDictionary dictionary];
				[data setObject:values forKey:questionKey];
			}
			NSNumber *valueCount = [values objectForKey:questionValue];
			if (!valueCount) {
				valueCount = [NSNumber numberWithInt:0];
			}
			valueCount = [NSNumber numberWithInt:valueCount.intValue + 1];
			[values setObject:valueCount forKey:questionValue];
		}
	}
	for (XYPieChart *chart in charts) {
		[chart reloadData];
	}
}

- (NSString *)findQuestionForChart:(XYPieChart *)pieChart {
	for (NSString *questionKey in questionToChart) {
		NSNumber *pos = [questionToChart objectForKey:questionKey];
		if ([pos intValue] >= charts.count)
			continue;
		if ([charts objectAtIndex:[pos intValue]] == pieChart) {
			return questionKey;
		}
	}
	return nil;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
	NSString *questionKey = [self findQuestionForChart:pieChart];
	if (!questionKey)
		return 0;
	NSDictionary *values = [data objectForKey:questionKey];
	return values.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
	NSString *questionKey = [self findQuestionForChart:pieChart];
	if (questionKey == nil)
		return 0;
	NSDictionary *values = [data objectForKey:questionKey];
	int total = 0;
	int pos = 0;
	int current = 0;
	for (NSString *questionValue in values) {
		NSNumber *count = [values objectForKey:questionValue];
		total += [count intValue];
		if (pos == index) {
			current += [count intValue];
		}
		pos++;
	}
	return (float)current / (float)total;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
	NSUInteger total = [self numberOfSlicesInPieChart:pieChart];
	UIColor *startColor = [UIColor colorWithRed:85.0/255.0 green:202.0/255.0 blue:237.0/255.0 alpha:1];
	UIColor *endColor = [UIColor colorWithRed:63.0/255.0 green:99.0/255.0 blue:232.0/255.0 alpha:1];
	return [self colorLerpFrom:startColor to:endColor withDuration:(float)index / (float)total];
}

- (UIColor *)colorLerpFrom:(UIColor *)start
                        to:(UIColor *)end
			  withDuration:(float)t
{
    if(t < 0.0f) t = 0.0f;
    if(t > 1.0f) t = 1.0f;
	
    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);
	
    float startAlpha = CGColorGetAlpha(start.CGColor);
    float endAlpha = CGColorGetAlpha(end.CGColor);
	
    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    float a = startAlpha + (endAlpha - startAlpha) * t;
	
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
	NSString *questionKey = [self findQuestionForChart:pieChart];
	if (!questionKey)
		return 0;
	NSDictionary *values = [data objectForKey:questionKey];
	int pos = 0;
	for (NSString *questionValue in values) {
		if (pos == index) {
			return questionValue;
		}
		pos++;
	}
	return @"";
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
	for (XYPieChart *chart in charts) {
		if (chart != pieChart) {
			for (int i = 0; i < [self numberOfSlicesInPieChart:chart]; i++) {
				[chart setSliceDeselectedAtIndex:i];
			}
		}
	}
	NSString *question = [self findQuestionForChart:pieChart];
	NSString *title = [[MMData sharedData].titles objectForKey:question];
	NSString *text = [self pieChart:pieChart textForSliceAtIndex:index];
	CGFloat value = [self pieChart:pieChart valueForSliceAtIndex:index];
	
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.descriptionLabel setAlpha:0];
					 }
					 completion:^(BOOL finished) {
						 [self.descriptionLabel setText:[NSString stringWithFormat:@"%@\n%@: %2.1f%%", title, text, value * 100.0]];
						 [UIView animateWithDuration:0.2f
											   delay:0.0f
											 options:UIViewAnimationOptionCurveEaseOut
										  animations:^{
											  [self.descriptionLabel setAlpha:1];
										  }
										  completion:nil];
					 }];
	
}


@end
