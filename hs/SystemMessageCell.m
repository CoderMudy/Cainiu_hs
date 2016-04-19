//
//  SystemMessageCell.m
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SystemMessageCell.h"
#import "SysMsgData.h"
@implementation SystemMessageCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initCellUI];
        
    }
    return self;

}
- (void)initCellUI;
{
    float cellHeight = ScreenWidth *13/50;
;
     _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, cellHeight)];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteBackView];
    [_whiteBackView.layer setBorderWidth:1.0]; //边框宽度
    [_whiteBackView.layer setBorderColor:[K_COLOR_CUSTEM(231,232,234, 1) CGColor]]; //边框颜色
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenWidth/50+5, ScreenWidth-60,ScreenWidth*4/75)];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
    [_whiteBackView addSubview:_titleLab];

    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLab.frame.origin.y+_titleLab.frame.size.height, ScreenWidth-60, ScreenWidth*4/75)];
    _timeLab.font = [UIFont systemFontOfSize:10];
    _timeLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
    [_whiteBackView addSubview:_timeLab];
    
    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _timeLab.frame.origin.y+_timeLab.frame.size.height+ScreenWidth/50, ScreenWidth-60,0)];
    _detailLab.numberOfLines = 3;
    _detailLab.font = [UIFont systemFontOfSize:12];
    _detailLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    [_whiteBackView addSubview:_detailLab];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, ScreenWidth*3/25, ScreenWidth-60, 1)];
    _lineView.backgroundColor = K_COLOR_CUSTEM(241, 242, 244, 1);
    [_whiteBackView addSubview: _lineView];
    
    float arrowsHeight = _lineView.frame.origin.y+(cellHeight - _lineView.frame.origin.y)/2;
    float arrowsWidth = ScreenWidth/64;

    _arrowsImageV = [[UIImageView alloc] init];
    _arrowsImageV.center =  CGPointMake(ScreenWidth-40-arrowsWidth/2, arrowsHeight);
    _arrowsImageV.bounds = CGRectMake(0, 0, arrowsWidth, arrowsWidth*9/5);
    _arrowsImageV.image = [UIImage imageNamed:@"arrow"];
    [self addSubview:_arrowsImageV];

    
}

- (void)setCellWith:(SysMsgData*)sysMsgModel
{

    _titleLab.text = sysMsgModel.title==nil?@"":sysMsgModel.title;
    
    NSString * timeString =sysMsgModel.updateDate==nil?@"":sysMsgModel.updateDate;
    _timeLab.text =[self chageTimeFormatter:timeString];
    _detailLab.text = sysMsgModel.content==nil?@"":sysMsgModel.content;
    [self setCellSubViewLocation:sysMsgModel];
}
- (void)setCellSubViewLocation:(SysMsgData*)sysMsgModel
{
    float cellHeight =ScreenWidth *13/50;

    float detailHeight;
    
    float backHeight;
    if (sysMsgModel.content.length<60) {
        CGRect rect = [sysMsgModel.content boundingRectWithSize:CGSizeMake(ScreenWidth-60, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        detailHeight =rect.size.height;
        backHeight = cellHeight +rect.size.height;
        _detailLab.numberOfLines =0;
    }else{
        
        detailHeight =35 ;
        backHeight =cellHeight +detailHeight;
        _detailLab.numberOfLines = 0;
        
    }
    
    _whiteBackView.frame = CGRectMake(15, 0, ScreenWidth-30, backHeight);
    _detailLab.frame = CGRectMake(15, _timeLab.frame.origin.y+_timeLab.frame.size.height+cellHeight/20, ScreenWidth-60,detailHeight);
    
    
    _lineView.frame = CGRectMake(15, backHeight-ScreenWidth/10, ScreenWidth-60, 1);
    float arrowsHeight = _lineView.frame.origin.y+(backHeight - _lineView.frame.origin.y)/2;
    float arrowsWidth = ScreenWidth/64;
    _arrowsImageV.center =  CGPointMake(ScreenWidth-40-arrowsWidth/2, arrowsHeight);


}
- (NSString *)chageTimeFormatter:(NSString*)timeStr
{

    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dm dateFromString:timeStr];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * string = [dm stringFromDate:date];
//    return string;
    NSArray * array = [string componentsSeparatedByString:@" "];
    NSString* createTime = [NSString stringWithFormat:@"%@ %@",array[0],@"00:00:00"];
    int days = [Helper timeSysTime:[[SystemSingleton sharedInstance].timeString stringByAppendingString:@" 00:00:00"] createTime:createTime];
    if (days==0) {
        string = @"今天";
        
    }else if (days==1){
        
        string = @"昨天";
    }else{
        
        string = array[0];
        
    }
    
    string = [NSString stringWithFormat:@"%@ %@",string,array[1]];
    return string;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
