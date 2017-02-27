//
//  PreciousViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/27.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "PreciousViewController.h"
#import "PreciousTableViewCell.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "PreciousInfoModel.h"
#import "AwardInfoViewController.h"
#import "MJRefresh.h"



@interface PreciousViewController ()


@property (strong, nonatomic) IBOutlet UISegmentedControl *Segment;
@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property(nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSString *ss;
@property (assign, nonatomic) NSInteger pageNo;
@property (nonatomic ,assign) NSInteger TotaPage;


@end

@implementation PreciousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_Segment setTintColor:[UIColor redColor]]; //设置segments的颜色
    
    _ss = @"1";
    _arrayData  = [NSMutableArray array];
    [self refreshUserBidsTableview];
    
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



- (void)Requestnetwork{
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageNo ];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@account/ybx.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"ss":_ss,
                           @"page":page
                           };
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        _TotaPage = [[dic objectForKey:@"total_page"] intValue];
        NSArray *infos = [dic objectForKey:@"infos"];
        if (![infos isKindOfClass:[NSNull class]]) {
            for (NSDictionary *allDic in infos) {
                PreciousInfoModel *model = [[PreciousInfoModel alloc]init];
                model.CreatTime = [allDic objectForKey:@"create_time"];
                model.EndTime = [allDic objectForKey:@"end_time"];
                if ([allDic objectForKey:@"money"]) {
                    model.ID = @"1";
                    model.Title = [allDic objectForKey:@"money"];
                    model.ZhuangTai = [allDic objectForKey:@"onoff"];
                    model.LaiYuan = [allDic objectForKey:@"buy_type"];
                }
                if ([allDic objectForKey:@"interest"]) {
                    model.ID = @"2";
                    model.Title = [allDic objectForKey:@"interest"];
                    model.ZhuangTai = [allDic objectForKey:@"type"];
                    model.LaiYuan = [allDic objectForKey:@"style"];
                }
                if ([allDic objectForKey:@"name"]) {
                    model.ID = @"3";
                    model.Title = [allDic objectForKey:@"name"];
                    model.ZhuangTai = [allDic objectForKey:@"status"];
                    model.Lid = [allDic objectForKey:@"lid"];
                    
                }
                [_arrayData addObject:model];
            }
        }

        [_tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

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
    static NSString *cellIdentifier = @"PreciousCell";
    PreciousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[PreciousTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    if (self.arrayData && indexPath.row < [self.arrayData count])
    {
        PreciousInfoModel *model = [_arrayData objectAtIndex:indexPath.row];
        [cell setCellWithInfo:model];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果

    return cell;
}


//表格视图的代理委托
#pragma mark - UITableViewDelegate
//设置每行表格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //动态获取自定义cell的高度
    PreciousTableViewCell *cell = (PreciousTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.height+5; //这里的5表示高度微调
}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreciousInfoModel *model = [_arrayData objectAtIndex:indexPath.row];
    if (model.Lid) {
        
        AwardInfoViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AwardInfoViewController"];
        VC.lid = model.Lid;
        [self.navigationController pushViewController:VC animated:YES];
    }

}


- (IBAction)segmentControlChanged:(id)sender {
    
    NSInteger index = _Segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            _ss = @"1";
            [self refreshUserBidsTableview];

            break;
        case 1:
            _ss = @"2";
            [self refreshUserBidsTableview];
           break;
        case 2:
            _ss = @"3";
            [self refreshUserBidsTableview];
            break;
        default:
            break;
    }
}


- (IBAction)Back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
