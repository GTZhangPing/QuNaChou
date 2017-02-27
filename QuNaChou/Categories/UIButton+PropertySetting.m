//
//  UIButton+PropertySetting.m
//  YSD_iPhone
//
//  Created by dan on 15/7/28.
//  Copyright (c) 2015年 Yesvion. All rights reserved.
//

#import "UIButton+PropertySetting.h"
//#import "PrefixHeader.pch"

@implementation UIButton (PropertySetting)

// 设置UIButton的相应属性
+ (void)customButton:(UIButton*)button bgColor:(UIColor *)color enable:(BOOL)enable layer:(CGFloat)layer
{
    
    button.layer.cornerRadius = layer;
    button.backgroundColor = color;
    button.enabled = enable;
    [button.layer setBorderWidth:1.0]; //边框宽度
    button.layer.borderColor=TEXT_COLOR_BLUE.CGColor;
}

@end
