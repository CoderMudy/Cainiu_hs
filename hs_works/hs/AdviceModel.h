//
//  AdviceModel.h
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//  ======回复记录界面的Model

#import <Foundation/Foundation.h>

@interface AdviceModel : NSObject

@property(nonatomic,strong) NSString *subContent;
@property(nonatomic,strong) NSString *subTime;
@property(nonatomic,strong) NSString *answerMesg;
@property(nonatomic,strong) NSString *answerTime;
@property(nonatomic,assign) NSInteger status;

- (instancetype)initWithFillDic:(NSDictionary *)dic;

@end
