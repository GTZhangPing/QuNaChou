//
//  IntegralExchangeViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/7/6.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "IntegralExchangeViewController.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "LotteryTableViewCell.h"
#import "IntralExchangeModel.h"
#import "MJRefresh.h"




@interface IntegralExchangeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong)NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger pageNo;
@property (nonatomic ,assign) NSInteger TotaPage;


@end

@implementation IntegralExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshUserBidsTableview];
    _arrayData = [NSMutableArray array];}


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
            if (_TotaPage <_pageNo) {
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }];
}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@exchange/integral_duihuan_info.html",QNCURL];
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
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        _TotaPage = [[dic objectForKey:@"total_page"] intValue];
        NSArray *DHMXArray = [dic objectForKey:@"duihaunmingxi"];
        if (![DHMXArray isKindOfClass:[NSNull class]]) {
            for (NSDictionary *infoDic in DHMXArray) {
                IntralExchangeModel *model = [[IntralExchangeModel alloc ]init];
                model.Name = [infoDic objectForKey:@"class_name"];
                model.Result = [infoDic objectForKey:@"duihuanjieguo"];
                model.ImageURL = [infoDic objectForKey:@"img_url"];
                model.Time = [infoDic objectForKey:@"times"];
                model.UseIntegral = [infoDic objectForKey:@"use_integral"];
                [_arrayData addObject:model];
            }
            [_tableview reloadData];
        }
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}



#pragma mark - UITableViewDataSource

//设置表格视图每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayData && [self.arrayData count])
    {
        return [self.arrayData count];
    }
    
    return 0;
}

//设置表格视图每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LotteryCell";//定义一个可重用标识
    LotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//从重用队列里获取可重用的cell
    if (!cell)
    {
        //如果不存在，创建一个可重用cell
        cell = [[LotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.arrayData && indexPath.row < [self.arrayData count])
    {
        IntralExchangeModel *model = [_arrayData objectAtIndex:indexPath.row];
        [cell setCellWithModel:model];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    return cell;
}

//表格视图的代理委托
#pragma mark - UITableViewDelegate
//设置每行表格的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 233;
//}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    StagesTourDetailedViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"StagesTourDetailedViewController"];
    //    [self.navigationController pushViewController:VC animated:YES];
    
}


- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}



@end
