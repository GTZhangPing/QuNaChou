//
//  BindBankCardViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/1.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "BindResultViewController.h"
#import "UIView+Custom.h"
//#import "PrefixHeader.pch"
#import "NSString+VerifyRegexTool.h"
#import "NSString+VerifyBankCard.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "STPickerSingle.h"


@interface BindBankCardViewController ()<UITextFieldDelegate,STPickerSingleDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UITextField *NameTextField;
@property (strong, nonatomic) IBOutlet UITextField *IDCardNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *CardTextField;
@property (strong, nonatomic) IBOutlet UITextField *BankCardNumTextField;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];
    
    _CardTextField.delegate = self;
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardFallOffHandle)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [_scrollView addGestureRecognizer:recognizer];
}

- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ConfirmButtonClicked:(id)sender {
    
    if ([_NameTextField.text isEqual:@""]) {
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
    if (![NSString verifyIDCardNumber:_IDCardNumTextField.text] ) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请输入正确的身份证号";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        
        return;
    }
    if ([_CardTextField.text isEqual:@""]) {
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
    if ([_BankCardNumTextField.text isEqual:@""]) {
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
    if (![NSString checkCardNo:_BankCardNumTextField.text]) {
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
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@set/shortcutauthen.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                           @"bankname":_CardTextField.text,
                           @"banknum":_BankCardNumTextField.text,
                           @"name":_NameTextField.text,
                           @"idnum":_IDCardNumTextField.text
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
            
            BindResultViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"BindResultViewController" ];
            VC.VCID = _VCID;
            [self.navigationController pushViewController:VC animated:YES];
          
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{     
    if (textField == _CardTextField) {
        [_CardTextField resignFirstResponder];
        
        NSMutableArray *arrayData = [NSMutableArray arrayWithObjects:@"中国银行",@"中国光大银行",@"中国农业银行",@"浦发银行", @"中国工商银行",@"兴业银行",@"中国建设银行",@"邮储银行",@"招商银行",@"平安银行",@"中信银行",@"北京银行",@"华夏银行",@"上海银行",@"民生银行",@"杭州银行",@"广发银行",@"宁波银行",@"交通银行",@"广州银行",@"包商银行",@"珠海华润银行",@"东莞银行",@"广东南粤银行",@"江苏银行",@"浙商银行", nil];
        
        STPickerSingle *pickerview = [[STPickerSingle alloc] init];
        [pickerview setArrayData:arrayData];
        [pickerview setTitle:@"请选择银行"];
        [pickerview setContentMode:STPickerContentModeBottom];
        [pickerview setDelegate:self];
        [pickerview show];
    }
}


#pragma mark - STPickerSingleDelegate

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    _CardTextField.text = text;
}


- (void) keyboardFallOffHandle
{
    [_NameTextField resignFirstResponder];
    [_CardTextField resignFirstResponder];
    [_IDCardNumTextField resignFirstResponder];
    [_BankCardNumTextField resignFirstResponder];
 
}

- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
