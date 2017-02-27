//
//  RecommendRewardTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/20.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendRewardInfoModel.h"

@interface RecommendRewardTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *Namelab;
@property (weak, nonatomic) IBOutlet UILabel *Moneylab;

- (void)SetCellWithInfo:(RecommendRewardInfoModel *)midel;

@end
