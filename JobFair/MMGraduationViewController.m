//
//  MMGraduationViewController.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMGraduationViewController.h"
#import "TBCircularSlider.h"
#import "MMData.h"

NSString* const GRADUATION_PARSE_ENTITY_NAME = @"Graduation";

@interface MMGraduationViewController () {
	TBCircularSlider *_slider;
	int _counter;
}
@end

@implementation MMGraduationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Create the Circular Slider
	CGRect screenRect = [[UIScreen mainScreen] bounds];
    _slider = [[TBCircularSlider alloc] initWithFrame:CGRectMake(
																 (screenRect.size.width - TB_SLIDER_SIZE) / 2,
																 (screenRect.size.height - TB_SLIDER_SIZE) / 2 + 50,
																 TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    //Define Target-Action behaviour
    [_slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
	
    [self.view addSubview:_slider];
	[self newValue:_slider];
}

- (void)newValue:(TBCircularSlider *)value {
	[[MMData sharedData].data setObject:value.text forKey:GRADUATION_PARSE_ENTITY_NAME];
}

@end
