//
//  PrivilegeTicketTableViewCell.h
//  QuNaChou
//
//  Created by 张平 on 16/6/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivilegeTicketInfoModel.h"

@interface PrivilegeTicketTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *Namelab;
@property (weak, nonatomic) IBOutlet UILabel *tequanLab;
@property (weak, nonatomic) IBOutlet UILabel *BeginTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *EndTimeLab;

@property (weak, nonatomic) IBOutlet UIImageView *guoqiImage;
@property (weak, nonatomic) IBOutlet UIImageView *BgImage;


- (void)SetCellWithInfo:(PrivilegeTicketInfoModel *)model;


@end
