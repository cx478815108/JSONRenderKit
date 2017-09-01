//
//  SSJSContext.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "SSJSContext.h"
#import "UI.h"
#import "CXMacros.h"
#import "NSObject+SSRender.h"
#import "JSONSpider.h"

SSJSContext *_currentContext=nil;

@interface SSJSContext()
@property(nonatomic ,strong) NSMutableDictionary *plugins;
@end

@implementation SSJSContext

+(instancetype)context
{
    SSJSContext *obj = [[SSJSContext alloc] init];
    return obj;
}

+(SSJSContext *)currentContext{
    return _currentContext;
}

+(void)setCurrentContext:(SSJSContext *)context{
    _currentContext=context;
}

- (instancetype)init
{
    self = [super init];
    if (self) {[self injectNativeSupport];}
    return self;
}

-(void)releaseObjcs
{
    //获取JS脚本里面的jsValueObjs
    // get the jsValueObjs form the script
    JSValue *jsValueObjs = [self evaluateScript:@"jsValueObjs"];
    //转化为OC的对象
    // turn it to the Objective-C objects
    NSArray *objs = [jsValueObjs toObject];
    [objs enumerateObjectsUsingBlock:^(NSObject  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //清空jsValue，否则内存泄露
        //must set nil to the value or it will cause the memory leak
        obj.jsValue=nil;
    }];
}

/**
 注入写好的JS脚本和必要方法
 inject the prepared JavaScript and methods for running
 */
-(void)injectNativeSupport
{
    self.exceptionHandler = ^(JSContext *context, JSValue *exception){NSLog(@"%@",exception);};
    
    //给JS定义一个函数，JS调用该函数可以达到调用OC实例对象的方法，其中JS传递的参数会自动转化为OC相应的类型
    //to define a function which JS can call and the parameters will turn to the relevant types of Objective-C
    self[@"oc_invokeWithArgs"] = ^id(JSValue *ocPointer,
                                 NSString *methodName,
                                 JSValue *args){
        id ocObj           = [ocPointer toObject];
        SEL methodSelector = NSSelectorFromString(methodName);
        NSArray *oc_args   = [args toArray];
        //调用给NSObject添加的方法，可以调用OC实例对象的方法
        //call this method to invoke any methods of Objective-C object
        id obj             = [ocObj js_performSelector:methodSelector withObjects:oc_args];
        return obj;
    };
    
    //给JS定义一个函数，JS调用该函数可以达到调用OC实例对象的方法，只支持一个参数，不会自动转化为OC相应的类型
    //to define a function which JS can call and the parameters will not turn to the relevant types of Objective-C
    self[@"oc_invokeWithOneJSArg"] = ^id(JSValue *ocPointer,
                                         NSString *methodName,
                                         JSValue *arg){
        id  ocObj          = [ocPointer toObject];
        SEL methodSelector = NSSelectorFromString(methodName);
        id  obj            = [ocObj js_performSelector:methodSelector withObjects:@[arg]];
        return obj;
    };
    
    //给JS定义一个函数，JS调用该函数可以获取一个OC对象，JS对象保存这个OC对象
    //to define a function which JS can call and get the returned value
    self[@"oc_creatObject"] = ^id(JSValue *ocClsName){
        //获取OC的类名
        NSString *classString = [ocClsName toString];
        Class instanceClass   = NSClassFromString(classString);
        id obj                = [[instanceClass alloc] init];
        return obj;
    };
    
    //给JS定义一个函数，JS该函数可以发送网络请求，并以回调函数的方式进行
    //JSValue *success 是JS传递的一个参数（箭头函数），传递过来后就是JSValue,通过callWithArguments调用，如果传递的是JS类实例，通过invokeMethod:withArguments执行JS的方法
    
    //to define a function which JS can use to send the Internet request
    //JSValue *success is a parameter which is the arrow function,when passed form the JS,it can be used through callWithArguments,and if the success parameter is a JS object you can use invokeMethod:withArguments to run the relevant function
    self[@"oc_urlRequest"] = ^void(NSString *url,NSString *type,JSValue *parameters,JSValue *success,JSValue *failure){
        NSDictionary *ocParameters = [parameters isUndefined]?nil:[parameters toDictionary];
        if ([type isEqualToString:@"GET"]) {
            [JSONSpider getWithURLString:url parameters:ocParameters success:^(id responseObject) {
                [success callWithArguments:@[responseObject]];
            } failure:^(NSError *netError) {
                [failure callWithArguments:@[netError.localizedDescription]];
            }];
        }
        else {
            [JSONSpider postWithURLString:url parameters:ocParameters success:^(id responseObject) {
                [success callWithArguments:@[responseObject]];
            } failure:^(NSError *netError) {
                [failure callWithArguments:@[netError.localizedDescription]];
            }];
        }
    };
    
    [self addInternalPlugins];
    @weakify(self);
    self[@"oc_renderFinish"] = ^(){
        @strongify(self);
        [self renderFinish];
    };
    
    //执行相应脚本
    //run the prepared script SSTool.js
    NSString *toolPath = [[NSBundle mainBundle] pathForResource:@"SSTool" ofType:@"js"];
    NSString *sstool   = [NSString stringWithContentsOfFile:toolPath encoding:NSUTF8StringEncoding error:nil];
    //增加sourceURL 你可以在Safari中 给脚本打断点调试
    NSURL *toolURL = [NSURL URLWithString:toolPath];
    [self addSricpt:sstool sourceURL:toolURL];
    
    //执行相应脚本
    //run the prepared script SSUIKit.js
    NSString *kitPath = [[NSBundle mainBundle] pathForResource:@"SSUIKit" ofType:@"js"];
    NSString *sskit   = [NSString stringWithContentsOfFile:kitPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *kitURL = [NSURL URLWithString:toolPath];
    [self addSricpt:sskit sourceURL:kitURL];
}

-(void)addInternalPlugins{
    //给JS注入UI这个对象，把UI类定义通过JSExport 输出给JS作为一个对象
    //inject the UI objetc to JS used the JSExport
    UI *uiPlugin = [[UI alloc] init];
    [self addJSPlugin:uiPlugin name:@"UI"];
}

-(void)addJSPlugin:(NSObject *)plugin name:(NSString *)name{
    if ([plugin conformsToProtocol:@protocol(JSExport)]) {
        [self.plugins setObject:plugin forKey:name];
        self[name] = plugin;
    }
}

-(void)addSricpt:(NSString *)sricpt sourceURL:(NSURL *)sourceURL{
    [self evaluateScript:sricpt withSourceURL:sourceURL];
}

-(UIView *)renderWithJSON:(NSDictionary *)json
{
    //准备一个容器视图
    //prepare a UIView used for a container
    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (json == nil) return wrapperView;
    //启动JSON入口
    JSValue *js_renderWithJSON = [self evaluateScript:@"renderWithJSON"];
    [js_renderWithJSON callWithArguments:@[json,wrapperView]];
    return wrapperView;
}

-(void)renderFinish{}

-(NSMutableDictionary *)plugins{
    if (_plugins == nil) {
        _plugins =@{}.mutableCopy;
    }
    return _plugins;
}

-(void)dealloc
{
    CXDebugLog(@"jsContext dead");
}

@end
