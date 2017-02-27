//
//  LotteryTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/28.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntralExchangeModel.h"


@interface LotteryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *Titlelab;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;


@property (strong, nonatomic) IBOutlet UILabel *ResultLab;


- (void)setCellWithInfo:(NSArray *)array;

- (void)setCellWithModel:(IntralExchangeModel *)model;


@end
