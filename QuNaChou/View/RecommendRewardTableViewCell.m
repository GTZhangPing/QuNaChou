//
//  RecommendRewardTableViewCell.m
//  QuNaChou
//
//  Created by 张平 on 16/6/20.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RecommendRewardTableViewCell.h"

@implementation RecommendRewardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)SetCellWithInfo:(RecommendRewardInfoModel *)model{
    
    _Namelab.text = model.username;
    _Moneylab.text = model.money;
    if (![model.money isEqual:@"未投资"]) {
        _Moneylab.text = [NSString stringWithFormat:@"¥ %@", model.money];
    }
}

@end
