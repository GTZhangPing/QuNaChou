//
//  UIButton+PropertySetting.h
//  YSD_iPhone
//
//  Created by dan on 15/7/28.
//  Copyright (c) 2015年 Yesvion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PropertySetting)

+ (void)customButton:(UIButton*)button bgColor:(UIColor *)color enable:(BOOL)enable layer:(CGFloat)layer;

@end
