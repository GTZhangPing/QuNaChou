//
//  RootViewController.m
//  QuNaChou
//
//  Created by WYD on 16/4/15.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RootViewController.h"
//#import "PrefixHeader.pch"

@interface RootViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)NSArray *array;
@property(nonatomic, strong)UIPageControl *pageControl;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    _scrollView.bounces = YES;//设置边界是否反弹
    _scrollView.pagingEnabled = YES;//设置自动滚动到边界
    _scrollView.delegate = self;//设置委托代理
    
    _array = [NSArray arrayWithObjects:@"",@"",@"" ,nil];  //图片名称
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    _scrollView.contentSize = CGSizeMake(width*_array.count, height);
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < _array.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(1*width, 0, width, height)];
        image.image = [UIImage imageNamed:_array[i]];
        [_scrollView addSubview:image];
    }
    
    //开启理财按钮
    UIButton *kickOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    kickOffButton.frame = CGRectMake(2.5*SCREEN_WIDTH-75, SCREEN_HEIGHT-80, 150, 45);
    kickOffButton.layer.cornerRadius = 3.0;
    [kickOffButton setTitle:@"立即开启理财人生" forState:UIControlStateNormal];
    [kickOffButton setBackgroundColor:[UIColor yellowColor]];
    kickOffButton.alpha = 0.75;
    [kickOffButton setTitleColor:TB_COLOR_NARMAL forState:UIControlStateNormal];
    [kickOffButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:kickOffButton];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-25);
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = TEXT_COLOR_BLUE;
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:_pageControl];

}


//开始按钮响应事件
- (void)startButtonPressed
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"isFirstLaunch" forKey:@"isFirstLaunch"];
    [userDefault synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];

}



#pragma mark - UISvrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}


@end
