//
//  SearchTableViewCell.h
//  hs
//
//  Created by PXJ on 15/4/30.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//
typedef void(^OptionalBtnClick)(id);

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (copy) OptionalBtnClick optionalBtnClick;
@property (nonatomic,strong)UILabel * labNum;
@property (nonatomic,strong)UILabel * labName;
@property (nonatomic,strong)UIButton * optionalBtn;
//@property (nonatomic,strong)UILabel * labType;
@end
