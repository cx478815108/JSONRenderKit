//
//  SSJSContext.h
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@import UIKit;

@interface SSJSContext : JSContext

+(instancetype)context;

/**
 the curren running context
 */
+(SSJSContext *)currentContext;

/**
 set the context which is running
 */
+(void)setCurrentContext:(SSJSContext *)context;

/**
 inject scripts that will support to analysis the JSON
 */
-(void)injectNativeSupport;

/**
 release the strong refrence objects between Javasrcipt and Objective-C,
 or it will cause the memory leak
 */
-(void)releaseObjcs;

/**
 get a UIView that has subviews accoring the json

 @param json that descript the layout and information of subviews
 @return view
 */
-(UIView *)renderWithJSON:(NSDictionary *)json;
@end
