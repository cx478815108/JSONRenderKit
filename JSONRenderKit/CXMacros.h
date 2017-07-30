//
//  CXFunctionKit.h
//  小代码测试
//
//  Created by 陈雄 on 16/1/2.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>


#define weakify(o)   autoreleasepool{} __weak typeof(o) o##Weak = o;
#define strongify(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  屏幕的宽和高
 */
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width) //屏幕的宽
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height) //屏幕的高

/**
 *  设备识别
 */

#define IPHONESMALL ([UIScreen mainScreen].bounds.size.width==320.0f)

#define IPHONE4S    (([UIScreen mainScreen].bounds.size.width==320.0f && [UIScreen mainScreen].bounds.size.height==480.0f)?TRUE:FALSE)
#define IPHONESE    (([UIScreen mainScreen].bounds.size.height==568.0f && [UIScreen mainScreen].bounds.size.width == 320.0f)?TRUE:FALSE)
#define IPHONE6     (([UIScreen mainScreen].bounds.size.height==667.0f)?TRUE:FALSE)
#define IPHONEPlus  (([UIScreen mainScreen].bounds.size.height==736.0f)?TRUE:FALSE)

/**
 *  弧度和角度互换
 */
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

/**
 *  RGBA颜色
 */
#define kColorAlpha(r, g, b, A) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:A]


/**
 *  RGB颜色
 */
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define kRandomColor kColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

/**
 *  打印中文
 */
#if DEBUG
#define CXCLog(format, ...) fprintf(stderr,"\n方法:%s\t行数:%d\n内容:%s\n\n", __FUNCTION__, __LINE__, [[NSString stringWithCString:[[NSString stringWithFormat:format, ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
#else
#define CXCLog(format, ...) nil
#endif

/**
 *  DEBUG 打印
 */
#ifdef DEBUG // 调试状态, 打开LOG功能
#define DebugLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define DebugLog(...)
#endif


/**
 *  断言
 */
#define CXAssert(condition, ...)\
do {\
    if (!(condition)) {\
        [[NSAssertionHandler currentHandler]\
         handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]\
         file:[NSString stringWithUTF8String:__FILE__]\
         lineNumber:__LINE__\
         description:__VA_ARGS__];\
    }\
} while(0)


/**
 *  将给定的列表的object拼接为字符串
 */
NS_INLINE NSString *_cx_stringJoint(id format, ...) {
    NSMutableString *_joinSting=[NSMutableString string];
    va_list params;
    va_start(params,format);
    id arg;
    if (format==nil) return nil;
    [_joinSting appendFormat:@"%@",format];
    while((arg = va_arg(params,id)))
    {
        if (arg) [_joinSting appendFormat:@"%@",arg];
    }
    va_end(params);
    return _joinSting;
}

/**
 *  将任意对象拼接为字符串
 */
#define CXStringJoint(format,...) _cx_stringJoint(format, ##__VA_ARGS__,nil)

#define _CXPropertyName(obj,keyPath) @(((void)(NO && ((void)obj.keyPath, NO)), #obj))

/**
 *  取得对象属性的字符串
 */
#define CXPropertyName(obj) [(_CXPropertyName(obj,self)) componentsSeparatedByString:@"."].lastObject


/**
 *  单例模式宏
 */

#define singletonInterface(className)   +(instancetype)shared##className;

#define singletonImplementation(className)   static className *_instance;\
+(instancetype)shared##className\
{    static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc]init];\
});return _instance;}\
+(id)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];});\
return _instance;}\
-(id)copyWithZone:(NSZone *)zone{\
return _instance;}

