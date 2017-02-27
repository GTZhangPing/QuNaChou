//
//  ReminderLoginView.h
//  QuNaChou
//
//  Created by 张平 on 16/7/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReminderLoginViewDelegate <NSObject>


//@required  //必需实现的

@optional //可选的
- (void)Register;

- (void)Login;

- (void)Bound;

@end


@interface ReminderLoginView : UIView

@property (nonatomic, assign) id<ReminderLoginViewDelegate>delegate;

@property (nonatomic, strong) UIImageView *IconImage;
@property (nonatomic, strong) UILabel *ReminderLab;
@property (nonatomic, strong) UIImageView *LineImage;
@property (nonatomic, strong) UIButton *Button1;
@property (nonatomic, strong) UIButton *Button2;


- (id)initWithFrame:(CGRect)frame Style:(NSString *)style;



@end
