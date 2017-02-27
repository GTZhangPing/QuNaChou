//
//  LianLianPayViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/1.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "LianLianPayViewController.h"
#import "PayResultViewController.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

@interface LianLianPayViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UILabel *TypeLab;
@property (strong, nonatomic) IBOutlet UILabel *MoneyLab;
@property (strong, nonatomic) IBOutlet UITextField *CodeTextField;

@property (strong, nonatomic) IBOutlet UILabel *PhoneNumber;


@end

@implementation LianLianPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];
    //设置导航栏字体颜色 字号
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    NSURL *netURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@invest/index/rid/%@/uid/%@/type/%@/money/%@/kyye/%@/hqb/%@/card/%@.html",QNCURL,rid,uid,_type,_money,_kyye,_hqb,_card]];
    [webView loadRequest:[NSURLRequest requestWithURL:netURL]];
    ZPLog(@"%@",netURL);
    [self.view addSubview:webView];
    
    
    if (![_card doubleValue] > 0) {
        webView.hidden = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated{

    _MoneyLab.text = [NSString stringWithFormat:@"¥%@",_money];
    ZPLog(@"%@",_type);
    if ([_type isEqualToString:@"14"]) {
        _TypeLab.text = @"活期宝";
    }
    if ([_type isEqualToString:@"2"]) {
        _TypeLab.text = @"特权活期宝";

    }
    if ([_type isEqualToString:@"3"] ||[_type isEqualToString:@"4"]||[_type isEqualToString:@"5"]||[_type isEqualToString:@"6"]||[_type isEqualToString:@"7"]) {
        _TypeLab.text = @"定期宝";
    }
    if ([_type isEqualToString:@"8"]||[_type isEqualToString:@"9"]||[_type isEqualToString:@"10"]||[_type isEqualToString:@"11"]||[_type isEqualToString:@"12"]) {
        _TypeLab.text = @"免单游";
    }
}

- (IBAction)ConfirmButtonClicked:(id)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = @"http://waptest.licaidabai.com/Home/Api/userinvest.html";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
        NSDictionary *postthing = @{@"rid":rid,
                               @"uid":uid,
                               @"type":_type,
                               @"money":_money,
                               @"kyye":_kyye,
                               @"hqb":_hqb,
                               @"card":_card
                               };
//    ZPLog(@"%@",postthing);
    
    [SVProgressHUD showSuccessWithStatus:@"支付中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:postthing success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        ZPLog(@"%@",dic);
        NSString *code =[dic objectForKey:@"code"];
//        NSInteger type = [[dic objectForKey:@"type"]integerValue];
//        NSString *tqcs =[dic objectForKey:@"tqcs"];
        
        if ([code isEqualToString:@"0011"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"投资失败";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
        }
//
        if ([code isEqual:@"0010"]) {
            
            if ([_type isEqualToString:@"2"]) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:0 forKey:@"tqcs"];
                [userDefault synchronize];
                }
            
            PayResultViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayResultViewController"];
            VC.Dic = dic;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}


- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
