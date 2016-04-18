//
//  SearchViewController.h
//  hs
//
//  Created by PXJ on 15/4/29.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

typedef enum {
    SearchListStyleHistoryStock,
    SearchListStyleHotStock,
    SearchListStyleSearchStock
} SearchListStyle;

#import <UIKit/UIKit.h>
#import "H5DataCenter.h"

@interface SearchViewController : HSBaseViewController

@property(nonatomic,assign)SearchListStyle searchListStyle;
@property(nonatomic,retain)H5DataCenter *dataCenter;
@end
