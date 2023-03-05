//
//  VNCycleCheckRequest.m
//  
//
//  Created by blom on 2020/9/15.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VNDomainCheckRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VNRequest.h"
#import "VNNetWorkHelper.h"
#import "DaShen-Swift.h" //桥接
//#import "JKEncrypt.h"



//启动后全局域名基础数组(二维数组)
static NSMutableArray *_mainArray = nil;
//第三方域名
static NSMutableArray *_thirdURLs = nil;

static AFHTTPSessionManager *_manager = nil;

static CallBack urlGetBack = nil;

static BOOL isFirstTime = YES;

static NSString *currLineResource = @"App预埋";

// 事件开始时间
static double _sensors_beginTimer = .0;

@implementation VNDomainCheckRequest


#pragma mark --第三方备有域名接口
+ (void)setCsanFangUrls:(NSMutableArray<NSString *> *)thirdURLs{
    _thirdURLs = thirdURLs;
}

// ooo<<<
+ (NSMutableArray<NSString *> *)thirdURLs {
    if (_thirdURLs == nil) {
        //第三方备用请求域名链接  测试
//            _thirdURLs = [NSMutableArray arrayWithArray:@[@"https://raw.githubusercontent.com/985434801/TestAPI/master/ApiUatDomain.java",
//                @"https://tutu356.cdn.bcebos.com/Api/ApiUatDomain.java"]];
        _thirdURLs = [NSMutableArray arrayWithArray:@[@""]];
    }
    return _thirdURLs;
}


#pragma mark -接口全局服务请求
+ (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
       _manager = [AFHTTPSessionManager manager];
       _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
       _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
       _manager.requestSerializer.timeoutInterval = 30; // 设置请求超时时间
       _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    }
    return _manager;
}

+ (void)setManager:(AFHTTPSessionManager *)manager{
    _manager = manager;
}


#pragma 启动初始化处理入口
+(void)requestCycleURLWithCallBack:(CallBack)callBack{
    
    urlGetBack = callBack;
    _mainArray = [NSMutableArray arrayWithCapacity:0];
    
    //后台备用域名
    NSArray *backendDomains = [[NSUserDefaults standardUserDefaults] objectForKey:@"BackendDommainsKey"];
    if (backendDomains && backendDomains.count) {
        [_mainArray addObject: [NSMutableArray arrayWithArray:backendDomains]];
    }
    
    if (_mainArray.count) {
        currLineResource = @"后台配置";
    }
    
    //2、本地预埋域名
    NSMutableArray *localArray = [NSMutableArray arrayWithArray:[EnvSwitchManager shared].selectedModel.app_api_url_array];
    if (localArray && localArray.count > 0) {
        [_mainArray addObject:localArray];
    }
    
    //3、第三方域名
    NSArray *thirdDomains = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdAPIDomainsKey"];
    if (thirdDomains && thirdDomains.count) {
        [_mainArray addObject: [NSMutableArray arrayWithArray:thirdDomains]];
    }

    [VNDomainCheckRequest loopRequestInterfaceCheckDomains];
}
#pragma mark -循环接口处理调用(bootstrap失败循环)
+(void)loopRequestInterfaceCheckDomains{
     __block BOOL isFirstUseful = YES;
    NSMutableArray *firstArray = _mainArray.firstObject;
    /**毫秒  开始统计时间*/
    _sensors_beginTimer = [[NSDate date] timeIntervalSince1970];
    if (firstArray && firstArray.count) {
        //GCD并行请求组别
        dispatch_group_t group = dispatch_group_create();
        for (NSString *url in firstArray) {
             //Enter group
             dispatch_group_enter(group);
            VNDomainCheckRequest.manager .requestSerializer.timeoutInterval = 8;
            [VNDomainCheckRequest.manager GET:[NSString stringWithFormat:@"%@domain/check",url] parameters:nil headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableLeaves) error:nil];
                BOOL isSuccess = dict[@"success"];
                
                 if (isSuccess && isFirstUseful) {
                     isFirstUseful = NO;
                     NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   任务成功效率首链接%@  ＊＊＊＊＊＊＊＊＊＊＊\n",url);
                     [VNConfigModel saveBaseApiURL: url];
                    
                     isFirstTime = NO ;
                     [firstArray removeObject:url];
                     if (firstArray.count == 0){
                         [_mainArray removeObject:firstArray];
                         [self changeCurrentName];
                     }
                     if (urlGetBack) urlGetBack(YES);
                 }else if(isSuccess){
                     NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   任务成功效率慢链接:%@   ＊＊＊＊＊＊＊＊＊＊＊\n",url);
                 }else{
                     [firstArray removeObject:url];
                     if (0 == firstArray.count) {
                         [VNDomainCheckRequest handleFailRequestData:!isFirstUseful];
                     }
                     NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   检测域名任务失败    %@ ＊＊＊＊＊＊＊＊＊＊＊",url);
                     
                 }
               
                 dispatch_group_leave(group);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [firstArray removeObject:url];
                 if (0 == firstArray.count) {
                     [VNDomainCheckRequest handleFailRequestData:!isFirstUseful];
                 }
                 NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   检测域名任务失败    %@ ＊＊＊＊＊＊＊＊＊＊＊",url);
                 dispatch_group_leave(group);
             }];
         }
    }else{
        //第三方域名
         if (VNDomainCheckRequest.thirdURLs.count > 0) {
             [VNDomainCheckRequest getRequestThirdDomains];
         }else{

             if (urlGetBack) urlGetBack(NO);
             NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   全部域名失效  ＊＊＊＊＊＊＊＊＊＊＊");
         }
    }
    
}

