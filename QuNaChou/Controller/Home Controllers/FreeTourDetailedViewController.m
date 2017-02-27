//
//  FreeTourDetailedViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/30.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "FreeTourDetailedViewController.h"
//#import "PrefixHeader.pch"
#import "LianLianPayViewController.h"
#import "BindBankCardViewController.h"
#import "UserLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "GYZChooseCityController.h"
#import "SVProgressHUD.h"
#import "ReminderLoginView.h"
#import "RegisterViewController.h"
#import "ChooseDateViewController.h"

@interface FreeTourDetailedViewController () <GYZChooseCityDelegate,ChooseDateViewControllerDelegate,ReminderLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;

@property (strong, nonatomic) IBOutlet UILabel *PhoneNumberLab;

@property (weak, nonatomic) IBOutlet UIView *BuyView;
@property (weak, nonatomic) IBOutlet UILabel *StartPlaceLab;  //出发地点
@property (weak, nonatomic) IBOutlet UILabel *StartTimeLab;   //出游日期
@property (weak, nonatomic) IBOutlet UILabel *BuyWayLab;  //购买方式
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;


@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *Lab1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *Lab2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *Lab3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *Lab4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *Lab5;

//@property(nonatomic, strong)UIView *BGView;
@property (strong, nonatomic) IBOutlet UIView *BGView;

@property(nonatomic,strong)UIButton *CancleButton;
@property(nonatomic, strong)MBProgressHUD *hud;
@property(nonatomic, strong) NSString *money;
@property(nonatomic, strong) NSString *city;

@property (nonatomic, strong) UIView *BuyWayWiew;
//@property(nonatomic, strong)UIView *BGView2;
@property (nonatomic, strong)UIButton *CancleButton2;
@property (nonatomic, strong)UILabel *UseMoneyLab;
@property (nonatomic, strong)UILabel *UseCurrentLab;
@property (nonatomic, strong)UILabel *CardMoneyLab;
@property (nonatomic, strong)UIButton *ConfirmButton2;

@property (nonatomic, strong) ReminderLoginView *RemindLogin;
@property (nonatomic, strong) ReminderLoginView *RemindBound;
@property (nonatomic, strong) UIButton *LoginCancleButton;
@property (nonatomic, strong) UIButton *BoundCancleButton;

@property (nonatomic, assign)BOOL UseMoney;
@property (nonatomic, assign) BOOL UseCurrent;
@property (nonatomic, assign)BOOL useCard;
@property(nonatomic, strong)NSString *type;

@end

@implementation FreeTourDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    _money = @"20000";
    _type = @"12";
    
    [self creatView];  //初始化购买方式界面
    [self initRemindLogin];  //初始化提醒登录界面
    [self initRemindBound];  //初始化提醒邦卡界面
    
}

- (void)viewWillAppear:(BOOL)animated{
    
//    _BGView.hidden = YES;
//    _BuyView.hidden = YES;
//    _CancleButton.hidden = YES;
//    _RemindLogin.hidden = YES;
//    _LoginCancleButton.hidden = YES;
//    _BoundCancleButton.hidden = YES;
//    _RemindBound.hidden = YES;
//    _BuyWayWiew.hidden = YES;
//    _CancleButton2.hidden = YES;
//    _scrollview.userInteractionEnabled = YES;
//    
    //判断是否登录
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        [_JoinButton setTitle:@"登陆后加入" forState:UIControlStateNormal];
    }
    else{
        [_JoinButton setTitle:@"加入" forState:UIControlStateNormal];
    }

    //出发地点
    if (_city) {
        _StartPlaceLab.text = [NSString stringWithFormat:@"%@",_city];
    }
    
    //请求网络
    [self Requestnetwork];
}

- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"http://waptest.licaidabai.com/Home/Api/lookinfo/rid/6355aeedab96a323a5b040de07cdc6dc/uid/%@/style/2.html",uid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:1.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];

    [manager GET:baseUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        ZPLog(@"%@",dic);
                 
        _UseMoneyLab.text = [dic objectForKey:@"keyongyue"];
        _UseCurrentLab.text = [dic objectForKey:@"huoqibao"];
       
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
}
    

