//
//  MyAccountViewController.m
//  QuNaChou
//
//  Created by WYD on 16/4/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//`

#import "MyAccountViewController.h"
//#import "PrefixHeader.pch"
#import "UIButton+PropertySetting.h"
#import "UIView+Custom.h"
#import "MyAccountTableViewCell.h"
#import "ReachStatus.h"
#import "SVProgressHUD.h"
#import "UserLoginViewController.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "TQCurrentViewController.h"
#import "GYZChooseCityController.h"
#import "GYZCity.h"
#import "UsableBalanceViewController.h"
#import "MACurrentViewController.h"
#import "MARegularViewController.h"
#import "PreciousViewController.h"
#import "RecommendFriendViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "CashViewController.h"
#import "BindBankCardViewController.h"
#import "IntegralDetailsViewController.h"
#import "ReminderLoginView.h"
#import "SetingViewController.h"



#define YELLOW_COLOR [UIColor colorWithRed:255.0/255.0f green:201.0/255.0f blue:17.0/255.0f alpha:1.0]

@interface MyAccountViewController ()<GYZChooseCityDelegate,ReminderLoginViewDelegate>

@property(nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong) UIView *BGView;
@property (strong, nonatomic) IBOutlet UIButton *LocationButton;

@property (strong, nonatomic) IBOutlet UIScrollView *OutScrollView;

@property (strong, nonatomic) IBOutlet UILabel *TomorrowEarnings;   //昨日收益
@property (weak, nonatomic) IBOutlet UILabel *Earningslab;

@property (strong, nonatomic) IBOutlet UIView *SecondView;

@property (strong, nonatomic) IBOutlet UIView *ThirdView;
@property (strong, nonatomic) IBOutlet UIView *BelowView;

@property (strong, nonatomic) IBOutlet UILabel *aAvailableBalance;  //可用余额
@property (strong, nonatomic) IBOutlet UILabel *Current;  //活期宝
@property (strong, nonatomic) IBOutlet UILabel *Regular;  //定期宝
@property (strong, nonatomic) IBOutlet UILabel *TotalAssets;  //总资产
@property (weak, nonatomic) IBOutlet UILabel *IntegralLab;   //积分

@property (strong, nonatomic) IBOutlet UILabel *Recommend;  //推荐好友
@property (strong, nonatomic) IBOutlet UILabel *Trusteeship;
@property (strong, nonatomic) IBOutlet UILabel *Set;

@property (strong, nonatomic) IBOutlet UILabel *Ticket;
@property (strong, nonatomic) IBOutlet UILabel *Plan;
@property (strong, nonatomic) IBOutlet UIButton *CashButton;

@property (strong, nonatomic) IBOutlet UIView *LoginView;

@property (strong, nonatomic) IBOutlet UIButton *RegistButton;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;

@property(nonatomic, strong)NSMutableArray *arrayData;


@property (nonatomic, strong) ReminderLoginView *RemindBound;
@property (nonatomic, strong) UIButton *BoundCancleButton;
@property(nonatomic, strong)UIView *RemindBGView;


@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewLayers];
    
    //提示界面
    [self initRemindBound];

}



- (void)viewWillAppear:(BOOL)animated{
    
    _RemindBGView.hidden = YES;
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefault objectForKey:@"city"];
    if (city) {
        [_LocationButton setTitle:city forState:UIControlStateNormal];
    }
    
    if (_BGView) {
        [_BGView removeFromSuperview];
    }
    
    if ([ReachStatus reach] == NotReachable) {
        _BGView = [UIView backgroundViewRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIButton *_bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_bgBtn addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_BGView addSubview:_bgBtn];
        [self.view addSubview:_BGView];
    } else {
        // 判断用户登录状况
        [self judgeUserLoginStatus];

        [self updateRequestAndUI];
    }

}


// 判断用户登录状况
- (void)judgeUserLoginStatus{
    // 如果用户没有登录, 跳转到登录页面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        
        _LoginView.hidden = NO;
        // 请求用户账号信息
    } else
    {
        // 请求用户信息
        _LoginView.hidden = YES;
        [self getUserAccountInfoRequest];
//        [self queryPersonalInfo];
        //判断未读消息
//        [self weiduxiaoxi];
    }
    
}



