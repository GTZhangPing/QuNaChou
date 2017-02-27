 //
//  RecommendRewardViewController.m
//  QuNaChou
//
//  Created by WYD on 16/6/2.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RecommendRewardViewController.h"
//#import "PrefixHeader.pch"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "RecommendRewardInfoModel.h"
#import "RecommendRewardTableViewCell.h"
#import "MJRefresh.h"


@interface RecommendRewardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *LVLab;

@property (weak, nonatomic) IBOutlet UILabel *GradeOneLab;
@property (weak, nonatomic) IBOutlet UILabel *GradeTwoLab;
@property (weak, nonatomic) IBOutlet UILabel *GradeThreeLab;
@property (strong, nonatomic) IBOutlet UIButton *GradeOneBtn;
@property (strong, nonatomic) IBOutlet UIButton *GradeTwoBtn;
@property (strong, nonatomic) IBOutlet UIButton *GradeThreeBtn;


@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSString *fs;
@property (assign, nonatomic) NSInteger pageNo;
@property (nonatomic ,assign) NSInteger TotaPage;



@end

@implementation RecommendRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fs = @"1";
    
    _LVLab.layer.cornerRadius = _progressView.layer.cornerRadius = 5;
    _progressView.layer.masksToBounds = _LVLab.layer.masksToBounds = true;
    _NameLab.text = [_dic objectForKey:@"username"];
    _progressView.progress = [[_dic objectForKey:@"grade"] doubleValue];
    _LVLab.text = [NSString stringWithFormat:@" LV%@ ",[_dic objectForKey:@"role"]];
    
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
    NSString *baseUrl = [NSString stringWithFormat:@"%@friend/%@.html",QNCURL,_urlStr];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:10.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"fs":_fs,
                           @"page":page
                            };
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);         
        _TotaPage = [[dic objectForKey:@"total_page"]intValue];
        if ( [[dic objectForKey:@"onegrade"]  isEqual: @"yes"]) {
            _GradeOneBtn.userInteractionEnabled = YES;
            _GradeOneLab.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"oneperson"]];
        }
        
        if ([[dic objectForKey:@"twograde"] isEqual:@"yes"]) {
            _GradeTwoLab.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"twoperson"]];
            _GradeTwoBtn.userInteractionEnabled = YES;
        }
        else{
            _GradeTwoLab.text = @"未开通特权";
            _GradeTwoBtn.userInteractionEnabled = NO;
        }
        if ([[dic objectForKey:@"threegrade"] isEqual:@"yes"]) {
            _GradeThreeLab.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"threeperson"]];
            _GradeTwoBtn.userInteractionEnabled = YES;
        }
        else{
            _GradeThreeLab.text = @"未开通特权";
            _GradeThreeBtn.userInteractionEnabled = NO;
        }
        
        NSArray  *InfosArray = [dic objectForKey:@"infos"];
        if (![InfosArray isKindOfClass:[NSNull class]]) {
            for (NSDictionary *InfoDic in InfosArray) {
                RecommendRewardInfoModel *model = [[RecommendRewardInfoModel alloc] init];
                model.username = [InfoDic objectForKey:@"username"];
                model.money = [NSString stringWithFormat:@"%@" ,[InfoDic objectForKey:@"money"]];
                [_arrayData addObject:model];
            }
        }
        
        [_tableview reloadData];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];

    
}

#pragma mark - UITableViewDataSource
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"RecommendRewardCell";
    RecommendRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[RecommendRewardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        
        RecommendRewardInfoModel *model = [_arrayData objectAtIndex:indexPath.row];
        [cell SetCellWithInfo:model];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    
    return cell;
}


- (IBAction)GradeOneButton:(id)sender {
    
    _fs = @"1";
    [self refreshUserBidsTableview];
}


- (IBAction)GradeTwoButton:(id)sender {
    
    _fs = @"2";
    [self refreshUserBidsTableview];
}


- (IBAction)GradeThreeButton:(id)sender {
    
    _fs = @"3";
    [self refreshUserBidsTableview];
}



- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
