//
//  VNMD5.m
//  
//
//  Created by blom on 2019/3/27.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "VNMD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation VNMD5


/**
 * MD5只能称为一种不可逆的加密算法，只能用作一些检验过程，不能恢复其原文
 */
+ (NSString *)md5String:(NSString *)str {
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
