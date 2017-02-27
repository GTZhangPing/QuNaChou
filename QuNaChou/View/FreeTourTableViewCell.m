//
//  FreeTourTableViewCell.m
//  QuNaChou
//
//  Created by WYD on 16/5/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FreeTourTableViewCell.h"

@implementation FreeTourTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)SetCellwithInfo:(NSArray *)array Index:(NSInteger)index{
    
    _index = index;
    _TitleImage.image = [UIImage imageNamed:array[0]];
    _TitleLab.text = array[1];
    _MiandanImage.image = [UIImage imageNamed:array[2]];
    _MinimumLab.text = array[3];
    _MarketPriceLab.text = array[4];
    [_AttentionButton setImage:[UIImage imageNamed:array[5]] forState:UIControlStateNormal];
    
    _JoinButton.layer.cornerRadius = 10;

}


- (IBAction)collect:(id)sender {
    
    [_AttentionButton setImage:[UIImage imageNamed:@"shoucang_click_.png"] forState:UIControlStateNormal];
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(CollectButton:)]) {
        [self.delegate CollectButton:_index];
        
    }
}

@end
