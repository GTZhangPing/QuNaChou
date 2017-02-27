//
//  UIView+Custom.m
//  YSD_iPhone
//
//  Created by dan on 15/6/23.
//  Copyright (c) 2015年 Yesvion. All rights reserved.

#import "UIView+Custom.h"
//#import "PrefixHeader.pch"

@implementation UIView (Custom)

+ (void)customView:(UIView*)view layerColor:(UIColor *)color cornerRadious:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1.0;
}

+ (UIView *)backgroundViewRect:(CGRect)rect {
    
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;

    UILabel *topBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(bgView.frame)/2+20, SCREEN_WIDTH-40, 30)];
    topBgLabel.text = @"当前网络不可用, 请检查你的网络设置";
    topBgLabel.font = kTextFont(15.0);
    topBgLabel.textColor = LIGHTGRAY_TEXT_COLOR;
    topBgLabel.textAlignment = NSTextAlignmentCenter;
    topBgLabel.userInteractionEnabled = YES;
    [bgView addSubview:topBgLabel];

    UILabel *botBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(topBgLabel.frame)+30, SCREEN_WIDTH-40, 30)];
    botBgLabel.text = @"点击屏幕刷新";
    botBgLabel.font = kTextFont(15.0);
    botBgLabel.textColor = LIGHTGRAY_TEXT_COLOR;
    botBgLabel.textAlignment = NSTextAlignmentCenter;
    botBgLabel.userInteractionEnabled = YES;
    [bgView addSubview:botBgLabel];
    
    return bgView;
}

+ (UIView *)backgroundViewRect2:(CGRect)rect2 {
    
    UIView *bgView = [[UIView alloc] initWithFrame:rect2];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    
    UILabel *topBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(bgView.frame)/2+20+64, SCREEN_WIDTH-40, 30)];
    topBgLabel.text = @"当前网络不可用, 请检查你的网络设置";
    topBgLabel.font = kTextFont(15.0);
    topBgLabel.textColor = LIGHTGRAY_TEXT_COLOR;
    topBgLabel.textAlignment = NSTextAlignmentCenter;
    topBgLabel.userInteractionEnabled = YES;
    [bgView addSubview:topBgLabel];
    
    UILabel *botBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(topBgLabel.frame)+30, SCREEN_WIDTH-40, 30)];
    botBgLabel.text = @"点击屏幕刷新";
    botBgLabel.font = kTextFont(15.0);
    botBgLabel.textColor = LIGHTGRAY_TEXT_COLOR;
    botBgLabel.textAlignment = NSTextAlignmentCenter;
    botBgLabel.userInteractionEnabled = YES;
    [bgView addSubview:botBgLabel];
    
    return bgView;
}

@end
