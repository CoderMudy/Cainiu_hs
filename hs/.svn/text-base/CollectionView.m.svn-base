//
//  CollectionView.m
//  TheOne
//
//  Created by PXJ on 15/10/20.
//  Copyright © 2015年 PXJ. All rights reserved.
//

#import "CollectionView.h"
#import "AddView.h"
@interface CollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{


}
@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation CollectionView

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _collectionDataArray = array;
        [self initConllection];
        
        
    }
    return self;
}


- (void)initConllection
{
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfViewHidden)];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    backView.alpha = 0.3;
    backView.backgroundColor = Color_black;
    [self addSubview:backView];
    [backView addGestureRecognizer:tapGesturRecognizer];

    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0.5;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ScreenWidth/4) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self addSubview:_collectionView];


}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;

}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.backgroundColor = Color_black;
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    int num = (int)indexPath.item;
    AddView * addView = [[AddView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-3)/4, ScreenWidth/4) imageName:[NSString stringWithFormat:@"%d",num%3] dsc:_collectionDataArray[num%3]];
    [cell.contentView addSubview:addView];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-3)/4, ScreenWidth/4);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectCell((int)indexPath.item);
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
   [UIView animateWithDuration:0.2 animations:^{
        
       cell.contentView.backgroundColor = RGBCOLOR(50, 50, 50);
        
    } completion:^(BOOL finished) {
        cell.contentView.backgroundColor = Color_black;
//        [self selfViewHidden];
    }];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)selfViewHidden
{
    [UIView  animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];

}
@end
