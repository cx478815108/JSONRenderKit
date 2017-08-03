//
//  NSObject+SSRender.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSObject+SSRender.h"
#import "SSJSContext.h"
#import "CXMacros.h"
#import <objc/message.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define SSRenderMsgSendWithoutReturn(...) ((void (*)(id, SEL, ...))objc_msgSend)(__VA_ARGS__)
#define SSRenderMsgSendWithReturn(...) ((id (*)(id, SEL, ...))objc_msgSend)(__VA_ARGS__)

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
    //get the signature of self
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (sig == nil) {
        CXDebugLog(@"%@ connot find the %@",self,NSStringFromSelector(aSelector));
        return nil;
    }
    
    NSUInteger returnLength = sig.methodReturnLength;
    id returnValue = nil;
    switch (objs.count) {
        case 0:
        {
            if(returnLength){ returnValue = SSRenderMsgSendWithReturn(self,aSelector);}
            else            { SSRenderMsgSendWithoutReturn(self,aSelector);}
            break;
        }
        case 1:
        {
            if(returnLength){ returnValue = SSRenderMsgSendWithReturn(self,aSelector);}
            else            { SSRenderMsgSendWithoutReturn(self,aSelector,objs[0]);}
            break;
        }
        case 2:
        {
            if(returnLength){ returnValue = SSRenderMsgSendWithReturn(self,aSelector);}
            else            { SSRenderMsgSendWithoutReturn(self,aSelector,objs[0],objs[1]);}
            break;
        }
        case 3:
        {
            if(returnLength){ returnValue = SSRenderMsgSendWithReturn(self,aSelector);}
            else            { SSRenderMsgSendWithoutReturn(self,aSelector,objs[0],objs[1],objs[2]);}
            break;
        }
        case 4:
        {
            if(returnLength){ returnValue = SSRenderMsgSendWithReturn(self,aSelector);}
            else            { SSRenderMsgSendWithoutReturn(self,aSelector,objs[0],objs[1],objs[2],objs[3]);}
            break;
        }
        default:
            break;
    }
    return returnValue;
}

@end
