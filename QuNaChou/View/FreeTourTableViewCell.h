//
//  FreeTourTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/5/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

//协议
@protocol FreeTourTableViewCellDelegate <NSObject>

@required

- (void)CollectButton:(NSInteger )index;

@end

@interface FreeTourTableViewCell : UITableViewCell

@property(assign, nonatomic) id<FreeTourTableViewCellDelegate> delegate;


@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;

@property (strong, nonatomic) IBOutlet UIImageView *MiandanImage;
@property (strong, nonatomic) IBOutlet UILabel *MinimumLab;
@property (strong, nonatomic) IBOutlet UILabel *MarketPriceLab;
@property (strong, nonatomic) IBOutlet UIButton *AttentionButton;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;

@property (nonatomic ,assign)NSInteger index;


- (void)SetCellwithInfo:(NSArray *)array Index:(NSInteger)index;


@end
