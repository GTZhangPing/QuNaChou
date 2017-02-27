//
//  ReachStatus.h
//  YSD_iPhone
//
//  Created by dan on 15/10/14.
//  Copyright © 2015年 Yesvion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachStatus : NSObject

// 判断当前网络状态
+ (NetworkStatus)reach;

@end
