//
//  MyCashOrderListView.h
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef enum{
    
    MyCashOrderListSuccess=0,
    MyCashOrderListSign=1,
    MyCashOrderListSet=2,
    MyCashOrderListEnd=3
    
}MyCashOrderListStyle;

#import <UIKit/UIKit.h>

@interface MyCashOrderListView : UIView


@property (nonatomic,assign)NSInteger  pageSize;
@property (nonatomic,assign)NSInteger  pageNo;
@property (nonatomic,assign)MyCashOrderListStyle myCashOrderListStyle;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)FoyerProductModel * productModel;
- (void)pageControl:(NSString * )urlStr wareId:(NSString*)string;
@end
