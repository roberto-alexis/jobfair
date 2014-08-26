//
//  MMThankYouViewController.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMThankYouViewController.h"
#import "MMData.h"

@interface MMThankYouViewController () {
	NSTimer *dismissTimer;
}
@end

@implementation MMThankYouViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[MMData sharedData] submit];
}

- (void)viewWillAppear:(BOOL)animated {
	dismissTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
													target:self
												  selector:@selector(thankyouClicked:)
												  userInfo:nil
												   repeats:NO];
}

- (IBAction)thankyouClicked:(id)sender {
	if (dismissTimer) {
		[dismissTimer invalidate];
		dismissTimer = nil;
	}
	[self.pageViewController restart];
}

@end
