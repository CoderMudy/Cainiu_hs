//
//  FindTableViewCell.m
//  hs
//
//  Created by PXJ on 15/8/6.
//  Copyright (c) 2015年 luckin. All rights reserved.18738597869
//
#define nameFont [UIFont systemFontOfSize:14]
#define detailFont [UIFont systemFontOfSize:11]

#import "FindTableViewCell.h"

@implementation FindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float cellHeight = ScreenWidth*85/375;
        
        
        float imageLength = ScreenWidth*40/375;
        float arrowsWidth = imageLength/6;
        _itemImageV = [[UIImageView alloc] init];//WithFrame:CGRectMake(20, cellHeight/2-imageLength/2, imageLength, imageLength)];
        
        _itemImageV.center = CGPointMake(20+imageLength/2, cellHeight/2);

        [self addSubview:_itemImageV];
        
        CGFloat markLength = 30*ScreenWidth/375;
        CGFloat markHeight = 18*ScreenWidth/375;
        _redMark = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40-markLength, cellHeight/2-markHeight/2, markLength, markHeight)];
        _redMark.image = [UIImage imageNamed:@"findPage_new"];
        _redMark.hidden = YES;
        [self addSubview:_redMark];
        
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20+imageLength+15, (cellHeight-35)/2, ScreenWidth-55-imageLength-arrowsWidth, 20)];
        _nameLab.font = nameFont;
        [self addSubview:_nameLab];
        
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20+imageLength+15, _nameLab.frame.size.height+_nameLab.frame.origin.y, ScreenWidth-55-imageLength-arrowsWidth, 20)];
        _detailLab.font = detailFont;
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0 , cellHeight-1, ScreenWidth, 1)];
        _line.backgroundColor = K_color_line;
        [self addSubview:_line];
        [self addSubview:_detailLab];
        
        
        _arrowsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-25-arrowsWidth, cellHeight/2-arrowsWidth*9/10, arrowsWidth, arrowsWidth*9/5)];
        _arrowsImageV.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:_arrowsImageV];
        
        _rightShowImgV = [[UIImageView alloc] init];
        _rightShowImgV.center = CGPointMake(_arrowsImageV.center.x -25, _arrowsImageV.center.y);
        _rightShowImgV.bounds = CGRectMake(0, 0, 33, 31);
        _rightShowImgV.hidden = YES;
        _rightShowImgV.image = [UIImage imageNamed:@"findPage_15"];
        [self addSubview:_rightShowImgV];
        
        
    }return self;
}


- (void)setCellDetailWithImageName:(NSString*)imageName name:(NSString*)name detailText:(NSString*)detailText enableClick:(BOOL)enableClick
{

    [_itemImageV setImage:[UIImage imageNamed:imageName]];
    _itemImageV.bounds = CGRectMake(0, 0, _itemImageV.image.size.width, _itemImageV.image.size.height);
    _nameLab.text = name;
    _detailLab.text =detailText;
    if (enableClick) {
        
        _nameLab.textColor = [UIColor blackColor];
        _detailLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
    
    }else{
        _nameLab.textColor = K_COLOR_CUSTEM(200,200,200, 1);
        _detailLab.textColor = K_COLOR_CUSTEM(200,200,200, 1);
    }
    

}

- (void)setNewMsgRemind:(BOOL)newRemind redBag:(BOOL)showRedBag
{
    self.redMark.hidden = !newRemind;
    self.rightShowImgV.hidden = !showRedBag;


}
- (void)dealloc{
    [_redMark removeFromSuperview];
    [_itemImageV removeFromSuperview];
    [_nameLab removeFromSuperview];
    [_detailLab removeFromSuperview];
    [_arrowsImageV removeFromSuperview];
    [_rightShowImgV removeFromSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
