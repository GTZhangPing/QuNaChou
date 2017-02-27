//
//  FlashSaleTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/23.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>



//协议
@protocol FlashSaleTableViewCellDelegate <NSObject>

@required

- (void)push:(NSInteger )str;


@end


@interface FlashSaleTableViewCell : UITableViewCell

@property (nonatomic, assign)id<FlashSaleTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *ValueLab;
@property (weak, nonatomic) IBOutlet UIButton *BuyButton;

@property (nonatomic, assign)NSInteger index;

- (void)setCellWithInfo:(NSArray *)array Index:(NSInteger)index;


@end
