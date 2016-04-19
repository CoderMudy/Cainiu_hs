//
//  TiXianFrameModel.m
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TiXianFrameModel.h"
#import "TiXianListModel.h"
@implementation TiXianFrameModel

- (instancetype)initWithData:(TiXianListModel *)model
{
    if (self = [super init]) {
        _listModel = model;
        
        CGFloat width = [Helper calculateTheHightOfText:[NSString stringWithFormat:@"提现金额%@元",model.tixianMoney] height:21 font:[UIFont systemFontOfSize:14.0]];
        _tixianMoneyFrame = CGRectMake(10, 10, width, 21);
        
        _timeFrame = CGRectMake(CGRectGetMinX(_tixianMoneyFrame), CGRectGetMaxY(_tixianMoneyFrame), 120, 21);
        _downImgFrame = CGRectMake(ScreenWidth - 10 - 20,CGRectGetMinY(_tixianMoneyFrame) + 3 + 10, 22, 22);
        
        _examineStatusFrame = CGRectMake(CGRectGetMinX(_downImgFrame) - 50, CGRectGetMinY(_downImgFrame), 40, 21);
        _tixianCancelFrame = CGRectMake(CGRectGetMinX(_examineStatusFrame) - 20 - 20 - 10 - 20, CGRectGetMinY(_tixianMoneyFrame) + 3, 70, 40*ScreenWidth/320);
        
        _cellHeight = CGRectGetMaxY(_timeFrame) + 10;
    }
    return self;
}

@end
