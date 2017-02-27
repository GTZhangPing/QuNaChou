//
//  InvestListViewController.m
//  QuNaChou
//
//  Created by WYD on 16/4/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "InvestListViewController.h"
#import "MJRefresh.h"
//#import "PrefixHeader.pch"
#import "InvestListTableViewCell.h"
#import "ReachStatus.h"
#import "UIView+Custom.h"
#import "SVProgressHUD.h"
#import "FreeTourViewController.h"
#import "StagesTourViewController.h"
#import "GYZChooseCityController.h"
#import "TQCurrentViewController.h"
#import "RegularViewController.h"
#import "CurrentViewController.h"
#import "FlashSaleViewController.h"
#import "ExchangeViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface InvestListViewController ()<GYZChooseCityDelegate>

@property (nonatomic, strong) UIView *BGView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) IBOutlet UIView *TopView;

@property (strong, nonatomic) IBOutlet UIButton *LocationButton;
//
//@property(nonatomic ,strong) NSArray *arrayData;
//@property(nonatomic, assign) NSUInteger pageNo;
//@property(nonatomic,assign) NSUInteger index;
@property(nonatomic, strong)NSArray *arrayData;

@end

@implementation InvestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;

//    [UIView customView:_TopView layerColor:[UIColor clearColor] cornerRadious:10];

}




- (IBAction)FreeButtonClicked:(id)sender {
    ZPLog(@"免费游");
    FreeTourViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreeTourViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)StagesButtonClicked:(id)sender {
    ZPLog(@"分期游");
    StagesTourViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"StagesTourViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)LastMinuteButtonClicked:(id)sender {
    ZPLog(@"限时惠");
    FlashSaleViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashSaleViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)IntegrateButtonClicked:(id)sender {
    ZPLog(@"积分游");
    ExchangeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExchangeViewController"];
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];

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
        _bgBtn.userInteractionEnabled = YES;
        [_bgBtn addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_BGView addSubview:_bgBtn];
        [self.view addSubview:_BGView];
    } else {
        [self updateRequestAndUI];
    }
}

- (void)updateRequestAndUI{
    
    if (_BGView) {
        [_BGView removeFromSuperview];
    }
    [self Requestnetwork];

}

- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
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
        ZPLog(@"%@",dic);
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setValue:[dic objectForKey:@"tqcs"] forKey:@"tqcs"];
        [userdefault synchronize];
        float add = [[dic objectForKey:@"add_interest"] floatValue];
        NSDictionary *interest = [dic objectForKey:@"common_interest"];
        float type2 = [[interest objectForKey:@"2"] floatValue];
        float type3 = [[interest objectForKey:@"3"] floatValue];
        float type7 = [[interest objectForKey:@"7"] floatValue];
        float type14 = [[interest objectForKey:@"14"] floatValue];
        NSString *str1 = [NSString stringWithFormat:@"%.1f",type2];
        NSString *str2 = [NSString stringWithFormat:@"%.1f",type14];
        NSString *str3 = [NSString stringWithFormat:@"%.1f%@-%.1f",type3,@"%",type7];
        NSString *str4 = [NSString stringWithFormat:@"%.1f",type14+add];
        NSString *str5 = [NSString stringWithFormat:@"%.1f%@-%.1f",type3+add,@"%",type7+add];
        NSString *str6 = [NSString stringWithFormat:@"%.1f",type2+add];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
            NSArray *array1 = @[@"TQbg_",@"特权活期宝",@"LCicon1",str1,@"投资一万，每天赚钱2.36元"];
            NSArray *array2 = @[@"TQbg_",@"活期宝",@"LCicon1",str2,@"投资一万，每天赚钱2.36元"];
            NSArray *array3 = @[@"TQbg2_",@"定期宝",@"LCicon2",str3,@"投资期限1-12个月"];
            _arrayData =[NSArray arrayWithObjects:array1 ,array2,array3, nil];
        }
        else{
            NSInteger tqcs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tqcs"] integerValue];
            NSArray *array1 = [NSArray array];
            if (tqcs == 0) {
                array1 = @[@"TQbg_",@"活期宝",@"LCicon1",str4,@"投资一万，每天赚钱2.36元"];
            }else{
                array1 = @[@"TQbg_",@"特权活期宝",@"LCicon1",str6,@"投资一万，每天赚钱2.36元"];
            }
            NSArray *array2 = @[@"TQbg2_",@"定期宝",@"LCicon2",str5,@"投资期限1-12个月"];
            _arrayData = @[array1,array2];
        }
        [_tableView reloadData];

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


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"InvestCell";
    InvestListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[InvestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        [cell setCellWithArray:[_arrayData objectAtIndex:indexPath.row]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        if (indexPath.row == 0) {
            TQCurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TQCurrentViewController"];
            [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row == 1) {
            CurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentViewController"];
            [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row == 2) {
            RegularViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularViewController"];
            [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
            [self.navigationController pushViewController:VC animated:YES];
        }

    }
    else{
    
        if (indexPath.row == 0) {
            NSInteger tqcs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tqcs"] integerValue];
            if (tqcs == 0) {
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
        if (indexPath.row == 1) {
            RegularViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularViewController"];
            [VC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
            [self.navigationController pushViewController:VC  animated:YES];
        }

    }

//    ZPLog(@"%ld",indexPath.row);
}



//- (void)push:(NSInteger )str{
//    
//    ZPLog(@"InvestListViewController%ld",(long)str);
//}

- (IBAction)LocationButtonClicked:(id)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    //    cityPickerVC.locationCityID = @"1400010000";
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}



- (IBAction)Login:(id)sender {
    
//    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:VC] animated:YES completion:nil];

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


@end
