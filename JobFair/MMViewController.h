//
//  MMViewController.h
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *contentViewControllers;
@property (nonatomic) int pageIndex;

- (void)moveNextPage;
- (void)moveBackPage;
- (void)restart;

@end
