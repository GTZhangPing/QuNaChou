//
//  CurrentInfoTableViewCell.h
//  QuNaChou
//
//  Created by WYD on 16/5/26.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *NameLab;
@property (strong, nonatomic) IBOutlet UILabel *Moneylab;

- (void)SetCellWithInfo:(NSArray *)array;

@end
