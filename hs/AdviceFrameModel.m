//
//  AdviceFrameModel.m
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AdviceFrameModel.h"
#import "AdviceModel.h"

@implementation AdviceFrameModel

- (instancetype)initFillFrameData:(AdviceModel *)adviceModel
{
    if (self = [super init]) {
        _model = adviceModel;
        
        CGFloat timeWidth       = [Helper calculateTheHightOfText:adviceModel.subTime height:20 font:[UIFont systemFontOfSize:12.0]] + 40;
        _subTimeFrame           = CGRectMake(ScreenWidth - timeWidth - 10, 10, timeWidth, 20);//ScreenWidth - timeWidth - 10
        _subNameFrame           = CGRectMake(10, 10, ScreenWidth - 10 - 10 - timeWidth - 10, 20);
        
//        [[CMStoreManager sharedInstance] getUserNick]获取用户昵称
       
        CGSize textSize         =  [Helper sizeWithText:[NSString stringWithFormat:@"%@%@",@"问：",adviceModel.subContent] font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(ScreenWidth - CGRectGetMinX(_subNameFrame) - 10 - 40, 2000)];
        _subContentFrame        = CGRectMake(CGRectGetMinX(_subNameFrame), CGRectGetMaxY(_subNameFrame) + 10, textSize.width, textSize.height);
        
        //判断是问还是答，如果是问，cell的高度增加20，如果是答，加一条线
        if (adviceModel.status == 1) {//如果为1就说明有回答，如果为0就只有问
            
            _lineFrame          = CGRectMake(10, CGRectGetMaxY(_subContentFrame) + 10, ScreenWidth - 40 - 20, 0.5);
            CGFloat answerTimeWidth = [Helper calculateTheHightOfText:adviceModel.answerTime height:20 font:[UIFont systemFontOfSize:12.0]] + 40;
            _answertimeFrame    = CGRectMake(ScreenWidth - answerTimeWidth - 10, CGRectGetMaxY(_lineFrame) + 10, answerTimeWidth, 20);
            _answerNameFrame    = CGRectMake(CGRectGetMinX(_subNameFrame), CGRectGetMinY(_answertimeFrame), ScreenWidth - answerTimeWidth - 30, 20);
            CGSize anMesgSize  = [Helper sizeWithText:[NSString stringWithFormat:@"%@%@",@"答：",adviceModel.answerMesg] font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(ScreenWidth - CGRectGetMinX(_answerNameFrame) - 10 - 40, 2000)];

            _answerMesgFrame    = CGRectMake(CGRectGetMinX(_answerNameFrame), CGRectGetMaxY(_answerNameFrame) + 10, anMesgSize.width, anMesgSize.height);
            
            _backFrame          = CGRectMake(20, 20, ScreenWidth - 40, CGRectGetMaxY(_answerMesgFrame) + 15);
            _cellHeight         = CGRectGetMaxY(_backFrame);
        }else
        {
            _backFrame          = CGRectMake(20, 20, ScreenWidth - 40, CGRectGetMaxY(_subContentFrame) + 15);
//            _lineFrame          = CGRectMake(0, 0, _backFrame.size.width, 0.5);
            _cellHeight         = CGRectGetMaxY(_backFrame);
        }
        
        
    }

    return self;
}

@end
