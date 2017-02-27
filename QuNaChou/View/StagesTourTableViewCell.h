//
//  StagesTourTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>


//协议
@protocol StagesTourTableViewCellDelegate <NSObject>

@required

- (void)CollectButton:(NSInteger )index;

@end


@interface StagesTourTableViewCell : UITableViewCell

@property (nonatomic, assign)id<StagesTourTableViewCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;

@property (strong, nonatomic) IBOutlet UIImageView *MiandanImage;
@property (strong, nonatomic) IBOutlet UILabel *MinimumLab;
@property (strong, nonatomic) IBOutlet UILabel *MarketPriceLab;
@property (strong, nonatomic) IBOutlet UIButton *AttentionButton;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;

@property (nonatomic, assign)NSInteger index;

- (void)SetCellwithInfo:(NSArray *)array Index:(NSInteger)index;



@end
