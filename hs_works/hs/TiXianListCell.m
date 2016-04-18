//
//  TiXianListCell.m
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TiXianListCell.h"
#import "TiXianFrameModel.h"
#import "TiXianListModel.h"

@implementation TiXianListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = [UIFont systemFontOfSize:14.0];
        _moneyLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_moneyLab];
        
        _timeLab = [[UILabel alloc]init];
        _timeLab.font = [UIFont systemFontOfSize:12.0];
        _timeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLab];
        
        _statusLab = [[UILabel alloc]init];
        _statusLab.textAlignment = NSTextAlignmentRight;
        _statusLab.font = [UIFont systemFontOfSize:12.0];
        _statusLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_statusLab];
        
        _tiXianCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiXianCancelBtn setImage:[UIImage imageNamed:@"tixian_list_cancel"] forState:UIControlStateNormal];
        [_tiXianCancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_tiXianCancelBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tiXianCancelBtn];
        
        _downImg = [[UIImageView alloc]init];
        _downImg.image = [UIImage imageNamed:@"button_02"];
        [self.contentView addSubview:_downImg];

    }
    
    return self;
}

- (void)fillWithData:(TiXianFrameModel *)tiXianModel
{
    _frameModel = tiXianModel;
    _ListModel = tiXianModel.listModel;
    
    _moneyLab.text = [NSString stringWithFormat:@"%@元",_ListModel.tixianMoney];
    _timeLab.text  = _ListModel.time;
    
    
    if (_ListModel.examineStatus == 0) {
        _statusLab.text = @"未审核";
        
    }else if (_ListModel.examineStatus == 1 || _ListModel.examineStatus == 8)
    {
            _statusLab.text = @"已审核";
        
    }else if (_ListModel.examineStatus == 21)
    {
        _statusLab.text = @"已撤回";
    }else if (_ListModel.examineStatus == 9 || _ListModel.examineStatus == 2)
    {
        _statusLab.text = @"失败";
    }else if(_ListModel.examineStatus == 10)
    {
        _statusLab.text = @"成功";
    }
//    [_tiXianCancelBtn setTitle:ListModel.tixianCancel forState:UIControlStateNormal];
//    _tiXianCancelBtn.hidden = NO;
    if ([_statusLab.text isEqualToString:@"未审核"]) {
        _tiXianCancelBtn.hidden = NO;
    }else
    {
        _tiXianCancelBtn.hidden = YES;
    }
    
    _moneyLab.frame = tiXianModel.tixianMoneyFrame;
    _timeLab.frame = tiXianModel.timeFrame;
    _statusLab.frame = tiXianModel.examineStatusFrame;
    _tiXianCancelBtn.frame = tiXianModel.tixianCancelFrame;
    _downImg.frame = tiXianModel.downImgFrame;
}

- (void)clickAction:(UIButton *)sender
{
    //南交所登出
    Go_SouthExchange_Logout;
    self.clickCancelAction(_ListModel,_row);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
