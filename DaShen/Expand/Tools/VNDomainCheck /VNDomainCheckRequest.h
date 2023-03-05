//
//  VNCycleCheckRequest.h
//  
//
//  Created by blom on 2020/9/15.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNConfigModel.h"


typedef void(^CallBack)(BOOL isSuccess);
NS_ASSUME_NONNULL_BEGIN

@interface VNDomainCheckRequest : NSObject

/// 初始化处理入口全域名初始化加载
/// @param callBack app全周期返回出口
+(void)requestCycleURLWithCallBack:(CallBack)callBack;


/// bootstrap挂了重新处理服务
+(void)loopRequestInterfaceCheckDomains;


@end

NS_ASSUME_NONNULL_END
