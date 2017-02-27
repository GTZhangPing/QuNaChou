//
//  PreciousTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/5/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreciousInfoModel.h"

@interface PreciousTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *BgImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UILabel *StatusLab;
@property (strong, nonatomic) IBOutlet UILabel *TimeLab;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab2;
@property (strong, nonatomic) IBOutlet UILabel *DescribeLab;
@property (weak, nonatomic) IBOutlet UIImageView *GuoQiImage;

@property (nonatomic) CGFloat height;//当前cell总高度


- (void)setCellWithInfo:(PreciousInfoModel *)model;


@end
