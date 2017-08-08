//
//  UIView+Separator.m
//  MyWHUT
//
//  Created by 陈雄 on 16/6/9.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import "UIView+SSeparator.h"
#import "UIColor+SSRender.h"
#import <objc/runtime.h>

@interface UIViewSeparator()
@property (nonatomic ,strong) UIView *topSeparatorView;
@property (nonatomic ,strong) UIView *bottomSeparatorView;
@property (nonatomic ,strong) UIView *leftSeparatorView;
@property (nonatomic ,strong) UIView *rightSeparatorView;
@property (nonatomic ,weak  ) UIView *associatedView;
@end

@implementation UIViewSeparator

- (instancetype)init
{
    if (self = [super init]) {
        _separatorHeight    = 0.7f;
        _separatorDirection = UISeparatorDirectionBottom;
        _separatorHInset    = UIEdgeInsetsZero;
        _separatorVInset    = UIEdgeInsetsZero;
        _separatorColor     = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    return self;
}

-(void)updateSeparatorView
{
    CGFloat width  = CGRectGetWidth(self.associatedView.frame);
    CGFloat height = CGRectGetHeight(self.associatedView.frame);
    if (self.separatorDirection & UISeparatorDirectionTop) {
        CGFloat hWidth                        = width - self.separatorHInset.left - self.separatorHInset.right;
        _topSeparatorView.hidden              = NO;
        self.topSeparatorView.backgroundColor = self.separatorColor;
        self.topSeparatorView.frame           = CGRectMake(self.separatorHInset.left,
                                                           self.separatorHInset.top,
                                                           hWidth,
                                                           self.separatorHeight);
        [self.associatedView bringSubviewToFront:self.topSeparatorView];
    }
    else{ _topSeparatorView.hidden = YES;}
    if (self.separatorDirection & UISeparatorDirectionBottom) {
        CGFloat hWidth                           = width - self.separatorHInset.left - self.separatorHInset.right;
        _bottomSeparatorView.hidden              = NO;
        self.bottomSeparatorView.backgroundColor = self.separatorColor;
        self.bottomSeparatorView.frame           = CGRectMake(self.separatorHInset.left,
                                                              height - self.separatorHInset.bottom,
                                                              hWidth,
                                                              self.separatorHeight);
        [self.associatedView bringSubviewToFront:self.bottomSeparatorView];
    }
    else{ _bottomSeparatorView.hidden = YES;}
    if (self.separatorDirection & UISeparatorDirectionLeft) {
        _leftSeparatorView.hidden              = NO;
        CGFloat vHeight                        = height - self.separatorVInset.bottom - self.separatorVInset.top;
        self.leftSeparatorView.backgroundColor = self.separatorColor;
        self.leftSeparatorView.frame           = CGRectMake(self.separatorVInset.left,
                                                            self.separatorVInset.top,
                                                            self.separatorHeight,
                                                            vHeight);
        [self.associatedView bringSubviewToFront:self.leftSeparatorView];
    }
    else{ _leftSeparatorView.hidden = YES;}
    if (self.separatorDirection & UISeparatorDirectionRight) {
        _rightSeparatorView.hidden              = NO;
        CGFloat vHeight                         = height - self.separatorVInset.bottom - self.separatorVInset.top;
        self.rightSeparatorView.backgroundColor = self.separatorColor;
        self.rightSeparatorView.frame           = CGRectMake(width-self.separatorVInset.right,
                                                             self.separatorVInset.top,
                                                             self.separatorHeight,
                                                             vHeight);
        [self.associatedView bringSubviewToFront:self.rightSeparatorView];
    }
    else{ _rightSeparatorView.hidden=YES;}
}

#pragma mark - getter
-(UIView *)topSeparatorView
{
    if (_topSeparatorView==nil) {
        _topSeparatorView=[[UIView alloc] init];
        [self.associatedView addSubview:_topSeparatorView];
    }
    return _topSeparatorView;
}

-(UIView *)bottomSeparatorView
{
    if (_bottomSeparatorView==nil) {
        _bottomSeparatorView=[[UIView alloc] init];
        [self.associatedView addSubview:_bottomSeparatorView];
    }
    return _bottomSeparatorView;
}

-(UIView *)leftSeparatorView
{
    if (_leftSeparatorView==nil) {
        _leftSeparatorView = [[UIView alloc] init];
        [self.associatedView addSubview:_leftSeparatorView];
    }
    return _leftSeparatorView;
}

-(UIView *)rightSeparatorView
{
    if (_rightSeparatorView==nil) {
        _rightSeparatorView = [[UIView alloc] init];
        [self.associatedView addSubview:_rightSeparatorView];
    }
    return _rightSeparatorView;
}
@end

@interface UIView()
@property(nonatomic ,strong) UIViewSeparator *ss_separator;
@end

@implementation UIView (SSeparator)

+ (void)swizzleOldSelector:(SEL)oldSelector newSelector:(SEL)newSelector{
    Class class      = [self class];
    Method oldMethod = class_getInstanceMethod(class, oldSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    BOOL success     = class_addMethod(class, oldSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (success) { class_replaceMethod(class,
                                       newSelector,
                                       method_getImplementation(oldMethod),
                                       method_getTypeEncoding(oldMethod));}
    else { method_exchangeImplementations(oldMethod, newMethod);}
}

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ [self swizzleOldSelector:@selector(layoutSubviews)
                                              newSelector:@selector(ss_layoutSubviews)];});
}

-(void)ss_layoutSubviews
{
    [self ss_layoutSubviews];
    if (self.ss_separator) {[self.ss_separator updateSeparatorView];}
}


#pragma mark - setter
-(void)ss_setSeparator:(UIViewSeparatorBlock)separator
{
    if (self.ss_separator==nil)                { self.ss_separator = [[UIViewSeparator alloc] init];}
    if (self.ss_separator.associatedView==nil) { self.ss_separator.associatedView = self;}
    separator(self.ss_separator);
    [self.ss_separator updateSeparatorView];
}

-(void)ss_setSeparatorWithDirection:(NSString *)direction color:(NSString *)color height:(NSString *)height
{
    if (direction) {
        UISeparatorDirection sd = UISeparatorDirectionNone;
        if ([direction isEqualToString:@"none"]) {
            [self ss_setSeparator:^(UIViewSeparator *ss_separator) { ss_separator.separatorDirection = sd;}];
        }
        else if ([direction isEqualToString:@"all"]){
            [self ss_setSeparator:^(UIViewSeparator *ss_separator) { ss_separator.separatorDirection = UISeparatorDirectionAll;}];
        }
        else{
            if ([direction containsString:@"left"])   { sd = sd | UISeparatorDirectionLeft;}
            if ([direction containsString:@"right"])  { sd = sd | UISeparatorDirectionRight;}
            if ([direction containsString:@"top"])    { sd = sd | UISeparatorDirectionTop;}
            if ([direction containsString:@"bottom"]) { sd = sd | UISeparatorDirectionBottom;}
        }
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) { ss_separator.separatorDirection=sd;}];
    }
    
    if (color) {
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) { ss_separator.separatorColor = [UIColor ss_colorWithString:color];}];
    }
    
    if (height) {
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) { ss_separator.separatorHeight = [height floatValue];}];
    }
}

#pragma mark - getter

-(UIViewSeparator *)ss_separator
{
    UIViewSeparator *obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

-(void)setSs_separator:(UIViewSeparator *)ss_separator
{
    objc_setAssociatedObject(self, @selector(ss_separator), ss_separator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
