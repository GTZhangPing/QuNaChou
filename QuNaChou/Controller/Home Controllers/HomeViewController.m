 //
//  HomeViewController.m
//  QuNaChou
//
//  Created by WYD on 16/4/14.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "HomeViewController.h"
#import "RootViewController.h"
//#import "PrefixHeader.pch"
#import "SDCycleScrollView.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIButton+PropertySetting.h"
#import "UIView+Custom.h"
//#import "UINavigationBar+Awesome.h"
#import "ProgressView.h"
#import "ReachStatus.h"
#import "SVProgressHUD.h"
#import "UserLoginViewController.h"
#import "GYZChooseCityController.h"
#import "TQCurrentViewController.h"
#import "CurrentViewController.h"
#import "FreeTourViewController.h"
#import "StagesTourViewController.h"
#import "FlashSaleViewController.h"
#import "ExchangeViewController.h"

@interface HomeViewController ()< UIScrollViewDelegate, GYZChooseCityDelegate>

{
    int  _i;
}

@property(nonatomic, strong) NSUserDefaults *userDefault;
@property (nonatomic, strong) UIView *BGView;
@property (strong, nonatomic) IBOutlet UIView *BigView;
@property (strong, nonatomic) IBOutlet UIScrollView *BigScrollerView;  //外层大ScrollView
@property (strong, nonatomic) IBOutlet UIView *TopView;  //用来承载顶部scrollview
//@property (strong, nonatomic) IBOutlet UIView *MidView;
@property (strong, nonatomic) IBOutlet UIButton *FreeButton;   //免费游
@property (strong, nonatomic) IBOutlet UIButton *StagesButton;  //分期游
@property (strong, nonatomic) IBOutlet UIButton *IntegrateButton;   //兑积分
@property (strong, nonatomic) IBOutlet UIButton *LastMinuteButton;   //限时惠
@property (strong, nonatomic) IBOutlet UIView *BelowView;
@property (strong, nonatomic) IBOutlet UIButton *LocationButton;
@property (strong, nonatomic) IBOutlet UILabel *Label1;
@property (strong, nonatomic) IBOutlet UILabel *Label2;
@property (strong, nonatomic) IBOutlet UILabel *LiLuLab;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;


@property(nonatomic ,strong) ProgressView *progressview;
@property(nonatomic, strong)SDCycleScrollView *TopScrollView;
@property(nonatomic, strong)UIScrollView *scrollerView;
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, strong)NSTimer *timer;

@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    self.navigationController.navigationBar.translucent = NO;


//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    self.automaticallyAdjustsScrollViewInsets = NO;  //设置ScrollView在导航栏下面
    
    //设置控件 边框颜色,宽度
    [self setupViewLayers];
    
    if (SCREEN_HEIGHT > 480) {
        _BigScrollerView.scrollEnabled = NO;
    }
    
    _i = 2;
}


//加载中间的圆
- (void)setcycleview{

    _progressview = [[ProgressView alloc]initWithFrame:CGRectMake(190, 40, 70, 70)];
    _progressview.arcFinishColor = TEXT_COLOR_RED;
    _progressview.arcUnfinishColor = TEXT_COLOR_RED;
    _progressview.arcBackColor = PINK_COLOR;
    _progressview.percent = 0.2;
    _progressview.width = 5;    //圆环宽度
//    _progressview.number = 15.12;  //收益率
    [_BelowView addSubview:_progressview];
//    sendSubViewToBack
    [_BelowView sendSubviewToBack:_progressview];
}



//视图将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //导航栏颜色 字体及大小
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];

    //定位                              
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefault objectForKey:@"city"];
    if (city) {
        [_LocationButton setTitle:city forState:UIControlStateNormal];
    }
    
    //判断是否为第一次登录
    _userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isFirstLaunch = [_userDefault objectForKey:@"isFirstLaunch"];
    if (!isFirstLaunch) {
        RootViewController *rootVC = [[RootViewController alloc]init];
        [self.navigationController presentViewController:rootVC animated:NO completion:nil];
    };

    self.BigScrollerView.delegate = self;
    [self scrollViewDidScroll:self.BigScrollerView];
    
    if (_BGView) {
        [_BGView removeFromSuperview];
    }                   
    
    if ([ReachStatus reach] == NotReachable) {//如果没有网络 提示网络异常
        _BGView = [UIView backgroundViewRect2:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIButton *_bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgBtn.userInteractionEnabled = YES;
        [_bgBtn addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_BGView addSubview:_bgBtn];              
        [self.view addSubview:_BGView];
    }
    else {
        [self updateRequestAndUI];
    } 
}


- (void)updateRequestAndUI{
    
    if (_BGView) {
        [_BGView removeFromSuperview];
    }
    
    
    //请求数据
    [self Requestnetwork];
    
    //加载中间的圆
    [self setcycleview];
    
    // 加载首页轮播图片
    [self insertCycleImages];
 
}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (!uid) {
        uid = @"wu";
    }
    NSString *baseUrl = [NSString stringWithFormat:@"%@index/interest.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
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
//        ZPLog(@"%@",dic);
        float add = [[dic objectForKey:@"add_interest"] floatValue];
        NSDictionary *interest = [dic objectForKey:@"common_interest"];
        float type2 = [[interest objectForKey:@"2"] floatValue];
        float type14 = [[interest objectForKey:@"14"] floatValue];

        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
            _TitleLab.text = @"特权活期宝";
            _LiLuLab.text = [NSString stringWithFormat:@"%.1f%@",type2,@"%"];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
            NSInteger tqcs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tqcs"] integerValue];
            if (tqcs == 0) {
                _TitleLab.text = @"活期宝";
                _LiLuLab.text = [NSString stringWithFormat:@"%.1f%@",add+type14,@"%"];
            }
            else{
                _TitleLab.text = @"特权活期宝";
                _LiLuLab.text = [NSString stringWithFormat:@"%.1f%@",add+type2,@"%"];
            }
        }
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
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

