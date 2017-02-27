//
//  RegisterLastViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/31.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RegisterLastViewController.h"
#import "HomeTabBarController.h"

@interface RegisterLastViewController ()

@end

@implementation RegisterLastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:@"hasLogin"];
    [userDefault synchronize];
}


//跳转首页
- (IBAction)Back:(id)sender {
    
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    tab.selectedIndex=0;
    [self presentViewController:tab animated:YES completion:nil];

}


//跳转账户
- (IBAction)ToMyAccount:(id)sender {
    
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
        tab.selectedIndex=2;
    [self presentViewController:tab animated:YES completion:nil];

    
    
}

@end
