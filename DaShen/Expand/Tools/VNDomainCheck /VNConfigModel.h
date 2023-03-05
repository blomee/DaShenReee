//
//  VNConfigModel.h
//  
//
//  Created by blom on 2018/10/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface VNConfigModel : NSObject

@property (copy, nonatomic) NSString *page_download_url;
@property (copy, nonatomic) NSString *short_video_icon_url;


+ (instancetype)shareInstanced;


/**
 * 获取URL前缀(环境切换)
 */
+(NSString*)getBaseApiURL;
/**
 * api前缀
 */ 
+(void)saveBaseApiURL:(NSString*)apiURL;



/**
 * 存Token；
 */
+(void)saveOwnToken:(NSString*)token;

/**
 * 获取Token；
 */
+(NSString*)getOwnToken;

#pragma mark -  获取本地预埋域名
/// 测试
+ (NSArray *)getLocalDomainNamesArray;



// 客服地址
+ (void)saveCustomerServiceUrl:(NSString *)string;
+ (NSString *)getCustomerServiceUrl;



@end

NS_ASSUME_NONNULL_END
