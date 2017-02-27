//
//  LotteryTwoViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/29.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "LotteryTwoViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "YiLotteryCell.h"
//#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "ReminderView.h"
#import "ConsigneeAddressViewController.h"
#import "ChangeAddressViewController.h"
#import "IntegralExchangeViewController.h"
#import "AwardInfoViewController.h"
#import "LuckView.h"


@interface LotteryTwoViewController ()<ReminderViewDelegate,LuckViewDelegate>
{
    
    long changes;
    long aid;
    NSString *youpiao;
    
}

@property (nonatomic ,strong)LuckView *luckView;

@property (nonatomic,strong)MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIView *TopView;

@property (strong, nonatomic) IBOutlet UIView *MiddleView;
@property (strong, nonatomic) IBOutlet UILabel *IntegralLab;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *ruleLab;

@property (nonatomic, strong) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSMutableArray *TitleArray;
@property (nonatomic, strong) NSMutableArray *ClassArray;

@property (nonatomic, strong)NSArray *NoGetArray;
@property (nonatomic, strong)NSArray *YesGetArray;

@property (nonatomic, strong) ReminderView *remindView1;
@property (nonatomic, strong) ReminderView *remindView2;
@property (nonatomic, strong) ReminderView *remindView3;
@property (nonatomic, strong) UIButton *CancleButton1;
@property (nonatomic, strong) UIButton *CancleButton2;
@property (nonatomic, strong) UIButton *CancleButton3;

@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) UIImageView *Image1;
@property (nonatomic, strong) UIImageView *Image2;

@property (nonatomic, strong) NSString *Lid;


@end

@implementation LotteryTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setupLayer];
    
    [self initLottery];
    [self initRemindView1];
    [self initRemindView2];
    [self initRemindView3];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];

    [self Requestnetwork];

    //加载网页、网络音频、视频、gif动画
    _webView.userInteractionEnabled = NO;
    NSURL *netURL = [NSURL URLWithString:@"http://www.tianxuning.com/work/p/pages/lucker_list.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:netURL]];
    
}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        uid = @"wu";
    }
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/enterlottery.html",QNCURL];
    
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
        _ImageArray = [NSMutableArray array];
        _TitleArray = [NSMutableArray array];
        _ClassArray = [NSMutableArray array];
        if ([[dic objectForKey:@"youpiao"] isKindOfClass:[NSNull class]]) {
            _IntegralLab.text = @"0游票";
        }
        else{
            youpiao = [dic objectForKey:@"youpiao"];
            _IntegralLab.text = [NSString stringWithFormat:@"%@游票",youpiao];

        }
        changes = [[dic objectForKey:@"changes"] longValue];
        NSArray *ListArray = [dic objectForKey:@"award_list"];
        if (![ListArray isKindOfClass:[NSNull class]]) {
            for (NSDictionary *ListDic in ListArray) {
                NSString *ImageStr = [ListDic objectForKey:@"image_url"];
                NSString *TitleStr = [ListDic objectForKey:@"name"];
                NSString *ClassStr = [ListDic objectForKey:@"class"];
                
                [_ImageArray addObject:ImageStr];
                [_TitleArray addObject:TitleStr];
                [_ClassArray addObject:ClassStr];
            }
        }
        _NoGetArray = [dic objectForKey:@"noget"];
        _YesGetArray = [dic objectForKey:@"yesget"];
        NSDictionary *dicName = _YesGetArray[0];
        _remindView3.lab.text = [NSString stringWithFormat:@"亲，您的%@已寄出，请注意接收！！",[dicName objectForKey:@"name"]];
        _luckView.LabArray = _TitleArray;
        _luckView.ImageArray = _ImageArray;


        [self Remind];
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}


//初始化抽奖视图
-(void)initLottery{

    _luckView = [[LuckView alloc] initWithFrame:CGRectMake(4, 4, _TopView.frame.size.width-8, _TopView.frame.size.height-8)];
    _luckView.delegate = self;
    [_TopView addSubview:_luckView];

}

