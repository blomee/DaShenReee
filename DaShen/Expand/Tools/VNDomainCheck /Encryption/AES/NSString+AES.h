//
//  NSString+AES.h
//  
//
//  Created by blom on 16/11/26.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;

/**<消息 加密方法 */
- (NSString*)aci_contentEncryptWithAES;

/**< 消息解密方法 */
- (NSString*)aci_contentDecryptWithAES;

/**<视频解密 */
+ (NSString *)aes_cebDecodeWith:(NSData *)data ;

/**<视频加密 */
+ (NSData *)aes_cebEncryptWith:(NSString *)dataStr;


+ (NSData *)aes_cebEncryptWith:(NSString *)dataStr keyS:(NSString *)key;

/**< 视频接口方法 */
-(NSString*)encryVideoData;
@end
