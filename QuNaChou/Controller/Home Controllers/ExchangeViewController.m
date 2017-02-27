//
//  ExchangeViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/22.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeTableViewCell.h"
#import "LotteryViewController.h"
//#import "PrefixHeader.pch"
#import "IntegralExchangeViewController.h"


@interface ExchangeViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *TopView;

@property (nonatomic, strong)NSMutableArray *arrayData;


@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _TopView.layer.cornerRadius = 10;
    
    NSArray *array1 =@[@"YPbg1",@"YPicon3-s",@"旅游防晒霜",@"10000游票"];
    NSArray *array2 =@[@"YPbg2",@"YPicon4-s",@"游票抽奖",@"10000游票"];
    NSArray *array3 =@[@"YPbg3",@"YPicon5-s",@"旅游优惠",@"10000游票"];
    NSArray *array4 =@[@"YPbg4",@"YPicon6-s",@"会员特权",@"10000游票"];
    _arrayData = [NSMutableArray arrayWithObjects:array1,array2,array3,array4, nil];
    
}



- (IBAction)Button1Cliked:(id)sender {
    
    ZPLog(@"抽奖活动");
    LotteryViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LotteryViewController"];
    [self.navigationController pushViewController:VC animated:YES];
    
}



//兑换详细
- (IBAction)IntegralExchangeButton:(id)sender {
    
    IntegralExchangeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntegralExchangeViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}


- (IBAction)Button2Cliked:(id)sender {
    
    ZPLog(@"理财特权");
}

- (IBAction)Button3Cliked:(id)sender {
    
    ZPLog(@"旅游用品");
}

- (IBAction)Button4Cliked:(id)sender {
    
    ZPLog(@"旅游优惠");
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
    static NSString *cellIdentifier = @"ExchangeCell";//定义一个可重用标识
    ExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//从重用队列里获取可重用的cell
    if (!cell)
    {
        //如果不存在，创建一个可重用cell
        cell = [[ExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIdentifier];
    }
    
    if (self.arrayData && indexPath.row < [self.arrayData count])
    {
        [cell setCellWithInfo:[_arrayData objectAtIndex:indexPath.row]];
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



@end
