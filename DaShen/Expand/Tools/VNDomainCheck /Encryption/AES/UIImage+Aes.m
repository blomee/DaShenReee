//
//  UIImage+Aes.m
//  123
//
//  Created by blom on 07/04/2020.
//  Copyright © 2020 Luther. All rights reserved.
//

#import "UIImage+Aes.h"
//key：1234567890003000   偏移量：0102030405060708
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NSData+ImageContentType.h"
#import "SDWebImageCompat.h"
#import <UIImage+GIF.h>
//#import "UIImage+WebP.h"


@implementation UIImage (Aes)

// 消息内容key
static NSString *const PSW_TEXT_AES_KEY = @"saIZXc4yMvq0Iz56";
// 消息内容偏移量
static NSString *const AES_TEXT_IV_PARAMETER = @"kbJYtBJUECT0oyjo";






/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return 加密后数据
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
//        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

/**< GTMBase64编码 */
- (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/**< GTMBase64解码 */
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    return data;
}





/**<图片 加密方法 */
- (NSData *)aci_imageEncryptWithAES{
    NSData *data = UIImagePNGRepresentation(self);
    if (data) {
        NSData *AESData = [self AES128operation:kCCEncrypt
                                           data:data
                                            key:PSW_TEXT_AES_KEY
                                             iv:AES_TEXT_IV_PARAMETER];
        return AESData;
    }else{
        return nil;
    }
}


//根据data 转图片
+ (UIImage *)aci_getImageWithAesData:(NSData *)data {
    if (data) {
        
        NSData *decodeData = [[UIImage new] AES128operation:kCCDecrypt
                                                 data:data
                                                  key:PSW_TEXT_AES_KEY
                                                   iv:AES_TEXT_IV_PARAMETER];

        UIImage *tempImage = [self getRealImageWithData:decodeData];
        return (tempImage != nil)?tempImage: [self getRealImageWithData:data];
    }
    return nil;
}

+(UIImage *)getRealImageWithData:(NSData *)imageData{
    SDImageFormat imageFormatFromData = [NSData sd_imageFormatForImageData:imageData];
    if (imageFormatFromData == SDImageFormatWebP) {
//        UIImage *webpImage = [UIImage sd_imageWithWebPData:imageData];
        UIImage *webpImage = [UIImage imageNamed:@"eeeeeeeeee"];
        return webpImage;
    }else if (imageFormatFromData == SDImageFormatGIF){
//        UIImage *gifImage = [UIImage sd_animatedGIFWithData:imageData];
        UIImage *gifImage = [UIImage imageNamed:@"eeeeeeeeee"];
        return gifImage;
    }
    else {
        UIImage *image = [UIImage imageWithData:imageData];
        return image;
    }
}


/**< 图片 解密方法 */
+ (UIImage *)aci_imageDecryptWithAES:(NSString *)filePath{
    NSData *AESData = [NSData dataWithContentsOfFile:filePath];
    if (AESData) {
        NSData *decodeData = [[UIImage new] AES128operation:kCCDecrypt
                                            data:AESData
                                             key:PSW_TEXT_AES_KEY
                                              iv:AES_TEXT_IV_PARAMETER];
        UIImage *tempImage = [self getRealImageWithData:decodeData];
        return (tempImage != nil)?tempImage:[self getRealImageWithData:AESData];
        
    }else{
        return nil;
    }
}



+ (UIImage *)aci_imageDecryptWithAESData:(NSData *)imageData{

    if (imageData) {
        NSData *decodeData = [[UIImage new] AES128operation:kCCDecrypt
                                            data:imageData
                                             key:PSW_TEXT_AES_KEY
                                              iv:AES_TEXT_IV_PARAMETER];
        UIImage *image = [UIImage imageWithData:decodeData];
        return image;
    }else{
        return nil;
    }
}

+ (NSData *)aci_imageDecryptWithAESData:(NSData *)imageData withAesKey:(NSString *)aesKey{
        if (imageData) {
            
        NSData *decodeData = [[UIImage new] AES128operation:kCCDecrypt
                                            data:imageData
                                             key:aesKey
                                              iv:@""];
        return decodeData;
    }else{
        return nil;
    }
    
}

+ (NSString *)aci_DecryptWithAesData:(NSData *)aesData WithAesKey:(NSString *)aesKey WithAesIv:(NSString *)aesIv{
    if(aesData){
                
        NSData *decodeData = [[UIImage new] AES128operation:kCCDecrypt
                                            data:aesData
                                             key:aesKey
                                              iv:aesIv];
              
        NSString *stringBase64 = [decodeData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
        return stringBase64;
    }else{
        return @"";
    }
}
@end

