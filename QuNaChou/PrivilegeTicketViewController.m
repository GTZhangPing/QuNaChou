//
//  PrivilegeTicketViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/20.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "PrivilegeTicketViewController.h"
#import "PrivilegeTicketInfoModel.h"
#import "PrivilegeTicketTableViewCell.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "CircularProgressBar.h"
#import "MJRefresh.h"


@interface PrivilegeTicketViewController ()

@property (nonatomic, strong) CircularProgressBar *bar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Segment;
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;
@property (weak, nonatomic) IBOutlet UILabel *Label4;
@property (weak, nonatomic) IBOutlet UILabel *Label5;

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger pageNo;
@property (nonatomic ,assign) NSInteger TotaPage;

@property (nonatomic, strong) NSString *ftype;

@end

@implementation PrivilegeTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_Segment setTintColor:[UIColor orangeColor]]; //设置segments的颜色
 
    _bar = [[CircularProgressBar alloc]initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH,125)];
    [_bar strokeChart];
    [_HeadView addSubview:_bar];
    
    _ftype = @"1";
    
    _arrayData = [NSMutableArray array];
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
    NSString *baseUrl = [NSString stringWithFormat:@"%@friend/tequanshouyi.html",QNCURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"ftype":_ftype,
                           @"page":page
                               };
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        _TotaPage = [[dic objectForKey:@"total_page"] intValue];
        NSString *str = [dic objectForKey:@"now"];
        CGFloat now = 0;
        if ([_ftype  isEqual: @"1"]) {
            if (![str isKindOfClass:[NSNull class]]) {
                now = [[dic objectForKey:@"now"] floatValue]*100;
            }
            _Label1.text = [NSString stringWithFormat:@"%.1f%@",now,@"%"];
            CGFloat tisheng = [[dic objectForKey:@"tishengedu"] floatValue]*100;
            _Label3.text = [NSString stringWithFormat:@"特权收益额度：%.1f%@",tisheng,@"%"];
            _Label5.text = [NSString stringWithFormat:@"当前特权收益：%.1f%@",now,@"%"];
        }
        if ([_ftype  isEqual: @"2"]) {
            if (![str isKindOfClass:[NSNull class]]) {
                now = [[dic objectForKey:@"now"] integerValue];
            }
            _Label1.text = [NSString stringWithFormat:@"¥%ld",(long)now];
            NSInteger tisheng = [[dic objectForKey:@"tishengedu"] integerValue];
            _Label3.text = [NSString stringWithFormat:@"特权本金额度：¥%ld",(long)tisheng];
            _Label5.text = [NSString stringWithFormat:@"当前特权本金：¥%ld",(long)now];
        }
        if ([_ftype  isEqual: @"3"]) {
            if (![str isKindOfClass:[NSNull class]]) {
                now = [[dic objectForKey:@"now"] integerValue];
            }
            _Label1.text = [NSString stringWithFormat:@"%ld",(long)now];
            NSInteger tisheng = [[dic objectForKey:@"tishengedu"] integerValue];
            _Label3.text = [NSString stringWithFormat:@"特权收益积分：%ld",(long)tisheng];
            _Label5.text = [NSString stringWithFormat:@"当前特权积分：%ld",(long)now];
        }
        _bar.progress = [[dic objectForKey:@"percent"] doubleValue];
        
        NSDictionary *infoDic = [dic objectForKey:@"infos"];
        if (![infoDic  isKindOfClass:[NSNull class]]) {
            for (NSDictionary *t1Dic in infoDic) {
                PrivilegeTicketInfoModel *model = [[PrivilegeTicketInfoModel alloc] init];
                if ([_ftype isEqual:@"1"]) {
                    model.tequan = [NSString stringWithFormat:@"%.1f%@",[[t1Dic objectForKey:@"interest"] doubleValue]*100 , @"%"];
                    model.beganTime = [t1Dic objectForKey:@"create_time"];
                    model.endTime = [t1Dic objectForKey:@"end_time"];
                }
                if ([_ftype isEqual:@"2"]) {
                    model.tequan = [NSString stringWithFormat:@"¥%ld",[[t1Dic objectForKey:@"money"] integerValue]];
                    model.beganTime = [t1Dic objectForKey:@"set_time"];
                    model.endTime = [t1Dic objectForKey:@"end_time"];
                }
                if ([_ftype isEqual:@"3"]) {
                    model.tequan = [NSString stringWithFormat:@"%ld", [[t1Dic objectForKey:@"integral"] integerValue]];
                    model.beganTime = [t1Dic objectForKey:@"create_time"];
                }
                model.name = [t1Dic objectForKey:@"from_user"];
                model.type = [t1Dic objectForKey:@"status"];
                [_arrayData addObject:model];
            }
        }
        [_tableview reloadData];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"PrivilegeTicketCell";
    PrivilegeTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[PrivilegeTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        
        PrivilegeTicketInfoModel *model = [_arrayData objectAtIndex:indexPath.row];
        [cell SetCellWithInfo:model];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    return cell;
}





- (IBAction)segment1:(id)sender{
    
    NSInteger index = _Segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            _Label2.text = @"特权收益";
            _Label4.text = @"增加特权收益";
            _ftype = @"1";
            [self refreshUserBidsTableview];
            break;
        case 1:
            _Label2.text = @"特权本金";
            _Label4.text = @"增加特权本金";
            _ftype = @"2";
            [self refreshUserBidsTableview];
            break;
        case 2:
            _Label2.text = @"特权积分";
            _Label4.text = @"增加特权积分";
            _ftype = @"3";
            [self refreshUserBidsTableview];
            break;
        default:
            break;
    }
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)dismissDelayed{
//    
//    [SVProgressHUD dismiss];
//}


@end
