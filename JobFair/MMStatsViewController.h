//
//  MMStatsViewController.h
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface MMStatsViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *chartTopRight;
@property (strong, nonatomic) IBOutlet XYPieChart *chartTopLeft;
@property (strong, nonatomic) IBOutlet XYPieChart *chartBottomRight;
@property (strong, nonatomic) IBOutlet XYPieChart *chartBottomLeft;
@property (strong, nonatomic) IBOutlet XYPieChart *chartTopCenter;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
