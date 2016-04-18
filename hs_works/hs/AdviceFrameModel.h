//
//  AdviceFrameModel.h
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//  ======回复记录界面的FrameModel

#import <Foundation/Foundation.h>
@class AdviceModel;
@interface AdviceFrameModel : NSObject

@property(nonatomic,assign) CGRect subNameFrame;
@property(nonatomic,assign) CGRect subContentFrame;
@property(nonatomic,assign) CGRect subTimeFrame;

@property(nonatomic,assign) CGRect answerNameFrame;
@property(nonatomic,assign) CGRect answerMesgFrame;
@property(nonatomic,assign) CGRect answertimeFrame;
@property(nonatomic,assign) CGRect backFrame;
@property(nonatomic,assign) CGRect lineFrame;

@property(nonatomic,assign) CGFloat cellHeight;

@property(nonatomic,strong) AdviceModel *model;

- (instancetype)initFillFrameData:(AdviceModel *)adviceModel;

@end
