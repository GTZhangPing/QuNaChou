//
//  AppDelegate.m
//  QuNaChou
//
//  Created by WYD on 16/4/14.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "AppDelegate.h"
//#import "PrefixHeader.pch"
#import "HomeViewController.h"
#import "MyAccountViewController.h"
#import "InvestListViewController.h"
#import "MoreViewController.h"

@interface AppDelegate ()

@property(nonatomic, strong)NSUserDefaults *userDefault;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //修改状态栏颜色 （运营商／时间／电量）
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBarTintColor:TB_COLOR_GRAY];   //tabbar颜色
    tabBar.tintColor = TB_COLOR_RED;    //tabbar 选中后图片 颜色
    // 选中后 字体原色
    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TB_COLOR_RED,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色
    //隐藏导航栏下面的黑线
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [[UIImage alloc] init];
    navigationBar.tintColor = TB_COLOR_RED;
    //设置导航栏字体颜色 字号
    [navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to t he background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
