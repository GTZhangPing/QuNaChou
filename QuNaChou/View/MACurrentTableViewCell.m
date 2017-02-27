//
//  MACurrentTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "MACurrentTableViewCell.h"
#import "NSString+TransformTimestamp.h"

@implementation MACurrentTableViewCell

- (void)SetCellWithInfo:(MACurrentInfoModel *)model{
    
    _AddMoneyLab.text = [NSString stringWithFormat:@"¥%@",  model.money];
    _YieldLab.text = [NSString stringWithFormat:@"%.1f%@",[model.interest floatValue]*100,@"%"];
    _ReturnLab.text = [NSString stringWithFormat:@"¥%@",  model.shouyi];
    _TimeLab.text = [NSString transformTime:model.set_time];
    
    if ([model.buy_type isEqualToString:@"1"]) {
        _TitleLab.text = @"特权活期宝（特权金）";
    }
    if ([model.buy_type isEqualToString:@"2"]) {
        _TitleLab.text = @"特权活期宝";
    }
    if ([model.buy_type isEqualToString:@"14"]) {
        _TitleLab.text = @"活期宝";
    }
    if ([model.buy_type isEqualToString:@"15"]) {
        _TitleLab.text = @"推荐好友奖励";
    }if ([model.buy_type isEqualToString:@"16"]) {
        _TitleLab.text = @"抽奖特权金";
    }
    if ([model.zhuangtai isEqual:@"1"]) {
        _StatusLab.text = @"特权金已过期";
        _BgImge.image = [UIImage imageNamed:@"HQbg2_"];
        _ShouyiLab.text = @"累计收益";
    }
    if ([model.zhuangtai isEqual:@"2"]) {
        _StatusLab.text = @"计息中";
        _BgImge.image = [UIImage imageNamed:@"HQbg1_"];
        _ShouyiLab.text = @"明天收益";
    }
    if ([model.zhuangtai isEqual:@"3"]) {
        _StatusLab.text = @"已退出结清";
        _BgImge.image = [UIImage imageNamed:@"HQbg3_"];
        _ShouyiLab.text = @"累计收益";
    }
    
}


@end
