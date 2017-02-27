//
//  UsableBalanceTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "UsableBalanceTableViewCell.h"
#import "NSString+TransformTimestamp.h"
//#import "PrefixHeader.pch"

@implementation UsableBalanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellWithModel:(UsableBalanceInfoModel *)moddel{
    
    _TimeLab.text = [NSString transformTime:moddel.Time];
    if ([moddel.Type  isEqual: @"1"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon1_"];
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TB_COLOR_RED;
        _TitleLab.text = @"活期收益";

    }
    if ([moddel.Type  isEqual: @"2"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon1_"];
        _TitleLab.text = @"定存收益";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TB_COLOR_RED;
    }
    if ([moddel.Type  isEqual: @"3"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon2_"];
        _TitleLab.text = @"推荐奖励";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TB_COLOR_RED;
    }
    if ([moddel.Type  isEqual: @"4"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon3_"];
        _TitleLab.text = @"提现申请";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
    }
    if ([moddel.Type  isEqual: @"5"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon3_"];
        _TitleLab.text = @"资金冻结";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_RED;
    }
    if ([moddel.Type  isEqual: @"6"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon4_"];
        _TitleLab.text = @"提现成功";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
    }
    if ([moddel.Type  isEqual: @"7"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon5_"];
        _TitleLab.text = @"可用余额投资";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
    }
    if ([moddel.Type  isEqual: @"8"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon1_"];
        _TitleLab.text = @"提现失败 资金加入";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
    }
    if ([moddel.Type  isEqual: @"9"]) {
        _IconImage.image = [UIImage imageNamed:@"YEicon3_"];
        _TitleLab.text = @"提现失败";
        _MoneyLab.text = [NSString stringWithFormat:@"¥%@",moddel.Money];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
    }
}





- (void)setCellWithModel2:(UsableBalanceInfoModel *)model2{
    
    _TimeLab.text = [NSString transformTime:model2.ID_time];
    if (model2.ID_style != nil) {
        _IconImage.image = [UIImage imageNamed:@"YEicon2_"];
        _MoneyLab.text = [NSString stringWithFormat:@"+%@",model2.ID_integral];
        _MoneyLab.textColor = TB_COLOR_RED;
        if ([model2.ID_style  isEqual: @"1"]) {
            _TitleLab.text = @"推荐好友";
        }
        if ([model2.ID_style  isEqual: @"2"]) {
            _TitleLab.text = @"投资奖励（定存宝）";
        }
        if ([model2.ID_style  isEqual: @"3"]) {
            _TitleLab.text = @"投资奖励（活期宝）";
        }
        if ([model2.ID_style  isEqual: @"4"]) {
            _TitleLab.text = @"抽奖";
        }
    }
    if (model2.ID_type != nil) {
        
        _MoneyLab.text = [NSString stringWithFormat:@"-%@",model2.ID_integral];
        _MoneyLab.textColor = TEXT_COLOR_GRAY;
        _IconImage.image = [UIImage imageNamed:@"YEicon4_"];
        if ([model2.ID_type  isEqual: @"1"]) {
            _TitleLab.text = @"游票兑换实物";
        }
        if ([model2.ID_type  isEqual: @"2"]) {
            _TitleLab.text = @"抽奖";
        }

    }
    
    
}

@end