//选择出发地点按钮
- (IBAction)StarPlaceButton:(id)sender {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    cityPickerVC.delegate = self;
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
    
}


//选择出发时间按钮
- (IBAction)StartTimeButton:(id)sender {
   
    ChooseDateViewController *chooseDateVC = [[ChooseDateViewController alloc] init];
    chooseDateVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:chooseDateVC] animated:YES completion:nil];
}


//购买方式按钮点击事件
- (IBAction)BuyWayButton:(id)sender {
    
    _BuyView.hidden = YES;
    _CancleButton.hidden = YES;
    _BuyWayWiew.hidden = NO;
    _BGView.hidden  = NO;
    _CancleButton2.hidden = NO;
    
    CGFloat card = [_money doubleValue] - [[_UseMoneyLab.text substringFromIndex:2] doubleValue] - [[_UseCurrentLab.text substringFromIndex:2] doubleValue];
    if (card >= 0) {
        _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",card];
    }
    else{
        _CardMoneyLab.text = @"¥ 0.00";
    }
}


//打电话功能
- (IBAction)CallPhoneButton:(id)sender {
    
    NSString *phoneNum = _PhoneNumberLab.text;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    UIWebView * phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}


//加入按钮点击
- (IBAction)JoinButton:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        
        _scrollview.userInteractionEnabled = NO;
        _BGView.hidden = NO;
        _BuyView.hidden = NO;
        _CancleButton.hidden = NO;
    }
    else{
        
        _BGView.hidden = _RemindLogin.hidden = _LoginCancleButton.hidden = NO;
    }
}


//确定按钮1点击
- (IBAction)ConfirmButtonClicked:(id)sender {
    
    [self JudgeCanBuy];
}


//确定按钮2点击
- (void)ConfirmButton2Clicked:(UIButton *)button{
    
    [self JudgeCanBuy];
}

