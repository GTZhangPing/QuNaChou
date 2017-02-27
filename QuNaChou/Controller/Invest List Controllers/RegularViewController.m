//
//  RegularViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/23.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "RegularViewController.h"
//#import "PrefixHeader.pch"
#import "LianLianPayViewController.h"
#import "BindBankCardViewController.h"
#import "UserLoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "ReminderLoginView.h"
#import "RegisterViewController.h"


@interface RegularViewController ()<UITextFieldDelegate,ReminderLoginViewDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *TopView;

@property (strong, nonatomic) IBOutlet UILabel *shouyi;

@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *BaseEarnings;
@property (strong, nonatomic) IBOutlet UILabel *PrerogativeEarnings;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;

@property (strong, nonatomic) IBOutlet UILabel *Label1;
@property (strong, nonatomic) IBOutlet UILabel *Label2;
@property (strong, nonatomic) IBOutlet UILabel *Label3;
@property (strong, nonatomic) IBOutlet UILabel *Label4;
@property (strong, nonatomic) IBOutlet UILabel *Label5;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;

@property (strong, nonatomic) IBOutlet UILabel *ljsyLab;
@property (strong, nonatomic) IBOutlet UILabel *zsyLab;

@property (nonatomic, strong) ReminderLoginView *RemindLogin;
@property (nonatomic, strong) ReminderLoginView *RemindBound;
@property (nonatomic, strong) UIButton *LoginCancleButton;
@property (nonatomic, strong) UIButton *BoundCancleButton;

@property(nonatomic, strong)UIView *BuyView;
@property(nonatomic, strong)UIButton *CancleButton;
@property(nonatomic, strong)UIView *BGView;
@property(nonatomic, strong)UILabel *UseMoneyLab;
@property(nonatomic, strong)UILabel *CardInfo;
@property(nonatomic, strong)UILabel *UseCurrentLab;

@property(nonatomic, strong)UITextField *MoneyField;
@property(nonatomic, strong)UIButton *ConfirmButton;


@property (nonatomic, assign)BOOL UseMoney;
@property (nonatomic, assign) BOOL UseCurrent;
@property (nonatomic, assign)BOOL useCard;
@property(nonatomic, strong)NSString *type;
@property (nonatomic, strong) NSString *code;

@property(nonatomic, strong)NSString *type3;
@property(nonatomic, strong)NSString *type4;
@property(nonatomic, strong)NSString *type5;
@property(nonatomic, strong)NSString *type6;
@property(nonatomic, strong)NSString *type7;
@property(nonatomic, strong)NSString *add;





@end

@implementation RegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatView];
    
    [self initRemindLogin];
    [self initRemindBound];
}


- (void)viewWillAppear:(BOOL)animated{
    
    _BGView.hidden = YES;
    _BuyView.hidden = YES;
    _CancleButton.hidden = YES;
    _RemindLogin.hidden = YES;
    _LoginCancleButton.hidden = YES;
    _BoundCancleButton.hidden = YES;
    _RemindBound.hidden = YES;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:199.0/255.0 alpha:1]];  //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:TEXT_COLOR_YELLOW, NSForegroundColorAttributeName, [UIFont systemFontOfSize:13], NSFontAttributeName, nil]];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        [_JoinButton setTitle:@"登录后加入" forState:UIControlStateNormal];
        
        _shouyi.text = @"12.0";
        _PrerogativeEarnings.text = @"登陆后查看";
        _PrerogativeEarnings.font = [UIFont systemFontOfSize:14];
        
    }
    else{
        _type = @"7";
        [_JoinButton setTitle:@"加入" forState:UIControlStateNormal];
        _Time.text = @"360天";
        _Time.font = _BaseEarnings.font = _PrerogativeEarnings.font = [UIFont systemFontOfSize:16];
        
        //请求网络
        [self Requestnetwork];
    }
    [self getInterest];
    
    
}


