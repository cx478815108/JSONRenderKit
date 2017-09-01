//
//  UIView+SSRender.h
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView(SSRender)
@property(nonatomic ,copy  ) NSString            *ss_identify;        // use to locate a view
@property(nonatomic ,strong) NSArray             *ss_componentsArray; // the component json objects array used to layout subviews
@property(nonatomic ,strong) NSMutableDictionary *ss_viewStore;       // used for selecting a view


/**
 use the ComponentDic to layout the subviews

 @param dic the component json objects
 @return view
 */
+(instancetype)ss_viewWithComponentDic:(NSDictionary *)dic;

/**
 set the properties according the style
 */
-(void)js_setStyle:(NSDictionary *)style;

/**
  set the properties of the subviews according the style
 */
-(void)js_setSubStyles:(NSArray <NSDictionary *>*)subStyles;

-(void)postEndEditingNotification;
@end
