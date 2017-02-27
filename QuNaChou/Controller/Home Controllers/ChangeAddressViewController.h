//
//  ChangeAddressViewController.h
//  QuNaChou
//
//  Created by 张平 on 16/6/30.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeAddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *NameTF;
@property (strong, nonatomic) IBOutlet UITextField *PhoneTF;
@property (strong, nonatomic) IBOutlet UIButton *PlaceButton;
@property (strong, nonatomic) IBOutlet UITextView *AddressTV;

@property (nonatomic, strong) NSString *lid;
@property (nonatomic, strong) NSString *Phone;

@property (nonatomic,strong) NSDictionary *dic;


@end
