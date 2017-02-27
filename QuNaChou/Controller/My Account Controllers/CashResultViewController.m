//
//  CashResultViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/12.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "CashResultViewController.h"
#import "HomeTabBarController.h"
//#import "PrefixHeader.pch"
#import "UsableBalanceViewController.h"
#import "MACurrentViewController.h"


@interface CashResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *CashLab;

@property (weak, nonatomic) IBOutlet UIButton *RecordButton;

@end

@implementation CashResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    if ([_index isEqual:@"1"]) {
        [_RecordButton setTitle:@"可用余额纪录" forState:UIControlStateNormal];
    }
    else{
        [_RecordButton setTitle:@"活期宝纪录" forState:UIControlStateNormal];
    }
    _RecordButton.layer.cornerRadius = 10;
}

- (void)viewWillAppear:(BOOL)animated{
 
    _CashLab.text = [NSString stringWithFormat:@"已提现¥%@至绑定银行卡，请注意查收！",_CashMoney];
}


- (IBAction)Back:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)ToMyAccount:(id)sender {
    
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    tab.selectedIndex = 2;
    [self presentViewController:tab animated:YES completion:nil];

}



- (IBAction)RecordButtonClicked:(id)sender {
    
    if ([_index isEqual:@"1"]) {
        
        UsableBalanceViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsableBalanceViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if ([_index isEqual:@"2"]) {
        
        MACurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MACurrentViewController"];
        [self.navigationController pushViewController:VC animated:YES];

    }
    
}


@end
