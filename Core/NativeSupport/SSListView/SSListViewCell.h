//
//  SSConfigCell.h
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/22.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSListViewCell : UICollectionViewCell
+(NSString *)reuseIdentify;
-(void)configWithSubviewDicArray:(NSArray *)array;
@end
