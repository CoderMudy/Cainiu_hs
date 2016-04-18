//
//  IndexOptionButton.h
//  hs
//
//  Created by RGZ on 16/3/7.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IndexOptionBlock)(NSMutableArray *aTitleArray,NSMutableArray *aImgArray,NSMutableArray *aStatusArray);

@interface IndexOptionButton : UIView

@property (nonatomic,strong)IndexOptionBlock    optionBlock;

-(void)setCainiuStatus:(int)aCainiuStatus   ScoreStatus:(int)aScoreStatus   NanjsStatus:(int)aNanjsStatus;

-(void)goActivateMoney;

@end
