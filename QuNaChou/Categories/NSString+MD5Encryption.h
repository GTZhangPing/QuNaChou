//
//  NSString+MD5Encryption.h
//  YSD_iPhone
//
//  Created by dan on 15/3/20.
//  Copyright (c) 2015年 Yesvion. All rights reserved.

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5Encryption)

- (NSString *) md5HexDigest;

@end
