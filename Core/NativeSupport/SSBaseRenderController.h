//
//  SSBaseRenderController.h
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSJSContext;
static NSString *SSViewDidAppearNotification     = @"ViewDidAppearNotification";
static NSString *SSViewDidDisappearNotification  = @"ViewDidDisappearNotification";

@interface SSBaseRenderController : UIViewController
@property(nonatomic ,strong) SSJSContext *jsContext;
@property(nonatomic ,copy  ) NSString    *url;
-(void)startRender;
@end