//视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止定时器
    [_timer invalidate];
    _timer = nil;
//    [self.navigationController.navigationBar setHidden:YES];
//    self.BigScrollerView.delegate = nil;
//    [self.navigationController.navigationBar lt_reset];
}


// 加载首页轮播图片
- (void)insertCycleImages
{
    [_scrollerView removeFromSuperview];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -30,  _TopView.bounds.size.height)];
    _scrollerView.delegate = self;
    _scrollerView.showsHorizontalScrollIndicator = FALSE;
    self.view.clipsToBounds = YES;
    _scrollerView.clipsToBounds = NO;
    [_TopView addSubview:_scrollerView];
    
    _imageArray = @[@"banner3",@"banner1",@"banner2",@"banner3",@"banner1"];
    for (NSInteger i = 0; i <_imageArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -30) *i, 0, SCREEN_WIDTH-30, _TopView.bounds.size.height)];
        view.backgroundColor = TB_COLOR_GRAY;
        [_scrollerView addSubview:view];
                
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, SCREEN_WIDTH -38, _TopView.bounds.size.height)];
        imageView.layer.cornerRadius = 5;
        [imageView.layer setMasksToBounds:YES];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:_imageArray[i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = imageView.frame;
        button.tag = 2016+i;
        [button addTarget:self action:@selector(buttonClivked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
        [view addSubview:imageView];
    }
    _scrollerView.contentSize = CGSizeMake((SCREEN_WIDTH -30) *_imageArray.count, _TopView.bounds.size.height);
    _scrollerView.pagingEnabled = YES;
    _scrollerView.contentOffset = CGPointMake((SCREEN_WIDTH -30), 0);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showPictureView) userInfo:nil repeats:YES];

}


//滚动试图点击事件
- (void)buttonClivked:(UIButton *)button
{
    ZPLog(@"%ld",(long)button.tag);
}


//免单游
- (IBAction)FreeButtonClicked:(id)sender {
    
    FreeTourViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreeTourViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}


//分期游
- (IBAction)StagesButtonClicked:(id)sender {
    
    StagesTourViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"StagesTourViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}


//限时惠
- (IBAction)LastMinuteButtonClicked:(id)sender {
    
    FlashSaleViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashSaleViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}


//积分游
- (IBAction)IntegrateButtonClicked:(id)sender {
  
    ExchangeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExchangeViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
    
}


//活期宝
- (IBAction)CurrentButtonClicked:(id)sender {
    
    if ([_TitleLab.text  isEqual: @"活期宝"]) {
        CurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentViewController"];
        [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
        [self.navigationController pushViewController:VC  animated:YES];
    }
    else{
        TQCurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TQCurrentViewController"];
        [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
        [self.navigationController pushViewController:VC  animated:YES];
    }
}


//定位
- (IBAction)LocationButtonClicked:(id)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    //    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
        cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}


//登录
- (IBAction)Login:(id)sender {
    
    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex=2;
}




#pragma mark - UIScrollViewDelegate
//scrollView滚动响应事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        [self.navigationController.navigationBar lt_setBackgroundColor:[TB_COLOR_NARMAL colorWithAlphaComponent:alpha]];
//    } else {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[TB_COLOR_NARMAL colorWithAlphaComponent:0]];
//    }
}

//定时器调用的方法
- (void)showPictureView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollerView.contentOffset = CGPointMake(_i*(SCREEN_WIDTH -30), 0);
    } completion:^(BOOL finished) {
        _i++;
        if (_i == (int)self.imageArray.count) {
            self.scrollerView.contentOffset = CGPointMake((SCREEN_WIDTH -30), 0);
            [self scrollViewDidEndDecelerating:self.scrollerView];
            _i = 1;
        }
    }];
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    滑动结束
    if (scrollView == _scrollerView) {
        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake((SCREEN_WIDTH -30) *(_imageArray.count-2), 0);
        }
        if (scrollView.contentOffset.x == (SCREEN_WIDTH -30) *(_imageArray.count-1)) {
            scrollView.contentOffset = CGPointMake((SCREEN_WIDTH -30)*1 , 0);
        }
    }
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


- (void)setupViewLayers
{    
    _BigView.backgroundColor = TB_COLOR_GRAY;
    [UIView customView:_BelowView layerColor:[UIColor clearColor] cornerRadious:10];

    _Label1.backgroundColor = _Label2.backgroundColor = PINK_COLOR;
    _Label1.layer.cornerRadius =  _Label2.layer.cornerRadius = 5;
    _Label1.layer.masksToBounds = _Label2.layer.masksToBounds = true;

    
}

@end
