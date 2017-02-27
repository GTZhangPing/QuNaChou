//
//  LotteryViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/28.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "LotteryViewController.h"
#import "LotteryTableViewCell.h"
//#import "PrefixHeader.pch"
#import "LotteryTwoViewController.h"


@interface LotteryViewController ()<UIScrollViewDelegate>

{
    int  _i;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *HeadView;
@property (nonatomic, strong) UIScrollView *scrollerView;


@property(nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *arrayData;



@end

@implementation LotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array1 =@[@"YPbg5",@"幸运大转盘",@"100游票/次",@"每天抽一次，丰富奖品等你来抽"];
    NSArray *array2 =@[@"YPbg6",@"大容量行李箱",@"100游票/次",@"每周六开奖，每周3份"];
    NSArray *array3 =@[@"YPbg7",@"塞班岛境外游",@"100游票/次",@"每月30号开奖，每月3份"];
    _arrayData = @[array1,array2,array3];
    
    _i = 2;
    [self insertCycleImages];
}

//视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_timer invalidate];
    _timer = nil;
}


- (void)insertCycleImages
{
//    [_scrollerView removeFromSuperview];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -30,  _HeadView.bounds.size.height)];
    _scrollerView.delegate = self;
    _scrollerView.showsHorizontalScrollIndicator = FALSE;
    self.view.clipsToBounds = YES;
    _scrollerView.clipsToBounds = NO;
    [_HeadView addSubview:_scrollerView];
    
    _imageArray = @[@"YPbg3",@"YPbg1",@"YPbg2",@"YPbg3",@"YPbg1"];
    for (NSInteger i = 0; i <_imageArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -30) *i, 0, SCREEN_WIDTH-30, _HeadView.bounds.size.height)];
        view.backgroundColor = TB_COLOR_GRAY;
        [_scrollerView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, SCREEN_WIDTH -38, _HeadView.bounds.size.height)];
        imageView.layer.cornerRadius = 5;
        [imageView.layer setMasksToBounds:YES];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:_imageArray[i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = imageView.frame;
        button.tag = 2030+i;
        [button addTarget:self action:@selector(buttonClivked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
        [view addSubview:imageView];
    }
    _scrollerView.contentSize = CGSizeMake((SCREEN_WIDTH -30) *_imageArray.count, _HeadView.bounds.size.height);
    _scrollerView.pagingEnabled = YES;
    _scrollerView.contentOffset = CGPointMake((SCREEN_WIDTH -30), 0);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(showPictureView) userInfo:nil repeats:YES];
    
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
        cell = [[LotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
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
    if (indexPath.row == 0) {
        
        LotteryTwoViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LotteryTwoViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (void)buttonClivked:(UIButton *)button
{
    ZPLog(@"%ld",(long)button.tag);
}

//定时器调用的方法
- (void)showPictureView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollerView.contentOffset = CGPointMake(_i*(SCREEN_WIDTH -30), 0);
    } completion:^(BOOL finished) {
        _i++;
        if (_i == (int)self.imageArray.count) {
            self.scrollerView.contentOffset = CGPointMake((SCREEN_WIDTH -30), 0);
            [self scrollViewDidEndDecelerating:self.scrollerView];
            _i = 1;
        }
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    滑动结束
    if (scrollView == _scrollerView) {
        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake((SCREEN_WIDTH -30) *(_imageArray.count-2), 0);
        }
        if (scrollView.contentOffset.x == (SCREEN_WIDTH -30) *(_imageArray.count-1)) {
            scrollView.contentOffset = CGPointMake((SCREEN_WIDTH -30)*1 , 0);
        }
    }
}




- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
