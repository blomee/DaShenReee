//
//  UIImage+Aes.h
//  123
//
//  Created by blom on 07/04/2020.
//  Copyright © 2020 Luther. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Aes)
/// 图片对象方法  返回加密数据data(可能为空)
- (NSData *)aci_imageEncryptWithAES;


//根据data转图片
+ (UIImage *)aci_getImageWithAesData:(NSData *)data ;
/// 类方法
/// /解密图片数据 返回图片(可能为空)
/// @param filePath 加密data路径
+ (UIImage *)aci_imageDecryptWithAES:(NSString *)filePath;

+ (UIImage *)aci_imageDecryptWithAESData:(NSData *)imageData;

+ (NSData *)aci_imageDecryptWithAESData:(NSData *)imageData withAesKey:(NSString *)aesKey;

+ (NSString *)aci_DecryptWithAesData:(NSData *)aesData WithAesKey:(NSString *)aesKey WithAesIv:(NSString *)aesIv;
@end

NS_ASSUME_NONNULL_END
