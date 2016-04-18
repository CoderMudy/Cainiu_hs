//
//  SpreadPage.h
//  hs
//
//  Created by PXJ on 15/8/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpreadPage : UIViewController
@property (nonatomic,strong)NSString * costMoney;
@property (nonatomic,strong)NSMutableArray  * brokerageArray;
@property (nonatomic,strong)NSString * shareAddress;//分享链接
@property (nonatomic,strong)NSString * invitNum;

//复制链接
- (void)pasteLink;
//分享
- (void)selectShare;
- (void)initUI;
//二维码
- (CIImage *)createQRForString:(NSString *)qrString;
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
- (void)getPromotionLink;
- (void)getBrokerageClickIndexPath:(NSIndexPath*)indexPath withClickBtn:(UIButton*)button btnBackImageV:(UIImageView*)backImageV;
- (void)setClickImageIndexPath:(NSIndexPath*)indexPath withClickBtn:(UIButton *)button ImageV:(UIImageView *)imageV status:(int)status;
@end
