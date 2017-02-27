//
//  ReachStatus.m
//  YSD_iPhone
//
//  Created by dan on 15/10/14.
//  Copyright © 2015年 Yesvion. All rights reserved.
//

#import "ReachStatus.h"

@implementation ReachStatus

+ (NetworkStatus)reach {

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    return [reach currentReachabilityStatus];
}

@end