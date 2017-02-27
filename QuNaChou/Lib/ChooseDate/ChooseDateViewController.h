//
//  ViewController.h
//  CHTCalendar
//
//  Created by risenb_mac on 16/8/13.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseDateViewController;
//协议
@protocol ChooseDateViewControllerDelegate <NSObject>

@required

- (void) ChooseDateViewController:(ChooseDateViewController *)chooseDateController ChoseDate:(NSString *)date;

- (void)ChooseDateViewController:(ChooseDateViewController *)chooseDateController;

@end

@interface ChooseDateViewController : UIViewController

@property (nonatomic, assign) id<ChooseDateViewControllerDelegate>delegate;


@end

