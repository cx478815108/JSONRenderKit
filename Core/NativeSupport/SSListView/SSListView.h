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

/**
 the collectionViewCell will config the subViews according to the templateComponents
 
 @param templateComponents the subStylesArray
 */
-(void)js_setTemplateComponents:(NSArray *)templateComponents;

/**
 reload the data
 */
-(void)js_reloadData;

/**
 go to the next collectionViewCell
 */
-(void)js_goNextPage;

/**
 go to the previous collectionViewCell
 */
-(void)js_goPreviousPage;

/**
 delete a item according a index string
 
 @param index a index which type is String
 */
-(void)deleteItemAtIndexString:(NSString *)index;

/**
 add a item to the index place
 
 @param item style
 @param index a index which type is String
 */
-(void)addItem:(NSDictionary *)item atIndexString:(NSString *)index;

/**
 add data and item to the trail
 
 @param item style
 */
-(void)addItemToTrail:(NSDictionary *)item;
@end
