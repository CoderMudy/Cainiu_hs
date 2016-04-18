//
//  CollectionView.h
//  TheOne
//
//  Created by PXJ on 15/10/20.
//  Copyright © 2015年 PXJ. All rights reserved.
//
typedef void(^DidSelectCell)(int);
#import <UIKit/UIKit.h>

@interface CollectionView : UIView

@property (nonatomic,strong)DidSelectCell  selectCell;
@property (nonatomic,strong)NSArray * collectionDataArray;

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;

@end
