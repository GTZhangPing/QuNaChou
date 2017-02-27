//
//  RecommendFriendViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/2.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RecommendFriendViewController.h"
#import "RecommendRewardViewController.h"
//#import "PrefixHeader.pch"
#import "UIView+Custom.h"
#import "PrivilegeTicketViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"


@interface RecommendFriendViewController ()

@property (strong, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *LVLab;

@property (strong, nonatomic) IBOutlet UIView *MiddleView;

@property (strong, nonatomic) IBOutlet UILabel *ReceiveLab;
@property (strong, nonatomic) IBOutlet UILabel *unReceivedLab;
@property (strong, nonatomic) IBOutlet UILabel *TicketLab;

@property (strong, nonatomic) IBOutlet UIButton *RegularButton;
@property (strong, nonatomic) IBOutlet UIButton *RecommendButton;


@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation RecommendFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewLayers];
    
    [self Requestnetwork];

}


- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    
}

- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@friend/index.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",_dic);
        _NameLab.text = [_dic objectForKey:@"username"];
        _progressView.progress = [[_dic objectForKey:@"grade"] doubleValue];
        _LVLab.text = [NSString stringWithFormat:@" LV%@ ",[_dic objectForKey:@"role"]];
        _ReceiveLab.text = [NSString stringWithFormat:@"¥ %.2f",[[_dic objectForKey:@"yishoujiangli"] doubleValue]];
        _unReceivedLab.text = [NSString stringWithFormat:@"¥ %.2f",[[_dic objectForKey:@"daishoujiangli"] doubleValue]];
        _TicketLab.text = [NSString stringWithFormat:@"%@ 张",[_dic objectForKey:@"tequanquan"]];
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}

//已收奖励
- (IBAction)ReceiveButton:(id)sender {
    
    RecommendRewardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommendRewardViewController"];
    VC.dic = _dic;
    VC.urlStr = @"yishou";
    [VC setTitle:@"已收收益"];
    [self.navigationController pushViewController:VC animated:YES];
    
}


//代收奖励
- (IBAction)unReceiveButton:(id)sender {
    
    RecommendRewardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommendRewardViewController"];
    VC.dic = _dic;
    VC.urlStr = @"daishou";
    [VC setTitle:@"待收收益"];
    [self.navigationController pushViewController:VC animated:YES];
}


//特权券
- (IBAction)TicketButton:(id)sender {
 
    PrivilegeTicketViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivilegeTicketViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}


//查看规则
- (IBAction)RegularButton:(id)sender {
  
//    TextViewController *VC = [[TextViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
}


//推荐好友
- (IBAction)RecommenButton:(id)sender {
    
    
    
}


- (IBAction)Share:(id)sender {
    
    ZPLog(@"分享");
}

- (IBAction)money:(id)sender {
    
    ZPLog(@"money");
}


- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViewLayers
{
    [UIView customView:_MiddleView layerColor:[UIColor clearColor] cornerRadious:10];
    [UIView customView:_RegularButton layerColor:[UIColor clearColor] cornerRadious:10];
    [UIView customView:_RecommendButton layerColor:[UIColor clearColor] cornerRadious:10];
    [UIView customView:_progressView layerColor:[UIColor clearColor] cornerRadious:5];
    [UIView customView:_LVLab layerColor:[UIColor clearColor] cornerRadious:5];
    _progressView.layer.masksToBounds = _LVLab.layer.masksToBounds = true;

}

- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
