//
//  SetPasswordViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/8/10.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "LoginPasswordViewController.h"

@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)ButtonClicked:(UIButton *)sender {
    
    if (sender.tag == 2081) {
        ZPLog(@"");
        LoginPasswordViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPasswordViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (sender.tag == 2082) {
        ZPLog(@"");
    }
    if (sender.tag == 2083) {
        ZPLog(@"");
    }
}



- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
