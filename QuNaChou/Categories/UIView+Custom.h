//
//  UIView+Custom.h
//  YSD_iPhone
//
//  Created by dan on 15/6/23.
//  Copyright (c) 2015年 Yesvion. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (Custom)

+ (void)customView:(UIView*)view layerColor:(UIColor *)color cornerRadious:(CGFloat)radious;
+ (UIView *)backgroundViewRect:(CGRect)rect;
+ (UIView *)backgroundViewRect2:(CGRect)rect2;

@end
