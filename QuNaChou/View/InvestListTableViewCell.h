//
//  InvestListTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/4/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

////协议
//@protocol InvestListTableViewCellDelegate <NSObject>
//
//@required
//
//- (void)push:(NSInteger )str;
//
//
//@end


@interface InvestListTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UIImageView *Icon;
@property (strong, nonatomic) IBOutlet UILabel *EarningsLab;
@property (strong, nonatomic) IBOutlet UILabel *TopLab1;
@property (strong, nonatomic) IBOutlet UILabel *TopLab2;
@property (strong, nonatomic) IBOutlet UILabel *TopLab3;
@property (strong, nonatomic) IBOutlet UILabel *TopLab4;
@property (strong, nonatomic) IBOutlet UILabel *BottomLab;


//- (void)setWithTitleLab:(NSString *)titleLab Icon:(NSString *)icon TopLab1:(NSString *)topLab1 TopLab2:(NSString *)topLab2 TopLab3:(NSString *)topLab3 TopLab4 :(NSString *)topLab4 EarningsLab:(NSString *)earningsLab BottomLab:(NSString *)bottomLab;


- (void)setCellWithArray:(NSArray *)array;

@end
