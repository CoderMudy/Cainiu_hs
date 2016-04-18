//
//  DetailViewController.h
//  hs
//
//  Created by RGZ on 15/5/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : HSBaseViewController

@property (nonatomic,assign)int     index;


//期货传入title；
@property (nonatomic,strong)NSString    *otherTitle;


@property (nonatomic,assign)BOOL        isUseCustomURL;
@property (nonatomic,strong)NSString    *customURL;

@end
