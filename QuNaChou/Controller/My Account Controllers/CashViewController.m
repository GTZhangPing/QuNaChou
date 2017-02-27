//
//  CashViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "CashViewController.h"
//#import "PrefixHeader.pch"
#import "CashSecondViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "CashSecondViewController.h"
#import "SVProgressHUD.h"


@interface CashViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *BalanceLab;
@property (weak, nonatomic) IBOutlet UILabel *CurrentLab;


@end



@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //导航栏颜色 字体 大小
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    [self RequestNetWork];

}


- (void)viewWillAppear:(BOOL)animated{
    
    

}


- (void)RequestNetWork{ 
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@withdraw/doing.html",QNCURL];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
  
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        
        _BalanceLab.text = [dic objectForKey:@"keyongyue"];
        _CurrentLab.text = [dic objectForKey:@"huoqibao"];

        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];

}

- (IBAction)ButtonClicked:(UIButton *)sender {
    
    
    CashSecondViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CashSecondViewController"];

    if (sender.tag == 1111) {
        VC.index = @"1";
    }
    if (sender.tag == 1112) {
        VC.index = @"2";
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@withdraw/enter.html",QNCURL];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"ws":VC.index
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        
        NSString *code = [dic objectForKey:@"code"];
        if ([code  isEqual: @"0060"]) {
            
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"充值投资完成后完成绑定";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;

        }
        else{
            VC.InfoDic = dic;
            [self.navigationController pushViewController:VC animated:YES];

        }

        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];

}



- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}


@end
