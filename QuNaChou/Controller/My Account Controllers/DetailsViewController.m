//
//  DetailsViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/26.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "DetailsViewController.h"
#import "ProtocolViewController.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button:(UIButton *)button {
    
    if (button.tag == 2208) {
        ZPLog(@"活期宝服务协议");
        ProtocolViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProtocolViewController"];
        VC.navigationItem.title = @"活期宝服务协议";
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (button.tag == 2209) {
        ZPLog(@"借款协议");
        ProtocolViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProtocolViewController"];
        VC.navigationItem.title = @"借款协议";
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
