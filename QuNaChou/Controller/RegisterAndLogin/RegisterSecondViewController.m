//
//  RegisterSecondViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/31.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import "RegisterThirdViewController.h"
#import "UserLoginViewController.h"
#import "UIView+Custom.h"
#import "SystemInfo.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface RegisterSecondViewController ()

@property (strong, nonatomic) IBOutlet UITextField *CodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *GetCodeButton;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic ,assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _count = 120;
}


- (IBAction)GetCodeButtonClicked:(id)sender {
    
    ZPLog(@"获取验证码");
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@register/getverify.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *dict = @{@"rid":rid,
                           @"phone":self.UserName
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

//下一步
- (IBAction)NextButtonClicked:(id)sender {
    ZPLog(@"下一步");
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@register/checkverify.html",QNCURL];
    NSDictionary *dict = @{@"phone":self.UserName,
                           @"rid":rid,
                           @"verify":_CodeTextField.text
                           };
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger.requestSerializer setHTTPShouldHandleCookies:YES];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setTimeoutInterval:20.0];
    manger.securityPolicy.allowInvalidCertificates = YES;
    [SVProgressHUD showWithStatus:@"数据验证中" maskType:SVProgressHUDMaskTypeBlack];
    [manger POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        if ([[dic objectForKey:@"code"] isEqual:@"0048"]) {
             RegisterThirdViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterThirdViewController"];
            VC.UserName = _UserName;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:VC]animated:YES completion:nil];
        }
        else{
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
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];

    }];
    
  
    
}



- (IBAction)Back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//
////跳转登录界面
//- (IBAction)LoginButton:(id)sender {
//    
//    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
//    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:VC]animated:YES completion:nil];
//}



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
    [_CodeTextField resignFirstResponder];
}


- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}

@end
