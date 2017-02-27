//
//  ConsigneeAddressViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/30.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ConsigneeAddressViewController.h"
#import "ChangeAddressViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
//#import "PrefixHeader.pch"

@interface ConsigneeAddressViewController ()


@property (strong, nonatomic) IBOutlet UILabel *NameLab;
@property (strong, nonatomic) IBOutlet UILabel *PhoneLab;
@property (strong, nonatomic) IBOutlet UILabel *RegionLab;
@property (strong, nonatomic) IBOutlet UILabel *AddressLab;

@property (strong, nonatomic) IBOutlet UIButton *ConfirmButton;
//@property (strong, nonatomic) IBOutlet UIButton *ChangeButton;



@end

@implementation ConsigneeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色
    
    _NameLab.text = [_dic objectForKey:@"name"];
    _PhoneLab.text = [_dic objectForKey:@"phone"];
    _RegionLab.text = [NSString stringWithFormat:@"%@ %@ %@", [_dic objectForKey:@"province"], [_dic objectForKey:@"city"], [_dic objectForKey:@"county"]];
    _AddressLab.text = [_dic objectForKey:@"addres"];
    
    if (!_lid) {
        _ConfirmButton.hidden = YES;
    }
}


- (IBAction)ConfirmButtonClicked:(id)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];

    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/go_write_address.html",QNCURL];
    
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
                   @"style":[_dic objectForKey:@"addres_id"],
                   @"lid":_lid
                   };
        
    }
    else{
        dict = @{@"rid":rid,
                   @"uid":uid,
                   @"style":[_dic objectForKey:@"addres_id"]
                   };
    }
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        if ([[dic objectForKey:@"code"] isEqualToString:@"0045"] ) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];

    
}


- (IBAction)ChangeButtonClicked:(id)sender {
    
    ChangeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
    VC.dic = _dic;
    VC.Phone = _Phone;
    VC.lid = _lid;
    [self.navigationController pushViewController:VC animated:YES];

}

- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
