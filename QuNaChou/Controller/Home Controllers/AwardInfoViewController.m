//
//  AwardInfoViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/7/4.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "AwardInfoViewController.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSString+TransformTimestamp.h"
#import "ChangeAddressViewController.h"
#import "ConsigneeAddressViewController.h"

@interface AwardInfoViewController ()

//@property (strong, nonatomic) IBOutlet UIView *TopView;
@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UILabel *StatusLab;
@property (strong, nonatomic) IBOutlet UILabel *Lab;


@property (strong, nonatomic) IBOutlet UIView *View1;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UILabel *Phone;
@property (strong, nonatomic) IBOutlet UILabel *Place;
@property (strong, nonatomic) IBOutlet UILabel *Address;
@property (strong, nonatomic) IBOutlet UILabel *Express;
@property (strong, nonatomic) IBOutlet UILabel *Number;
@property (strong, nonatomic) IBOutlet UILabel *ExpresStatus;


@property (strong, nonatomic) IBOutlet UIView *View2;
@property (strong, nonatomic) IBOutlet UILabel *V2Name;
@property (strong, nonatomic) IBOutlet UILabel *CreatTime;
@property (strong, nonatomic) IBOutlet UILabel *EndTime;


@end

@implementation AwardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:TB_COLOR_GRAY];  //导航栏颜色

    
    _View1.hidden = YES;
    _View2.hidden = YES;
    

}

- (void)viewWillAppear:(BOOL)animated
{

    [self Requestnetwork];

}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/look_award.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:1.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"lid":_lid
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        ZPLog(@"%@",dic);
        
        NSDictionary *DZDic = [dic objectForKey:@"dizhi"];
        if (![DZDic isKindOfClass:[NSNull class]]) {
            _View1.hidden = NO;
            _Name.text = [DZDic objectForKey:@"dz_name"];
            _Phone.text = [DZDic objectForKey:@"dz_phone"];
            _Place.text = [NSString stringWithFormat:@"%@ %@ %@",
            [DZDic objectForKey:@"dz_province"], [DZDic objectForKey:@"dz_city"],[DZDic objectForKey:@"dz_county"]];
            _Address.text = [DZDic objectForKey:@"dz_addres"];
        }
        NSDictionary *userInfoDic = [dic objectForKey:@"userinfo"];
        if (![userInfoDic isKindOfClass:[NSNull class]]) {
            _View2.hidden = NO;
            _V2Name.text = [userInfoDic objectForKey:@"username"];
            _CreatTime.text = [NSString transformTime:[userInfoDic objectForKey:@"create_time"]];
            _EndTime.text = [NSString transformTime:[userInfoDic objectForKey:@"end_time"]];
        }
        
        NSDictionary *JiangpinDic = [dic objectForKey:@"jiangpin"];
        if (![JiangpinDic isKindOfClass:[NSNull class]]) {
            _TitleLab.text = [JiangpinDic objectForKey:@"jp_name"];
            _StatusLab.text = @"已中奖"; 
            _Lab.text = [JiangpinDic objectForKey:@"jp_zhuangtai"];
            [_TitleImage sd_setImageWithURL:[JiangpinDic objectForKey:@"jp_img_url"] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        
        NSDictionary *KDDic = [dic objectForKey:@"kuaidi"];
        if (![KDDic isKindOfClass:[NSNull class]]) {
//            _View2.hidden = NO;
            _Express.text = [KDDic objectForKey:@"kd_name"];
            _Number.text = [KDDic objectForKey:@"kd_nums"];
            _ExpresStatus.text = [KDDic objectForKey:@"kd_status"];
        }
        
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}


- (IBAction)SetAddress:(id)sender {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/go_write_address.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"style":@"go",
                           @"lid":_lid
                           };
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        ZPLog(@"%@",dic);
        if ([[dic objectForKey:@"addres_info"] isKindOfClass:[NSNull class]]) {
            ChangeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
            VC.lid = _lid;
            VC.Phone = [dic objectForKey:@"user_phone"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else{
            
            ConsigneeAddressViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConsigneeAddressViewController"];
            
            NSArray *addresArray = [dic objectForKey:@"addres_info"];
            VC.dic = addresArray[0];
            VC.lid = _lid;
            VC.Phone = [dic objectForKey:@"user_phone"];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];

}



- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Share:(id)sender {
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
