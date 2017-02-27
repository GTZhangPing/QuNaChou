//
//  CashAttestationViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/8/16.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "CashAttestationViewController.h"
#import "CashResultViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
//#import "PrefixHeader.pch"
#import "SystemInfo.h"


@interface CashAttestationViewController ()

@property (strong, nonatomic) IBOutlet UILabel *PhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *CodeTF;
@property (strong, nonatomic) IBOutlet UIButton *GetCodeButton;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic ,assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation CashAttestationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _PhoneNum.text = _Phone;
    _count = 120;

}

- (IBAction)GetCodeButton:(id)sender {
    
    ZPLog(@"获取验证码");
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@withdraw/getverify.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid
                           };
    
    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        
        NSString *code =[dic objectForKey:@"code"];
        
        if ([code isEqual:@"0053"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"今日验证码获取次数超过限制";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;
        }
        if ([code isEqual:@"0052"]) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(showCountdown)
                                                    userInfo:nil
                                                     repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
    

}

// 验证码发送倒计时计数器
- (void)showCountdown
{
    // 倒计时状态
    if (_count > 0) {
        NSString *title = [NSString stringWithFormat:@"%ld秒",(long)_count];
        if (IOS8_OR_LATER) {
            [_GetCodeButton setTitle:title forState:UIControlStateNormal];
        } else {
            _GetCodeButton.titleLabel.text = title;
        }
        _GetCodeButton.enabled = NO;
        _count--;
        // 120s倒计时完成
    } else {
        _count = 120;
        [_GetCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _GetCodeButton.enabled = YES;
        [_timer invalidate];
    }
}


- (IBAction)CashButton:(id)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@withdraw/index.html",QNCURL];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"ws":_index,
                           @"money":_CashMoney,
                           @"verify":_CodeTF.text
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
        if ([code  isEqual: @"0049"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"验证码错误";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;
        }
        if ([code  isEqual: @"0047"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"未获取验证码";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;
        }
        if ([code  isEqual: @"0021"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"提现失败";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;
        }
        if ([code  isEqual: @"0020"]) {
            
            CashResultViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CashResultViewController"];
            VC.CashMoney = _CashMoney;
            VC.index = _index;
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 键盘掉落处理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self keyboardFallOffHandle];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardFallOffHandle];
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardFallOffHandle];
}


// UITextField取消第一响应,键盘掉落
- (void)keyboardFallOffHandle
{
    [_CodeTF resignFirstResponder];
}


- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}


@end
