//
//  TiXianListCell.h
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiXianListModel.h"

@class TiXianFrameModel;
@interface TiXianListCell : UITableViewCell

@property(nonatomic,strong) UILabel *moneyLab;//提现金额
@property(nonatomic,strong) UILabel *timeLab;//时间
@property(nonatomic,strong) UIButton *tiXianCancelBtn;//提现撤回或者已撤回按钮
@property(nonatomic,strong) UILabel *statusLab;//审核状态（已审核，未审核，成功，已撤回等状态）
@property(nonatomic,strong) UIImageView *downImg;//向下的箭头

@property(nonatomic,assign) NSInteger row;

@property(nonatomic,strong) TiXianFrameModel *frameModel;
@property(nonatomic,strong) TiXianListModel *ListModel;

@property(nonatomic,copy) void(^clickCancelAction)(TiXianListModel *model,NSInteger);

- (void)fillWithData:(TiXianFrameModel *)tiXianModel;

@end
