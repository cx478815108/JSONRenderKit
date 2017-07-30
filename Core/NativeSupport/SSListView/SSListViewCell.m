//
//  SSConfigCell.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/22.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "SSListViewCell.h"
#import "NSObject+SSRender.h"
#import "SSJSContext.h"
#import "UIView+SSRender.h"
#import "UIColor+SSRender.h"

@interface SSListViewCell()
@property(nonatomic ,assign) BOOL configed;
@end

@implementation SSListViewCell

+(NSString *)reuseIdentify
{
    return @"SSConfigCell";
}

-(void)configWithSubviewDicArray:(NSArray *)array
{
    if (self.configed) return;
    self.configed=YES;
    if (self.ss_viewStore==nil) {self.ss_viewStore=@{}.mutableCopy;}
    [array enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view=[UIView ss_viewWithComponentDic:obj];
        [self.contentView addSubview:view];
        [self.ss_viewStore setObject:view forKey:view.ss_identify];
    }];
}

-(void)js_setStyle:(NSDictionary *)style
{
    if(style[@"itemBackgroundColor"]){
        {self.backgroundColor=[UIColor ss_colorWithString:style[@"itemBackgroundColor"]];}
    }
    NSArray *subStyles= style[@"subStyles"];
    if (subStyles && subStyles.count) {
        [self js_setSubStyles:subStyles];
    }
}

@end
