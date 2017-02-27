//
//  UsableBalanceTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsableBalanceInfoModel.h"
#import "UsableBalanceInfoModel.h"

@interface UsableBalanceTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *IconImage;
@property (strong, nonatomic) IBOutlet UILabel *TimeLab;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UILabel *MoneyLab;




- (void)setCellWithModel:(UsableBalanceInfoModel *)moddel;

- (void)setCellWithModel2:(UsableBalanceInfoModel *)model2;

@end