- (void)getUserAccountInfoRequest{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@account/look.html",QNCURL];
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSString *mtshouyi = [dic objectForKey:@"mingtianshouyi"];
        if (mtshouyi) {
            _TomorrowEarnings.text = [dic objectForKey:@"mingtianshouyi"];
            _Earningslab.text = @"预计明天收益";
        }
        else{
            _TomorrowEarnings.text = [dic objectForKey:@"zuotianshouyi"];
            _Earningslab.text = @"昨天收益";
        }     
        _IntegralLab.text = [dic objectForKey:@"youpiao"];
        _aAvailableBalance.text =[dic objectForKey:@"keyongyue"];
        _Current.text =[dic objectForKey:@"huoqibao"];
        _Regular.text =[dic objectForKey:@"dingqibao"];
        _TotalAssets.text = [dic objectForKey:@"zongzichang"];
        _Recommend.text = [dic objectForKey:@"tuijianhaoyou"];
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        nil;

        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];

    }];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [_hud hide:NO afterDelay:0.0f];
}


- (IBAction)Regist:(id)sender {
  
    RegisterViewController *registVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registVC] animated:YES completion:nil];
    
}


- (IBAction)Login:(id)sender {

    UserLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
}

- (void)updateRequestAndUI{
    
    if (_BGView) {
        [_BGView removeFromSuperview];
    }
    
    // 请求网络
       
}


- (void)backgroundButtonPressed:(UIButton *)button{
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    // 网络恢复正常
    if ([ReachStatus reach] != NotReachable) {
        // 移除异常提示
        if (_BGView) {
            [_BGView removeFromSuperview];
        }
        // 更新UI界面
        [self updateRequestAndUI];
    }
}


- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}



- (IBAction)LocationButtonClicked:(id)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    //    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}




- (IBAction)ButtonClicked:(UIButton *)button{
    
    if (button.tag == 2000) {
        ZPLog(@"可用余额");
        UsableBalanceViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsableBalanceViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (button.tag == 2001) {
        ZPLog(@"活期宝～～");
        MACurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MACurrentViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }   
    if (button.tag == 2002) {
        ZPLog(@"定期宝～～");
        MARegularViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MARegularViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (button.tag == 2003) {
        ZPLog(@"总资产～～");
    }
    if (button.tag == 2004) {
        ZPLog(@"银宝箱～～");
        PreciousViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreciousViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (button.tag == 2005) {
        ZPLog(@"推荐好友～～");
        RecommendFriendViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommendFriendViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (button.tag == 2006) {
        ZPLog(@"交易记录～～");
    }
    if (button.tag == 2007) {
        ZPLog(@"托管/信用卡～");
    }
    if (button.tag == 2008) {
        ZPLog(@"设置～～");
        SetingViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetingViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];

    }
    if (button.tag == 2009) {
        ZPLog(@"旅游券～～");
    }
    if (button.tag == 2010) {
        ZPLog(@"旅游计划～～");
    }
    if (button.tag == 2011) {
        ZPLog(@"游票～～");
        IntegralDetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntegralDetailsViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}


- (IBAction)CashButton:(id)sender {
    
    ZPLog(@"提现");
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCard"]) {
//        
//        _RemindBGView.hidden = _RemindBound.hidden = _BoundCancleButton.hidden = NO;
//    }
//    else{
    
        CashViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CashViewController"];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
//    }
}


- (void)initRemindBound{
    
    _RemindBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _RemindBGView.backgroundColor = [UIColor blackColor];
    _RemindBGView.alpha = 0.5;
    [self.view addSubview:_RemindBGView];
    
    _RemindBound = [[ReminderLoginView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-200)/2-64, SCREEN_WIDTH-20, 200) Style:@"Bound"];
    _RemindBound.delegate = self;
    [self.view addSubview:_RemindBound];
    
    _BoundCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _BoundCancleButton.frame = CGRectMake(SCREEN_WIDTH-60, _RemindBound.frame.origin.y-50, 34, 34);
    [_BoundCancleButton setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_BoundCancleButton addTarget:self action:@selector(BoundCancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_BoundCancleButton];
    
    _RemindBGView.hidden = YES;
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
}

- (void)BoundCancleButtonClicked{
    
    _RemindBGView.hidden = YES;
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
}


- (void)Bound{
    
    ZPLog(@"bangka");
    BindBankCardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
    VC.VCID = @"MyAccountViewController";
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
    
}


//定位后返回位置
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    //保存位置信息
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:city.cityName forKey:@"city"];
    [userDefault synchronize];
    
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)setupViewLayers{
    
    _ThirdView.backgroundColor = YELLOW_COLOR;
    _SecondView.layer.cornerRadius = 10;
    _ThirdView.layer.cornerRadius = 10;
    _BelowView.layer.cornerRadius = 10;
    _CashButton.layer.cornerRadius = 10;
    _LoginButton.layer.cornerRadius = 10;
    _RegistButton.layer.cornerRadius = 10;
    
    
}

@end
