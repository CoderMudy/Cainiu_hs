//
//  AccountPageCell.m
//  hs
//
//  Created by PXJ on 16/2/23.
//  Copyright © 2016年 luckin. All rights reserved.
//

#define connectAccount @"connectAccountCell"
#define account @"accountCell"

#import "AccountPageCell.h"
#import "AccountModel.h"
#import "UIImageView+WebCache.h"

@interface AccountPageCell()
{

    CGFloat _cellHeight;
    CGFloat _backHeight;
    NSInteger _cellStyle;
}

@end
@implementation AccountPageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:connectAccount]) {
            _cellHeight = 100*ScreenWidth/375;
            _backHeight = _cellHeight+10;
            _cellStyle = 1;
            [self initConnectUI];
        }else{
            _cellHeight = 85*ScreenWidth/375;
            _backHeight = _cellHeight-10*ScreenWidth/375.0;
            _cellStyle = 0;
            [self initUI];

        }
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor =  RGBACOLOR(239, 239, 244, 1);
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-30, _backHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
//    backView.layer.borderColor = RGBACOLOR(229, 229, 234, 1).CGColor;
//    backView.layer.borderWidth = 1;
    [self addSubview:backView];
    
    
    _accountImgView = [[UIImageView alloc] init];
    _accountImgView.center = CGPointMake(29, _backHeight/2);
    _accountImgView.bounds = CGRectMake(0, 0, 28, 28);
    [backView addSubview:_accountImgView];
    
    _accountNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_accountImgView.frame)+10, 0, 60, _backHeight)];
    _accountNameLab.font = FontSize(15);
    [backView addSubview:_accountNameLab];
    
    _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_accountNameLab.frame), _backHeight/2-_backHeight/16, _backHeight/18, _backHeight/10)];
    _arrowImgV.image = [UIImage imageNamed:@"arrow"];
    [backView addSubview:_arrowImgV];
    
    _posiImgV                     = [[UIImageView alloc] init];
    _posiImgV.center              = CGPointMake(CGRectGetMaxX(_arrowImgV.frame)+20, _arrowImgV.center.y);
    _posiImgV.bounds              = CGRectMake(0, 0, 33, 14);
    _posiImgV.image               = [UIImage imageNamed:@"foyer_6"];
    _posiImgV.hidden              = YES;
    [backView addSubview:_posiImgV];
    
    
    _showLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backView.frame)- ScreenWidth/3-10, 20*ScreenWidth/375, ScreenWidth/3, 12)];
    _showLab.font = FontSize(12);
    _showLab.text = @"可用余额";
    _showLab.adjustsFontSizeToFitWidth = YES;
    _showLab.textAlignment = NSTextAlignmentRight;
    _showLab.textColor = K_color_grayBlack;
    [backView addSubview:_showLab];
    
    _showDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backView.frame)-ScreenWidth/2-15, _backHeight/2, ScreenWidth/2, 22*ScreenWidth/375)];
    _showDetailLab.font = FontSize(19);
    _showDetailLab.text = @"0.00";
    _showDetailLab.adjustsFontSizeToFitWidth = YES;
    _showDetailLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_showDetailLab];
    
    _loginLab = [[UILabel alloc] init];
    _loginLab.center = CGPointMake(ScreenWidth-30-25*ScreenWidth/375, CGRectGetHeight(backView.frame)/2+2);
    _loginLab.bounds = CGRectMake(0, 0, 50*ScreenWidth/375, 24*ScreenWidth/375);
    [self addSubview:_loginLab];
    
}
- (void)initConnectUI
{
    self.backgroundColor =  RGBACOLOR(239, 239, 244, 1);
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, _cellHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
//    backView.layer.borderColor = RGBACOLOR(229, 229, 234, 1).CGColor;
//    backView.layer.borderWidth = 1;
    [self addSubview:backView];
    
    
    _accountImgView = [[UIImageView alloc] init];
    _accountImgView.center = CGPointMake(35, _cellHeight/2);
    _accountImgView.bounds = CGRectMake(0, 0, 40, 40);
    [backView addSubview:_accountImgView];
    
    _accountNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_accountImgView.frame)+10, _cellHeight/5,ScreenWidth/2, _cellHeight/3)];
    _accountNameLab.font = FontSize(16);
    [backView addSubview:_accountNameLab];
    
    UIImageView * arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-10-_cellHeight/5, _cellHeight/2-_cellHeight*2/30, _cellHeight/9*2/3, _cellHeight*2/15)];
    arrowImgV.image = [UIImage imageNamed:@"arrow"];
    [backView addSubview:arrowImgV];
    
    _showLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_accountNameLab.frame), CGRectGetMaxY(_accountNameLab.frame), ScreenWidth/2, 15)];
    _showLab.font = FontSize(12);
    _showLab.textColor = K_color_grayBlack;
    _showLab.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:_showLab];
    
    _separateLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_accountNameLab.frame), 0, ScreenWidth-CGRectGetMaxX(_accountImgView.frame)-35, 1)];
    _separateLine.backgroundColor = K_color_grayLine;
    _separateLine.hidden = YES;
    [backView addSubview:_separateLine];


}
- (void)setCellWithStyle:(NSInteger )Style cellDetail:(id)detailInfo;
{
    if (Style==0) {
        
        AccountModel *model = detailInfo;
        [_accountImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@""]];
        _accountNameLab.text = model.name;
        double amt = 0.000000;
        NSString * showTitle = @"";
        if (model.floatAmt.doubleValue) {
            amt = model.floatAmt.doubleValue;
            if (amt>0) {
                _showDetailLab.textColor = K_color_red;
            }else{
                _showDetailLab.textColor = K_color_green;
            }
            showTitle = @"总持仓盈亏";
            _posiImgV.hidden = NO;
        }else{
            _posiImgV.hidden = YES;
            showTitle = @"可用余额";
            amt = model.amt.doubleValue;
            _showDetailLab.textColor = [UIColor blackColor];
        }
        
        if ([model.code isEqualToString:@"score"]) {
            _showLab.text = [NSString stringWithFormat:@"%@（积分）",showTitle];
            _showDetailLab.text = [Helper addSign:[NSString stringWithFormat:@"%.0f",amt] num:0] ;

        }else{
            _showLab.text = [NSString stringWithFormat:@"%@（元）",showTitle];
            _showDetailLab.text = [Helper addSign:[NSString stringWithFormat:@"%.2f",amt] num:2] ;

        }
        if (model.floatAmt.doubleValue&&amt>0) {
            _showDetailLab.text = [NSString stringWithFormat:@"+%@",_showDetailLab.text];
        }
        UILabel * messageLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 80, _backHeight/2-15*ScreenWidth/375, 80, 30*ScreenWidth/375)];
        [self addSubview:messageLab];

        if ([model.code isEqualToString:@"nanjs"]) {
            _showLab.hidden = YES;
            _showDetailLab.hidden = YES;
            if ([SpotgoodsAccount sharedInstance].isNeedLogin && [SpotgoodsAccount sharedInstance].isNeedRegist)
            {
                _loginLab.text = @"登录";
                _loginLab.backgroundColor = K_COLOR_CUSTEM(255, 133, 39, 1);
                _loginLab.textColor = [UIColor whiteColor];
                _loginLab.textAlignment = NSTextAlignmentCenter;
                _loginLab.font = FontSize(12);
                _loginLab.layer.cornerRadius = 5;
                _loginLab.layer.masksToBounds = YES;
                _loginLab.hidden = NO;
            }else{
                _loginLab.hidden = YES;
            }
            _posiImgV.hidden = YES;
        }else {
            _showDetailLab.hidden = NO;
            _showLab.hidden = NO;
            _loginLab.hidden = YES;

        }
        CGFloat accountNameLength = [Helper calculateTheHightOfText:model.name height:20 font:FontSize(16)];
        _accountNameLab.frame = CGRectMake(CGRectGetMaxX(_accountImgView.frame)+10, 0, accountNameLength, _backHeight);
        _arrowImgV.frame = CGRectMake(CGRectGetMaxX(_accountNameLab.frame), _backHeight/2-_backHeight/16, _backHeight/9, _backHeight/8);
        _posiImgV.center              = CGPointMake(CGRectGetMaxX(_arrowImgV.frame)+20, _arrowImgV.center.y);
        _posiImgV.bounds              = CGRectMake(0, 0, 33, 14);
    }else
    {
        NSDictionary * dic = detailInfo;
        _accountNameLab.text = [NSString stringWithFormat:@"%@",dic[@"showName"]];
        _showLab.text = [NSString stringWithFormat:@"%@",dic[@"detail"]];
        _accountImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"imageName"]]];
        
    }
}
@end
