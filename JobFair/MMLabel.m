//
//  MMLabel.m
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMLabel.h"

@implementation MMLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {5, 10, 5, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
