//
//  NSString+TransformTimestamp.m
//  YSD_iPhone
//
//  Created by dan on 15/5/12.
//  Copyright (c) 2015年 Yesvion. All rights reserved.

#import "NSString+TransformTimestamp.h"

@implementation NSString (TransformTimestamp)

// 将时间戳转换成时间
+ (NSString *)transformTime:(NSString *)sendTime{
    
    NSTimeInterval time = [sendTime doubleValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:timeDate];
    return timeStr;
    
}



+ (NSString *)transformTime2:(NSString *)sendTime2
{
    
    NSTimeInterval time = [sendTime2 doubleValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:timeDate];
    return timeStr;
    
}


+ (NSString *)transformTime3:(NSString *)sendTime3
{
    
    NSTimeInterval time = [sendTime3 doubleValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:timeDate];
    return timeStr;

}



@end
