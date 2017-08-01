//
//  UIView+SSRender.m
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSObject+SSRender.h"
#import "UIColor+SSRender.h"
#import "UIView+SSRender.h"
#import "SSBaseRenderController.h"
#import "UIView+SSeparator.h"

#import <objc/runtime.h>
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <JavaScriptCore/JavaScriptCore.h>

@implementation UIView (SSRender)

+(instancetype)ss_viewWithComponentDic:(NSDictionary *)dic
{
    NSString *cls = dic[@"type"];
    if ([cls isEqualToString:@"ListView"]) {cls=@"SSListView";}
    else if (![cls hasPrefix:@"UI"]) {
        cls = [NSString stringWithFormat:@"UI%@",cls];
    }
    Class instanceCls=NSClassFromString(cls);
    id obj = [[instanceCls alloc] init];
    NSDictionary *style = dic[@"style"];
    [(UIView *)obj setSs_identify:dic[@"id"]];
    if (style) { [(UIView *)obj js_setStyle:style];}

    NSArray *components=dic[@"components"];
    if (components && components.count) { [obj setSs_componentsArray:components];}
    return obj;
}

#pragma mark - properites
-(NSString *)ss_identify
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setSs_identify:(NSString *)ss_identify
{
    objc_setAssociatedObject(self, @selector(ss_identify), ss_identify, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSArray *)ss_componentsArray
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setSs_componentsArray:(NSArray *)ss_componentsArray
{
    objc_setAssociatedObject(self, @selector(ss_componentsArray), ss_componentsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (ss_componentsArray && ss_componentsArray.count) {
        [ss_componentsArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                UIView *view = [UIView ss_viewWithComponentDic:dic];
                [self addSubview:view];
                if (self.ss_viewStore==nil) { self.ss_viewStore=@{}.mutableCopy;}
                [self.ss_viewStore setObject:view forKey:view.ss_identify];
            }
        }];
    }
}

-(NSMutableDictionary *)ss_viewStore
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setSs_viewStore:(NSMutableDictionary *)ss_viewStore
{
    objc_setAssociatedObject(self, @selector(ss_viewStore), ss_viewStore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - setStyle
-(void)js_setStyle:(NSDictionary *)style
{
    if(style[@"backgroundColor"]){
        {self.backgroundColor=[UIColor ss_colorWithString:style[@"backgroundColor"]];}
    }
    if(style[@"position"]){
        self.frame=CGRectFromString(style[@"position"]);
    }
    if(style[@"cornerRadius"]){
        self.layer.cornerRadius=[style[@"cornerRadius"] floatValue];
    }
    if(style[@"borderWidth"]){
        self.layer.borderWidth=[style[@"borderWidth"] floatValue];
    }
    if(style[@"borderColor"]){
        self.layer.borderColor=[UIColor ss_colorWithString:style[@"borderColor"]].CGColor;
    }
    
    if(style[@"hidden"]){
        self.hidden=[style[@"hidden"] boolValue];
    }
    NSString *direction = style[@"separatorDirection"];
    if (direction) {
        UISeparatorDirection sd = UISeparatorDirectionNone;
        if ([direction isEqualToString:@"none"]) {
            [self ss_setSeparator:^(UIViewSeparator *ss_separator) {
                ss_separator.separatorDirection = sd;
            }];
        }
        else if ([direction isEqualToString:@"all"]){
            [self ss_setSeparator:^(UIViewSeparator *ss_separator) {
                ss_separator.separatorDirection = UISeparatorDirectionAll;
            }];
        }
        else{
            if ([direction containsString:@"left"]) {
                sd = sd | UISeparatorDirectionLeft;
            }
            if ([direction containsString:@"right"]) {
                sd = sd | UISeparatorDirectionRight;
            }
            if ([direction containsString:@"top"]) {
                sd = sd | UISeparatorDirectionTop;
            }
            if ([direction containsString:@"bottom"]) {
                sd = sd | UISeparatorDirectionBottom;
            }
        }
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) {
            ss_separator.separatorDirection=sd;
        }];
    }
    
    NSString *separatorColor = style[@"separatorColor"];
    if (separatorColor) {
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) {
            ss_separator.separatorColor=[UIColor ss_colorWithString:separatorColor];
        }];
    }
    
    NSString *separatorHeight = style[@"separatorHeight"];
    if (separatorHeight) {
        [self ss_setSeparator:^(UIViewSeparator *ss_separator) {
            ss_separator.separatorHeight=[style[separatorHeight] floatValue];
        }];
    }
}

