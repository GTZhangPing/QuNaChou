//
//  RegisterThirdViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/31.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RegisterThirdViewController.h"
//#import "PrefixHeader.pch"
#import "UserLoginViewController.h"
#import "RegisterLastViewController.h"
#import "UIView+Custom.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "NSString+MD5Encryption.h"

@interface RegisterThirdViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *InviteCodeTextField;



@end

@implementation RegisterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}




- (IBAction)RegisterButtonClicked:(id)sender {
    
    [self keyboardFallOffHandle];
    
    if (_PasswordTextField.text.length < 6 || _PasswordTextField.text.length > 18) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"密码长度需为6～18位";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    
    if (![_PasswordTextField.text isEqualToString:_ConfirmPassword.text]) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"两次输入密码不一致";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    

    NSString *baseUrl = [NSString stringWithFormat:@"%@register/setpsd.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    if ([_InviteCodeTextField.text isEqual:@""]) {
        _InviteCodeTextField.text = @"wu";
    }
    NSDictionary *dict = @{@"phone":_UserName,
                           @"password":[[_ConfirmPassword.text md5HexDigest] md5HexDigest],
                           @"rid":rid,
                           @"inviter":_InviteCodeTextField.text
                           };
    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        NSString *uid = [dic objectForKey:@"uid"];
        NSString *tqcs = [dic objectForKey:@"tqcs"];
        if ([code isEqual:@"0005"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"注册失败";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code isEqual:@"0029"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"邀请码有误";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code isEqual:@"0006"]) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"hasLogin"];
            [userDefault setObject:uid forKey:@"uid"];
            [userDefault setValue:tqcs forKey:@"tqcs"];
            [userDefault synchronize];
            
            RegisterLastViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterLastViewController"];
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:VC]animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}


- (IBAction)Back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Join:(id)sender {
    
    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:VC]animated:YES completion:nil];
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
    [_ConfirmPassword resignFirstResponder];
    [_PasswordTextField resignFirstResponder];
    [_InviteCodeTextField resignFirstResponder];
}

- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}

@end
