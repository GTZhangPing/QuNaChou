//
//  CurrentInfoTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/26.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "CurrentInfoTableViewCell.h"

@implementation CurrentInfoTableViewCell


- (void)SetCellWithInfo:(NSArray *)array{
    if ([array[0]isEqual:@"1"]) {
        _NameLab.text = @"陈先生";
    }
    if ([array[0]isEqual:@"2"]) {
        _NameLab.text = @"李先生";
    }
    if ([array[0]isEqual:@"3"]) {
        _NameLab.text = @"杨女士";
    }
    if ([array[0]isEqual:@"4"]) {
        _NameLab.text = @"张先生";
    }
    _Moneylab.text = array[1];
}


@end
