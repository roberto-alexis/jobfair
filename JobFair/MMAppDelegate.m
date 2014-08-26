//
//  MMAppDelegate.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMAppDelegate.h"
#import <Parse/Parse.h>

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:<USE_YOUR_OWN_APP_ID>
				  clientKey:<USE_YOUR_CLIENT_KEY>];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    return YES;
}

@end
