//
//  NSString+VerifyBankCard.h
//  QuNaChou
//
//  Created by 张平 on 16/8/8.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VerifyBankCard)

+ (BOOL) checkCardNo:(NSString*) cardNo;

@end
