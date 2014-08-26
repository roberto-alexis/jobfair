//
//  MMViewController.m
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMViewController.h"
#import "MMBasePageViewController.h"

@interface MMViewController ()

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createViewControllers];
	
	// Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
	
    [self.pageViewController setViewControllers:@[[self.contentViewControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
		
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)createViewControllers {
	self.contentViewControllers = [NSMutableArray array];
	// First page
	[self addPageContent:@"IconSelectionViewController"];
	// Middle pages
	[self addPageContent:@"GraduationViewController"];
	[self addPageContent:@"SurveyAndReviewViewController"];
	[self addPageContent:@"FullTimeViewController"];
	// Last page
	[self addPageContent:@"ThankYouViewController"];
	self.pageIndex = 0;
}

- (void)addPageContent:(NSString *) storyboardId {
	MMBasePageViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
	page.pageViewController = self;
	[self.contentViewControllers addObject:page];
}

- (void)moveNextPage {
	self.pageIndex++;
	[self.pageViewController setViewControllers:@[[self.contentViewControllers objectAtIndex:self.pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)moveBackPage {
	self.pageIndex--;
	[self.pageViewController setViewControllers:@[[self.contentViewControllers objectAtIndex:self.pageIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (void)restart {
	self.pageIndex = 0;
	[self createViewControllers];
	[self.pageViewController setViewControllers:@[[self.contentViewControllers objectAtIndex:self.pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
