//
//  FlashSaleTableViewCell.m
//  QuNaChou
//
//  Created by 张平 on 16/6/23.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FlashSaleTableViewCell.h"

@implementation FlashSaleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithInfo:(NSArray *)array Index:(NSInteger)index{
    
    _index = index;
    _BuyButton.layer.cornerRadius = 5;
}


- (IBAction)BuyButtonClicked:(id)sender {
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(push:)])
    {
        [self.delegate push:_index];
    }

}


@end
