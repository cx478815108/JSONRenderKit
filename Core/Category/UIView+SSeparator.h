//
//  UIView+Separator.h
//  MyWHUT
//
//  Created by 陈雄 on 16/6/9.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UISeparatorDirection) {
    UISeparatorDirectionNone         = 1 << 0,
    UISeparatorDirectionTop          = 1 << 1,
    UISeparatorDirectionBottom       = 1 << 2,
    UISeparatorDirectionLeft         = 1 << 3,
    UISeparatorDirectionRight        = 1 << 4,
    UISeparatorDirectionAll          = UISeparatorDirectionTop | UISeparatorDirectionBottom | UISeparatorDirectionLeft |UISeparatorDirectionRight
};

@interface UIViewSeparator : NSObject
@property (nonatomic ,assign) UISeparatorDirection separatorDirection;
@property (nonatomic ,assign) CGFloat              separatorHeight;
@property (nonatomic ,strong) UIColor              *separatorColor;
@property (nonatomic ,assign) UIEdgeInsets         separatorHInset;
@property (nonatomic ,assign) UIEdgeInsets         separatorVInset;
@end

typedef void (^UIViewSeparatorBlock)(UIViewSeparator *ss_separator);

@interface UIView (FSeparator)
-(void)ss_setSeparator:(UIViewSeparatorBlock)separator;
@end
