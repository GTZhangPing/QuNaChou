//
//
//  QuNaChou
//
//  Created by 张平 on 16/8/9.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "SetingViewController.h"
#import "ChangeAddressViewController.h"
#import "SetPasswordViewController.h"
#import "BoundPhoneViewController.h"
#import "RealNameViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
//#import "PrefixHeader.pch"
#import "BoundCardViewController.h"
#import "BindBankCardViewController.h"
#import "ConsigneeAddressViewController.h"
#import "ChangeAddressViewController.h"

@interface SetingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *VerifyName;
@property (strong, nonatomic) IBOutlet UILabel *BoundCard;
@property (strong, nonatomic) IBOutlet UILabel *QRCode;
@property (strong, nonatomic) IBOutlet UILabel *VerifyPhone;
@property (strong, nonatomic) IBOutlet UILabel *SetPassword;
@property (strong, nonatomic) IBOutlet UILabel *Address;
@property (strong, nonatomic) IBOutlet UILabel *Message;




@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self ReQuestNetWorking];
}


- (void)ReQuestNetWorking{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@set/goset.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        if ([[dic objectForKey:@"authenname"]intValue] == 0) {
            _VerifyName.text = @"未认证";
        }
        else{
            _VerifyName.text = @"已认证";
        }
        if ([[dic objectForKey:@"bindcard "] intValue] == 0) {
            _BoundCard.text = @"未绑定";
        }
        else{
            _BoundCard.text = @"已绑定";
        }
        if ([[dic objectForKey:@"qrcode"]intValue] == 0) {
            _QRCode.text = @"未开通";
        }
        else{
            _QRCode.text = @"已开通";
        }
        if ([[dic objectForKey:@"bindphone"] intValue] == 0) {
            _VerifyPhone.text = @"未绑定";
        }
        else{
            _VerifyPhone.text = @"已绑定";
        }
        if ([[dic objectForKey:@"password"] intValue] == 0) {
            _SetPassword.text = @"未设置";
        }
        else{
            _SetPassword.text = @"已设置";
        }
        if ([[dic objectForKey:@"address"]intValue] == 0) {
            _Address.text = @"未设置";
        }
        else{
            _Address.text = @"已设置";
        }
        if ([[dic objectForKey:@"message"] intValue] == 0) {
            _Message.text = @"";
        }
        else{
            _Message.text = [dic objectForKey:@"message"];
        }
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];

}


- (IBAction)ButtonClicked:(UIButton *)sender {
    
    if (sender.tag == 2051) {
        ZPLog(@"实名认证");
        RealNameViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RealNameViewController"];
        [self.navigationController pushViewController:VC  animated:YES];
    }
    if (sender.tag == 2052) {
        ZPLog(@"银行卡绑定");
        
        NSString *baseUrl = [NSString stringWithFormat:@"%@set/goauthenbank.html",QNCURL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:20.0f];
        manager.securityPolicy.allowInvalidCertificates = YES;
        NSDictionary *dict = @{@"rid":rid,
                               @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]
                               };
        [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
        [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            ZPLog(@"%@",dic);
            if ([[dic objectForKey:@"name"]isKindOfClass:[NSNull class]] && [[dic objectForKey:@"bankname"]isKindOfClass:[NSNull class]] && [[dic objectForKey:@"banknum"]isKindOfClass:[NSNull class]]) {
                
                BindBankCardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                
                BoundCardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BoundCardViewController"];
                VC.InfoDic = dic;
            [self.navigationController pushViewController:VC animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        }];

        
        
    }
    if (sender.tag == 2053) {
        ZPLog(@"专属二维码");
    }
    if (sender.tag == 2054) {
        ZPLog(@"手机绑定");
        BoundPhoneViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BoundPhoneViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (sender.tag == 2055) {
        ZPLog(@"设置密码");
        SetPasswordViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetPasswordViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (sender.tag == 2056) {
        ZPLog(@"收件地址");
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *baseUrl = [NSString stringWithFormat:@"%@set/go_address.html",QNCURL];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:20.0f];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSDictionary *dict = @{@"rid":rid,
                               @"uid":uid
                               };
        [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            ZPLog(@"%@",dic);
            if ([[dic objectForKey:@"addres_info"] isKindOfClass:[NSNull class]]) {
                ChangeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
                VC.Phone = [dic objectForKey:@"user_phone"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                
                ConsigneeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConsigneeAddressViewController"];
                
                NSArray *addresArray = [dic objectForKey:@"addres_info"];
                VC.dic = addresArray[0];
                VC.Phone = [dic objectForKey:@"user_phone"];
                [self.navigationController pushViewController:VC animated:YES];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        }];
        
    }
    if (sender.tag == 2057) {
        ZPLog(@"我的消息");
    }
    if (sender.tag == 2058) {
        ZPLog(@"退出登录");
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLogin"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}


@end
