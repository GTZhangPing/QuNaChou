//
//  ExchangeTableViewCell.m
//  QuNaChou
//
//  Created by 张平 on 16/6/23.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ExchangeTableViewCell.h"

@implementation ExchangeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithInfo:(NSArray *)array{
    
    _BigImage.image = [UIImage imageNamed:array[0]];
    _LittleImage.image = [UIImage imageNamed:array[1]];
    _TitleLab.text = array[2];
    _ValueLab.text = array[3];
    
}




@end
