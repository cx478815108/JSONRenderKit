//
//  Spider.m
//  MyWHUT
//
//  Created by 陈雄 on 16/4/4.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import "Spider.h"
#import "AFNetworking.h"

@implementation Spider

static AFHTTPSessionManager *_manager = nil;

+(void)initialize
{
    _manager                                           = [AFHTTPSessionManager manager];
    _manager.responseSerializer                        = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",nil];
}

+(void)postWithURLString:(NSString *)URLString
              parameters:(NSDictionary *)parameters
                 success:(SpiderNetSuccessBlock)success
                 failure:(SpiderNetFailureBlock)failure
{
    URLString=[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [_manager POST:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success?:success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

+(void)getWithURLString:(NSString *)URLString
             parameters:(NSDictionary *)parameters
                success:(SpiderNetSuccessBlock)success
                failure:(SpiderNetFailureBlock)failure
{
    URLString=[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [_manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success?:success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
@end
