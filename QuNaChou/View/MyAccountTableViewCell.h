//
//  MyAccountTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/4/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;

- (void)setCellWithInfo:(NSArray *)array;

@end
