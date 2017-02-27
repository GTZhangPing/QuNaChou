//
//  LuckView.h
//  Lottery
//
//  Created by 张平 on 16/8/5.
//  Copyright © 2016年 张平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LuckViewDelegate <NSObject>

- (void)startButton:(UIButton *)button;
- (void)luckViewDidStopWithArrayCount:(NSInteger)count;


@end

@interface LuckView : UIView

@property (nonatomic,assign)id<LuckViewDelegate>delegate;

@property (nonatomic, strong) NSArray *ImageArray;
@property (nonatomic, strong) NSArray *LabArray;
@property (nonatomic, assign) int stopCount;

@property (nonatomic, strong) UIButton *StartButton;
@property (nonatomic, strong) UIButton *AgainButton;
@property (nonatomic, assign) BOOL canUse;


@end
