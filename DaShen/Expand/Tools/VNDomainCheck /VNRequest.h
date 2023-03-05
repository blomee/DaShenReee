//
//  VNRequest.h
//  
//
//  Created by blom on 2018/10/20.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VNRequest : NSObject

/**
 * 错误码
 */
@property(nonatomic,copy) NSString *code;
/**
 * 状态名称，仅调试用
 */
@property(nonatomic,copy) NSString *name;
/**
 * 友好信息，可酌情提示给用户
 */
@property(nonatomic,copy) NSString *message;
/**
 *  数据
 */
@property(nonatomic,strong) id data;


/**
 *  🔐
 */
+(NSString*)encryDic:(NSDictionary*)dic;


/**
 * 解密
 */
+(NSDictionary*)decryptionJSon:(NSString*)jsonString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 * 字典转json
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
