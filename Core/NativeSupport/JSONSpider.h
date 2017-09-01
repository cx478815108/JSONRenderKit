//
//  Spider.h
//  MyWHUT
//
//  Created by 陈雄 on 16/4/4.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
typedef void(^SpiderNetSuccessBlock)(id responseObject);
typedef void(^SpiderNetFailureBlock)(NSError *netError);


@interface JSONSpider : NSObject


/**
 GET请求方法

 @param URLString URL地址
 @param parameters 参数
 @param success 成功Block回调
 @param failure 失败Block回调
 */
+(void)getWithURLString:(NSString *)URLString
              parameters:(NSDictionary *)parameters
                 success:(SpiderNetSuccessBlock)success
                 failure:(SpiderNetFailureBlock)failure;


+(void)postWithURLString:(NSString *)URLString
              parameters:(NSDictionary *)parameters
                success:(SpiderNetSuccessBlock)success
                failure:(SpiderNetFailureBlock)failure;

@end
