//
//  PrivilegeTicketTableViewCell.m
//  QuNaChou
//
//  Created by 张平 on 16/6/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "PrivilegeTicketTableViewCell.h"
#import "NSString+TransformTimestamp.h"
//#import "PrefixHeader.pch"


@implementation PrivilegeTicketTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)SetCellWithInfo:(PrivilegeTicketInfoModel *)model{
    
    if ([model.type  isEqual: @"yes"]) {
        
        _guoqiImage.hidden = YES;
        _BgImage.image = [UIImage imageNamed:@"HQbg1_.png"];
        _Namelab.text = model.name;
        _tequanLab.text = model.tequan;
        _BeginTimeLab.text = [NSString stringWithFormat:@"发放时间：%@", [NSString transformTime2:model.beganTime]];
        if (model.endTime) {
            _EndTimeLab.text = [NSString stringWithFormat:@"过期时间：%@",[NSString transformTime2:model.endTime]];
        }
        else{
            _EndTimeLab.text = @"";
        }
        _Namelab.textColor = [UIColor blackColor];
        _tequanLab.textColor = TEXT_COLOR_RED;

    }
    if ([model.type  isEqual: @"no"]) {
        
        _guoqiImage.hidden = NO;
        _BgImage.image = [UIImage imageNamed:@"HQbg3_.png"];
        _Namelab.text = model.name;
        _tequanLab.text = model.tequan;
        _BeginTimeLab.text = [NSString stringWithFormat:@"发放时间：%@", [NSString transformTime2:model.beganTime]];
        if (model.endTime) {
            _EndTimeLab.text = [NSString stringWithFormat:@"过期时间：%@",[NSString transformTime2:model.endTime]];
        }
        else{
            _EndTimeLab.text = @"";
        }
        _Namelab.textColor = _tequanLab.textColor = TEXT_COLOR_GRAY;
    }
}


@end
