//
//  MMBasePageViewController.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMBasePageViewController.h"
#import "MMResultsViewController.h"
#import "MMStatsViewController.h"
#import "MMData.h"

@interface MMBasePageViewController () {
	int _counter;
	UINavigationController *_navigationController;
}

@end

@implementation MMBasePageViewController

- (IBAction)moveNextPage:(id)sender {
	[self.pageViewController moveNextPage];
}

- (IBAction)movePreviousPage:(id)sender {
	[self.pageViewController moveBackPage];
}

- (IBAction)medalliaClicked:(id)sender {
	if (++_counter == 4) {

		// MMResultsViewController *resultsViewController = [[MMResultsViewController alloc] initWithStyle:UITableViewStylePlain];
		MMStatsViewController *resultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatsViewController"];
		resultsViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
		resultsViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(send)];
		resultsViewController.navigationItem.title = @"Results";
		_navigationController = [[UINavigationController alloc] initWithRootViewController:resultsViewController];
		[self presentViewController:_navigationController animated:YES completion:NO];
		_counter = 0;
	}
}

- (void) dismiss {
	[_navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) send {
	[[MMData sharedData] sendDataByEmailFrom:_navigationController];
}

@end
