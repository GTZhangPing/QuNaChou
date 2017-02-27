//
//  LuckView.m
//  Lottery
//
//  Created by 张平 on 16/8/5.
//  Copyright © 2016年 张平. All rights reserved.
//

#import "LuckView.h"
#import "UIImageView+WebCache.h"

@interface LuckView (){
    
    NSTimer *startTime;
    int currenTime;
    int stopTime;
    int result;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    UIButton *button7;
    UIButton *button8;
    UIButton *button9;
    UIButton *button10;
    UIButton *button11;

    
}
@property (nonatomic, strong) NSArray *BtnArray;
@property (nonatomic, assign) CGFloat Time;

@end


@implementation LuckView

- (NSArray *)BtnArray{
    
    if (!_BtnArray) {
        _BtnArray = [NSArray array];
    }
    return _BtnArray;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        currenTime = 0;
        _Time = 0.1;
        stopTime = 59+_stopCount;
    }
    return self;
}


- (void)setStopCount:(int)stopCount{
    
    _stopCount = stopCount;
    stopTime = 59 + _stopCount;
}

- (void)setLabArray:(NSArray *)labArray{
    _LabArray = labArray;
}

- (void)setImageArray:(NSArray *)ImageArray{
    
    _canUse = YES;
    _ImageArray = ImageArray;
//    float orginX = 0;
//    float orginY = 0;
    float space = 4;
    float cellWidth = (self.bounds.size.width-space*3)/4;
    float cellHeight = cellWidth;
    
    self.StartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _StartButton.frame = CGRectMake(cellWidth+space, cellHeight+space, cellWidth*2+space, 100);
    [_StartButton setBackgroundImage:[UIImage imageNamed:@"YPbutton1"] forState:UIControlStateNormal];
    _StartButton.layer.cornerRadius = 10;
    [_StartButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_StartButton];
    
    _AgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _AgainButton.frame = CGRectMake(cellWidth+space, _StartButton.frame.size.height+cellHeight+space*2, cellWidth*2+space, 38);
    [_AgainButton setBackgroundImage:[UIImage imageNamed:@"YPbutton2"] forState:UIControlStateNormal];
    //    [_againButton addTarget:self action:@selector(prepareLotteryAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_AgainButton];
    
    button0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    [self addSubview:button0];
    button1 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth+space, 0, cellWidth, cellHeight)];
    [self addSubview:button1];
    button2 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*2+space*2, 0, cellWidth, cellHeight)];
    [self addSubview:button2];
    button3 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*3+space*3, 0, cellWidth, cellHeight)];
    [self addSubview:button3];
    button4 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*3+space*3, cellHeight+space, cellWidth, cellHeight)];
    [self addSubview:button4];
    button5 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*3+space*3, (cellHeight+space)*2, cellWidth, cellHeight)];
    [self addSubview:button5];
    button6 = [[UIButton alloc]initWithFrame:CGRectMake(cellWidth*3+space*3, (cellHeight+space)*3, cellWidth, cellWidth)];
    [self addSubview:button6];
    button7 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*2+space*2, (cellHeight+space)*3, cellWidth, cellHeight)];
    [self addSubview:button7];
    button8 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*1+space*1, (cellHeight+space)*3, cellWidth, cellHeight)];
    [self addSubview:button8];
    button9 = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth*0+space*0, (cellHeight+space)*3, cellWidth, cellHeight)];
    [self addSubview:button9];
    button10=[[UIButton alloc] initWithFrame:CGRectMake(cellWidth*0+space*0, (cellHeight+space)*2, cellWidth, cellHeight)];
    [self addSubview:button10];
    button11=[[UIButton alloc] initWithFrame:CGRectMake(0, (cellHeight+space), cellWidth, cellHeight)];
    [self addSubview:button11];
    
    
    self.BtnArray = [NSMutableArray arrayWithObjects:button0,button1,button2,button3,button4,button5,button6,button7,button8,button9,button10,button11, nil];
    
    for (int j = 0; j < _ImageArray.count; j++) {
        UIButton *button = [[UIButton alloc] init];
        button = [self.BtnArray objectAtIndex:j];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(button.bounds.origin.x, button.bounds.origin.y, cellWidth, cellHeight)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addSubview:imageview];
        [imageview sd_setImageWithURL:[_ImageArray objectAtIndex:j] placeholderImage:nil];
        
        UILabel *Lab = [[UILabel alloc]initWithFrame:CGRectMake(button.bounds.origin.x, cellHeight-20, cellWidth, 20)];
        Lab.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:155.0/255.0 alpha:1];
        Lab.textColor = [UIColor whiteColor];
        Lab.font=[UIFont systemFontOfSize:10];
        Lab.alpha = 0.8;
        Lab.layer.cornerRadius = 5;
        Lab.layer.masksToBounds = YES;
        Lab.textAlignment = NSTextAlignmentCenter;
        Lab.text = [_LabArray objectAtIndex:j];
        [button addSubview:Lab];
    }
}


