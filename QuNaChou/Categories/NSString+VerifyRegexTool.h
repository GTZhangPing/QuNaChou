//
//  NSString+VerifyRegexTool.h
//  VIP
//
//  Created by 张平 on 16/8/1.
//  Copyright © 2016年 张平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VerifyRegexTool)

+ (BOOL)verifyIsNotEmpty:(NSString *)str;   //验证是否不为空

+ (BOOL)verifyIDCardNumber:(NSString *)value; //验证身份证

+ (NSString *)getIDCardBirthday:(NSString *)card;   //得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSInteger)getIDCardSex:(NSString *)card;   //得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证


@end