-(void)js_setSubStyles:(NSArray<NSDictionary *> *)subStyles
{
    if (self.ss_viewStore==nil || self.ss_viewStore.allValues.count==0) return;
    [subStyles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = self.ss_viewStore[obj[@"viewId"]];
        [view js_setStyle:obj[@"style"]];
        NSArray *subStyles = obj[@"subStyles"];
        if (subStyles && subStyles.count) {
            [view js_setSubStyles:subStyles];
        }
    }];
}

@end

@implementation UIButton (SSRender)

-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    [self addTarget:self action:@selector(js_didPressedButton) forControlEvents:(UIControlEventTouchUpInside)];
    if (style[@"fontSize"]) {
        self.titleLabel.font=[UIFont systemFontOfSize:[style[@"fontSize"] floatValue]];
    }
    if (style[@"title"]) {
        [self setTitle:style[@"title"] forState:(UIControlStateNormal)];
    }
    if (style[@"highlightTitle"]) {
        [self setTitle:style[@"highlightTitle"] forState:(UIControlStateHighlighted)];
    }
    if (style[@"titleColor"]) {
        [self setTitleColor:[UIColor ss_colorWithString:style[@"titleColor"]] forState:UIControlStateNormal];
    }
    
    if (style[@"highlightTitleColor"]) {
        [self setTitleColor:[UIColor ss_colorWithString:style[@"highlightTitleColor"]] forState:UIControlStateHighlighted];
    }
    else{
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    
    if (style[@"image"]){
        NSURL *url = [NSURL URLWithString:style[@"image"]];
        [self sd_setImageWithURL:url forState:(UIControlStateNormal) completed:nil];
    }
}

-(void)js_didPressedButton
{
    [self.jsValue invokeMethod:@"didPressedButton" withArguments:nil];
}

@end

@implementation UILabel (SSRender)
-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    if (style[@"fontSize"]) {
        self.font=[UIFont systemFontOfSize:[style[@"fontSize"] floatValue]];
    }
    if (style[@"adjustTextFont"]) {
        self.adjustsFontSizeToFitWidth=[style[@"adjustTextFont"] floatValue];
    }
    if (style[@"text"]) {
        self.text=style[@"text"];
    }
    if (style[@"textColor"]) {
        self.textColor=[UIColor ss_colorWithString:style[@"textColor"]];
    }
    
    NSString *align=style[@"align"];
    if (align) {
        NSDictionary *aligns=@{@"left":@(NSTextAlignmentLeft),@"right":@(NSTextAlignmentRight),@"center":@(NSTextAlignmentCenter)};
        if ([aligns.allKeys containsObject:align]) {
            self.textAlignment=[aligns[align] integerValue];
        }
    }
}
@end


@implementation UIScrollView (SSRender)
-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    if (style[@"showHBar"]){
        self.showsHorizontalScrollIndicator=[style[@"showHBar"] boolValue];
    }
    if (style[@"showVBar"]) {
        self.showsVerticalScrollIndicator=[style[@"showVBar"] boolValue];
    }
    if (style[@"scrollSize"]) {
        self.contentSize=CGSizeFromString(style[@"scrollSize"]);
    }
    if (style[@"splitPage"]) {
        self.pagingEnabled=[style[@"splitPage"] boolValue];
    }
    if (style[@"allowScroll"]) {
        self.scrollEnabled=[style[@"allowScroll"] boolValue];
    }
    self.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
}
@end


@implementation UIImageView (SSRender)
-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    NSString *mode=style[@"imageMode"];
    if (mode){
        NSDictionary *modes=@{@"fill":@(0),@"aspectfit":@(1),@"aspectfill":@(2)};
        if ([modes.allKeys containsObject:mode]) {
            self.contentMode=[modes[mode] integerValue];
        }
    }
    NSString *image=style[@"image"];
    if (image){
        NSURL *url = [NSURL URLWithString:image];
        [self sd_setImageWithURL:url completed:nil];
    }
}
@end

