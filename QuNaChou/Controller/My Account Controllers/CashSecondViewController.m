
//
//  CashSecondViewController.m
//  QuNaChou
//
//  Created by 张平 on 16/6/12.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "CashSecondViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "CashResultViewController.h"
#import "SVProgressHUD.h"
#import "CashAttestationViewController.h"

@interface CashSecondViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;

@property (weak, nonatomic) IBOutlet UIImageView *CashImage;
@property (weak, nonatomic) IBOutlet UILabel *CashTitle;
@property (weak, nonatomic) IBOutlet UILabel *CashMoney;
@property (strong, nonatomic) IBOutlet UILabel *BankName;
@property (strong, nonatomic) IBOutlet UILabel *BankNum;

@property (weak, nonatomic) IBOutlet UITextField *MoneyTextField;

@property (strong, nonatomic) IBOutlet UILabel *Lab1;
@property (strong, nonatomic) IBOutlet UILabel *Lab2;

@property(nonatomic, assign) float UserMoney;
@property (nonatomic, assign) NSInteger withdrawnum;
@property (nonatomic, strong) NSString *MinMoney;
@property (nonatomic, strong) NSString *PhoneNum;
@property (nonatomic, strong) NSString *code;

@end

@implementation CashSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ConfirmButton.layer.cornerRadius = 10;
    
    _MinMoney = [_InfoDic objectForKey:@"min_money"];
    _withdrawnum = [[_InfoDic objectForKey:@"withdrawnum"] intValue];
    _BankNum.text = [NSString stringWithFormat:@"****%@",[_InfoDic objectForKey:@"banknum"]];
    _BankName.text = [_InfoDic objectForKey:@"bankname"];
    _Lab1.text = [NSString stringWithFormat:@"本月还有%ld次免费提现机会",(long)_withdrawnum];
    _Lab2.text = [NSString stringWithFormat:@"每次提现金额至少为%@元",_MinMoney];
    _PhoneNum = [_InfoDic objectForKey:@"phone"];
    if ([_index isEqual:@"1"]) {
        _UserMoney = [[_InfoDic objectForKey:@"keyongyue"] floatValue];
        _CashMoney.text = [NSString stringWithFormat:@"¥ %.2f",_UserMoney];
        _CashTitle.text = @"可用余额";
        _CashImage.image = [UIImage imageNamed:@"TXicon3"];
    }
    if ([_index isEqual:@"2"]) {
        _UserMoney = [[_InfoDic objectForKey:@"huoqibao"] floatValue];
        _CashMoney.text =
        [NSString stringWithFormat:@"¥ %.2f",_UserMoney];
        _CashTitle.text = @"活期宝余额";
        _CashImage.image = [UIImage imageNamed:@"TXicon2"];
    }

}


- (void)viewWillAppear:(BOOL)animated{
    
    
}


- (IBAction)ConfirmButtonClicked:(id)sender {
    
    [_MoneyTextField resignFirstResponder];

    if (_UserMoney < [_MoneyTextField.text doubleValue] ||
         [_MoneyTextField.text isEqual: @""]) {
    
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"输入金额有误";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    if ([_MoneyTextField.text doubleValue] < [_MinMoney doubleValue] ) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = [NSString stringWithFormat:@"最小提现金额为%@元",_MinMoney];
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
    if (_withdrawnum <= 0 ) {
        [UIView animateWithDuration:0.5f animations:^{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"本月免费提现次数已用完";
            _hud.mode = MBProgressHUDModeText;
        } completion:^(BOOL finished) {
            [_hud hide:YES afterDelay:0.8f];
        }];
        return;
    }
//    if ([_code isEqual:@"0060"]) {
//        [UIView animateWithDuration:0.5f animations:^{
//            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            _hud.labelText = @"充值投资完成后完成绑定";
//            _hud.mode = MBProgressHUDModeText;
//        } completion:^(BOOL finished) {
//            [_hud hide:YES afterDelay:0.8f];
//        }];
//        return;
//    }
    
    else{
        
        CashAttestationViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CashAttestationViewController"];
        VC.CashMoney = _MoneyTextField.text;
        VC.index = _index;
        VC.Phone = _PhoneNum;
        [self.navigationController pushViewController:VC animated:YES];

    }
}



- (IBAction)Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 键盘掉落处理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_MoneyTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_MoneyTextField resignFirstResponder];
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_MoneyTextField resignFirstResponder];
}


- (void)dismissDelayed{
    
    [SVProgressHUD dismiss];
}

@end
