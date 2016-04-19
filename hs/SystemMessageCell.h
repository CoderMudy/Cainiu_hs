//
//  SystemMessageCell.h
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SysMsgData;
@interface SystemMessageCell : UITableViewCell

@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UILabel * detailLab;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UIImageView  * arrowsImageV;
@property (nonatomic,strong)UIView * whiteBackView;
- (void)setCellWith:(SysMsgData*)sysMsgModel;


@end