@implementation UITextField (SSRender)

-(void)ss_addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_removeObserver) name:SSViewDidDisappearNotification object:nil];
}

-(void)ss_removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handeleWithNotification:(NSNotification *)notification{
    UITextField *field = notification.object;
    if (![self isEqual:field]) return;
    [self.jsValue invokeMethod:@"setText" withArguments:@[field.text]];
}

-(void)ss_textViewTextBeginEditing:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)ss_textViewTextDidChange:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)ss_textViewTextDidEndEditing:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    [self ss_addNotification];
    if (style[@"textColor"]) {
        self.textColor=[UIColor ss_colorWithString:style[@"textColor"]];
    }
    if (style[@"placeholder"]) {
        self.placeholder=style[@"placeholder"];
    }
    NSString *align=style[@"align"];
    if (align) {
        NSDictionary *aligns=@{@"left":@(NSTextAlignmentLeft),@"right":@(NSTextAlignmentRight),@"center":@(NSTextAlignmentCenter)};
        if ([aligns.allKeys containsObject:align]) {
            self.textAlignment=[aligns[align] integerValue];
        }
    }
    NSString *borderStyle=style[@"borderStyle"];
    if (borderStyle) {
        NSDictionary *style=@{@"none":@(UITextBorderStyleNone),@"line":@(UITextBorderStyleLine),@"bezel":@(UITextBorderStyleBezel),@"roundedRect":@(UITextBorderStyleRoundedRect)};
        self.borderStyle=[style[borderStyle] integerValue];
    }
    if (style[@"cursorColor"]) {
        self.tintColor=[UIColor ss_colorWithString:style[@"cursorColor"]];
    }
    if (style[@"fontSize"]) {
        self.font=[UIFont systemFontOfSize:[style[@"fontSize"] floatValue]];
    }
    if([style[@"showClear"] boolValue]){
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    else{
        self.clearButtonMode=UITextFieldViewModeNever;
    }
    NSNumber *clearOnBegin=style[@"clearOnBegin"];
    if(clearOnBegin){
        self.clearsOnBeginEditing=[clearOnBegin boolValue];
    }
}

@end

@implementation UITextView (SSRender)

-(void)ss_addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_textViewTextDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ss_removeObserver) name:SSViewDidDisappearNotification object:nil];
}

-(void)ss_removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handeleWithNotification:(NSNotification *)notification{
    UITextView *textView = notification.object;
    if (![self isEqual:textView]) return;
    //save the text value to the relevant JS Object 
    [self.jsValue invokeMethod:@"setText" withArguments:@[textView.text]];
}

-(void)ss_textViewTextBeginEditing:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)ss_textViewTextDidChange:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)ss_textViewTextDidEndEditing:(NSNotification *)notification
{
    [self handeleWithNotification:notification];
}

-(void)js_setStyle:(NSDictionary *)style
{
    [super js_setStyle:style];
    self.text=style[@"text"];
    if (style[@"textColor"]) {
        self.textColor=[UIColor ss_colorWithString:style[@"textColor"]];
    }
    if (style[@"showVBar"]) {
        self.showsVerticalScrollIndicator=[style[@"showVBar"] boolValue];
    }
    NSString *align=style[@"align"];
    if (align) {
        NSDictionary *aligns=@{@"left":@(NSTextAlignmentLeft),@"right":@(NSTextAlignmentRight),@"center":@(NSTextAlignmentCenter)};
        if ([aligns.allKeys containsObject:align]) {
            self.textAlignment=[aligns[align] integerValue];
        }
    }
    if (style[@"cursorColor"]) {
        self.tintColor=[UIColor ss_colorWithString:style[@"cursorColor"]];
    }
    if (style[@"fontSize"]) {
        self.font=[UIFont systemFontOfSize:[style[@"fontSize"] floatValue]];
    }
    if (style[@"allowEdit"]) {
        self.editable=[style[@"allowEdit"] boolValue];
    }
}

@end
