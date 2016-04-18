//
//  UserSpreadQR.h
//  hs
//
//  Created by PXJ on 15/10/12.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSpreadQR : UIView

@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,strong)UIImageView * imgV;

-(id)initWithFrame:(CGRect)frame imageUrl:(NSString*)strUrl;

@end
