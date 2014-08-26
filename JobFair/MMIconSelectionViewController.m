//
//  MMIconSelectionViewController.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMIconSelectionViewController.h"
#import "MMData.h"

NSString* const ICON_SELECTION_PARSE_ENTITY_NAME = @"HowDidYouHearAboutMedallia";

@interface MMIconSelectionViewController () {
	NSDictionary *buttons;
	CGSize size;
}

@end

@implementation MMIconSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttons = @{@"Friends": self.friendsButton,
				@"TartanTrack": self.tartanTrackButton,
				@"Little Bird": self.littlebirdButton,
				@"What's Medallia?": self.whatsMedalliaButton,
				@"Tech Talk": self.techTalkButton,
				@"Medallia Survey": self.surveyButton};
	size = self.friendsButton.frame.size;
}

- (IBAction)buttonClicked:(id)sender {
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	NSString *selectedValue = @"Unknown";
	for (NSString *key in buttons) {
		UIButton *button = [buttons objectForKey:key];
		CGPoint center = button.center;
		CGRect frame = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
		if (button == sender) {
			[button setAlpha:1];
			[button setFrame:CGRectInset(frame, -20, -15)];
			selectedValue = key;
		} else {
			[button setAlpha:0.25];
			[button setFrame:CGRectInset(frame, 20, 15)];
		}
	}
	[UIView commitAnimations];
	[[MMData sharedData].data setObject:selectedValue forKey:ICON_SELECTION_PARSE_ENTITY_NAME];
}

@end
