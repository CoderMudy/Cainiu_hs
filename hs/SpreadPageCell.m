//
//  SpreadPageCell.m
//  hs
//
//  Created by PXJ on 15/8/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#import "SpreadPageCell.h"




@implementation SpreadPageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _clickBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _clickRightBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickRightBtn.tag              = 1001;
        [_clickRightBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _itemImageV                     = [[UIImageView alloc] init];
        _itemRightImgeV                 = [[UIImageView alloc] init];
        _titleLab                       = [[UILabel alloc] init];
        _titleRightLab                  = [[UILabel alloc] init];
        _detailLab                      = [[UILabel alloc] init];
        _detailRightLab                 = [[UILabel alloc] init];
        
        _titleLab.textAlignment         = NSTextAlignmentCenter;
        _titleRightLab.textAlignment    = NSTextAlignmentCenter;
        _detailLab.textAlignment        = NSTextAlignmentCenter;
        _detailRightLab.textAlignment   = NSTextAlignmentCenter;
        
        _titleLab.numberOfLines         = 0;
        _titleRightLab.numberOfLines    = 0;
        _detailLab.numberOfLines        = 0;
        _detailRightLab.numberOfLines   = 0;
        
        
        
        [self addSubview:_clickBtn];
        [self addSubview:_clickRightBtn];
        [self addSubview:_itemImageV];
        [self addSubview:_itemRightImgeV];
        [self addSubview:_titleLab];
        [self addSubview:_titleRightLab];
        [self addSubview:_detailLab];
        [self addSubview:_detailRightLab];
    }
    return self;
}


