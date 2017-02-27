//
//  UserLoginViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/4.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "UserLoginViewController.h"
//#import "PrefixHeader.pch"
#import "UIButton+PropertySetting.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "FindPasswordViewController.h"
#import "UIView+Custom.h"
#import "HomeTabBarController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "NSString+MD5Encryption.h"

@interface UserLoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *UsernameTF;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTF;
@property (strong, nonatomic) MBProgressHUD *hud;



@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}


- (void)viewWillAppear:(BOOL)animated
{
//        self.navigationController.navigationBar.tintColor = TB_COLOR_GRAY;
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//登录按钮点击
- (IBAction)Login:(id)sender {
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@login/index.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"phone":_UsernameTF.text,
                           @"password":[[_PasswordTF.text md5HexDigest] md5HexDigest],
                           @"rid":rid
                               };
    [SVProgressHUD showWithStatus:@"登陆中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *code =[dic objectForKey:@"code"];
        NSString *uid = [dic objectForKey:@"uid"];
        NSString *tqcs =[dic objectForKey:@"tqcs"];
        
        if ([code isEqualToString:@"0007"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"账号或密码错误";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
        }
        if ([code isEqual:@"0006"]){
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"hasLogin"];
            [userDefault setObject:uid forKey:@"uid"];
            [userDefault setValue:tqcs forKey:@"tqcs"];
            [userDefault synchronize];
//            ZPLog(@"%@,%@",[userDefault objectForKey:@"uid"],[userDefault objectForKey:@"tqcs"]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}

//找回密码
- (IBAction)findBackPassword:(id)sender {
    
    FindPasswordViewController *FindPassWordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindPasswordViewController"];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:FindPassWordVC] animated:YES completion:nil];
    [self.navigationController pushViewController:FindPassWordVC animated:YES];
}

//注册
- (IBAction)moveToRegisterPage:(id)sender {
    
    RegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerVC] animated:YES completion:^{
    }];
    
    
    
}

//返回
- (IBAction)Back:(id)sender {
    
    [_UsernameTF resignFirstResponder];
    [_PasswordTF resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWin   dow.rootViewController;
//    tab.selectedIndex=0;
    
//    HomeTabBarController *tab = [self. storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
//    tab.selectedIndex = 0;
//    [self presentViewController:tab animated:YES completion:nil];
//
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

- (void)keyboardFallOffHandle{
    [_UsernameTF resignFirstResponder];
    [_PasswordTF resignFirstResponder];
}


- (void)dismissDelayed{
    [SVProgressHUD dismiss];
}

@end
