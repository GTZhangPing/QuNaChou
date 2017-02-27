//
//  SystemInfo.h
//  WYD
//
//  Created by WYD on 16/3/31.
//  Copyright © 2016年 WYD. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface SystemInfo : NSObject

@end
