//
//  TiXianListModel.m
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TiXianListModel.h"

@implementation TiXianListModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        _tixianMoney = [Helper judgeStr:dic[@"inOutAmt"]];
        _time = [Helper judgeStr:dic[@"createDate"]];
//        _tixianCancel = [Helper judgeStr:dic[@"tixianCancel"]];
        _examineStatus = [dic[@"status"] intValue];
        _recodeId = [Helper judgeStr:dic[@"id"]];
    }
    
    return self;
}

@end