- (void)Requestnetwork{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *baseUrl = [NSString stringWithFormat:@"%@invest/look.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid,
                           @"style":@"2",
                           @"type":@"7"
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            ZPLog(@"%@",dic);
        _zsyLab.text = [dic objectForKey:@"zhzichan"];
        _ljsyLab.text = [dic objectForKey:@"leijishouyi"];
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
    
    NSString *baseUrl2 = [NSString stringWithFormat:@"%@invest/jiaru.html",QNCURL];
    NSDictionary *dict2 = @{@"rid":rid,
                            @"uid":uid
                            };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl2 parameters:dict2 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //        ZPLog(@"%@",dic);
        _code = [dic objectForKey:@"code"];
        _UseMoneyLab.text = [dic objectForKey:@"keyongyue"];
        _CardInfo.text = [NSString stringWithFormat:@"%@***%@",[dic objectForKey:@"bankname"],[dic objectForKey:@"banknum"]];
        _UseCurrentLab.text = [dic objectForKey:@"huoqibao"];
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];

}


- (void)getInterest{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        uid = @"wu";
    }
    NSString *baseUrl = [NSString stringWithFormat:@"%@index/interest.html",QNCURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20.0f];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *dict = @{@"rid":rid,
                           @"uid":uid
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        ZPLog(@"%@",dic);
        NSDictionary *interest = [dic objectForKey:@"common_interest"];
        _add = [dic objectForKey:@"add_interest"];
        _type3 = [interest objectForKey:@"3"];
        _type4 = [interest objectForKey:@"4"];
        _type5 = [interest objectForKey:@"5"];
        _type6 = [interest objectForKey:@"6"];
        _type7 = [interest objectForKey:@"7"];
        
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f%@",[[interest objectForKey:@"7"] doubleValue],@"%"];
        _PrerogativeEarnings.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"add_interest"],@"%"];
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[[interest objectForKey:@"7"] floatValue]+[[dic objectForKey:@"add_interest"] floatValue]];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
            _PrerogativeEarnings.text = @"登陆后查看";
            _PrerogativeEarnings.font = [UIFont systemFontOfSize:14];
        }
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
    
}




- (IBAction)JoinButton:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        
        _BGView.hidden = _RemindLogin.hidden = _LoginCancleButton.hidden = NO;
        
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"]) {
        
        _scrollview.userInteractionEnabled = NO;
        _BGView.hidden = NO;
        _BuyView.hidden = NO;
        _CancleButton.hidden = NO;
        //        return;
    }
    if ([_code isEqual: @"0059"]) {
        
        _BoundCancleButton.hidden = NO;
        _RemindBound.hidden = NO;
        _BGView.hidden = NO;
        _BuyView.hidden = YES;
        _CancleButton.hidden = YES;
        
        return;
    }
}


