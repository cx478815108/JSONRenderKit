//
//  NSObject+SSRender.h
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSValue;
@interface NSObject (SSRender)
/**
 必须强引用，否则没法持有JSContext内部变量，但要注意内存泄漏
 must to have a strong refrence or it will be nil when used ,pay attention the memory leak
 */
@property(nonatomic ,strong) JSValue *jsValue;

/**
 JS调用OC
 JS invoke the method of Objective-C
 @param aSelector description
 @param objects 参数数组
 @return 返回值
 */
- (id)js_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
@end