//点击抽奖按钮
- (void)startButton:(UIButton *)button{
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"hasLogin"]) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"登陆后抽奖";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        _luckView.canUse = NO;
        return;
    }
    if (changes <= 0) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"抽奖机会已经用完";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        _luckView.canUse = NO;
        return;
    }
    if ([youpiao intValue] < 100) {
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"积分不足";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        _luckView.canUse = NO;
        return;
    }
    if (_NoGetArray && _NoGetArray.count) {
        
        [self ViewHiddenNO:@"view2"];
        _luckView.canUse = NO;
        
        return;
    }

    [self netAction];
    
}

//抽奖中间获取网络数据
-(void)netAction{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/draw.html",QNCURL];
    
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
        NSString *code = [dic objectForKey:@"code"];
        if ([code  isEqual: @"0033"]) {
            
            _luckView.stopCount = [[dic objectForKey:@"aid"] intValue];
            ZPLog(@"stopCount = %d",_luckView.stopCount);
            aid = [[dic objectForKey:@"aid"] integerValue];
            _Lid = [dic objectForKey:@"lid"];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
}


- (void)luckViewDidStopWithArrayCount:(NSInteger)count {

    _remindView1.NameLabel.text = _TitleArray[aid-1];
    NSString *imageString = _ImageArray[aid-1];
    NSURL *imageURL = [NSURL URLWithString:imageString];
    [_remindView1.titleImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    [self ViewHiddenNO:@"view1"];

}


- (void)initRemindView1{
    
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0.5;
    [self.view addSubview:_BGView];
    
    _remindView1 = [[ReminderView alloc] initWithFrame:CGRectMake(25, 140, SCREEN_WIDTH-50, 230) Type:1];
    _remindView1.backgroundColor = [UIColor whiteColor];
    _remindView1.delegate = self;
    [self.view addSubview:_remindView1];
    
    _Image2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-295)/2, 90, 295, 63)];
    _Image2.image = [UIImage imageNamed:@"YPbg11"];
    [self.view addSubview:_Image2];
    
    _Image1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-49)/2, 40, 49, 53)];
    _Image1.image = [UIImage imageNamed:@"YPbg10"];
    [self.view addSubview:_Image1];
    
    _CancleButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton1.frame = CGRectMake(SCREEN_WIDTH-60, 40, 34, 34);
    [_CancleButton1 setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton1 addTarget:self action:@selector(CancleButton1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton1];
    
    [self ViewHiddenYES:@"view1"];
}


- (void) initRemindView2{
    
    _remindView2 = [[ReminderView alloc] initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 200) Type:2];
    _remindView2.backgroundColor = [UIColor whiteColor];
    _remindView2.delegate = self;
    [self.view addSubview:_remindView2];

    _CancleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton2.frame = CGRectMake(SCREEN_WIDTH-50, 80, 34, 34);
    [_CancleButton2 setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton2 addTarget:self action:@selector(CancleButton2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton2];

    [self ViewHiddenYES:@"view2"];

}

- (void)initRemindView3{
    
        _remindView3 = [[ReminderView alloc] initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 200) Type:3];
    _remindView3.backgroundColor = [UIColor whiteColor];
    _remindView3.delegate = self;
    [self.view addSubview:_remindView3];
    
    _CancleButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton3.frame = CGRectMake(SCREEN_WIDTH-50, 80, 34, 34);
    [_CancleButton3 setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton3 addTarget:self action:@selector(CancleButton3Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton3];
    
    [self ViewHiddenYES:@"view3"];
}



- (void)Remind{
    
    if (_NoGetArray && _NoGetArray.count) {
        
        [self ViewHiddenNO:@"view2"];
    }
    
    if (_YesGetArray && _YesGetArray.count) {
        [self ViewHiddenNO:@"view3"];
    }
}


