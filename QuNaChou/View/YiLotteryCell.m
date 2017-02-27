//
//  YiLotteryCell.m
//  YiLotteryDemo
//
//  Created by apple on 15/2/12.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "YiLotteryCell.h"

@implementation YiLotteryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.image=[UIImage imageNamed:@"bg2_"];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        _titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,70,70)];
        _titleImageView.image=[UIImage imageNamed:@"l1"];
        [self addSubview:_titleImageView];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 70, 20)];
        _label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:155.0/255.0 alpha:1];
        [self addSubview:_label];
        
        _label.font=[UIFont systemFontOfSize:10];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.textColor= [UIColor whiteColor];
        _label.alpha = 0.8;
        
        _BGlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
        _BGlab.backgroundColor = [UIColor clearColor];
        [self addSubview:_BGlab];
        
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com