#pragma mark -失败相关处理
+(void)handleFailRequestData:(BOOL)hasUseFullLine {
    
    if (_mainArray.count > 0 ) {
        [_mainArray removeObjectAtIndex:0];
    }
   
    [self changeCurrentName];
    //假如已经有效链接直接返回，避免并行最后一个数据是失效导致重新并行
    if (hasUseFullLine) {
        return;
    }
    if (_mainArray.count) {
        [VNDomainCheckRequest loopRequestInterfaceCheckDomains];
    } else {
       //第三方域名
        if (VNDomainCheckRequest.thirdURLs.count > 0) {
            [VNDomainCheckRequest getRequestThirdDomains];
        }else{
            
            if (urlGetBack) urlGetBack(NO);
            NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   全部链接失效  ＊＊＊＊＊＊＊＊＊＊＊");
        }
    }
}


#pragma mark --请求存放在第三方网站APP的备用域名
+ (void)getRequestThirdDomains {
    /**毫秒  新的预埋域名数组开始统计时间*/
    _sensors_beginTimer = [[NSDate date] timeIntervalSince1970];
    if (VNDomainCheckRequest.thirdURLs.count > 0) {
        NSString *url = VNDomainCheckRequest.thirdURLs.firstObject;
        [VNNetWorkHelper GET:url parameters:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject allKeys] containsObject:@"body"]) {
                    NSLog(@"备用域名:%@解析成功", url);
                    NSString *sbody = responseObject[@"body"];
//                    NSString *body = [JKEncrypt.new doDecEncryptStr:sbody];
                    //解析出来的备用域名
                    NSDictionary *dic = [VNRequest dictionaryWithJsonString:sbody];
                    NSLog(@"body%@", dic);
                    NSArray * standbyDomain = [dic objectForKey:@"domains"];
                    [[NSUserDefaults standardUserDefaults] setObject:standbyDomain forKey:@"standbydomains"];
                    if (standbyDomain && standbyDomain.count) {
                        NSMutableArray *standbyArray = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *dict in standbyDomain) {
                            NSString *dictUrl =  [dict objectForKey:@"api_domain"];
                            [standbyArray addObject:dictUrl];
                        }
                        [_mainArray addObject:standbyArray];
                    }
                    [VNDomainCheckRequest.thirdURLs removeObject:url];
                    [VNDomainCheckRequest loopRequestInterfaceCheckDomains];
                    return;
                }
            }
            NSLog(@"备用域名:%@解析失败", url);
            [VNDomainCheckRequest.thirdURLs removeObject:url];
            [VNDomainCheckRequest getRequestThirdDomains];
           
            NSString *errorString = @"URL请求失败";
            if ([responseObject isKindOfClass:[NSString class]]) {
                errorString = @"URL请求失败";
            }
        } failure:^(NSError *error) {
            NSLog(@"备用域名:%@请求失败", url);
            [VNDomainCheckRequest.thirdURLs removeObject:url];
            [VNDomainCheckRequest getRequestThirdDomains];
        }];
    } else {
        if (urlGetBack) urlGetBack(NO);
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊   全部链接失效  ＊＊＊＊＊＊＊＊＊＊＊");
    }
}



/// 变更域名渠道来源
+(void)changeCurrentName{
    if ([currLineResource isEqualToString:@"后台配置"]) {
        currLineResource = @"App预埋";
    }else if([currLineResource isEqualToString:@"App预埋"]){
        currLineResource = @"第三方预埋";
    }else{
        currLineResource = @"第三方预埋";
    }
}

@end
