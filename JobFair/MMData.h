//
//  MMData.h
//  JobFair
//
//  Created by Roberto on 8/24/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

extern NSString* const AnswersParseEntityName;

@interface MMData : UIStoryboardSegue <MFMailComposeViewControllerDelegate>
@property (nonatomic) NSMutableDictionary *data;
@property (nonatomic) NSDictionary *titles;

+ (MMData *)sharedData;
- (void) submit;
- (void) sendDataByEmailFrom: (UIViewController *)controller;
@end
