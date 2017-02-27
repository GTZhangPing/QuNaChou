//
//  ReminderView.h
//  QuNaChou
//
//  Created by 张平 on 16/6/29.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>


//协议
@protocol ReminderViewDelegate <NSObject>

@required

- (void)ZhongJiang;

- (void)Back1;

- (void)PushToAddress;

- (void)Back2;

- (void)PushLookInfo;


@end


@interface ReminderView : UIView

@property (nonatomic, assign) id<ReminderViewDelegate>delegate;

@property UILabel *NameLabel;
@property UIImageView *titleImageView;
@property UIButton *ReceiveButton;

//－－－－－－－－－－－－－－－－－－

@property (nonatomic, strong) UILabel *TitleLab;
@property (nonatomic, strong) UIImageView *LineImage;
@property (nonatomic ,strong) UIButton *BackButton1;
@property (nonatomic, strong) UIButton *ToAddressButton;


//－－－－－－－－－－－－－－－－－－－－

@property (nonatomic ,strong) UIButton *BackButton2;
@property (nonatomic, strong) UIButton *LookInfoButton;
//@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) UILabel *lab;



- (id)initWithFrame:(CGRect)frame Type:(int )type;

@end
