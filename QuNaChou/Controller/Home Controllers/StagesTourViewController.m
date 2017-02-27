//
//  StagesTourViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "StagesTourViewController.h"
//#import "PrefixHeader.pch"
#import "StagesTourTableViewCell.h"
#import "StagesTourDetailedViewController.h"

@interface StagesTourViewController ()<UISearchBarDelegate,UIScrollViewDelegate, StagesTourTableViewCellDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *HOTButton1;
@property (strong, nonatomic) IBOutlet UIButton *HOTButton2;
@property (strong, nonatomic) IBOutlet UIButton *HOTButton3;
@property (strong, nonatomic) IBOutlet UIButton *HOTButton4;

@property(nonatomic, strong)NSArray *arrayData;
@property(nonatomic, strong)NSArray *HOTarray;



@end

@implementation StagesTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.searchBar.delegate = self;
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 10.0f;
        searchField.layer.borderColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1].CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    _searchBar.showsCancelButton = YES;
    
    UIButton*cancelButton = [_searchBar valueForKey:@"_cancelButton"];
    
    [cancelButton setTitle:@""forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"search_"] forState:UIControlStateNormal];
    
    
    
    NSArray *array1 = @[@"MDbg2",@"塞班岛",@"miandan_",@"理财10000元/12期起",@"6000元",@"shoucang_click_"];
    NSArray *array2 = @[@"MDbg2",@"塞班岛",@"miandan_",@"理财20000元/9期起",@"8000元",@"shoucang_"];
    NSArray *array3 = @[@"MDbg2",@"塞班岛",@"miandan_",@"理财30000元/6期起",@"10000元",@"shoucang_click_"];
    
    _arrayData = @[array1,array2,array3];
    
    _HOTarray = @[@" 塞班岛 ",@" 星马泰 ",@" 澳洲 "];
    
    [self setButtonTitle];
    [self setupViewLayers];
}


- (void)setButtonTitle{
    if (_HOTarray && _HOTarray.count > 0) {
        
        if (_HOTarray.count == 1) {
            [_HOTButton1 setTitle:[_HOTarray objectAtIndex:0] forState:UIControlStateNormal];
            
            [_HOTButton2 removeFromSuperview];
            [_HOTButton3 removeFromSuperview];
            [_HOTButton4 removeFromSuperview];
            
        }
        if (_HOTarray.count == 2) {
            [_HOTButton1 setTitle:[_HOTarray objectAtIndex:0] forState:UIControlStateNormal];
            [_HOTButton2 setTitle:[_HOTarray objectAtIndex:1] forState:UIControlStateNormal];
            
            [_HOTButton3 removeFromSuperview];
            [_HOTButton4 removeFromSuperview];
        }
        if (_HOTarray.count == 3) {
            [_HOTButton1 setTitle:[_HOTarray objectAtIndex:0] forState:UIControlStateNormal];
            [_HOTButton2 setTitle:[_HOTarray objectAtIndex:1] forState:UIControlStateNormal];
            [_HOTButton3 setTitle:[_HOTarray objectAtIndex:2] forState:UIControlStateNormal];
            
            [_HOTButton4 removeFromSuperview];
            
        }
    }
    
    
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
    static NSString *cellIdentifier = @"StagesTourCell";//定义一个可重用标识
    StagesTourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//从重用队列里获取可重用的cell
    if (!cell)
    {
        //如果不存在，创建一个可重用cell
        cell = [[StagesTourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIdentifier];
    }
    
    if (self.arrayData && indexPath.row < [self.arrayData count])
    {
        [cell SetCellwithInfo:[_arrayData objectAtIndex:indexPath.row] Index:indexPath.row];
        cell.delegate = self;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  //设置cell无点击效果
    
    return cell;
}

//表格视图的代理委托
#pragma mark - UITableViewDelegate
//设置每行表格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 233;
}

//选择表格视图某一行调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StagesTourDetailedViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"StagesTourDetailedViewController"];
    [self.navigationController pushViewController:VC animated:YES];
    
}


//关注
- (void)CollectButton:(NSInteger)index{
    
    ZPLog(@"%ld",(long)index);
}


- (IBAction)HOTButtonClocked:(UIButton*)button {
    
    ZPLog(@"%@",button.titleLabel.text);
    
    
}


//返回
- (IBAction)Back:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma mark - 实现取消按钮的方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder]; // 丢弃第一使用者
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    ZPLog(@"您点击了取消按钮");
    [_searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    ZPLog(@"您点击了键盘上的Search按钮");
    
    [_searchBar resignFirstResponder]; // 丢弃第一使用者
    
}
#pragma mark - 实现监听开始输入的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    ZPLog(@"开始输入搜索内容");
    return YES;
}
#pragma mark - 实现监听输入完毕的方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    ZPLog(@"输入完毕");
    return YES;
}


#pragma mark 搜索框的代理方法，搜索输入框获得焦点（聚焦）
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}



- (void)setupViewLayers{
    
    _HOTButton1.layer.cornerRadius =_HOTButton2.layer.cornerRadius = _HOTButton3.layer.cornerRadius = _HOTButton4.layer.cornerRadius = 5;
    _HOTButton1.layer.borderColor=  _HOTButton2.layer.borderColor=  _HOTButton3.layer.borderColor=  _HOTButton4.layer.borderColor=TEXT_COLOR_GRAY.CGColor;
    _HOTButton1.layer.borderWidth = _HOTButton2.layer.borderWidth = _HOTButton3.layer.borderWidth = _HOTButton4.layer.borderWidth = 1.0;
    
    
}




@end
