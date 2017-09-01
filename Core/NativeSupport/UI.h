//
//  UI.h
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/6/19.
//  Copyright © 2017年 com.feelings. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol UI <JSExport>
@optional

JSExportAs(log, -(void)log:(NSString *)msg);
JSExportAs(alert, -(void)alertWithTitle:(NSString *)title msg:(NSString *)msg);
JSExportAs(alertTitles, -(void)alertWithTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray *)actionTitles callBack:(JSValue *)callBack);
JSExportAs(showIndicator, -(void)showIndicatorWithStyle:(NSString *)style);
JSExportAs(hideIndicatorDelay, -(void)hideIndicatorDelay:(NSInteger)delay);
JSExportAs(showSheetView, -(void)showSheetViewWithTitle:(NSString *)title msg:(NSString *)msg actionTitles:(NSArray *)actionTitles callBack:(JSValue *)callBack);

@property(nonatomic, assign, readonly) CGFloat  screenW;
@property(nonatomic, assign, readonly) CGFloat  screenH;
@property(nonatomic, copy  , readonly) NSString *themeColor;
@property(nonatomic, copy  , readonly) NSString *cyanColor;
@property(nonatomic, copy  , readonly) NSString *orangeColor;
@property(nonatomic, copy  , readonly) NSString *pureColor;
@property(nonatomic, copy  , readonly) NSString *lightCyanColor;
@property(nonatomic, copy  , readonly) NSString *blueColor;
@property(nonatomic, copy  , readonly) NSString *pinkRedColor;
@property(nonatomic, copy  , readonly) NSString *lightOrgangeColor;
@end

@interface UI : NSObject<UI>

@end
