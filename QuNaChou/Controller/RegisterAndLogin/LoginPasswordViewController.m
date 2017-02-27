//
//  LoginPasswordViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/8/10.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "LoginPasswordViewController.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "NSString+MD5Encryption.h"


@interface LoginPasswordViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UITextField *OldPasswordTX;
@property (strong, nonatomic) IBOutlet UITextField *NewPasswordTX;
@property (strong, nonatomic) IBOutlet UITextField *VerifyNewPasswordTX;


@end

@implementation LoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


//修改密码
- (IBAction)ChangeButton:(id)sender {
    
    [self keyboardFallOffHandle];
    
    if ([_OldPasswordTX.text isEqualToString:_NewPasswordTX.text]) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"新密码不能为旧密码";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    
    if (_NewPasswordTX.text.length < 6 || _NewPasswordTX.text.length > 18) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"密码长度需为6～18位";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    
    if (![_NewPasswordTX.text isEqualToString:_VerifyNewPasswordTX.text]) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"两次输入密码不一致";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@set/alterpsd.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"oldpassword":[[_OldPasswordTX.text md5HexDigest]md5HexDigest],
                           @"newpassword":[[_NewPasswordTX.text md5HexDigest] md5HexDigest],
                           @"rid":rid,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]
                           };
    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqual:@"0058"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"原始密码有误";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code isEqual:@"0057"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"密码设置失败";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code isEqual:@"0056"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"密码设置成功";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;

        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];

}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [_OldPasswordTX resignFirstResponder];
    [_NewPasswordTX resignFirstResponder];
    [_VerifyNewPasswordTX resignFirstResponder];
}

- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}

@end
