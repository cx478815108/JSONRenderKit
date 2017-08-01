//
//  SSListView.h
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/21.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSListView : UIView
@property(nonatomic ,strong) NSArray      *templateComponents;
@property(nonatomic ,strong) NSArray      *dataArray;
@property(nonatomic ,strong) NSDictionary *itemStyle;
-(void)js_setDataArrays:(NSArray <NSDictionary *>*)array;
-(void)js_addDataWithArray:(NSArray <NSDictionary *>*)array;
-(void)js_setTemplateComponents:(NSArray *)templateComponents;
-(void)js_reloadData;
@end
