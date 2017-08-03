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

@class SSJSContext;
@interface SSBaseRenderController : UIViewController
@property(nonatomic ,strong) SSJSContext *jsContext;
@property(nonatomic ,copy  ) NSString    *url;
@property(nonatomic ,strong ,readonly) UIActivityIndicatorView *indicatorView;
+(SSBaseRenderController *)currentController;
+(void)setCurrentController:(SSBaseRenderController *)controller;
-(void)startRender;
-(void)showIndicator;
-(void)hideIndicator;
@end
