//
//  NSObject+SSRender.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSObject+SSRender.h"
#import "SSJSContext.h"
#import <objc/message.h>
#import <JavaScriptCore/JavaScriptCore.h>

//#define SSRenderMsgSendWithReturn(...) ((id (*)(id, SEL, ...))objc_msgSend)(__VA_ARGS__)

@implementation NSObject (SSRender)
-(JSValue *)jsValue
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setJsValue:(JSValue *)jsValue
{
    objc_setAssociatedObject(self, @selector(jsValue), jsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)js_performSelector:(SEL)aSelector withObjects:(NSArray *)objs
{
    if (![self respondsToSelector:aSelector]) return nil;
    
    //方法签名(对方法的描述)
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (sig == nil) return nil;

    // 方法调用者 方法名 方法参数 方法返回值
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = self;
    invocation.selector = aSelector;
    
    for (int i = 0; i< objs.count; i++) {
        id objct = objs[i] ;
        if (![objct isKindOfClass:[NSNull class]]) [invocation setArgument:&objct atIndex:i+2];
    }
    //调用方法
    [invocation invoke];
    
    // 获取返回值
    id result = nil;
    if (sig.methodReturnLength) { [invocation getReturnValue:&result];}
    return result;
}

@end
