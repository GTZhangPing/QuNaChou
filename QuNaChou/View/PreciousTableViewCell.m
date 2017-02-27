//
//  PreciousTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "PreciousTableViewCell.h"
#import "NSString+TransformTimestamp.h"
//#import "PrefixHeader.pch"


@implementation PreciousTableViewCell

- (void)initSubviews{
    
}


- (void)setCellWithInfo:(PreciousInfoModel *)model{
    
    if ([model.ID  isEqual: @"1"]) {
        _TitleLab.text = [NSString stringWithFormat:@"¥%d",[model.Title intValue]];
        _TitleLab2.textColor = TEXT_COLOR_YELLOW;
        _StatusLab.text = @"已在“特权活期宝”中使用";
        _DescribeLab.text = @"特权金从发放至个人账户只有效期内，按“特权活期宝”收益每天计算投资收益，可叠加“特权收益”，有效期结束后，系统自动回收特权金，利息可投资可提现。";
        _BgImage.image = [UIImage imageNamed:@"BXbg1"];
        _GuoQiImage.hidden = YES;

        if ([model.LaiYuan  isEqual: @"1"]) {
            _TitleLab2.text = @"特权金（注册特权金）";
            
        }
        if ([model.LaiYuan  isEqual: @"15"]) {
            _TitleLab2.text = @"特权金（推荐奖励）";
        }
        if ([model.LaiYuan  isEqual: @"16"]) {
            _TitleLab2.text = @"特权金（抽奖特权金）";
        }
        
        if (([model.ZhuangTai isEqual:@"2"])) {
            _BgImage.image = [UIImage imageNamed:@"BXbg4"];
            _GuoQiImage.hidden = NO;
            _TitleLab2.textColor = TEXT_COLOR_GRAY;
        }
    }
    if ([model.ID  isEqual: @"2"]) {
        _TitleLab.text = [NSString stringWithFormat:@"%.1f%@",[model.Title doubleValue]*100,@"%"];
        _TitleLab2.textColor = TB_COLOR_RED;
        _StatusLab.text = @"可叠加所有投资项目";
        _DescribeLab.text = @"特权收益在有效期内可以增加投资回报率，最高可以同时叠加3%，可以通过理财活动、推荐好友等方式获得。";
        if ([model.LaiYuan  isEqual: @"1"]) {
            _TitleLab2.text = @"特权收益（注册特权收益）";
        }
        if ([model.LaiYuan  isEqual: @"2"]) {
            _TitleLab2.text = @"特权收益（推荐奖励）";
        }
        if ([model.LaiYuan  isEqual: @"3"]) {
            _TitleLab2.text = @"特权收益（限时惠抢购）";
        }
        
        if ([model.ZhuangTai isEqual:@"1"]) {
            _BgImage.image = [UIImage imageNamed:@"BXbg2"];
            _GuoQiImage.hidden = YES;
        }
        else{
            _BgImage.image = [UIImage imageNamed:@"BXbg4"];
            _GuoQiImage.hidden = NO;
            _TitleLab2.textColor = TEXT_COLOR_GRAY;
        }
    }
    if ([model.ID  isEqual: @"3"]) {
        _TitleLab.text = model.Title;
        _TitleLab2.text = @"领奖说明";
        _TitleLab2.textColor = TB_COLOR_RED;
        _DescribeLab.text = @"在有效期内，用户需要设置收件，方可派送，有效期结束后视为自动放弃领取奖品！奖品不能折现或转让";
        _GuoQiImage.hidden = YES;
        
        if ([model.Title isEqualToString:@"iphone6s 64G"]) {
            _TitleLab.text = @"iphone6S";
        }

        if ([model.ZhuangTai isEqual:@"1"]) {
            _BgImage.image = [UIImage imageNamed:@"BXbg5"];
            _StatusLab.text = @"已接收";
        }
        if ([model.ZhuangTai isEqual:@"2"]) {
            _BgImage.image = [UIImage imageNamed:@"BXbg5"];
            _StatusLab.text = @"等待设置收件地址";
            
        }
        if ([model.ZhuangTai isEqual:@"3"]) {
            _TitleLab2.textColor = TEXT_COLOR_GRAY;
            _BgImage.image = [UIImage imageNamed:@"BXbg4"];
            _GuoQiImage.hidden = NO;


        }
        if ([model.ZhuangTai isEqual:@"4"]) {
            _TitleLab2.textColor = TEXT_COLOR_GRAY;
            _BgImage.image = [UIImage imageNamed:@"BXbg4"];


            
        }
    }
    _TitleLab.font = [UIFont systemFontOfSize:23];
    _TimeLab.text = [NSString stringWithFormat:@"有限期%@至%@",[NSString transformTime2:model.CreatTime],[NSString transformTime2:model.EndTime]];
    
    CGFloat height = [self textHeight:_DescribeLab];
    self.DescribeLab.frame = CGRectMake(self.TitleLab2.frame.origin.x,self.TitleLab2.frame.origin.y+self.TitleLab2.frame.size.height+5,_BgImage.frame.size.width-40, height);
    
    self.height = _DescribeLab.frame.origin.y+height;//设置当前cell高度
}


/**
 @功能：计算文本的高度
 @参数：文本字符串
 @返回值：指定宽度下的字符串高度
 */
- (CGFloat)textHeight:(UILabel*)lab
{
    NSDictionary *attribute = @{NSFontAttributeName:lab.font};
    CGSize size = [lab.text boundingRectWithSize:CGSizeMake(lab.frame.size.width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute context:nil].size;
    return size.height;
}
@end
