//
//  AdviceCell.m
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AdviceCell.h"
#import "AdviceModel.h"
#import "AdviceFrameModel.h"

@implementation AdviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        
//        //用户名
        _subName = [[UILabel alloc]init];
        _subName.font = [UIFont systemFontOfSize:15.0];
        _subName.textColor = [UIColor blackColor];
        [_backView addSubview:_subName];
        
        //问内容
        _subContent = [[UILabel alloc]init];
        _subContent.numberOfLines = 0;
        _subContent.font = [UIFont systemFontOfSize:13.0];
        _subContent.textColor = [UIColor grayColor];
        [_backView addSubview:_subContent];
        
        //问时间
        _subTime = [[UILabel alloc]init];
        _subTime.font = [UIFont systemFontOfSize:12.0];
        _subTime.textColor = [UIColor grayColor];
        [_backView addSubview:_subTime];
        
//        线条
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:216/255.0 green:217/255.0 blue:218/255.0 alpha:1];
        [_backView addSubview:_lineView];
        
        //客服名称
        _answerName = [[UILabel alloc]init];
        _answerName.font = [UIFont systemFontOfSize:15.0];
        _answerName.textColor = [UIColor blackColor];
        [_backView addSubview:_answerName];
        
        //答内容
        _answerMesg = [[UILabel alloc]init];
        _answerMesg.numberOfLines = 0;
        _answerMesg.font = [UIFont systemFontOfSize:13.0];
        _answerMesg.textColor = [UIColor grayColor];
        [_backView addSubview:_answerMesg];
        
        //答时间
        _answerTime = [[UILabel alloc]init];
        _answerTime.font = [UIFont systemFontOfSize:12.0];
        _answerTime.textColor = [UIColor grayColor];
        [_backView addSubview:_answerTime];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    }
    return self;
}

- (void)fillWithData:(AdviceFrameModel *)adviceFrameModel
{
    _frameModel             = adviceFrameModel;
    AdviceModel *model      = _frameModel.model;
    
    _subName.text       = [[CMStoreManager sharedInstance] getUserNick];
    _subContent.attributedText = [Helper multiplicityText:[NSString stringWithFormat:@"%@%@",@"问：",model.subContent] from:0 to:2 color:[UIColor orangeColor]];
    _subTime.text           = model.subTime;
    _answerName.text        = [NSString stringWithFormat:@"%@ 客服",App_appShortName];
    _answerMesg.attributedText = [Helper multiplicityText:[NSString stringWithFormat:@"%@%@",@"答：",model.answerMesg] from:0 to:2 color:[UIColor orangeColor]];
    _answerTime.text           = model.answerTime;
    
    //如果为1就说明有回答，如果为0就只有问
     if (model.status == 1)
     {
         _answerMesg.hidden = NO;
         _answerTime.hidden = NO;
         _answerName.hidden = NO;
         _lineView.hidden   = NO;
     }else
     {
         _answerMesg.hidden = YES;
         _answerTime.hidden = YES;
         _answerName.hidden = YES;
         _lineView.hidden   = YES;
     }
    
    _subTime.frame          = adviceFrameModel.subTimeFrame;
    _subName.frame          = adviceFrameModel.subNameFrame;
    _subContent.frame       = adviceFrameModel.subContentFrame;
    
    _answerTime.frame       = adviceFrameModel.answertimeFrame;
    _answerName.frame       = adviceFrameModel.answerNameFrame;
    _answerMesg.frame       = adviceFrameModel.answerMesgFrame;
    
    _lineView.frame         = adviceFrameModel.lineFrame;
    _backView.frame         = adviceFrameModel.backFrame;
//    +(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)colorFrom to:(int)colorTo color:(UIColor *)color;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
