//
//  SystemMsgDetailPage.h
//  hs
//
//  Created by PXJ on 15/8/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SysMsgData;

@interface SystemMsgDetailPage : UIViewController

@property (nonatomic,strong)SysMsgData * sysMsgModel;
@property (nonatomic,assign)BOOL isPush;
@property (nonatomic,strong)NSString * messageId;

@end
