//
//  UICustomCell.m
//  cocurrency
//
//  Created by hbucius on 10/7/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "UICustomCell.h"

@implementation UICustomCell

- (void) drawRect:(CGRect)rect {
    CALayer *btLayer=[self.currencyImage layer];
    [btLayer setMasksToBounds:YES];
    [btLayer setCornerRadius:4.0f];
    [self.currencyImage setBackgroundColor:[UIColor clearColor]];
}

@end
