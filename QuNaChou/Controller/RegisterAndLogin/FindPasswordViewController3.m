//
//  FindPasswordViewController3.m
//  QuNaChou
//
//  Created by 张平 on 16/8/10.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FindPasswordViewController3.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "NSString+MD5Encryption.h"


@interface FindPasswordViewController3 ()

@property(nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPassword;

@end

@implementation FindPasswordViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)ConfirmButton:(id)sender {
    
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
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@retrieve/setpsd.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;

    NSDictionary *dict = @{@"phone":_UserName,
                           @"password":[[_ConfirmPassword.text md5HexDigest] md5HexDigest],
                           @"rid":rid
                           };
//    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqual:@"0057"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"密码设置失败，请重新设置";
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
                _hud.labelText = @"密码设置成功，请重新登录";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                sleep(2);
                [self.navigationController popToRootViewControllerAnimated:YES];
                [_hud hide:YES afterDelay:0.8f];
            }];

        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
    
}


- (IBAction)Back:(id)sender {
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    [_ConfirmPassword resignFirstResponder];
    [_PasswordTextField resignFirstResponder];
}

//- (void)dismissDelayed
//{
//    [SVProgressHUD dismiss];
//}

@end