- (void)creatView{
    
    
    _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0.5;
    [self.view addSubview:_BGView];
    
    _BuyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-320-64, SCREEN_WIDTH, 320)];
    _BuyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BuyView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    image1.image = [UIImage imageNamed:@"icon4TQ"];
    [_BuyView addSubview:image1];
    
    UILabel *usable = [[UILabel alloc] initWithFrame:CGRectMake(image1.frame.size.width+image1.frame.origin.x+10, image1.frame.origin.y-10, 100, 15)];
    usable.text = @"可用余额";
    usable.font = [UIFont systemFontOfSize:12];
    usable.textColor = TB_COLOR_RED;
    [_BuyView addSubview:usable];
    
    _UseMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(usable.frame.origin.x, usable.frame.origin.y+20, 100,15)];
    _UseMoneyLab.text = @"¥0.00";
    _UseMoneyLab.font = [UIFont systemFontOfSize:12];
    _UseMoneyLab.textColor = TEXT_COLOR_GRAY;
    [_BuyView addSubview:_UseMoneyLab];
    
    _UseMoney = YES;
    UIButton *usableMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    usableMoneyButton.frame = CGRectMake(SCREEN_WIDTH-50, 20, 24, 24);
    [usableMoneyButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [usableMoneyButton addTarget:self action:@selector(usableMoneyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyView addSubview:usableMoneyButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, _UseMoneyLab.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = TB_COLOR_GRAY;
    [_BuyView addSubview:line];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line.frame.origin.y+20, 20, 20)];
    image2.image = [UIImage imageNamed:@"icon1DC_"];
    [_BuyView addSubview:image2];
    
    UILabel *current = [[UILabel alloc] initWithFrame:CGRectMake(image2.frame.size.width+image2.frame.origin.x+10, image2.frame.origin.y-10, 100, 15)];
    current.text = @"活期宝转入";
    current.font = [UIFont systemFontOfSize:12];
    current.textColor = TB_COLOR_RED;
    [_BuyView addSubview:current];
    
    _UseCurrentLab = [[UILabel alloc] initWithFrame:CGRectMake(current.frame.origin.x, current.frame.origin.y+20, 200,15)];
    _UseCurrentLab.text = @"¥0.00";
    _UseCurrentLab.font = [UIFont systemFontOfSize:12];
    _UseCurrentLab.textColor = TEXT_COLOR_GRAY;
    [_BuyView addSubview:_UseCurrentLab];
    
    _UseCurrent = YES;
    UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    currentButton.frame = CGRectMake(SCREEN_WIDTH-50, line.frame.origin.y+20, 24, 24);
    [currentButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [currentButton addTarget:self action:@selector(currentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyView addSubview:currentButton];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _UseCurrentLab.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line2.backgroundColor = TB_COLOR_GRAY;
    [_BuyView addSubview:line2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line2.frame.origin.y+20, 20, 20)];
    image3.image = [UIImage imageNamed:@"icon5TQ"];
    [_BuyView addSubview:image3];
    
    UILabel *card = [[UILabel alloc] initWithFrame:CGRectMake(image3.frame.size.width+image3.frame.origin.x+10, image3.frame.origin.y-10, 100, 15)];
    card.text = @"银行卡";
    card.font = [UIFont systemFontOfSize:12];
    card.textColor = TB_COLOR_RED;
    [_BuyView addSubview:card];
    
    _CardInfo = [[UILabel alloc] initWithFrame:CGRectMake(card.frame.origin.x, card.frame.origin.y+20, 200,15)];
//    cardInfor.text = @"招行＊＊8888（储蓄）";
    _CardInfo.font = [UIFont systemFontOfSize:12];
    _CardInfo.textColor = TEXT_COLOR_GRAY;
    [_BuyView addSubview:_CardInfo];
    
    _useCard = YES;
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cardButton.frame = CGRectMake(SCREEN_WIDTH-50, line2.frame.origin.y+20, 24, 24);
    [cardButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyView addSubview:cardButton];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, _CardInfo.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line3.backgroundColor = TB_COLOR_GRAY;
    [_BuyView addSubview:line3];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line3.frame.origin.y+15, 20, 20)];
    image4.image = [UIImage imageNamed:@"icon6TQ"];
    [_BuyView addSubview:image4];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(image4.frame.size.width+image4.frame.origin.x+10, image4.frame.origin.y+2, 100, 15)];
    money.text = @"加入总金额";
    money.font = [UIFont systemFontOfSize:12];
    money.textColor = TB_COLOR_RED;
    [_BuyView addSubview:money];
    
    _MoneyField = [[UITextField alloc] initWithFrame:CGRectMake(image4.frame.origin.x, image4.frame.origin.y+image4.frame.size.height+5, SCREEN_WIDTH-40, 44)];
    _MoneyField.placeholder = @"输入加入金额";
    _MoneyField.font = [UIFont systemFontOfSize:16];
    _MoneyField.layer.cornerRadius = 5;
    _MoneyField.layer.borderColor = TB_COLOR_RED.CGColor;
    _MoneyField.layer.borderWidth = 1.0;
    _MoneyField.delegate = self;
    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    [_BuyView addSubview:_MoneyField];
    
    UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(0, _MoneyField.frame.origin.y+_MoneyField.frame.size.height, SCREEN_WIDTH, 30)];
    remind.text = @"市场有风险，投资需谨慎";
    remind.textColor = TEXT_COLOR_GRAY;
    remind.textAlignment = NSTextAlignmentCenter;
    remind.font = [UIFont systemFontOfSize: 11];
    [_BuyView addSubview:remind];
    
    _ConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton.backgroundColor = TB_COLOR_RED;
    _ConfirmButton.frame = CGRectMake(0,_BuyView.frame.size.height-44 , SCREEN_WIDTH, 44);
    [_ConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ConfirmButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyView addSubview:_ConfirmButton];
    
    
    _CancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CancleButton.frame = CGRectMake(SCREEN_WIDTH-50, _BuyView.frame.origin.y-50, 34, 34);
    [_CancleButton setBackgroundImage:[UIImage imageNamed:@"delete_"] forState:UIControlStateNormal];
    [_CancleButton addTarget:self action:@selector(CancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CancleButton];
    
    _scrollview.userInteractionEnabled = YES;
    _BuyView.hidden = YES;
    _BGView.hidden = YES;
    _CancleButton.hidden = YES;
    
}



