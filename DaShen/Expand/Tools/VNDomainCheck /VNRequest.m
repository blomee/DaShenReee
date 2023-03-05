//
//  VNRequest.m
//  
//
//  Created by blom on 2018/10/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "VNRequest.h"
#import "Encryption/AES/NSString+AES.h"
#import "Encryption/MD5/VNMD5.h"

// key
static NSString *const PSW_DIC_KEY = @"gfder534534sg";

@implementation VNRequest

/// 加密
+(NSString*)encryDic:(NSDictionary*)dic{
    
    NSMutableDictionary *md5Dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    // 获取时间戳，到毫秒
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSInteger time = interval;
    NSString *timestamp = [NSString stringWithFormat:@"%zd",time];
    [md5Dic setObject:timestamp forKey:@"t"];
    
    // aes加密没有参数“k”
    NSMutableDictionary *aesDic = [NSMutableDictionary dictionaryWithDictionary:md5Dic];
    
    // 于后台约定好的key值，用于校验
    [md5Dic setObject:PSW_DIC_KEY forKey:@"k"];
    // md5排序完的json字符串
    NSString * md5JsonString = [self sortedDictionary:md5Dic];
    // md5加密后的String
    NSString * md5String = [VNMD5 md5String:md5JsonString];
    // md5的字符串加到参数s里面，h后台做md5验证
    [aesDic setObject:md5String forKey:@"s"];
    // aes前，排序完的字符串
    NSString *dString = [self sortedDictionary:aesDic];
    // aes后的字符串
    NSString * dValue = [dString aci_encryptWithAES];

    return dValue;
}

+ (NSString *)sortedDictionary:(NSDictionary *)dict{
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];

    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *sortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        // compare方法是区分大小写的，即按照ASCII排序
        NSComparisonResult resuest = [obj1 compare:obj2 options:NSNumericSearch];
        return resuest;
    }];

    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in sortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }

    // 组合成json串
    NSMutableArray *signArray = [NSMutableArray array];
    NSMutableDictionary *tmpDic = @{}.mutableCopy;
    for (int i = 0; i < sortKeyArray.count; i++) {
        id tmpValue = valueArray[i];
        if ([tmpValue isKindOfClass:[NSString class]]) {
            NSString *tmpStr = tmpValue;
            if ([tmpStr containsString:@"http://"] || [tmpStr containsString:@"https://"] || [tmpStr containsString:@"index.m3u8"] || [tmpStr containsString:@"/"]) {
                tmpValue = [VNRequest JSON2String:valueArray[i]];
            } else {
                tmpValue = [VNRequest JSON1String:valueArray[i]];
            }
        }
        NSString *keyValueStr = [NSString stringWithFormat:@"\"%@\":\"%@\"",sortKeyArray[i], tmpValue];
//      NSString *keyValueStr = [NSString stringWithFormat:@"\"%@\":\"%@\"",sortKeyArray[i], valueArray[i]];
        [signArray addObject:keyValueStr];
        tmpDic[sortKeyArray[i]] = valueArray[i];
    }
    NSString *sign = [signArray componentsJoinedByString:@","];
    NSString * signString = [NSString stringWithFormat:@"{%@}",sign];
    NSLog(@"%@", signString);
    NSLog(@"%@", [VNRequest convertToJsonData:tmpDic]);
    return signString;
}
+(NSDictionary*)decryptionJSon:(NSString*)jsonString{
    
    NSString* descryString = [jsonString aci_decryptWithAES];
    
    NSDictionary * descryDic = [self dictionaryWithJsonString:descryString];
    return descryDic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSLog(@"dict%@", dict);
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (NSString *)JSON1String:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

+ (NSString *)JSON2String:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

@end
