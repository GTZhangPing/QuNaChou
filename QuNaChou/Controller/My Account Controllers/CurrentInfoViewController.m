//
//  CurrentInfoViewController.m
//  
//
//  Created by WYD on 16/5/25.
//
//

#import "CurrentInfoViewController.h"
#import "CurrentInfoTableViewCell.h"
#import "DetailsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "NSString+TransformTimestamp.h"
//#import "PrefixHeader.pch"


@interface CurrentInfoViewController ()

@property(nonatomic, strong)MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *Addmoney;
@property (weak, nonatomic) IBOutlet UILabel *nianhuibaolv;
@property (weak, nonatomic) IBOutlet UILabel *leijishouyi;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *Stadus;
@property (weak, nonatomic) IBOutlet UIView *BGView;


@property(nonatomic, strong)NSMutableArray *arrayData;

@end

@implementation CurrentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _TimeLab.text = [NSString transformTime:_Time];
    if ([_zhuangtai isEqual:@"2"]) {
        _Stadus.text =  @"计息中";
//        _BGView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    }
    if ([_zhuangtai isEqual:@"3"]) {
        _Stadus.text = @"已退出结清";
    }
    
    [self Requestnetwork];
}


-(void)viewWillAppear:(BOOL)animated{
    
   
}

- (void)Requestnetwork{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@account/mate.html",QNCURL];
    NSDictionary *dict = @{@"rid":rid,
                           @"oid":_IndexID
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _arrayData = [NSMutableArray array];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        
        _Addmoney.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"jiarujine"]];
        _nianhuibaolv.text = [NSString stringWithFormat:@"%.1f%@",[[dic objectForKey:@"nianhuibaolv"] floatValue]*100,@"%"];
        _leijishouyi.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"yishoushouyi"]];
        
        NSArray *infoArray = [dic objectForKey:@"pipeixiangqing"];
        for (NSDictionary *dic in infoArray)
        {
            NSArray *array = @[[dic objectForKey:@"sid"],[dic objectForKey:@"u_money"]];
            [_arrayData addObject:array];
        }
        //        ZPLog(@"%@",_arrayData);
        [_tableview reloadData];
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"CurrentInfoCell";
    CurrentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[CurrentInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (_arrayData && _arrayData.count>indexPath.row) {
        [cell SetCellWithInfo:[_arrayData objectAtIndex:indexPath.row]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailsViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}


- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}


@end