- (void)currentButtonClicked:(UIButton *)button{
    if (_UseCurrent == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        _UseCurrent = NO;
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        _UseCurrent = YES;
    }
}

- (void)cardButtonClicked:(UIButton *)button{
    if (_useCard == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        _useCard = NO;
    }
    else {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        _useCard = YES;
    }
}

- (void)usableMoneyButtonClicked:(UIButton *)button{
    
    if (_UseMoney == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan2TQ"] forState:UIControlStateNormal];
        _UseMoney = NO;
    }
    else {
        
        [button setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
        _UseMoney = YES;
    }
}


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

- (void)LoginCancleButtonClicked{
    
    _BGView.hidden = YES;
    _RemindLogin.hidden = YES;
    _LoginCancleButton.hidden = YES;
}


- (void)BoundCancleButtonClicked{
    _scrollview.userInteractionEnabled = YES;
    _CancleButton.hidden = YES;
    _BGView.hidden = YES;
    _RemindBound.hidden = YES;
    _BoundCancleButton.hidden = YES;
}


- (IBAction)TimeChanged:(UIButton *)button {
    
    BOOL hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"];
    if (button.tag == 2200) {
        _image1.alpha = _Label2.alpha = _Label3.alpha = _Label4.alpha = _Label5.alpha = 1;
        _image2.alpha = _image3.alpha = _image4.alpha = _image5.alpha = _Label1.alpha = 0;
        _Time.text = @"30天";
        _type = @"3";
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type3 doubleValue]+[_add doubleValue]];
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f",[_type3 doubleValue]];
        if (!hasLogin) {
            _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type3 doubleValue]];;
        }
    }
    if (button.tag == 2201) {
        _image2.alpha = _Label1.alpha = _Label3.alpha = _Label4.alpha =  _Label5.alpha = 1;
        
        _image1.alpha = _Label2.alpha =  _image3.alpha = _image4.alpha = _image5.alpha =0;
        _Time.text = @"90天";
        _type = @"4";
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type4 doubleValue]+[_add doubleValue]];
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f",[_type4 doubleValue]];
        if (!hasLogin) {
            _shouyi.text =[NSString stringWithFormat:@"%.1f",[_type4 doubleValue]];
        }
        
    }
    if (button.tag == 2202) {
        _image3.alpha = _Label1.alpha = _Label2.alpha = _Label4.alpha =  _Label5.alpha = 1;
        
        _image1.alpha = _Label3.alpha =  _image2.alpha = _image4.alpha = _image5.alpha =0;
        _Time.text = @"180天";
        _type = @"5";
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type5 doubleValue]+[_add doubleValue]];
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f",[_type5 doubleValue]];
        if (!hasLogin) {
            _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type5 doubleValue]];
        }
        
    }
    if (button.tag == 2203) {
        
        _image4.alpha = _Label1.alpha = _Label2.alpha = _Label3.alpha =  _Label5.alpha = 1;
        
        _image1.alpha = _Label4.alpha =  _image2.alpha = _image3.alpha = _image5.alpha =0;
        _Time.text = @"270天";
        _type = @"6";
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type6 doubleValue]+[_add doubleValue]];
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f",[_type6 doubleValue]];
        if (!hasLogin) {
            _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type6 doubleValue]];
        }
    }
    if (button.tag == 2204) {
        _image5.alpha = _Label1.alpha = _Label3.alpha = _Label4.alpha =  _Label2.alpha = 1;
        
        _image1.alpha = _Label5.alpha =  _image3.alpha = _image4.alpha = _image2.alpha =0;
        _Time.text = @"360天";
        _type = @"7";
        _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type7 doubleValue]+[_add doubleValue]];
        _BaseEarnings.text = [NSString stringWithFormat:@"%.1f",[_type7 doubleValue]];
        if (!hasLogin) {
            _shouyi.text = [NSString stringWithFormat:@"%.1f",[_type7 doubleValue]];
        }
    }
    
    
}


