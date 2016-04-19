//
//  CouponsPage.h
//  hs
//
//  Created by PXJ on 15/11/16.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef enum{
    couponsStyleEnable,
    couponsStyleUnEnable
    
    

}CouponsListStyle;

#import <UIKit/UIKit.h>

@interface CouponsPage : UIViewController

@property (nonatomic,assign)CouponsListStyle couponsListStyle;
@property (nonatomic,assign)int couponsNum;

@end
