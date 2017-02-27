//
//  FlashSaleViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/14.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FlashSaleViewController.h"
//#import "PrefixHeader.pch"
#import "MZTimerLabel.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "NSString+TransformTimestamp.h"
#import "FlashSaleTableViewCell.h"


@interface FlashSaleViewController ()<MZTimerLabelDelegate,FlashSaleTableViewCellDelegate>

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong) MZTimerLabel *timerExample;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton1;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton2;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton3;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton4;
@property (weak, nonatomic) IBOutlet UILabel *StateLab1;
@property (weak, nonatomic) IBOutlet UILabel *StateLab2;
@property (weak, nonatomic) IBOutlet UILabel *StateLab3;
@property (weak, nonatomic) IBOutlet UILabel *StateLab4;
@property (weak, nonatomic) IBOutlet UILabel *DescribeLab;

@property (weak, nonatomic) IBOutlet UILabel *Timelab;

@property (weak, nonatomic) IBOutlet UIButton *BuyButton;
@property (weak, nonatomic) IBOutlet UILabel *NumberLab;
@property (nonatomic, strong)NSString *Button1State;
@property (nonatomic, strong)NSString *Button2State;
@property (nonatomic, strong)NSString *Button3State;
@property (nonatomic, strong)NSString *Button4State;

@property (nonatomic ,strong)NSMutableArray *arrayData;

@end

@implementation FlashSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏颜色 字体颜色及大小
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];

     NSArray *array1 = @[];
    NSArray *array2 = @[];
    _arrayData = [NSMutableArray arrayWithObjects:array1,array2, nil];
    
    [self setupViewLayers];
}  

- (void)viewWillAppear:(BOOL)animated{
    
    [self Requestnetwork];
 
}

//请求网络
- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        uid = @"wu";
    }
    NSString *baseUrl = [NSString stringWithFormat:@"%@xiansh/index.html",QNCURL];
    
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
        NSDictionary *infoDic = [dic objectForKey:@"infos"];
        
        _NumberLab.text = [NSString stringWithFormat:@"（每天限购一张，剩余%d/5张）",5-[[infoDic objectForKey:@"now_have"]intValue]];
        NSInteger clost = [[infoDic objectForKey:@"this_close"] intValue];
        NSInteger star = [[infoDic objectForKey:@"next_start"] intValue];
        if (clost ) {
            [_timerExample setCountDownTime:clost];
            _DescribeLab.text = @"距离本场限时惠还剩：";
        }
        if (star ) {
            [_timerExample setCountDownTime:star];
            _DescribeLab.text = @"距离下场限时惠还剩：";
        }
        if (!clost && !star  ) {
            _DescribeLab.text = @"今日活动已结束";
            _timerExample = nil;
        }    

        NSDictionary *styleDic = [infoDic objectForKey:@"abcd_styel"];
        _Button1State = [styleDic objectForKey:@"A"];
        _Button2State = [styleDic objectForKey:@"B"];
        _Button3State = [styleDic objectForKey:@"C"];
        _Button4State = [styleDic objectForKey:@"D"];
        
        [self refreshView];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}



- (void)refreshView{
    
    [_timerExample start];

    if ([_Button1State isEqual:@"off"]) {
        _TimeButton1.backgroundColor = [UIColor clearColor];
        _StateLab1.text = @"已结束";
    }
    if ([_Button1State isEqual:@"on"]) {
        _TimeButton1.backgroundColor = TB_COLOR_RED;
        _StateLab1.text = @"进行中";
        _StateLab1.textColor = [UIColor whiteColor];
        [_TimeButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([_Button1State isEqual:@"hot"]) {
        _TimeButton1.backgroundColor = TB_COLOR_GRAY;
        _StateLab1.text = @"热场中";
    }
    if ([_Button2State isEqual:@"off"]) {
        _TimeButton2.backgroundColor = [UIColor clearColor];
        _StateLab2.text = @"已结束";
    }
    if ([_Button2State isEqual:@"on"]) {
        _TimeButton2.backgroundColor = TB_COLOR_RED;
        _StateLab2.text = @"进行中";
        _StateLab2.textColor = [UIColor whiteColor];
        [_TimeButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([_Button2State isEqual:@"hot"]) {
        _TimeButton2.backgroundColor = TB_COLOR_GRAY;
        _StateLab2.text = @"热场中";
    }
    if ([_Button3State isEqual:@"off"]) {
        _TimeButton3.backgroundColor = [UIColor clearColor];
        _StateLab3.text = @"已结束";
    }
    if ([_Button3State isEqual:@"on"]) {
        _TimeButton3.backgroundColor = TB_COLOR_RED;
        _StateLab3.text = @"进行中";
        _StateLab3.textColor = [UIColor whiteColor];
        [_TimeButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([_Button3State isEqual:@"hot"]) {
        _TimeButton3.backgroundColor = TB_COLOR_GRAY;
        _StateLab3.text = @"热场中";
    }
    if ([_Button4State isEqual:@"off"]) {
        _TimeButton4.backgroundColor = [UIColor clearColor];
        _StateLab4.text = @"已结束";
    }
    if ([_Button4State isEqual:@"on"]) {
        _TimeButton4.backgroundColor = TB_COLOR_RED;
        _StateLab4.text = @"进行中";
        _StateLab4.textColor = [UIColor whiteColor];
        [_TimeButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([_Button4State isEqual:@"hot"]) {
        _TimeButton4.backgroundColor = TB_COLOR_GRAY;
        _StateLab4.text = @"热场中";
    }
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arrayData && _arrayData.count > 0) {
        return _arrayData.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"FlashSaleCell";
    FlashSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[FlashSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        [cell setCellWithInfo:[_arrayData objectAtIndex:indexPath.row] Index:indexPath.row];
        cell.delegate = self;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    RegularInfoViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularInfoViewController"];
//    MARegularInfoModel *model = [self.arrayData objectAtIndex:indexPath.row];
//    VC.IndexID = model.indexID;
//    VC.Time = model.set_time;
//    VC.zhuangtai = model.zhuangtai;
//    [self.navigationController pushViewController:VC animated:YES];
//}



- (void)push:(NSInteger)str{
    
    ZPLog(@"%ld",(long)str);
    

}



- (IBAction)BuyButtonClicked:(id)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@xiansh/rush.html",QNCURL];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        uid = @"wu";
    }
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
        if ([code  isEqual: @"0031"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"限时惠特权利率已经抢完";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0032"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"当前积分不足";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        
        
        if ([code  isEqual: @"0033"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"抢购成功";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0034"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"抢购失败";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0035"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"今日已经抢购一次";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0036"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"未到开抢时间";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0037"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"超过了限时惠利率的最大值";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }
        if ([code  isEqual: @"0038"]) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"您还没有登录";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
            return ;
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}



//倒计时结束回调
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    [self Requestnetwork];
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViewLayers{
    
    _timerExample = [[MZTimerLabel alloc] initWithLabel:_Timelab andTimerType:MZTimerLabelTypeTimer];
    _timerExample.delegate = self;
    
    _BuyButton.layer.cornerRadius = 5;
    _TimeButton1.layer.cornerRadius = _TimeButton2.layer.cornerRadius = _TimeButton3.layer.cornerRadius = _TimeButton4.layer.cornerRadius = 5;


    
}

- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    [_timerExample6 invalidate];
    _timerExample = nil;
}


@end