- (void)CancleButtonClicked:(UIButton *)button{
    
    _BuyView.hidden = YES;
    _BGView.hidden = YES;
    _CancleButton.hidden = YES;
    _scrollview.userInteractionEnabled = YES;
    
}

- (void)buttonClicked:(UIButton *)button{
    ZPLog(@"确认购买～～～");
    [_MoneyField resignFirstResponder];
  
        if ([_MoneyField.text doubleValue] <= 0) {
            [_hud hide:YES];
            [UIView animateWithDuration:0.5f animations:^{
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"输入金额有误";
                _hud.mode = MBProgressHUDModeText;
            } completion:^(BOOL finished) {
                [_hud hide:YES afterDelay:0.8f];
            }];
        }
        else{
            
            LianLianPayViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LianLianPayViewController"];
            VC.type = _type;
            VC.money = _MoneyField.text;
            if (_UseMoney == YES) {
                CGFloat kyye = [[_UseMoneyLab.text substringFromIndex:2] doubleValue];
                if ([_MoneyField.text doubleValue] > kyye) {
                    VC.kyye = [NSString stringWithFormat:@"%.2f",kyye];
                }
                else{
                    VC.kyye = _MoneyField.text;
                }
            }
            else{
                VC.kyye = @"0.0";
            }
            if (_UseCurrent  == YES) {
                CGFloat hqb = [[_UseCurrentLab.text substringFromIndex:2] doubleValue];
                if ([_MoneyField.text doubleValue] - [VC.kyye doubleValue] > hqb) {
                    VC.hqb = [_UseCurrentLab.text substringFromIndex:2];
                }
                else{
                    VC.hqb = [NSString stringWithFormat:@"%.2f",[_MoneyField.text doubleValue] - [VC.kyye doubleValue]];
                }
            }
            else{
                VC.hqb = @"0.0";
            }
            if (_useCard == YES) {
                CGFloat card = [_MoneyField.text doubleValue]-[VC.kyye doubleValue]-[VC.hqb doubleValue];
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
            if ([_MoneyField.text doubleValue] == [VC.kyye doubleValue]+[VC.hqb doubleValue]+[VC.card doubleValue]) {
                
                if ([VC.card isEqual:@"0"]) {
                    VC.card = @"wu";
                }
                if ([VC.kyye isEqual:@"0.0"]) {
                    VC.kyye = @"wu";
                }if ([VC.hqb isEqual:@"0.0"]) {
                    VC.hqb = @"wu";
                }
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                [_hud hide:YES];
                [UIView animateWithDuration:0.5f animations:^{
                    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    _hud.labelText = @"输入金额有误";
                    _hud.mode = MBProgressHUDModeText;
                } completion:^(BOOL finished) {
                    [_hud hide:YES afterDelay:0.8f];
                }];
            }
//        }
    }
}


//返回上一页
- (IBAction)back:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 键盘掉落处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-384, SCREEN_WIDTH, 320);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-384, SCREEN_WIDTH, 320);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-384, SCREEN_WIDTH, 320);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5f animations:^{
        _BuyView.frame = CGRectMake(0, -30, SCREEN_WIDTH, 320);
        _BGView.hidden = YES;
        _CancleButton.hidden = YES;
    }];
}

- (void)Login{
    
    ZPLog(@"denglu");
    
    UserLoginViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:VC] animated:YES completion:nil];
}


-(void)Register{
    
    ZPLog(@"zhuce");
    RegisterViewController *registVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registVC] animated:YES completion:nil];
    
    
}


- (void)Bound{
    
    ZPLog(@"bangka");
    BindBankCardViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
    VC.VCID = @"RegularViewController";
    [self.navigationController pushViewController:VC animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [_MoneyField resignFirstResponder];
    
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
