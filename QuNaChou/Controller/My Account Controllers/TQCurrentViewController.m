//
//  RechargeViewController.m
//  QuNaChou
//
//  Created by WYD on 16/5/6.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "TQCurrentViewController.h"
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


@interface TQCurrentViewController ()<UITextFieldDelegate,UIAlertViewDelegate,ReminderLoginViewDelegate>
@property(nonatomic, strong)MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;
@property (strong, nonatomic) IBOutlet UILabel *ShouYiLab;
@property (strong, nonatomic) IBOutlet UILabel *tqcsLab;
@property (strong, nonatomic) IBOutlet UILabel *jcsyLab;
@property (strong, nonatomic) IBOutlet UILabel *tqsyLab;

@property (strong, nonatomic) IBOutlet UILabel *ljsyLab;
@property (strong, nonatomic) IBOutlet UILabel *zsyLab;


@property (nonatomic, strong) ReminderLoginView *RemindLogin;
@property (nonatomic, strong) ReminderLoginView *RemindBound;
@property (nonatomic, strong) UIButton *LoginCancleButton;
@property (nonatomic, strong) UIButton *BoundCancleButton;

@property (nonatomic, strong) UIView *BuyView;
@property (nonatomic, strong) UIButton *CancleButton;
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) UILabel *UseMoneyLab;
@property (nonatomic, strong) UILabel *CardInfor;

@property (nonatomic, strong) UITextField *MoneyField;
@property (nonatomic, strong) UIButton *ConfirmButton;

@property (nonatomic, assign) BOOL UseMoney;
@property (nonatomic, assign) BOOL useCard;
@property (nonatomic, strong) NSString *code;

@end

@implementation TQCurrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationController.navigationBar.translucent = YES;
    //    self.automaticallyAdjustsScrollViewInsets = NO;  //设置ScrollView在导航栏下面
    
    [self creatView];
    
    [self initRemindView1];
    [self initRemindView2];
}

- (void)viewWillAppear:(BOOL)animated
{
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
        
        [_JoinButton setTitle:@"登陆后加入" forState:UIControlStateNormal];
        
        _ShouYiLab.text = @"8.0";
        _tqcsLab.text = _jcsyLab.text = _tqsyLab.text = @"登陆后查看";
        _tqcsLab.font = _jcsyLab.font = _tqsyLab.font = [UIFont systemFontOfSize:14];
        
    }
    else{
        [_JoinButton setTitle:@"加入" forState:UIControlStateNormal];
//        _tqcsLab.text = @"1次";
        _tqcsLab.font = _jcsyLab.font = _tqsyLab.font = [UIFont systemFontOfSize:16];
        
        //请求网络
        [self Requestnetwork];
    }
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
                           @"style":@"1",
                           @"type":@"2"
                           };
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    [ manager POST:baseUrl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            ZPLog(@"%@",dic);
        
        _zsyLab.text = [dic objectForKey:@"zhzichan"];
        _ljsyLab.text = [dic objectForKey:@"leijishouyi"];
        _jcsyLab.text = [NSString stringWithFormat:@"%.1f%@",[[dic objectForKey:@"jcsy"] doubleValue],@"%"];
        _tqsyLab.text = [NSString stringWithFormat:@"%.1f%@",[[dic objectForKey:@"tqsy"] doubleValue],@"%"];
        _tqcsLab.text = [NSString stringWithFormat:@"%@次",[dic objectForKey:@"tqcs"]];
        _ShouYiLab.text = [NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"jcsy"] doubleValue]+[[dic objectForKey:@"tqsy"] doubleValue]];
        
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
            ZPLog(@"%@",dic);
        
        _code = [dic objectForKey:@"code"];
        _UseMoneyLab.text = [dic objectForKey:@"keyongyue"];
        _CardInfor.text = [NSString stringWithFormat:@"%@***%@",[dic objectForKey:@"bankname"],[dic objectForKey:@"banknum"]];
        
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self performSelector:@selector(dismissDelayed) withObject:nil afterDelay:0.0f];
    }];
    
}


//加入按钮
- (IBAction)JoinButtonClicked:(id)sender {
    
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


- (void)creatView
{
    _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0.5;
    [self.view addSubview:_BGView];
    
    _BuyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260-64, SCREEN_WIDTH, 260)];
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
    image2.image = [UIImage imageNamed:@"icon5TQ"];
    [_BuyView addSubview:image2];
    
    UILabel *card = [[UILabel alloc] initWithFrame:CGRectMake(image2.frame.size.width+image2.frame.origin.x+10, image2.frame.origin.y-10, 100, 15)];
    card.text = @"银行卡";
    card.font = [UIFont systemFontOfSize:12];
    card.textColor = TB_COLOR_RED;
    [_BuyView addSubview:card];
    
    _CardInfor = [[UILabel alloc] initWithFrame:CGRectMake(card.frame.origin.x, card.frame.origin.y+20, 200,15)];
