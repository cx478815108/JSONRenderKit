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

@interface SSListView()<UICollectionViewDataSource,
                        UICollectionViewDelegate>

@property(nonatomic ,strong) UICollectionView           *collectionView;
@property(nonatomic ,strong) UICollectionViewFlowLayout *layout;
@property(nonatomic ,strong) NSDictionary               *style;
@end

@implementation SSListView{
    UIColor *_cachedColor;
}

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


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

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
    [listViewCell configItemStyle:self.itemStyle];
    //设置style
    NSDictionary *style = self.dataArray[indexPath.item];
    if (style && [style isKindOfClass:[NSDictionary class]]) {
        [listViewCell js_setStyle:style];
    }
    return listViewCell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemHighlightColor = self.itemStyle[@"itemHighlightColor"];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    _cachedColor=cell.backgroundColor;
    if (itemHighlightColor) {
        cell.backgroundColor=[UIColor ss_colorWithString:itemHighlightColor];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=_cachedColor;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.jsValue invokeMethod:@"didSelectItemAtIndex" withArguments:@[@(indexPath.item)]];
    [self postEndEditingNotification];
    [self collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
}


#pragma mark - action
-(void)deleteItemAtIndexString:(NSString *)index
{
    NSInteger realIndex = [index integerValue];
    if (realIndex<0 && self.dataArray.count <= realIndex+1) return;
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        [array removeObjectAtIndex:realIndex];
        self.dataArray=array;
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:realIndex inSection:0]]];
    } completion:nil];
}

-(void)addItemToTrail:(NSDictionary *)item
{
    [self addItem:item atIndexString:[NSString stringWithFormat:@"%@",@(self.dataArray.count)]];
}

-(void)addItem:(NSDictionary *)item atIndexString:(NSString *)index
{
    if(![item isKindOfClass:[NSDictionary class]]) return;
    
    NSInteger realIndex = [index integerValue];
    if (realIndex<0 && realIndex>self.dataArray.count) return;
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        [array insertObject:item atIndex:realIndex];
        self.dataArray=array;
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:realIndex]]];
    } completion:nil];
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
