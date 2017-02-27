//
//  PayResultViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/1.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "PayResultViewController.h"
#import "HomeTabBarController.h"
#import "UIView+Custom.h"
#import "MACurrentViewController.h"
#import "MARegularViewController.h"
#import "CurrentViewController.h"
#import "RegularViewController.h"
#import "FreeTourViewController.h"


@interface PayResultViewController ()

@property (strong, nonatomic) IBOutlet UIView *CellView;
@property (strong, nonatomic) IBOutlet UIButton *RecordButton;
@property (strong, nonatomic) IBOutlet UIButton *ContinueButton;


@property (strong, nonatomic) IBOutlet UIImageView *Icon;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UILabel *MoneyLab;
@property (strong, nonatomic) IBOutlet UILabel *InsterstLab;
@property (strong, nonatomic) IBOutlet UILabel *MtshouyiLab;
@property (strong, nonatomic) IBOutlet UILabel *TimeLab;
@property (strong, nonatomic) IBOutlet UILabel *SucceedLab;


@property(nonatomic, assign)NSInteger type;

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupViewLayers];

}

- (void)viewWillAppear:(BOOL)animated{
    
    //
    _type = [[_Dic objectForKey:@"type"] integerValue];
    NSString *interest = [_Dic objectForKey:@"interest"];
    NSString *money = [_Dic objectForKey:@"money"];
    NSString *mtshouyi = [_Dic objectForKey:@"mtshouyi"];
    //设置时间
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *dateStr = [forMatter stringFromDate:date];
    
    _TimeLab.text = [NSString stringWithFormat:@"加入：%@",dateStr];
    if (_type == 2) {
        _Icon.image = [UIImage imageNamed:@"huoqi_"];
        _TitleLab.text = @"特权活期宝";
        _SucceedLab.text = [NSString stringWithFormat:@"特权活期宝%@",money];
    }
    if (_type == 14) {
        _Icon.image = [UIImage imageNamed:@"huoqi_"];
        _TitleLab.text = @"活期宝";
        _SucceedLab.text = [NSString stringWithFormat:@"活期宝%@",money];
        
    }
    if (_type == 3 ||_type == 4||_type == 5||_type == 6 || _type == 7) {
        _Icon.image = [UIImage imageNamed:@"dingqi_"];
        _TitleLab.text = @"定期宝";
        _SucceedLab.text = [NSString stringWithFormat:@"定存宝%@",money];
    }
    if (_type == 8 ||_type == 9||_type == 10||_type == 11||_type == 12) {
        _TitleLab.text = @"免单游";
        _Icon.image = [UIImage imageNamed:@"dingqi_"];
        _SucceedLab.text = [NSString stringWithFormat:@"免单游%@",money];
    }
    
    
    _MoneyLab.text = money;
   _InsterstLab.text = [NSString stringWithFormat:@"%@",interest];
    _MtshouyiLab.text = [NSString stringWithFormat:@"¥%@",mtshouyi];
    
    if (_type == 2 || _type == 14) {
        [_RecordButton setTitle:@"活期记录" forState:UIControlStateNormal];
    }
    else{
        [_RecordButton setTitle:@"定期记录" forState:UIControlStateNormal];
    }
}


- (IBAction)RecordButtonClicked:(id)sender {
    
    if (_type == 2 || _type == 14) {
        MACurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MACurrentViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
        MARegularViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MARegularViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}



- (IBAction)ContinueButtonClicked:(id)sender {
    
    if (_type == 2 || _type == 14) {
        CurrentViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (_type == 3 ||_type == 4||_type == 5||_type == 6 || _type == 7) {
        RegularViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (_type == 8 ||_type == 9||_type == 10||_type == 11||_type == 12) {
        FreeTourViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FreeTourViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


- (IBAction)Back:(id)sender {
    
    
}


- (IBAction)ToMyAccount:(id)sender {
    
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    tab.selectedIndex = 2;
    [self presentViewController:tab animated:YES completion:nil];
}


- (void)setupViewLayers
{
    [UIView customView:_CellView layerColor:[UIColor clearColor] cornerRadious:10];

    [UIView customView:_RecordButton layerColor:[UIColor clearColor] cornerRadious:10];
    [UIView customView:_ContinueButton layerColor:[UIColor clearColor] cornerRadious:10];
    

}

@end