//    _CardInfor.text = @"招行＊＊8888（储蓄）";
    _CardInfor.font = [UIFont systemFontOfSize:12];
    _CardInfor.textColor = TEXT_COLOR_GRAY;
    [_BuyView addSubview:_CardInfor];
    
    _useCard = YES;
    UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cardButton.frame = CGRectMake(SCREEN_WIDTH-50, line.frame.origin.y+20, 24, 24);
    [cardButton setBackgroundImage:[UIImage imageNamed:@"fuxuan1TQ"] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_BuyView addSubview:cardButton];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _CardInfor.frame.origin.y+25, SCREEN_WIDTH-40, 1)];
    line2.backgroundColor = TB_COLOR_GRAY;
    [_BuyView addSubview:line2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line2.frame.origin.y+15, 20, 20)];
    image3.image = [UIImage imageNamed:@"icon6TQ"];
    [_BuyView addSubview:image3];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(image3.frame.size.width+image3.frame.origin.x+10, image3.frame.origin.y+2, 100, 15)];
    money.text = @"加入总金额";
    money.font = [UIFont systemFontOfSize:12];
    money.textColor = TB_COLOR_RED;
    [_BuyView addSubview:money];
    
    _MoneyField = [[UITextField alloc] initWithFrame:CGRectMake(image3.frame.origin.x, image3.frame.origin.y+image3.frame.size.height+5, SCREEN_WIDTH-40, 44)];
    _MoneyField.placeholder = @"输入加入金额";
    _MoneyField.font = [UIFont systemFontOfSize:16];
    _MoneyField.delegate = self;
    _MoneyField.layer.cornerRadius = 5;
    _MoneyField.layer.borderColor = TB_COLOR_RED.CGColor;
    _MoneyField.layer.borderWidth = 1.0;
//    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    [_BuyView addSubview:_MoneyField];
    
    UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(0, _MoneyField.frame.origin.y+_MoneyField.frame.size.height, SCREEN_WIDTH, 30)];
    remind.text = @"市场有风险，投资需谨慎";
    remind.textColor = TEXT_COLOR_GRAY;
    remind.textAlignment = NSTextAlignmentCenter;
    remind.font = [UIFont systemFontOfSize: 11];
    [_BuyView addSubview:remind];
    
    _ConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton.backgroundColor = TB_COLOR_RED;
    _ConfirmButton.frame = CGRectMake(0,220 , SCREEN_WIDTH, 44);
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



- (void)initRemindView1{
    
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



- (void)initRemindView2{
    
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
        VC.money = _MoneyField.text;
        VC.type = @"2";
        VC.hqb = @"wu";
        if (_UseMoney == YES) {
            CGFloat kyye = [[_UseMoneyLab.text substringFromIndex:2] doubleValue];
            if ([_MoneyField.text doubleValue] >= kyye) {
                VC.kyye = [NSString stringWithFormat:@"%f",kyye];
            }else{
                VC.kyye = _MoneyField.text;
            }
        }
        else{
            VC.kyye = @"0";
        }

        if (_useCard == YES) {
            CGFloat card = [_MoneyField.text doubleValue]-[VC.kyye doubleValue];
            if (card < 0) {
                VC.card = @"0.0";
            }else{
                VC.card = [NSString stringWithFormat:@"%.1f",card];
                
            }
        }
        else{
            VC.card = @"0.0";
        }
        
        if ([_MoneyField.text doubleValue] == [VC.kyye doubleValue] + [VC.card doubleValue]) {
            
            if ([VC.card isEqual:@"0.0"]) {
                VC.card = @"wu";
            }
            if ([VC.kyye isEqual:@"0"]) {
                VC.kyye = @"wu";
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
    }
}


- (void)CancleButtonClicked:(UIButton *)button{
    
    _BuyView.hidden = YES;
    _BGView.hidden = YES;
    _CancleButton.hidden = YES;
    _scrollview.userInteractionEnabled = YES;
    
}



- (IBAction)back:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 键盘掉落处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-260-64, SCREEN_WIDTH, 260);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-260-64, SCREEN_WIDTH, 260);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_MoneyField resignFirstResponder];
    _BuyView.frame = CGRectMake(0, SCREEN_HEIGHT-260-64, SCREEN_WIDTH, 260);
    _BGView.hidden = NO;
    _CancleButton.hidden = NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5f animations:^{
        _BuyView.frame = CGRectMake(0, 25, SCREEN_WIDTH, 260);
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
    VC.VCID = @"TQCurrentViewController";
    [self.navigationController pushViewController:VC animated:YES];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [_MoneyField resignFirstResponder];
    
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
