//
//  MARegularTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MARegularInfoModel.h"

@interface MARegularTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *LockTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *DrawTimeLab;

@property (strong, nonatomic) IBOutlet UILabel *ShouyiLab;
@property (strong, nonatomic) IBOutlet UILabel *AddMoneyLab;
@property (strong, nonatomic) IBOutlet UILabel *YieldLab;
@property (strong, nonatomic) IBOutlet UILabel *ReturnLab;
@property (strong, nonatomic) IBOutlet UILabel *TimeLab;
@property (strong, nonatomic) IBOutlet UILabel *StatusLab;
@property (strong, nonatomic) IBOutlet UIImageView *BgImage;


- (void)SetCellWithInfo:(MARegularInfoModel *)model;
@end
