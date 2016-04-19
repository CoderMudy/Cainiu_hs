//
//  AdviceModel.m
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AdviceModel.h"

@implementation AdviceModel

- (instancetype)initWithFillDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        _subContent = [Helper judgeStr:dic[@"content"]];
        _subTime    = [Helper judgeStr:dic[@"subTime"]];
        _answerMesg = [Helper judgeStr:dic[@"message"]];
        _answerTime = [Helper judgeStr:dic[@"answerTime"]];
        _status     = [dic[@"status"] intValue];
    }
    
    return self;
}

@end
