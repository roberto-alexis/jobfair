//
//  MMCustomSlider.m
//  JobFair
//
//  Created by Roberto on 8/25/14.
//  Copyright (c) 2014 Dosmonos.net. All rights reserved.
//

#import "MMCustomSlider.h"

@implementation MMCustomSlider

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -15, -20);
    return CGRectContainsPoint(bounds, point);
}

@end
