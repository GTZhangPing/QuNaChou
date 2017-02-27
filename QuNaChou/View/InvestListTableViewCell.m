//
//  InvestListTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/4/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "InvestListTableViewCell.h"
//#import "PrefixHeader.pch"
#import "UIButton+PropertySetting.h"

@implementation InvestListTableViewCell

//
//- (void)setWithTitleLab:(NSString *)titleLab Icon:(NSString *)icon TopLab1:(NSString *)topLab1 TopLab2:(NSString *)topLab2 TopLab3:(NSString *)topLab3 TopLab4 :(NSString *)topLab4 EarningsLab:(NSString *)earningsLab BottomLab:(NSString *)bottomLab{
//    _TitleLab.text = titleLab;
//    _TopLab1.text = topLab1;
//    _TopLab2.text = topLab2;
//    _TopLab3.text = topLab3;
//    _TopLab4.text = topLab4;
//    _BottomLab.text = bottomLab;
//    _EarningsLab.text = earningsLab;
//    _Icon.image =[UIImage imageNamed:icon];
//    
//    [self setupViewLayers];
//
//}


- (void)setCellWithArray:(NSArray *)array{
   
    _TitleImage.image = [UIImage imageNamed:array[0]];
    _TitleLab.text = array[1];
    _Icon.image =[UIImage imageNamed:array[2]];
    _EarningsLab.text = [NSString stringWithFormat:@"%@%@", array[3],@"%"];
    _BottomLab.text = array[4];

    [self setupViewLayers];

}

- (void)setupViewLayers{
    
    _TopLab1.backgroundColor =_TopLab2.backgroundColor = PINK_COLOR;
    _TopLab1.layer.cornerRadius =  _TopLab2.layer.cornerRadius = _TopLab3.layer.cornerRadius = _TopLab4.layer.cornerRadius = 5;
    _TopLab1.layer.masksToBounds = _TopLab2.layer.masksToBounds = _TopLab3.layer.masksToBounds = _TopLab4.layer.masksToBounds = true;
    
    
}

@end
