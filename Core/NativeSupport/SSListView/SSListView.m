//
//  SSListView.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/21.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "SSListView.h"
#import "SSListViewCell.h"
#import "UIView+SSRender.h"
#import "NSObject+SSRender.h"
#import "UIColor+SSRender.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SSListView()<UICollectionViewDelegateFlowLayout,
                        UICollectionViewDataSource,
                        UICollectionViewDelegate>

@property(nonatomic ,strong) UICollectionView           *collectionView;
@property(nonatomic ,strong) UICollectionViewFlowLayout *layout;
@property(nonatomic ,strong) NSDictionary               *style;
@end

@implementation SSListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame=self.bounds;
}

-(void)js_setTemplateComponents:(NSArray *)templateComponents{
    self.templateComponents=templateComponents;
}

-(void)js_setDataArrays:(NSArray<NSDictionary *> *)array{
    if (array && [array isKindOfClass:[NSArray class]]) {
        self.dataArray=[NSArray arrayWithArray:array];
    }
}

-(void)js_addDataWithArray:(NSArray<NSDictionary *> *)array
{
    if (array && [array isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        [tempArray addObjectsFromArray:array];
        self.dataArray=[NSArray arrayWithArray:tempArray];
    }
}

-(void)js_reloadData{
    [self.collectionView reloadData];
}

-(void)js_setStyle:(NSDictionary *)style{
    [super js_setStyle:style];
    self.style=style;
    if (style[@"showHBar"]){
        self.collectionView.showsHorizontalScrollIndicator=[style[@"showHBar"] boolValue];
    }
    if (style[@"showVBar"]) {
        self.collectionView.showsVerticalScrollIndicator=[style[@"showVBar"] boolValue];
    }
    if (style[@"splitPage"]) {
        self.collectionView.pagingEnabled=[style[@"splitPage"] boolValue];
    }
    if (style[@"allowScroll"]) {
        self.collectionView.scrollEnabled=[style[@"allowScroll"] boolValue];
    }
    if (style[@"itemSize"]) {
        self.layout.itemSize=CGSizeFromString(style[@"itemSize"]);
    }
    if (style[@"itemHMarign"]) {
        self.layout.minimumInteritemSpacing=[style[@"itemHMarign"] floatValue];
    }
    if (style[@"itemVMarign"]) {
        self.layout.minimumLineSpacing=[style[@"itemVMarign"] floatValue];
    }
    NSString *direction = style[@"scrollDirection"];
    if (direction) {
        NSDictionary *directions=@{@"vetical":@(UICollectionViewScrollDirectionVertical),@"horizontal":@(UICollectionViewScrollDirectionHorizontal)};
        self.layout.scrollDirection=[directions[direction] integerValue];
    }
}


#pragma mark - 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSListViewCell *listViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:[SSListViewCell reuseIdentify] forIndexPath:indexPath];
    listViewCell.tag=indexPath.item;
    //只会配置一次
    [listViewCell configWithSubviewDicArray:self.templateComponents];
    NSString *colorString = self.style[@"itemBackgroundColor"];
    if (colorString) {listViewCell.contentView.backgroundColor=[UIColor ss_colorWithString:colorString];}
    //设置style
    NSDictionary *style = self.dataArray[indexPath.item];
    if (style && [style isKindOfClass:[NSDictionary class]]) {
        [listViewCell js_setStyle:style];
    }
    return listViewCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.jsValue invokeMethod:@"didSelectItemAtIndex" withArguments:@[@(indexPath.item)]];
}

#pragma mark - getter
-(UICollectionView *)collectionView
{
    if (_collectionView==nil) {
        self.layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SSListViewCell class] forCellWithReuseIdentifier:[SSListViewCell reuseIdentify]];
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _collectionView;
}

@end
