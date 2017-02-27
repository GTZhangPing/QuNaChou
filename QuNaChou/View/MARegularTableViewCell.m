//
//  MARegularTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "MARegularTableViewCell.h"
#import "UIView+Custom.h"
#import "NSString+TransformTimestamp.h"

#define ORANGE_COLOR [UIColor colorWithRed:255.0/255.0f green:201.0/255.0f blue:17.0/255.0f alpha:1.0]
#define GRAY_COLOR [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0]

@implementation MARegularTableViewCell


- (void)SetCellWithInfo:(MARegularInfoModel *)model{
    
    _AddMoneyLab.text = [NSString stringWithFormat:@"¥%@",  model.money];
    _YieldLab.text = [NSString stringWithFormat:@"%.1f%@",[model.interest floatValue]*100,@"%"];
    _ReturnLab.text = [NSString stringWithFormat:@"¥%@",  model.shouyi];
    _TimeLab.text = [NSString transformTime:model.set_time];
    
    
    if ([model.zhuangtai isEqual:@"2"]) {
        _StatusLab.text = @"计息中";
        _BgImage.image = [UIImage imageNamed:@"HQbg1_"];
        _ShouyiLab.text = @"明天收益";
    }
    if ([model.zhuangtai isEqual:@"3"]) {
        _StatusLab.text = @"已退出结清";
        _BgImage.image = [UIImage imageNamed:@"HQbg3_"];
        _ShouyiLab.text = @"累计收益";
    }

    if ([model.buy_type isEqualToString:@"3"]) {
        _LockTimeLab.text = @" 30天锁定期 ";
    }
    if ([model.buy_type isEqualToString:@"4"]) {
        _LockTimeLab.text = @" 90天锁定期 ";
    }
    if ([model.buy_type isEqualToString:@"5"]) {
        _LockTimeLab.text = @" 180天锁定期 ";
    }
    if ([model.buy_type isEqualToString:@"6"]) {
        _LockTimeLab.text = @" 270天锁定期 ";
    }
    if ([model.buy_type isEqualToString:@"7"]) {
        _LockTimeLab.text = @" 360天锁定期 ";
    }
    if ([model.buy_type isEqualToString:@"8"]) {
        _LockTimeLab.text = @" 30天免单游 ";
    }
    if ([model.buy_type isEqualToString:@"9"]) {
        _LockTimeLab.text = @" 90天免单游 ";
    }
    if ([model.buy_type isEqualToString:@"10"]) {
        _LockTimeLab.text = @" 180天免单游 ";
    }if ([model.buy_type isEqualToString:@"11"]) {
        _LockTimeLab.text = @" 270天免单游 ";
    }
    if ([model.buy_type isEqualToString:@"12"]) {
        _LockTimeLab.text = @" 360天免单游 ";
    }
    
    [self setupViewLayers];
}


- (void)setupViewLayers{

    _LockTimeLab.layer.cornerRadius = _DrawTimeLab.layer.cornerRadius = 5;
    _LockTimeLab.layer.masksToBounds = _DrawTimeLab.layer.masksToBounds = true;
    
}

@end
