//
//  VNConfigModel.m
//  
//
//  Created by blom on 2018/10/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "VNConfigModel.h"


NSString * const VNToken = @"VNtoken";
NSString * const VNAPI_URL_Key = @"VNAPI_URL_Key";
NSString * const VNWebSite = @"VNWebSite";
NSString * const CustomerServiceURL = @"CustomerServiceURL";


@implementation VNConfigModel


static id manager = nil;
+ (instancetype)shareInstanced {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}


//+(instancetype)
+(void)saveOwnToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:VNToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getBaseApiURL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:VNAPI_URL_Key];
}

+(void)saveBaseApiURL:(NSString *)apiURL
{
    [[NSUserDefaults standardUserDefaults] setObject:apiURL forKey:VNAPI_URL_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)saveConfigwebSite:(NSString *)site
{
    [[NSUserDefaults standardUserDefaults] setObject:site forKey:VNWebSite];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getWebSite
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:VNWebSite];
}

+(NSString*)getOwnToken
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:VNToken]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:VNToken];
}

// 客服地址
+ (void)saveCustomerServiceUrl:(NSString *)string {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:CustomerServiceURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerServiceUrl {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CustomerServiceURL];
}


/// 获取域名数组
+(NSArray *)getLocalDomainNamesArray {
    
    NSArray *urlArray = @[@"", @""];
    return urlArray;
}


@end
