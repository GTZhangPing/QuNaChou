//
//  ReminderView.m
//  QuNaChou
//
//  Created by 张平 on 16/6/29.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ReminderView.h"
//#import "PrefixHeader.pch"

@implementation ReminderView

- (id)initWithFrame:(CGRect)frame Type:(int )type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat Width = self.frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        
        if (type == 1) {
         
            _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-100)/2, 20, 100, 100)];
            [self addSubview:_titleImageView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, Width, 20)];
            lab.text = @"收获了";
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = TEXT_COLOR_GRAY;
            lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lab];
            
            _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, Width, 20)];
            _NameLabel.textAlignment = NSTextAlignmentCenter;
            _NameLabel.textColor = TB_COLOR_RED;
            _NameLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:_NameLabel];
            
            
            _ReceiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _ReceiveButton.frame = CGRectMake((Width-180)/2, 170, 180, 44);
            _ReceiveButton.backgroundColor = TB_COLOR_RED;
            [_ReceiveButton setTitle:@"接受奖品" forState:UIControlStateNormal];
            [_ReceiveButton addTarget:self action:@selector(ReceiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _ReceiveButton.layer.cornerRadius = 10;
            [self addSubview:_ReceiveButton];
        }
        if (type == 2) {
            
            _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-49)/2, 15, 49, 53)];
            _titleImageView.image = [UIImage imageNamed:@"YPbg10"];
            [self addSubview:_titleImageView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, Width-80, 40)];
            lab.text = @"亲，您有奖品需要邮寄，您还没有设置收件地址，无法给您寄送!";
            lab.numberOfLines = 2;
            lab.font = [UIFont systemFontOfSize:13];
            lab.textColor = TEXT_COLOR_GRAY;
            lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lab];
            
            _LineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, Width-20, 1)];
            _LineImage.image = [UIImage imageNamed:@"YPbg10"];
            [self addSubview:_LineImage];
            
            
            _BackButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _BackButton1.frame = CGRectMake(20 , 140, (Width-60)/2, 44);
            _BackButton1.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:155.0/255.0 alpha:1];
            [_BackButton1 setTitle:@"返回" forState:UIControlStateNormal];
            [_BackButton1 setTitleColor:TB_COLOR_RED forState:UIControlStateNormal];
            _BackButton1.titleLabel.font = [UIFont systemFontOfSize:13];
            [_BackButton1 addTarget:self action:@selector(BackButton1Clicked) forControlEvents:UIControlEventTouchUpInside];
            _BackButton1.layer.cornerRadius = 10;
            [self addSubview:_BackButton1];


            _ToAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _ToAddressButton.frame = CGRectMake(_BackButton1.frame.size.width+40, 140, (Width-60)/2, 44);
            _ToAddressButton.backgroundColor = TB_COLOR_RED;
            [_ToAddressButton setTitle:@"设置收件地址" forState:UIControlStateNormal];
            _ToAddressButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [_ToAddressButton addTarget:self action:@selector(ToAddressButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _ToAddressButton.layer.cornerRadius = 10;
            [self addSubview:_ToAddressButton];
            
        }
        if (type == 3) {
            
            _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-49)/2, 15, 49, 53)];
            _titleImageView.image = [UIImage imageNamed:@"YPbg10"];
            [self addSubview:_titleImageView];
            
            _lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, Width-80, 40)];
//            lab.text = [NSString stringWithFormat:@"亲，您的“%@“已寄出，请注意接收！！",_Name];
            _lab.numberOfLines = 2;
            _lab.font = [UIFont systemFontOfSize:13];
            _lab.textColor = TEXT_COLOR_GRAY;
            _lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_lab];

            _LineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, Width-20, 1)];
            _LineImage.image = [UIImage imageNamed:@"YPbg10"];
            [self addSubview:_LineImage];

            
            _BackButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _BackButton2.frame = CGRectMake(20 , 140, (Width-60)/2, 44);
            _BackButton2.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:155.0/255.0 alpha:1];
            [_BackButton2 setTitle:@"返回" forState:UIControlStateNormal];
            [_BackButton2 setTitleColor:TB_COLOR_RED forState:UIControlStateNormal];
            _BackButton2.titleLabel.font = [UIFont systemFontOfSize:13];
            [_BackButton2 addTarget:self action:@selector(BackButton2Clicked) forControlEvents:UIControlEventTouchUpInside];
            _BackButton2.layer.cornerRadius = 10;
            [self addSubview:_BackButton2];
            
            
            _LookInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _LookInfoButton.frame = CGRectMake(_BackButton2.frame.size.width+40, 140, (Width-60)/2, 44);
            _LookInfoButton.backgroundColor = TB_COLOR_RED;
            [_LookInfoButton setTitle:@"查看奖品详情" forState:UIControlStateNormal];
            _LookInfoButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [_LookInfoButton addTarget:self action:@selector(LookInfoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            _LookInfoButton.layer.cornerRadius = 10;
            [self addSubview:_LookInfoButton];
            
        }

    }
    return self;
}




- (void)ReceiveButtonClicked{
    
//    ZPLog(@"~~~~");
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZhongJiang)]) {
        [self.delegate ZhongJiang];
    }
}


- (void)BackButton1Clicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Back1)]) {
        [self.delegate Back1];
    }
}


- (void)ToAddressButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PushToAddress)]) {
        [self.delegate PushToAddress];
    }
}

- (void)BackButton2Clicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Back2)]) {
        [self.delegate Back2];
    }
}



- (void)LookInfoButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PushLookInfo)]) {
        [self.delegate PushLookInfo];
    }
}


@end
