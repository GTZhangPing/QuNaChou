//
//  MoreViewController.m
//  QuNaChou
//
//  Created by WYD on 16/4/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "MoreViewController.h"
#import "UserLoginViewController.h"
#import "GYZChooseCityController.h"
#import "GYZCity.h"


@interface MoreViewController ()<GYZChooseCityDelegate>

@property (strong, nonatomic) IBOutlet UIButton *LocationButton;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;



}




- (void)viewWillAppear:(BOOL)animated{
    
//    [TabBarStatus ShowTabBar];   //显示tabbar
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *city = [userDefault objectForKey:@"city"];
    if (city) {
        [_LocationButton setTitle:city forState:UIControlStateNormal];
    }
    
    

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



- (IBAction)Login:(id)sender {
    
    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:VC] animated:YES completion:^{
        
    }];
}


- (IBAction)ButtonClicked:(UIButton *)button {
    if (button.tag == 2001) {
        ZPLog(@"美食");
    }
    if (button.tag == 2002) {
        ZPLog(@"酒店");
    }
    if (button.tag == 2003) {
        ZPLog(@"车票");
    }
    if (button.tag == 2004) {
        ZPLog(@"机票");
    }
    if (button.tag == 2005) {
        ZPLog(@"出行");
    }
    if (button.tag == 2006) {
        ZPLog(@"演出");
    }
    if (button.tag == 2007) {
        ZPLog(@"服务");
    }
    if (button.tag == 2008) {
        ZPLog(@"购物");
    }
    if (button.tag == 2009) {
        ZPLog(@"活动1");
    }
    if (button.tag == 2010) {
        ZPLog(@"活动2");
    }
    if (button.tag == 2011) {
        ZPLog(@"活动3");
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

@end