- (void)JudgeCanBuy{
    
    ZPLog(@"确认购买～～～");
    //判断是否绑卡
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCard"]) {
        
        _BoundCancleButton.hidden = NO;
        _RemindBound.hidden = NO;
        _BGView.hidden = NO;
        _BuyView.hidden = YES;
        _CancleButton.hidden = YES;
        return;
    }
    //判断是否选择出发城市
    if ([_StartPlaceLab.text isEqualToString:@"点击选择出发城市"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲，请选择出发城市！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //判断是否选择出发时间
    if ([_StartTimeLab.text isEqualToString:@"点击选择出游日期"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲，请选择出发时间！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    else{
        [self ConfirmBuy];
    }
}



- (void)ConfirmBuy{
    
    LianLianPayViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LianLianPayViewController"];
    VC.type = _type;
    VC.money = _money;
    if (_UseMoney == YES) {
        CGFloat kyye = [[_UseMoneyLab.text substringFromIndex:2] doubleValue];
        if ([_money doubleValue] > kyye) {
            VC.kyye = [NSString stringWithFormat:@"%.2f",kyye];
        }
        else{
            VC.kyye = _money;
        }
    }
    else{
        VC.kyye = @"0";
    }
    if (_UseCurrent  == YES) {
        CGFloat hqb = [[_UseCurrentLab.text substringFromIndex:2] doubleValue];
        if ([_money doubleValue] - [VC.kyye doubleValue] > hqb) {
            VC.hqb = [_UseCurrentLab.text substringFromIndex:2];
        }
        else{
            VC.hqb = [NSString stringWithFormat:@"%.2f",[_money doubleValue] - [VC.kyye doubleValue]];
        }
    }
    else{
        VC.hqb = @"0";
    }
    if (_useCard == YES) {
        CGFloat card = [_money doubleValue]-[VC.kyye doubleValue]-[VC.hqb doubleValue];
        if (card < 0) {
            VC.card = @"0";
        }
        else{
            VC.card = [NSString stringWithFormat:@"%.2f",card];
        }
    }
    else{
        VC.card = @"0";
    }
    if ([_money doubleValue] == [VC.kyye doubleValue]+[VC.hqb doubleValue]+[VC.card doubleValue]) {
        
        ZPLog(@"%@    %@   %@     %@",VC.money, VC.kyye, VC.hqb,VC.card);
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
        [_hud hide:YES];
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"金额有误";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
    }
}


//取消按钮点击
- (void)CancleButtonClicked:(UIButton *)button{
    
    if (_BuyView.hidden == NO) {
        _BuyView.hidden = YES;
        _BGView.hidden = YES;
        _CancleButton.hidden = YES;
        _scrollview.userInteractionEnabled = YES;
    }
    else{
        _BuyWayWiew.hidden = YES;
        _CancleButton2.hidden = YES;
        _BuyView.hidden = NO;
        _BGView.hidden = NO;
        _CancleButton.hidden = NO;
        _scrollview.userInteractionEnabled = NO;
        
        if (_UseMoney == YES ) {
            if (_UseCurrent == YES) {
                if (_useCard == YES) {
                    _BuyWayLab.text = @"可用余额＋活期转入＋银行卡支付";
                }
                else{
                    _BuyWayLab.text = @"可用余额＋活期转入";
                }
            }
            else{
                if (_useCard == YES) {
                    _BuyWayLab.text = @"可用余额＋银行卡支 付";
                }
                else{
                    _BuyWayLab.text = @"可用余额";
                }
            }
        }
        else{
            if (_UseCurrent == YES) {
                if (_useCard == YES) {
                    _BuyWayLab.text = @"活期转入＋银行卡支付";
                }
                else{
                    _BuyWayLab.text = @"活期转入";
                }
            }
            else{
                if (_useCard == YES) {
                    _BuyWayLab.text = @"银行卡支付";
                }
                else{
                    _BuyWayLab.text = @"请选择购买方式";
                }
            }
        }
    }
    
}


//返回
- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//选择理财期限
- (IBAction)ButtonClicked:(UIButton *)button {
    
    if (button.tag == 2211) {
        _image1.alpha = _Lab2
        .alpha = _Lab3.alpha = _Lab4.alpha = _Lab5.alpha = 1;
        _image2.alpha = _image3.alpha = _image4.alpha = _image5.alpha = _Lab1.alpha = 0;
        
        [_ConfirmButton setTitle:@"理财40000元 30天免单                      确定" forState:UIControlStateNormal];
        _type = @"8";
        _money = @"40000";
    }
    if (button.tag == 2212) {
     _image2.alpha = _Lab1.alpha = _Lab3.alpha = _Lab4.alpha =  _Lab5.alpha = 1;

        _image1.alpha = _Lab2.alpha =  _image3.alpha = _image4.alpha = _image5.alpha =0;
        _type = @"9";
        [_ConfirmButton setTitle:@"理财35000元 90天免单                      确定" forState:UIControlStateNormal];
        _money = @"35000";

    }
    if (button.tag == 2213) {
        _image3.alpha = _Lab1.alpha = _Lab2.alpha = _Lab4.alpha =  _Lab5.alpha = 1;

        _image1.alpha = _Lab3.alpha =  _image2.alpha = _image4.alpha = _image5.alpha =0;
        _type = @"10";
        [_ConfirmButton setTitle:@"理财30000元 180天免单                      确定" forState:UIControlStateNormal];
        _money = @"30000";

    }
    if (button.tag == 2214) {

        _image4.alpha = _Lab1.alpha = _Lab2.alpha = _Lab3.alpha =  _Lab5.alpha = 1;

        _image1.alpha = _Lab4.alpha =  _image2.alpha = _image3.alpha = _image5.alpha =0;
        _type = @"11";
        [_ConfirmButton setTitle:@"理财25000元 270天免单                  确定" forState:UIControlStateNormal];
        _money = @"25000";

    }
    if (button.tag == 2215) {
        _image5.alpha = _Lab1.alpha = _Lab3.alpha = _Lab4.alpha =  _Lab2.alpha = 1;
        _image1.alpha = _Lab5.alpha =  _image3.alpha = _image4.alpha = _image2.alpha =0;
        _type = @"12";
        [_ConfirmButton setTitle:@"理财20000元 360天免单                      确定" forState:UIControlStateNormal];
        _money = @"20000";

    }
}



//定位后返回位置
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    //保存位置信息
    _city = city.cityName;
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}



- (void)ChooseDateViewController:(ChooseDateViewController *)chooseDateController ChoseDate:(NSString *)date{

    _StartTimeLab.text = date;
    [chooseDateController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ChooseDateViewController:(ChooseDateViewController *)chooseDateController{
    
    [chooseDateController dismissViewControllerAnimated:YES completion:nil];

}


//初始化购买方式界面
- (void)creatView{
    
    _CancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton.frame = CGRectMake(SCREEN_WIDTH-50, _BuyView.frame.origin.y-50-64, 34, 34);
    [_CancleButton setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton addTarget:self action:@selector(CancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton];
    
    _BuyWayWiew = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-305-64, SCREEN_WIDTH, 305)];
    _BuyWayWiew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _BuyWayWiew];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    image1.image = [UIImage imageNamed:@"icon4TQ"];
    [_BuyWayWiew addSubview:image1];
    
    UILabel *usable = [[UILabel alloc] initWithFrame:CGRectMake(image1.frame.size.width+image1.frame.origin.x+10, image1.frame.origin.y-10, 100, 15)];
    usable.text = @"可用余额";
    usable.font = [UIFont systemFontOfSize:12];
    usable.textColor = TB_COLOR_RED;
    [_BuyWayWiew addSubview:usable];
    
    _UseMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(usable.frame.origin.x, usable.frame.origin.y+20, 100,15)];
    _UseMoneyLab.text = @"¥0.00";
    _UseMoneyLab.font = [UIFont systemFontOfSize:12];
    _UseMoneyLab.textColor = TEXT_COLOR_GRAY;
    [_BuyWayWiew addSubview:_UseMoneyLab];
    
    _UseMoney = YES;
    UIButton *usableMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    usableMoneyButton.frame = CGRectMake(SCREEN_WIDTH-50, 20, 24, 24);
    [usableMoneyButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [usableMoneyButton addTarget:self action:@selector(usableMoneyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyWayWiew addSubview:usableMoneyButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, _UseMoneyLab.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = TB_COLOR_GRAY;
    [_BuyWayWiew addSubview:line];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line.frame.origin.y+20, 20, 20)];
    image2.image = [UIImage imageNamed:@"icon1DC_"];
    [_BuyWayWiew addSubview:image2];
    
    UILabel *current = [[UILabel alloc] initWithFrame:CGRectMake(image2.frame.size.width+image2.frame.origin.x+10, image2.frame.origin.y-10, 100, 15)];
    current.text = @"活期宝转入";
    current.font = [UIFont systemFontOfSize:12];
    current.textColor = TB_COLOR_RED;
    [_BuyWayWiew addSubview:current];
    
    _UseCurrentLab = [[UILabel alloc] initWithFrame:CGRectMake(current.frame.origin.x, current.frame.origin.y+20, 200,15)];
    _UseCurrentLab.text = @"¥0.00";
    _UseCurrentLab.font = [UIFont systemFontOfSize:12];
    _UseCurrentLab.textColor = TEXT_COLOR_GRAY;
    [_BuyWayWiew addSubview:_UseCurrentLab];
    
    _UseCurrent = YES;
    UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    currentButton.frame = CGRectMake(SCREEN_WIDTH-50, line.frame.origin.y+20, 24, 24);
    [currentButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [currentButton addTarget:self action:@selector(currentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyWayWiew addSubview:currentButton];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _UseCurrentLab.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line2.backgroundColor = TB_COLOR_GRAY;
    [_BuyWayWiew addSubview:line2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line2.frame.origin.y+20, 20, 20)];
    image3.image = [UIImage imageNamed:@"icon5TQ"];
    [_BuyWayWiew addSubview:image3];
    
    UILabel *card = [[UILabel alloc] initWithFrame:CGRectMake(image3.frame.size.width+image3.frame.origin.x+10, image3.frame.origin.y-10, 100, 15)];
    card.text = @"银行卡";
    card.font = [UIFont systemFontOfSize:12];
    card.textColor = TB_COLOR_RED;
    [_BuyWayWiew addSubview:card];
    
    UILabel *cardInfor = [[UILabel alloc] initWithFrame:CGRectMake(card.frame.origin.x, card.frame.origin.y+20, 200,15)];
    cardInfor.text = @"招行＊＊8888（储蓄）";
    cardInfor.font = [UIFont systemFontOfSize:12];
    cardInfor.textColor = TEXT_COLOR_GRAY;
    [_BuyWayWiew addSubview:cardInfor];
    
    _useCard = YES;
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cardButton.frame = CGRectMake(SCREEN_WIDTH-50, line2.frame.origin.y+20, 24, 24);
    [cardButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyWayWiew addSubview:cardButton];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, cardInfor.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line3.backgroundColor = TB_COLOR_GRAY;
    [_BuyWayWiew addSubview:line3];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line3.frame.origin.y+15, 20, 20)];
    image4.image = [UIImage imageNamed:@"icon6TQ"];
    [_BuyWayWiew addSubview:image4];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(image4.frame.size.width+image4.frame.origin.x+10, image4.frame.origin.y+2, 100, 15)];
    money.text = @"银行卡加入总金额";
    money.font = [UIFont systemFontOfSize:12];
    money.textColor = TB_COLOR_RED;
    [_BuyWayWiew addSubview:money];
    
    _CardMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(money.frame.origin.x, image4.frame.origin.y+image4.frame.size.height+5, SCREEN_WIDTH-40, 20)];
    _CardMoneyLab.text = @"¥0.00";
    _CardMoneyLab.font = [UIFont systemFontOfSize:12];
    _CardMoneyLab.textColor = TEXT_COLOR_RED;
    [_BuyWayWiew addSubview:_CardMoneyLab];
    
    UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(0, _CardMoneyLab.frame.origin.y+_CardMoneyLab.frame.size.height, SCREEN_WIDTH, 30)];
    remind.text = @"市场有风险，投资需谨慎";
    remind.textColor = TEXT_COLOR_GRAY;
    remind.textAlignment = NSTextAlignmentCenter;
    remind.font = [UIFont systemFontOfSize: 11];
    [_BuyWayWiew addSubview:remind];
    
    _ConfirmButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton2.backgroundColor = TB_COLOR_RED;
    _ConfirmButton2.frame = CGRectMake(0,_BuyWayWiew.frame.size.height-44 , SCREEN_WIDTH, 44);
    [_ConfirmButton2 setTitle:@"确定" forState:UIControlStateNormal];
    [_ConfirmButton2 addTarget:self action:@selector(ConfirmButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyWayWiew addSubview:_ConfirmButton2];

    _CancleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton2.frame = CGRectMake(SCREEN_WIDTH-50, _BuyWayWiew.frame.origin.y-50, 34, 34);
    [_CancleButton2 setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton2 addTarget:self action:@selector(CancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton2];
    
    
    _scrollview.userInteractionEnabled = YES;
    _BuyView.hidden = YES;
    _BGView.hidden = YES;
    _CancleButton.hidden = YES;
    _BuyWayWiew.hidden = YES;
    _CancleButton2.hidden = YES;
    

}


//是否选择可用余额
- (void)usableMoneyButtonClicked:(UIButton *)button{
    CGFloat card = [_money doubleValue] - [[_UseCurrentLab.text substringFromIndex:2] doubleValue];
    if (_UseMoney == YES) {
        _UseMoney = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        if (_UseCurrent == YES) {
            if (card > 0) {
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",card];
            }
            else{
                _CardMoneyLab.text = @"¥ 0.00";
            }
        }
        else{
            _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f", [_money doubleValue]];
        }
    }
    else{
        _UseMoney = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        if (_UseCurrent == YES) {
            
            CGFloat money = [[_CardMoneyLab.text substringFromIndex:2] doubleValue]-[[_UseMoneyLab.text substringFromIndex:2] doubleValue];
            if ( money > 0) {
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",money];
            }
            else{
                _CardMoneyLab.text = @"¥ 0.00";
            }
        }
        else{
            CGFloat card = [_money doubleValue] - [[_UseMoneyLab.text substringFromIndex:2] doubleValue];
            if (card > 0) {
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",card];
            }
            else{
                _CardMoneyLab.text = @"¥ 0.00";
            }
        }
    }
    if (_useCard == NO) {
        _CardMoneyLab.text = @"¥ 0.00";
    }
}

//是否选择活期资产
- (void)currentButtonClicked:(UIButton *)button{
    CGFloat card = [_money doubleValue] - [[_UseMoneyLab.text substringFromIndex:2] doubleValue];
    if (_UseCurrent == YES) {
        _UseCurrent = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        if (_UseMoney == YES) {
            if (card > 0) {
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",card];
            }
            else{
                _CardMoneyLab.text = @"¥ 0.00";
            }
        }
        else{
            _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[_money doubleValue]];
        }
    }
    else{
        _UseCurrent = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        if (_UseMoney == YES) {
            CGFloat money = [[_UseCurrentLab.text substringFromIndex:2] doubleValue]+[[_UseMoneyLab.text substringFromIndex:2] doubleValue];
            if (money > [_money doubleValue]) {
                _CardMoneyLab.text = @"¥ 0.00";
            }
            else{
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[_money doubleValue]-money];
            }
        }
        else{
            CGFloat money = [_money doubleValue]-[[_UseCurrentLab.text substringFromIndex:2] doubleValue];
            if (money > 0) {
                _CardMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f",money];
            }
            else{
                _CardMoneyLab.text = @"¥ 0.00";
            }
        }
    }
    if (_useCard == NO) {
        _CardMoneyLab.text = @"¥ 0.00";
    }
    
}


