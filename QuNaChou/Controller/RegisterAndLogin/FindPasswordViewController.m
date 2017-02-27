//
//  FindPasswordViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/6.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "FindPasswordViewController2.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+MobileNumVerify.h"
//#import "PrefixHeader.pch"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface FindPasswordViewController ()<UITextFieldDelegate>

@property(nonatomic, assign) BOOL CanNext;
@property (strong, nonatomic) IBOutlet UITextField *MobliePhoneTF;
@property (strong, nonatomic) IBOutlet UIImageView *StatusImage;

@property (nonatomic ,strong) MBProgressHUD *hud;
@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 给TextField注册内容变动通知,添加监听方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(judgeUserInputStatus)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}


// TextField监听方法
- (void)judgeUserInputStatus
{
    if (![NSString validateMobile:_MobliePhoneTF.text]) {
        _StatusImage.image = [UIImage imageNamed:@"ZCicon3.png"];
        _CanNext = NO;
    }
    else{
        _StatusImage.image = [UIImage imageNamed:@"ZCicon2.png"];
        _CanNext = YES;
    }
}


- (IBAction)NextButtonClicked:(id)sender {
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@retrieve/checkphone.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *dict = @{@"rid":rid,
                           @"phone":_MobliePhoneTF.text
                           };
    
    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        
        NSString *code =[dic objectForKey:@"code"];
        
        if (!_CanNext) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"请输入正确的手机号";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        
        if ([code isEqualToString:@"0054"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"号码未注册";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return;
        }
        if ([code isEqual:@"0055"]) {
            
            FindPasswordViewController2 *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindPasswordViewController2"];
            VC.UserName = _MobliePhoneTF.text;
//            [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:VC] animated:YES completion:nil];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        ZPLog(@"%@",error);
    }];

}

- (IBAction)Back:(id)sender {
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 键盘滑落处理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self keyboardFallOffHandle];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardFallOffHandle];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardFallOffHandle];
    return YES;
}


// UITextField取消第一响应,键盘掉落
- (void)keyboardFallOffHandle
{
    [_MobliePhoneTF resignFirstResponder];
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
