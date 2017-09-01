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

/**
 you can add a NSObject that conform the JSExport
 example : [context addJSPlugin:[[UI alloc] init] name:@"UI"];
 then you can use UI.screenW in the json
 @param plugin custom object
 */
-(void)addJSPlugin:(NSObject *)plugin name:(NSString *)name;

/**
 you can add custom sricpt that define the new UI tools or kits
 
 @param sricpt JS sricpt
 @param sourceURL sourceURL of the JS sricpt that can help for the debuging in Safari
 */
-(void)addSricpt:(NSString *)sricpt sourceURL:(NSURL *)sourceURL;
@end