//是否选择银行卡
- (void)cardButtonClicked:(UIButton *)button{
    if (_useCard == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        _useCard = NO;
        _CardMoneyLab.text = @"¥ 0.00";
    }
    else {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        _useCard = YES;

    }
}


//初始化提醒登录界面
- (void)initRemindLogin{
    
    _RemindLogin = [[ReminderLoginView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-200)/2-64, SCREEN_WIDTH-20, 200) Style:@"Login"];
    _RemindLogin.delegate = self;
    [self.view addSubview:_RemindLogin];
    
    _LoginCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _LoginCancleButton.frame = CGRectMake(SCREEN_WIDTH-60, _RemindLogin.frame.origin.y-50, 34, 34);
    [_LoginCancleButton setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_LoginCancleButton addTarget:self action:@selector(LoginCancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LoginCancleButton];
    
    _RemindLogin.hidden = YES;
    _LoginCancleButton.hidden = YES;
}

//初始化提醒绑卡界面
- (void)initRemindBound{
    
    _RemindBound = [[ReminderLoginView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-200)/2-64, SCREEN_WIDTH-20, 200) Style:@"Bound"];
    _RemindBound.delegate = self;
    [self.view addSubview:_RemindBound];
    
    _BoundCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _BoundCancleButton.frame = CGRectMake(SCREEN_WIDTH-60, _RemindBound.frame.origin.y-50, 34, 34);
    [_BoundCancleButton setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_BoundCancleButton addTarget:self action:@selector(BoundCancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_BoundCancleButton];
    
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
    
    
}


//提醒登录界面取消按钮
- (void)LoginCancleButtonClicked{
    
    _BGView.hidden = YES;
    _RemindLogin.hidden = YES;
    _LoginCancleButton.hidden = YES;
}


//提醒绑卡界面取消按钮
- (void)BoundCancleButtonClicked{
    
    _BGView.hidden = YES;
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
    _scrollview.userInteractionEnabled = YES;
}


#pragma mark  ReminderLoginViewDelegate
//登录
- (void)Login{
    
    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:VC] animated:YES completion:nil];
}

//注册
-(void)Register{
    
    RegisterViewController *registVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registVC] animated:YES completion:nil];
}

//绑卡
- (void)Bound{
    
    ZPLog(@"bangka");
    BindBankCardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
    VC.VCID = @"FreeTourViewController";
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)dismissDelayed
{
    [SVProgressHUD dismiss];
}


@end
