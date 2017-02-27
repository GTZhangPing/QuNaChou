//
//  ReminderLoginView.m
//  QuNaChou
//
//  Created by 张平 on 16/7/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ReminderLoginView.h"
//#import "PrefixHeader.pch"


@implementation ReminderLoginView

- (id)initWithFrame:(CGRect)frame Style:(NSString *)style{
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat Width = self.frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
       
        _IconImage = [[UIImageView alloc] initWithFrame:CGRectMake((Width-49)/2, 10, 49, 53)];
        _IconImage.image = [UIImage imageNamed:@"YPbg10"];
        [self addSubview:_IconImage];
        
        _ReminderLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, Width, 20)];
        _ReminderLab.textAlignment = NSTextAlignmentCenter;
        _ReminderLab.textColor = TEXT_COLOR_GRAY;
        _ReminderLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_ReminderLab];
        
        _LineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, Width-20, 1)];
        _LineImage.image = [UIImage imageNamed:@"Line3_"];
        [self addSubview:_LineImage];
        
         if ([style  isEqual: @"Login"]) {
             
             _ReminderLab.text = @"亲，您需要登录后才能加入哦！";

            _Button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _Button1.frame = CGRectMake(20 , 130, (Width-60)/2, 44);
            _Button1.backgroundColor = TEXT_COLOR_YELLOW;
            [_Button1 setTitle:@"注册" forState:UIControlStateNormal];
            _Button1.titleLabel.font = [UIFont systemFontOfSize:13];
            [_Button1 addTarget:self action:@selector(RegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _Button1.layer.cornerRadius = 10;
            [self addSubview:_Button1];
            
            _Button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _Button2.frame = CGRectMake(_Button1.frame.size.width+40 , 130, (Width-60)/2, 44);
            _Button2.backgroundColor = TB_COLOR_RED;
            [_Button2 setTitle:@"登录" forState:UIControlStateNormal];
            _Button2.titleLabel.font = [UIFont systemFontOfSize:13];
            [_Button2 addTarget:self action:@selector(LoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _Button2.layer.cornerRadius = 10;
            [self addSubview:_Button2];
         }
        
        if ([style isEqual:@"Bound"]) {
            
            _ReminderLab.text = @"亲，您还没有绑定银行卡，怎么加入？";
            
            _Button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _Button1.frame = CGRectMake(Width/3 , 130, Width/3, 44);
            _Button1.backgroundColor = TB_COLOR_RED;
            [_Button1 setTitle:@"绑定银行卡" forState:UIControlStateNormal];
            _Button1.titleLabel.font = [UIFont systemFontOfSize:13];
            [_Button1 addTarget:self action:@selector(BoundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _Button1.layer.cornerRadius = 10;
            [self addSubview:_Button1];

        }
    }

    return self;
}


- (void)RegisterButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Register)]) {
        [self.delegate Register];
    }
}


- (void)LoginButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Login)]) {
        [self.delegate Login];
    }
}


- (void)BoundButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Bound)]) {
        [self.delegate Bound];
    }
}

@end
