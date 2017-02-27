//
//  ChangeAddressViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/30.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "STPickerArea.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
//#import "PrefixHeader.pch"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "SystemInfo.h"


@interface ChangeAddressViewController ()<UITextFieldDelegate,UITextViewDelegate,STPickerAreaDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *PhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *CodeTF;

@property (strong, nonatomic) IBOutlet UIButton *CodeButton;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;


@property (nonatomic ,assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ChangeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色

    _count = 120;
    _PhoneNumber.text = _Phone;
    
    if (_dic) {
        _NameTF.text = [_dic objectForKey:@"name"];
        _PhoneTF.text = [_dic objectForKey:@"phone"];
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", [_dic objectForKey:@"province"], [_dic objectForKey:@"city"], [_dic objectForKey:@"county"]];
        _province = [_dic objectForKey:@"province"];
        _city = [_dic objectForKey:@"city"];
        _area = [_dic objectForKey:@"county"];
        
        [_PlaceButton setTitle:text forState:UIControlStateNormal];
        _AddressTV.text = [_dic objectForKey:@"addres"];

        ZPLog(@"%@",[_dic objectForKey:@"addres"]);
}
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [_scrollView addGestureRecognizer:recognizer];
}



- (void)touchScrollView{
    
    [self keyboardFallOffHandle];
    
}


- (IBAction)ChoosePlacce:(id)sender {
    
    STPickerArea *pickerArea = [[STPickerArea alloc]init];
    [pickerArea setDelegate:self];
    [pickerArea setContentMode:STPickerContentModeBottom];
    [pickerArea show];

}



- (IBAction)GetCode:(id)sender {
    
    ZPLog(@"获取验证码");
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/getverify.html",QNCURL];
    
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
            [_CodeButton setTitle:title forState:UIControlStateNormal];
        } else {
            _CodeButton.titleLabel.text = title;
        }
        _CodeButton.enabled = NO;
        _count--;
        // 120s倒计时完成
    } else {
        _count = 120;
        [_CodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _CodeButton.enabled = YES;
        [_timer invalidate];
    }
}


- (IBAction)ConfirmButtonClicked:(id)sender {
    
    if (_CodeTF.text == nil) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请填写验证码";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    if (_NameTF.text == nil || _PhoneTF.text == nil || _AddressTV.text == nil || _province == nil || _city == nil) {
        
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"请填写正确的收件信息";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *url = [NSString string];
        if (_lid) {
            url = @"exchange/store_address.html";
        }
        else{
            url = @"set/store_address.html";
        }
        NSString *baseUrl = [NSString stringWithFormat:@"%@%@",QNCURL,url];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:20.0f];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSDictionary *dict = [NSDictionary dictionary];
        if (_lid) {
           dict = @{@"rid":rid,
                  @"uid":uid,
                  @"phone":_PhoneTF.text,
                  @"name":_NameTF.text,
                  @"lid":_lid,
                  @"province":_province,
                  @"city":_city,
                  @"county":_area,
                  @"addres":_AddressTV.text,
                  @"verify":_CodeTF.text
                  };
        }
        else{
            dict = @{@"rid":rid,
                     @"uid":uid,
                     @"phone":_PhoneTF.text,
                     @"name":_NameTF.text,
                     @"province":_province,
                     @"city":_city,
                     @"county":_area,
                     @"addres":_AddressTV.text,
                     @"verify":_CodeTF.text
                     };
            
        }
    
        [SVProgressHUD showWithStatus:@"数据提交中" maskType:SVProgressHUDMaskTypeBlack];
        [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            ZPLog(@"%@",dic);
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"0049"]) {
                [_hud hide:YES];
                [UIView animateWithDuration:0.5f animations:^{
                    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    _hud.labelText = @"验证码错误";
                    _hud.mode = MBProgressHUDModeText;
                } completion:^(BOOL finished) {
                    [_hud hide:YES afterDelay:0.8f];
                }];
                return ;
            }
            if ([[dic objectForKey:@"code"] isEqualToString:@"0047"]) {
                [_hud hide:YES];
                [UIView animateWithDuration:0.5f animations:^{
                    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    _hud.labelText = @"未获取验证码";
                    _hud.mode = MBProgressHUDModeText;
                } completion:^(BOOL finished) {
                    [_hud hide:YES afterDelay:0.8f];
                }];
                
            }
            if ([[dic objectForKey:@"code"] isEqualToString:@"0045"] || [[dic objectForKey:@"code"] isEqualToString:@"0056"]) {
                
                [_hud hide:YES];
                [UIView animateWithDuration:0.5f animations:^{
                    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    _hud.labelText = @"数据提交成功";
                    _hud.mode = MBProgressHUDModeText;
                } completion:^(BOOL finished) {
                    [_hud hide:YES afterDelay:0.8f];
                }];
                [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
            }
            
           [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * error) {
            [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        }];
   
}


- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    [_PlaceButton setTitle:text forState:UIControlStateNormal];
    _province = province;
    _city = city;
    _area = area;
}



- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)keyboardFallOffHandle{
    [_NameTF resignFirstResponder];
    [_PhoneTF resignFirstResponder];
    [_AddressTV resignFirstResponder];
    [_CodeTF resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_timer invalidate];
    _timer = nil;
}



- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