-(void)setSpreadPageCellAtIndexPath:(NSIndexPath *)indexPath{
    
    [self updataCellUI:indexPath];
    float spreadHeight;
    switch (indexPath.section) {
        case 0:
        {
            spreadHeight = ScreenWidth*90/375;
            
            _itemImageV.center          = CGPointMake(20+(ScreenWidth-40)/4, spreadHeight*5/16);
            _itemImageV.bounds          = CGRectMake(0, 0,spreadHeight*2/5 , spreadHeight*6/25);
            
            
            _itemRightImgeV.center      = CGPointMake(20+(ScreenWidth-40)*3/4, spreadHeight*5/16);
            _itemRightImgeV.bounds      = CGRectMake(0, 0, spreadHeight*3/10, spreadHeight*27/100);
            
            _titleLab.center            = CGPointMake(20+(ScreenWidth-40)/4, spreadHeight*3/5);
            _titleLab.bounds            = CGRectMake(0, 0, (ScreenWidth-40)/2, spreadHeight/5);
            _titleLab.font              = [UIFont systemFontOfSize:spreadHeight*3/25];
            
            _titleRightLab.center       = CGPointMake(20+(ScreenWidth-40)*3/4, spreadHeight*3/5);
            _titleRightLab.bounds       = CGRectMake(0, 0, (ScreenWidth-40)/2, spreadHeight/5);
            _titleRightLab.font         = [UIFont systemFontOfSize:spreadHeight*3/25];
            
            
            _detailLab.center           = CGPointMake(20+(ScreenWidth-40)/4, spreadHeight*4/5);
            _detailLab.bounds           = CGRectMake(0, 0, (ScreenWidth-40)/2, spreadHeight/5);
            _detailLab.textColor        = K_color_red;
            _detailLab.font             = [UIFont systemFontOfSize:spreadHeight/5];
            
            
            _detailRightLab.center      = CGPointMake(20+(ScreenWidth-40)*3/4, spreadHeight*4/5);
            _detailRightLab.bounds      = CGRectMake(0, 0, (ScreenWidth-40)/2, spreadHeight/5);
            _detailRightLab.textColor   = K_color_red;
            _detailRightLab.font        = [UIFont systemFontOfSize:spreadHeight/5];
            
            [_itemImageV setImage:[UIImage imageNamed:@"01"]];
            [_itemRightImgeV setImage:[UIImage imageNamed:@"02"]];
            
            _titleLab.attributedText    = nil;
            _titleLab.backgroundColor = [UIColor whiteColor];
            _titleLab.textColor       = [UIColor blackColor];
            _titleLab.text              = @"成功邀请好友";
            _titleRightLab.backgroundColor = [UIColor whiteColor];
            _titleRightLab.textColor       = [UIColor blackColor];
            _titleRightLab.attributedText    = nil;
            _titleRightLab.text         = @"好友累计交易手数";
            
            _detailLab.text             = @"0";
            _detailRightLab.text        = @"0";
            
            
            _seperatorLine       = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-1, spreadHeight/6, 1.5, spreadHeight* 3/4)];
            _seperatorLine.backgroundColor= K_COLOR_CUSTEM(213, 213, 213, 1);
            [self addSubview:_seperatorLine];
            
        }
            break;
        case 1:
        {
            
            spreadHeight                = ScreenWidth*80/375;
            _titleLab.center            = CGPointMake(ScreenWidth/2, spreadHeight*3/8);
            _titleLab.bounds            = CGRectMake(0, 0, ScreenWidth-40, spreadHeight*4/8);
            _titleLab.textColor         = K_COLOR_CUSTEM(55, 54, 53, 1);
            _titleLab.backgroundColor   = [UIColor whiteColor];
            NSString * titleText = [NSString stringWithFormat:@"将%@分享给好友\n好友交易成功后即可领取三重好礼",App_appShortName];
            _titleLab.text              = titleText;
            _titleLab.font              = [UIFont boldSystemFontOfSize:spreadHeight*3/18];
            
        }
            break;
        case 2:
        {
            spreadHeight                = ScreenWidth*85/375;
            _clickBtn.center            = CGPointMake(ScreenWidth/2, spreadHeight/2);
            _clickBtn.bounds            = CGRectMake(0, 0, ScreenWidth*250/375, ScreenWidth*250*11/50/375);
            [_clickBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _itemImageV.center          = CGPointMake(ScreenWidth/2, spreadHeight/2);
            _itemImageV.bounds          = CGRectMake(0, 0, ScreenWidth*250/375, ScreenWidth*250*11/50/375);
            NSString * btnImageName;
            switch (indexPath.row) {
                case 0:
                {
                    btnImageName        = @"03";
                }
                    break;
                case 1:
                {
                    btnImageName        = @"04";
                }
                    break;
                case 2:
                {
                    btnImageName        = @"05";
                    
                }
                    break;
                default:
                    break;
            }
            _itemImageV.image = [UIImage imageNamed:btnImageName];
        }
            break;
        case 3:
        {
            
            spreadHeight = ScreenWidth*67/375;
            _clickBtn.center            = CGPointMake(ScreenWidth/2, spreadHeight/2);
            _clickBtn.bounds            = CGRectMake(0, 0, ScreenWidth*250/375, ScreenWidth*250*11/50/375 +15);
            NSString * titleText;
            _titleLab.bounds                = CGRectMake(0, 0, ScreenWidth-40, spreadHeight/3);
            _titleLab.textColor             = K_COLOR_CUSTEM(55, 54, 53, 1);
            _titleLab.font                  = [UIFont boldSystemFontOfSize:spreadHeight*2/11];
            switch (indexPath.row) {
                case 0:
                {
                    titleText                       = @"选择复制链接分享给好友";
                    _titleLab.center                = CGPointMake(ScreenWidth/2, spreadHeight/3+20);
                    _titleLab.text                  = titleText;
                    _detailLab.center               = CGPointMake(ScreenWidth/2, spreadHeight*8/13+20);
                    _detailLab.bounds               = CGRectMake(0, 0, ScreenWidth-40, spreadHeight/3);
                    _detailLab.font                 = [UIFont systemFontOfSize:spreadHeight/5];
                    _detailLab.textColor            = K_COLOR_CUSTEM(153, 153, 153, 1);
                    _titleRightLab.text             = @"方式一";
                    _titleRightLab.font             = [UIFont boldSystemFontOfSize:spreadHeight*2/11];
                    _titleRightLab.center           = CGPointMake(ScreenWidth/2, spreadHeight/3-ScreenWidth*4/375);
                    _titleRightLab.bounds           = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*20/375);
                    _titleRightLab.backgroundColor  = K_color_red;
                    _titleRightLab.textColor        = [UIColor whiteColor];
                    _titleRightLab.layer.cornerRadius = 2;
                    _titleRightLab.layer.masksToBounds = YES;
                }
                    break;
                case 1:
                {
                    _titleLab.center        = CGPointMake(20+(ScreenWidth-40)/4 ,spreadHeight*3/12-ScreenWidth*2/375);
                    _titleLab.textColor     = [UIColor whiteColor];
                    _titleLab.bounds        = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*20/375);
                    _titleLab.backgroundColor = K_color_red;
                    titleText               = @"方式二";
                    _titleLab.layer.cornerRadius = 2;
                    _titleLab.layer.masksToBounds = YES;
                    
                    
                    _titleRightLab.text             = @"方式三";
                    _titleRightLab.font             = [UIFont boldSystemFontOfSize:spreadHeight*2/11];
                    _titleRightLab.center           = CGPointMake(20+(ScreenWidth-40)*3/4, spreadHeight*3/12-ScreenWidth*2/375);
                    _titleRightLab.bounds           = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*20/375);
                    _titleRightLab.backgroundColor  = K_color_red;
                    _titleRightLab.textColor        = [UIColor whiteColor];
                    _titleRightLab.layer.cornerRadius = 2;
                    _titleRightLab.layer.masksToBounds = YES;
                    CGFloat clickBtnLength =ScreenWidth*55/375;
                    
                    _clickBtn.center        = CGPointMake(_titleLab.center.x, _titleLab.center.y+ScreenWidth*50/375);
                    _clickBtn.bounds        = CGRectMake(0, 0, clickBtnLength, clickBtnLength);
                    [_clickBtn setBackgroundImage:[UIImage imageNamed:@"findPage_11"] forState:UIControlStateNormal];
                    
                    _clickRightBtn.center   = CGPointMake(_titleRightLab.center.x, _titleRightLab.center.y+ScreenWidth*50/375);
                    _clickRightBtn.bounds   = CGRectMake(0, 0, clickBtnLength, clickBtnLength);
                    [_clickRightBtn setBackgroundImage:[UIImage imageNamed:@"findPage_12"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            
            _titleLab.text                  = titleText;
            
            
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)updataCellUI:(NSIndexPath*)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            _clickBtn.hidden = YES;
            _clickRightBtn.hidden = YES;

            _itemImageV.hidden = NO;
            _itemRightImgeV.hidden = NO;
            _titleLab.layer.masksToBounds = NO;
            _titleRightLab.layer.masksToBounds = NO;
            _titleLab.hidden = NO;
            _titleRightLab.hidden = NO;
            _detailLab.hidden = NO;
            _detailRightLab.hidden= NO;
//            _seperatorLine.hidden = NO;
        }
            break;
        case 1:
        {
            _titleLab.hidden =NO;
            
            _clickRightBtn.hidden = _detailLab.hidden = _seperatorLine.hidden = _clickBtn.hidden = _itemImageV.hidden=_itemRightImgeV.hidden = _titleRightLab.hidden=_detailRightLab.hidden = YES;
            
            
        }
            break;
        case 2:
        {
            _clickBtn.hidden= _itemImageV.hidden = NO;
            _clickRightBtn.hidden =_seperatorLine.hidden = _titleLab.hidden =   _detailLab.hidden = _itemRightImgeV.hidden = _titleRightLab.hidden=_detailRightLab.hidden = YES;
            
        }
            break;
        case 3:
        {
            _clickBtn.hidden = NO;
            _seperatorLine.hidden = YES;
            _titleRightLab.hidden = NO;
            switch (indexPath.row) {
                case 0:
                {
                    _titleLab.hidden = NO;
                    _detailLab.hidden = NO;
                    _clickRightBtn.hidden =_itemImageV.hidden=_itemRightImgeV.hidden =_detailRightLab.hidden = YES;
                }
                    break;
                case 1:
                {
                    _titleLab.hidden = NO;
                    _clickRightBtn.hidden = _itemImageV.hidden = NO;
                    _detailLab.hidden =_itemRightImgeV.hidden =_detailRightLab.hidden = YES;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
}
- (void)clickBtnClick:(UIButton*)button
{
    
    self.clickBlock(button);
}
@end
