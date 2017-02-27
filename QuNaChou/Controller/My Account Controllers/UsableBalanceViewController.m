//
//  UsableBalanceViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "UsableBalanceViewController.h"
#import "UsableBalanceTableViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "UsableBalanceInfoModel.h"
#import "SVProgressHUD.h"
//#import "PrefixHeader.pch"
#import "MJRefresh.h"

@interface UsableBalanceViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *UseMoney;


@property(nonatomic, strong)NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger pageNo;
@property (nonatomic ,assign) NSInteger TotaPage;


@end

@implementation UsableBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    _pageNo = 1;
//    [self Requestnetwork];
    [self refreshUserBidsTableview];
    _arrayData = [NSMutableArray array];


}


- (void)viewWillAppear:(BOOL)animated{
    
    
    
}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@//kyye.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageNo ];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"page":page
                           };
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        _TotaPage = [[dic objectForKey:@"total_page"] intValue];
        _UseMoney.text = [dic objectForKey:@"keyongyue"];
        _TotaPage = [[dic objectForKey:@"total_page"] integerValue];
        NSArray *infoArray = [dic objectForKey:@"infos"];
        if ( ![infoArray isKindOfClass:[NSNull class]] ) {
            for (NSDictionary *dic in infoArray)
            {
                UsableBalanceInfoModel *model = [[UsableBalanceInfoModel alloc] init];
                model.Time = [dic objectForKey:@"create_time"];
                model.Money = [dic objectForKey:@"money"];
                model.Type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
                [_arrayData addObject:model];
            }
        }
        [_tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}


//刷新
-(void)refreshUserBidsTableview
{
    //下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _pageNo=1;
        if (_arrayData.count>0) {
            [_arrayData removeAllObjects];
        }
        [_tableview.mj_footer resetNoMoreData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self Requestnetwork];
            [_tableview.mj_header endRefreshing];

        });
    }];
    // 马上进入刷新状态
    [_tableview.mj_header beginRefreshing];

    //上拉刷新
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block 
        ++_pageNo;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self Requestnetwork];
            // 刷新表格后调用endRefreshing结束刷新状态
            [_tableview.mj_footer endRefreshing];
            if (_TotaPage < _pageNo) {
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"UsableBalanceCell";
    UsableBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UsableBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {

        UsableBalanceInfoModel *model = [_arrayData objectAtIndex:indexPath.row];
        [cell setCellWithModel:model];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    
    return cell;
}



- (IBAction)Back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
