//
//  MMFullTimeViewController.m
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMFullTimeViewController.h"
#import "MMData.h"

NSString* const LOOKING_FOR_PARSE_ENTITY_NAME = @"LookingFor";

@interface MMFullTimeViewController () {
	NSArray *labels;
}
@end

@implementation MMFullTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImage *thumbImage = [UIImage imageNamed:@"handle.png"];
	thumbImage = [MMFullTimeViewController imageWithImage:thumbImage scaledToSize:CGSizeMake(60, 60)];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
	labels = @[self.fullTimeLabel,
			   self.internshipLabel,
			   self.justCheckingLabel,
			   self.notInterestedLabel];
	[self valueChanged:nil];
	float currentValue = self.slider.value;
	float integerValue = lroundf(currentValue);
	UILabel *label = [labels objectAtIndex:integerValue];
	[[MMData sharedData].data setObject:label.text forKey:LOOKING_FOR_PARSE_ENTITY_NAME];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)touchEnded:(id)sender {
	float currentValue = self.slider.value;
	float integerValue = lroundf(currentValue);
	if (currentValue != integerValue) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self.slider setValue:integerValue animated:YES];
							 [self valueChanged:nil];
						 }];
	}
	UILabel *label = [labels objectAtIndex:integerValue];
	[[MMData sharedData].data setObject:label.text forKey:LOOKING_FOR_PARSE_ENTITY_NAME];
}

- (IBAction)valueChanged:(id)sender {
	float currentValue = self.slider.value;

	for (int i = 0; i < labels.count; i++) {
		float delta = fabsf(currentValue - i);
		delta = delta > 1 ? 1 : delta;
		UIColor *color = [UIColor colorWithWhite:0 alpha:1 - delta * 0.80];
		UILabel *label = [labels objectAtIndex:i];
		[label setTextColor:color];
	}
}

@end
