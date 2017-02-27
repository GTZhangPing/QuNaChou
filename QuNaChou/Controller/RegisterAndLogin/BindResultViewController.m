//
//  BindResultViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/1.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "BindResultViewController.h"
#import "UIView+Custom.h"
#import "HomeTabBarController.h"
#import "FreeTourViewController.h"
#import "TQCurrentViewController.h"
#import "CurrentViewController.h"
#import "RegularViewController.h"
#import "StagesTourViewController.h"

@interface BindResultViewController ()



@end

@implementation BindResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ToInvestList:(id)sender {
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    tab.selectedIndex = 1;
    [self presentViewController:tab animated:YES completion:nil];
}

- (IBAction)TpmMyAccount:(id)sender {
    HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    tab.selectedIndex = 2;
    [self presentViewController:tab animated:YES completion:nil];
}


- (IBAction)ToLiCaiView:(id)sender {
    if ([_VCID isEqualToString:@"MyAccountViewController"]) {
        HomeTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
        tab.selectedIndex = 0;
        [self presentViewController:tab animated:YES completion:nil];
    }
    
    if ( [_VCID  isEqual: @"FreeTourViewController"] ) {
        FreeTourViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"FreeTourViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if ( [_VCID  isEqual: @"StagesTourViewController"] ) {
        StagesTourViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"StagesTourViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }

    if ([_VCID  isEqual: @"TQCurrentViewController"]) {
        TQCurrentViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"TQCurrentViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if ( [_VCID  isEqual: @"CurrentViewController"] ) {
        CurrentViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    } 
    if ([_VCID  isEqual: @"RegularViewController"]) {
        RegularViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"RegularViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}



@end
