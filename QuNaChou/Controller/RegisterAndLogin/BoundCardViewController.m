//
//  BoundCardViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/8/11.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "BoundCardViewController.h"
//#import "PrefixHeader.pch"
#import "NSString+VerifyBankCard.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "STPickerSingle.h"
#import "BindBankCardViewController.h"

@interface BoundCardViewController ()<UITextFieldDelegate,STPickerSingleDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UITextField *UserNameTF;
@property (strong, nonatomic) IBOutlet UITextField *BankNameTF;
@property (strong, nonatomic) IBOutlet UITextField *CardNumberTF;



@end

@implementation BoundCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _BankNameTF.delegate = self;
    _UserNameTF.text = [_InfoDic objectForKey:@"name"];
    _UserNameTF.userInteractionEnabled = NO;
//    _BankNameTF.text = [_InfoDic objectForKey:@"bankname"];
//    _CardNumberTF.text = [_InfoDic objectForKey:@"banknum"];

    
}



- (IBAction)ConfirmButton:(id)sender {
    
    if ([_UserNameTF.text isEqual:@""]) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请输入正确姓名";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        
        return;
    }

    if ([_BankNameTF.text isEqual:@""]) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请选择银行";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        
        return;
    }
    if ([_CardNumberTF.text isEqual:@""]) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请输入正确的银行卡号";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        
        return;
    }
    if (![NSString checkCardNo:_CardNumberTF.text]) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请输入正确的银行卡号";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@set/authenbank.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                           @"bankname":_BankNameTF.text,
                           @"banknum":_CardNumberTF.text
                           };
    [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqual:@"0057"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"绑定失败";
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
                _hud.labelText = @"绑定成功";
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _BankNameTF) {
        [_BankNameTF resignFirstResponder];
        
        NSMutableArray *arrayData = [NSMutableArray arrayWithObjects:@"中国银行",@"中国光大银行",@"中国农业银行",@"浦发银行", @"中国工商银行",@"兴业银行",@"中国建设银行",@"邮储银行",@"招商银行",@"平安银行",@"中信银行",@"北京银行",@"华夏银行",@"上海银行",@"民生银行",@"杭州银行",@"广发银行",@"宁波银行",@"交通银行",@"广州银行",@"包商银行",@"珠海华润银行",@"东莞银行",@"广东南粤银行",@"江苏银行",@"浙商银行", nil];
        
        STPickerSingle *pickerview = [[STPickerSingle alloc] init];
        [pickerview setArrayData:arrayData];
        [pickerview setTitle:@"请选择银行"];
        [pickerview setContentMode:STPickerContentModeBottom];
        [pickerview setDelegate:self];
        [pickerview show];
    }
}

- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - STPickerSingleDelegate

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    _BankNameTF.text = text;
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


- (void) keyboardFallOffHandle
{
    [_CardNumberTF resignFirstResponder];
    [_BankNameTF resignFirstResponder];
    [_UserNameTF resignFirstResponder];
    
}


- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}


@end
