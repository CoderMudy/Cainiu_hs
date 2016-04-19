//
//  FoyerTableView.h
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

typedef void(^FoyerPushBlock)(NSString * pushPage,NSDictionary * dic,FoyerProductModel * productModel);


typedef enum {
    SubViewBackStyle,//从内页返回
    OtherPageBackStyle,//从其他页面返回
    BackStyleDefault,
}BackStyle;

#import <UIKit/UIKit.h>

@class FoyerPage;
@interface FoyerTableView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    //大厅头部广告图片名称数组
    NSMutableArray * _imageUrlArray;
}
@property (nonatomic,copy)FoyerPushBlock pushBlock;
@property (nonatomic,assign)BackStyle backStyle;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)RDVTabBarController *rdvTabBarController;
- (void)viewAppearLoadData;
- (void)viewDisAppearLoadData;

@end
