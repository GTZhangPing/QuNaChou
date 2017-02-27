//
//  MARegularViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/25.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "MARegularViewController.h"
#import "MARegularTableViewCell.h"
#import "RegularInfoViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "MARegularInfoModel.h"
#import "MJRefresh.h"
//#import "PrefixHeader.pch"


#define TEXT_COLOR_YELLOW [UIColor colorWithRed:254.0/255.0f green:150.0/255.0f blue:1.0/255.0f alpha:1.0]

@interface MARegularViewController ()


@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property (weak, nonatomic) IBOutlet UILabel *dingqizichan;
@property (weak, nonatomic) IBOutlet UILabel *leijitouzi;
@property (weak, nonatomic) IBOutlet UILabel *leijishouyi;

@property (nonatomic ,assign) NSInteger pageNo;
@property(nonatomic, strong)NSMutableArray *arrayData;
@property (nonatomic, assign) NSInteger TotalPage;

@end

@implementation MARegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];  //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    _arrayData = [NSMutableArray array];
    [self refreshUserBidsTableview];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
   
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
            if (_TotalPage < _pageNo) {
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }];
}



- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@account/dcb.html",QNCURL];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageNo];
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"page":page
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        _TotalPage = [[dic objectForKey:@"total_page"]intValue];
        _dingqizichan.text = [dic objectForKey:@"huoqizichan"];
        _leijitouzi.text = [dic objectForKey:@"leijitouzi"];
        _leijishouyi.text = [dic objectForKey:@"leijishouyi"];
        
        NSArray *info = [dic objectForKey:@"infos"];
        if (![info isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in info) {
                MARegularInfoModel *model = [[MARegularInfoModel alloc] init];
                model.interest = [dic objectForKey:@"interest"];
                model.money = [dic objectForKey:@"money"];
                model.shouyi = [dic objectForKey:@"shouyi"];
                model.buy_type = [dic objectForKey:@"buy_type"];
                model.indexID = [dic objectForKey:@"id"];
                model.zhuangtai = [[dic objectForKey:@"zhuangtai"] stringValue];
                model.set_time = [dic objectForKey:@"set_time"];
                model.withdraw_time = [dic objectForKey:@"withdraw_time"];
                [_arrayData addObject:model];
            }
        }
        [_tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arrayData && _arrayData.count > 0) {
        return _arrayData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"MARegularCell";
    MARegularTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[MARegularTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        MARegularInfoModel *model = [self.arrayData objectAtIndex:indexPath.row];
        [cell SetCellWithInfo:model];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegularInfoViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularInfoViewController"];
    MARegularInfoModel *model = [self.arrayData objectAtIndex:indexPath.row];
    VC.IndexID = model.indexID;
    VC.Time = model.set_time;
    VC.zhuangtai = model.zhuangtai;
    [self.navigationController pushViewController:VC animated:YES];
}



- (IBAction)Back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