- (void)ZhongJiang{
    ZPLog(@"~~~");
    NSString *class = _ClassArray[aid-1];
    if ([class isKindOfClass:[NSNull class]]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/go_write_address.html",QNCURL];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:20.0f];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSDictionary *dict = @{@"rid":rid,
                               @"uid":uid,
                               @"style":@"go",
                               @"lid":_Lid
                               };
        [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"addres_info"] isKindOfClass:[NSNull class]]) {
                ChangeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
                VC.lid = _Lid;
                VC.Phone = [dic objectForKey:@"user_phone"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                
                ConsigneeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConsigneeAddressViewController"];
                
                NSArray *addresArray = [dic objectForKey:@"addres_info"];
                VC.dic = addresArray[0];
                VC.lid = _Lid;
                VC.Phone = [dic objectForKey:@"user_phone"];
                [self.navigationController pushViewController:VC animated:YES];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        }];
    }
    else{
        [self ViewHiddenYES:@"view1"];
        [self Requestnetwork];
    }
}



- (void)Back1{
    
    [self ViewHiddenYES:@"view2"];
}


- (void)Back2{
    
    [self ViewHiddenYES:@"view3"];
}


- (void)PushToAddress{

    ZPLog(@"设置收件地址");
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/go_write_address.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *dic = _NoGetArray[0];
    NSString *lid = [dic objectForKey:@"lid"];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"style":@"go",
                           @"lid":lid
                           };
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        if ([[dic objectForKey:@"addres_info"] isKindOfClass:[NSNull class]]) {
            ChangeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
            VC.lid = lid;
            VC.Phone = [dic objectForKey:@"user_phone"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else{
            
            ConsigneeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConsigneeAddressViewController"];
            
            NSArray *addresArray = [dic objectForKey:@"addres_info"];
            VC.dic = addresArray[0];
            VC.lid = lid;
            VC.Phone = [dic objectForKey:@"user_phone"];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];

}


- (void)PushLookInfo{
    
    ZPLog(@"查看奖品详情");
    
    AwardInfoViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AwardInfoViewController"]; 
    NSDictionary *dicLid = _YesGetArray[0];
    VC.lid = [dicLid objectForKey:@"lid"];
    [self.navigationController pushViewController:VC animated:YES];
    
}


- (IBAction)IntegralExchangeButton:(id)sender {
    
    IntegralExchangeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)CancleButton1Clicked{
    
    [self ViewHiddenYES:@"view1"];
    
    [self Requestnetwork];
    
    NSURL *netURL = [NSURL URLWithString:@"http://www.tianxuning.com/work/p/pages/lucker_list.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:netURL]];
}


- (void)CancleButton2Clicked{

    [self ViewHiddenYES:@"view2"];
}


- (void)CancleButton3Clicked{
    
    [self ViewHiddenYES:@"view3"];
}


- (void)ViewHiddenYES:(NSString *)view{
    
    if ([view  isEqual: @"view1"]) {
        _BGView.hidden = _remindView1.hidden = _Image1.hidden = _Image2.hidden = _CancleButton1.hidden = YES;
    }
    if ([view  isEqual: @"view2"]) {
        _BGView.hidden = _remindView2.hidden = _CancleButton2.hidden = YES;
    }
    if ([view isEqual:@"view3"]) {
        _BGView.hidden = _remindView3.hidden = _CancleButton3.hidden = YES;
    }
}


- (void)ViewHiddenNO:(NSString *)view{
    
    if ([view  isEqual: @"view1"]) {
        _BGView.hidden = _remindView1.hidden = _Image1.hidden = _Image2.hidden = _CancleButton1.hidden = NO;
    }
    if ([view  isEqual: @"view2"]) {
        _BGView.hidden = _remindView2.hidden = _CancleButton2.hidden = NO;
    }
    if ([view  isEqual: @"view3"]) {
        _BGView.hidden = _remindView3.hidden = _CancleButton3.hidden = NO;
    }
}


- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissDelayed{
    [SVProgressHUD dismiss];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色

    [self ViewHiddenYES:@"view1"];
    [self ViewHiddenYES:@"view2"];
    [self ViewHiddenYES:@"view3"];
    
    
}


@end
