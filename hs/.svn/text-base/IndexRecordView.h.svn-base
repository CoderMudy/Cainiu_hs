//
//  RecordView.h
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^PageChange)(FoyerProductModel*productModel,NSDictionary*dic);
typedef void(^RecodeBlock)();
typedef enum{
    IndexRecordTypeEntrustedRecordStyle=0,
    IndexRecordTypeConditionsStyle=1,
    IndexRecordTypeEndStyle=2
}IndexRecordType;
#import <UIKit/UIKit.h>


@class IndexSaleRecordPage,FoyerProductModel;

@interface IndexRecordView : UIView
{
    NSString * _systemTime;
}
@property (nonatomic,copy)PageChange pageChangeBlock;
@property (nonatomic,assign)IndexRecordType indexRecordType;
@property(nonatomic,strong)FoyerProductModel * productModel;
@property(nonatomic,strong)RecodeBlock block;
@property(nonatomic,strong)NSMutableArray * recordArray;
//@property(nonatomic,strong)IndexSaleRecordPage * superVC;
- (id)initWithFrame:(CGRect)frame orderListStyle:(IndexRecordType)listStyle;
- (void)pageControl:(NSString * )urlStr wareId:(NSString*)string;
@end
