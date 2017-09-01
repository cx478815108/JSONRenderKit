//
//  SSBaseRenderController.h
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const SSViewDidAppearNotification;
FOUNDATION_EXPORT NSString * const SSViewDidDisappearNotification;

typedef NS_ENUM(NSUInteger, SSJSONRequestType) {
    SSJSONRequestGET,
    SSJSONRequestPOST
};

@interface SSJSONRequest : NSObject
@property(nonatomic ,copy  ) NSString          *url;
@property(nonatomic ,strong) NSDictionary      *parameters;
@property(nonatomic ,assign) SSJSONRequestType type;
@end

@class SSJSContext;
@interface SSBaseRenderController : UIViewController
@property(nonatomic ,strong) SSJSContext   *jsContext;
@property(nonatomic ,strong) SSJSONRequest *jsonRequest;//the optional way to get a json ,youcan directly use startRenderWithJSON:
@property(nonatomic ,strong ,readonly) UIActivityIndicatorView *indicatorView;
+(SSBaseRenderController *)currentController;
+(void)setCurrentController:(SSBaseRenderController *)controller;
-(void)startRenderWithJSON:(NSDictionary *)json;
-(void)showIndicator;
-(void)hideIndicator;
@end
