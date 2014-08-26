//
//  MMIconSelectionViewController.h
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBasePageViewController.h"

extern NSString* const ICON_SELECTION_PARSE_ENTITY_NAME;

@interface MMIconSelectionViewController : MMBasePageViewController

@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UIButton *tartanTrackButton;
@property (strong, nonatomic) IBOutlet UIButton *littlebirdButton;
@property (strong, nonatomic) IBOutlet UIButton *surveyButton;
@property (strong, nonatomic) IBOutlet UIButton *techTalkButton;
@property (strong, nonatomic) IBOutlet UIButton *whatsMedalliaButton;

- (IBAction)buttonClicked:(id)sender;

@end