- (void)btnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(startButton:)]) {
        [self.delegate startButton:btn];
    }
    if (_canUse == YES) {
        //点击开始抽奖
        currenTime = result;
        self.Time = 0.1;
        stopTime = 59 + self.stopCount % 12;
        [self.StartButton setEnabled:NO];
        
        startTime = [NSTimer scheduledTimerWithTimeInterval:self.Time target:self selector:@selector(Go:) userInfo:nil repeats:YES];
    }

    
}


- (void)Go:(NSTimer *)timer{
                      
    UIButton *oldBtn = [self.BtnArray objectAtIndex:currenTime % self.BtnArray.count];
    UIImageView  *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(oldBtn.bounds.origin.x, oldBtn.bounds.origin.y, oldBtn.bounds.size.width, oldBtn.bounds.size.height)];
    [oldBtn addSubview:imageview];
    [imageview sd_setImageWithURL:[_ImageArray objectAtIndex:currenTime % self.BtnArray.count] placeholderImage:nil];

    UILabel *Lab = [[UILabel alloc] initWithFrame:CGRectMake(oldBtn.bounds.origin.x, oldBtn.bounds.size.height-20, oldBtn.bounds.size.width, 20)];
    Lab.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:163.0/255.0 blue:155.0/255.0 alpha:1];
    Lab.textColor = [UIColor whiteColor];
    Lab.alpha = 0.8;
    Lab.layer.cornerRadius = 5;
    Lab.layer.masksToBounds = YES;
    Lab.text = [_LabArray objectAtIndex:currenTime % self.LabArray.count];
    [oldBtn addSubview:Lab];
    Lab.font=[UIFont systemFontOfSize:10];
    Lab.textAlignment = NSTextAlignmentCenter;
    currenTime++;
    
    UIButton *Btn = [self.BtnArray objectAtIndex:currenTime %self.BtnArray.count];
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(Btn.bounds.origin.x, Btn.bounds.origin.y, Btn.bounds.size.width, Btn.bounds.size.height)];
    [Btn addSubview:imageview2];
    imageview2.backgroundColor = [UIColor blackColor];
    imageview2.alpha = 0.2;
    
    if (currenTime > stopTime) {
        [timer invalidate];
        [self.StartButton setEnabled:YES];
        result = currenTime%self.BtnArray.count;
        [self stopWithCount:currenTime%self.BtnArray.count];
        
        return;
    }
    
    if (currenTime > stopTime -10) {
        self.Time += 0.1;
        [timer invalidate];
        
        startTime = [NSTimer scheduledTimerWithTimeInterval:self.Time target:self selector:@selector(Go:) userInfo:nil repeats:YES];
    }
}



- (void)stopWithCount:(NSInteger)count {
    if ([self.delegate respondsToSelector:@selector(luckViewDidStopWithArrayCount:)]) {
        [self.delegate luckViewDidStopWithArrayCount:count];
    }
}



- (void)dealloc {
    //    [imageTimer invalidate];
    [startTime invalidate];
}
@end
