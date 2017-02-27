//
//  ExchangeTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/23.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntralExchangeModel.h"


@interface ExchangeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@property (weak, nonatomic) IBOutlet UIImageView *LittleImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ValueLab;


- (void)setCellWithInfo:(NSArray *)array;


@end
