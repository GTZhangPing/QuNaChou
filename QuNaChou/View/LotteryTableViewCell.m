//
//  LotteryTableViewCell.m
//  QuNaChou
//
//  Created by 张平 on 16/6/28.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "LotteryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+TransformTimestamp.h"

@implementation LotteryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithInfo:(NSArray *)array{
    
    _IconImage.image = [UIImage imageNamed:array[0]];
    _Titlelab.text = array[1];
    _PriceLab.text = array[2];
    _TimeLab.text = array[3];
    
    
}



- (void)setCellWithModel:(IntralExchangeModel *)model{
 
    _ResultLab.text = [NSString stringWithFormat:@"兑换结果：%@",model.Result];
    _Titlelab.text = model.Name;
    _PriceLab.text = model.UseIntegral;
    NSString *timeStr = [NSString transformTime:model.Time];
    _TimeLab.text = [NSString stringWithFormat:@"兑换时间:%@",timeStr];
    NSURL *imageURL = [NSURL URLWithString:model.ImageURL];

    [_IconImage sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    }


@end
