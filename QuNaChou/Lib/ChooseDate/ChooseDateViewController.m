//
//  ViewController.m
//  CHTCalendar
//
//  Created by risenb_mac on 16/8/9.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "CHTCalendarView.h"

@interface ChooseDateViewController ()<CHTCalendarViewDelegate>

@property (nonatomic, strong) CHTCalendarView *calendar;
@property (nonatomic, strong) NSArray *colorTitlesArray;
@property (nonatomic, copy) NSString *currentColorTitle;

@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"日期选择"];
//    self.navigationController.navigationBar.translucent = NO;
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0, 0, 50, 30);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:TEXT_COLOR_BLUE forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBarButton];
    
    
    CHTCalendarView *calendarView = [[CHTCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.width)];
    [self.view addSubview:calendarView];
    self.calendar = calendarView;
    self.calendar.delegate = self;
//    [self setupViews];
    calendarView.markedDays = @[@"20160802",@"20160803",@"20160804", @"20160808",@"20160809",@"20160812", @"20160816",@"20160823"];
    calendarView.dayCornerRadius = 20;
    calendarView.weekendDayColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    calendarView.workingDayColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    calendarView.dayFilledColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    calendarView.markedDayFilledColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:0.5];
    calendarView.markedDayColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [calendarView reloadInterface];
}
   
- (void)CollectButton:(NSString *)date{
    
    for (NSString *str in _calendar.markedDays) {
        if ([str isEqual:date]) {
            ZPLog(@"%@",date);
            if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseDateViewController:ChoseDate:)]) {
    
                [self.delegate ChooseDateViewController:self ChoseDate:date];
                return;
            }
        }
    }

        ZPLog(@"该日期不可选");
}


- (void)cancelButtonDown:(UIBarButtonItem *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseDateViewController:)]) {
        
        [self.delegate ChooseDateViewController:self];
    }
}

@end
