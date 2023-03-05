//
//  NSString+AES.m
//  
//
//  Created by blom on 16/11/26.
//  Copyright © 2016年 Bear . All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"



// key
//static NSString *const PSW_AES_KEY = @"xPxo2S5uGPhKHx5g";
//// 偏移量
//static NSString *const AES_IV_PARAMETER = @"0a1b2c3d4e5f6789";
//
//// 视频处理key和偏移量
//static NSString *const PSW_VIDEO_KEY = @"v6lnc7yqkiof47q5";
//// 偏移量
//static NSString *const PSW_VIDEO_IV = @"6853173374198157";
//
//// 消息内容key
//static NSString *const PSW_TEXT_AES_KEY = @"OGX3fHL#LQa0aGo9";
//// 消息内容偏移量
//static NSString *const AES_TEXT_IV_PARAMETER = @"9qct08xv*&92nZ6K";
//
//
//// key(ECB视频加密key)
//static NSString *const AES_ECB_MOVIEKEY = @"saIZXc4yMvq0Iz56";





// key
static NSString *const PSW_AES_KEY = @"toho%&642531@*37";
// 偏移量
static NSString *const AES_IV_PARAMETER = @"";

// 视频处理key和偏移量
static NSString *const PSW_VIDEO_KEY = @"v6lnc7yqkiof47q5";
// 偏移量
static NSString *const PSW_VIDEO_IV = @"6853173374198157";

// 消息内容key
static NSString *const PSW_TEXT_AES_KEY = @"OGX3fHL#LQa0aGo9";
// 消息内容偏移量
static NSString *const AES_TEXT_IV_PARAMETER = @"9qct08xv*&92nZ6K";


// key(ECB视频加密key)
static NSString *const AES_ECB_MOVIEKEY = @"saIZXc4yMvq0Iz56";






@implementation NSString (AES)


- (NSString*)aci_encryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"*****************\nGTMBase:%@\n*****************", baseStr_GTM);
    NSLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    return baseStr_GTM;
}

- (NSString*)aci_decryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:PSW_AES_KEY
                                             iv:AES_IV_PARAMETER];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    NSLog(@"*****************\nGTMBase:%@\n*****************", decStr_GTM);
    NSLog(@"*****************\niOSCode:%@\n*****************", decStr);
    
    return decStr;
}

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



/**<消息 加密方法 */
- (NSString*)aci_contentEncryptWithAES{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_TEXT_AES_KEY
                                         iv:AES_TEXT_IV_PARAMETER];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"*****************\nGTMBase:%@\n*****************", baseStr_GTM);
    NSLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    return baseStr_GTM;
}

/**< 消息 解密方法 */
- (NSString*)aci_contentDecryptWithAES{
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_TEXT_AES_KEY
                                         iv:AES_TEXT_IV_PARAMETER];
    
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    NSLog(@"*****************\niOSCode:%@\n*****************", decStr);
    
    return decStr;
}


+ (NSData *)aes_cebEncryptWith:(NSString *)dataStr keyS:(NSString *)key{
  char keyPtr[kCCKeySizeAES128+1];
  memset(keyPtr, 0, sizeof(keyPtr));
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
  NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [data length];
    
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding|kCCOptionECBMode,
                                        keyPtr,
                                        kCCBlockSizeAES128,
                                        NULL,
                                        [data bytes],
                                        dataLength,
                                        buffer,
                                        bufferSize,
                                        &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
      return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];

  }
  free(buffer);
  return nil;

}



/// 加密
-(NSString*)encryVideoData{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operationToVideo:kCCEncrypt
                                       data:data
                                        key:PSW_VIDEO_KEY
                                         iv:PSW_VIDEO_IV];
    NSString *baseStr_GTM = [self dataTohexString:AESData];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"*****************\nGTMBase:%@\n*****************", baseStr_GTM);
    NSLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    return baseStr_GTM;
}


/**
 *  AES加解密算法(视频)
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return 加密后数据
 */
- (NSData *)AES128operationToVideo:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = data.length;
    void const *initVectorBytes = [iv dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = data.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kCCKeySizeAES128,
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}


- (NSString *)dataTohexString:(NSData*)data
{
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

   [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
       unsigned char *dataBytes = (unsigned char*)bytes;
       for (NSInteger i = 0; i < byteRange.length; i++) {
           NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
           if ([hexStr length] == 2) {
               [string appendString:hexStr];
           } else {
               [string appendFormat:@"0%@", hexStr];
           }
       }
   }];
    
    
    return string;
}





+ (NSString *)aes_cebDecodeWith:(NSData *)data {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [AES_ECB_MOVIEKEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
      
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
    }else{
        free(buffer);
        return nil;
    }
}




+ (NSData *)aes_cebEncryptWith:(NSString *)dataStr{
  char keyPtr[kCCKeySizeAES128+1];
  memset(keyPtr, 0, sizeof(keyPtr));
  [AES_ECB_MOVIEKEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
  NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [data length];
    
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding|kCCOptionECBMode,
                                        keyPtr,
                                        kCCBlockSizeAES128,
                                        NULL,
                                        [data bytes],
                                        dataLength,
                                        buffer,
                                        bufferSize,
                                        &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
      return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];

  }
  free(buffer);
  return nil;
}

@end
#pragma clang diagnostic pop
