//
//  MyAccountTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/4/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "MyAccountTableViewCell.h"

@implementation MyAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellWithInfo:(NSArray *)array
{
    _Image.image  =[UIImage imageNamed:array[0]];
    _TitleLab.text = array[1];
}

@end
