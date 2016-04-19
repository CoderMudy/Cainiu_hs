//
//  TraderRemindCell.m
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TraderRemindCell.h"
#import "SysMsgDataModels.h"
@implementation TraderRemindCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}
/*@property (nonatomic,strong)UIImageView * systemHeader;
 @property (nonatomic,strong)UIImageView * BubbleImageV;
 @property (nonatomic,strong)UILabel * messageLab;
 @property (nonatomic,strong)UILabel * receiveLab;
 */
- (void)initCellView
{
    _receiveTimeLab = [[UILabel alloc] init];
    _receiveTimeLab.center =  CGPointMake(ScreenWidth/2, 15);
    _receiveTimeLab.bounds = CGRectMake(0, 0, ScreenWidth, 10);
    _receiveTimeLab.font = [UIFont systemFontOfSize:11];
    _receiveTimeLab.textColor = K_COLOR_CUSTEM(146, 147, 148, 1);
    _receiveTimeLab.textAlignment = NSTextAlignmentCenter;
    _receiveTimeLab.text = @"2015-08-10 16:21:22";
    [self addSubview:_receiveTimeLab];
    
    
    float sysHeaderLength = ScreenWidth/10;
    _systemHeader = [[UIImageView alloc] init];
    _systemHeader.center = CGPointMake(20+sysHeaderLength/2, _receiveTimeLab.frame.size.height+_receiveTimeLab.frame.origin.y+sysHeaderLength/2 +5);
    _systemHeader.bounds = CGRectMake(0, 0, sysHeaderLength, sysHeaderLength);
    _systemHeader.image = [UIImage imageNamed:@"kefutouxiang"];
    [self addSubview:_systemHeader];
    _BubbleImageV = [[UIImageView alloc] init];

    _BubbleImageV.center = CGPointMake(_systemHeader.frame.size.width+_systemHeader.frame.origin.x+13,_systemHeader.center.y);
    _BubbleImageV.bounds = CGRectMake(0, 0,4, 4*20/7);
    
    _BubbleImageV.image = [UIImage imageNamed:@"bubble"];
    
    [self addSubview:_BubbleImageV];
    
    _backView = [[UIView alloc] init ];
    _backView.backgroundColor = K_COLOR_CUSTEM(234, 235, 236, 1);
    [self addSubview:_backView];
    
    _messageLab = [[UILabel alloc] init];
    _messageLab.numberOfLines = 0;
    _messageLab.font = [UIFont systemFontOfSize:14];
    _messageLab.textColor = K_COLOR_CUSTEM(89, 87, 87, 1);
    [self addSubview:_messageLab];
}
- (void)setTraderCell:(SysMsgData*)sysMsgModel
{
    NSString * message = sysMsgModel.content;
    _messageLab.text = message;
    _receiveTimeLab.text = [self chageTimeFormatter:sysMsgModel.createDate] ;
    //根据显示的文本，计算出文本的高度。
    CGRect rect = [message boundingRectWithSize:CGSizeMake(ScreenWidth*3/5, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    _backView.frame = CGRectMake(CGRectGetMaxX(_BubbleImageV.frame), CGRectGetMinY(_systemHeader.frame), ScreenWidth*3/5+10, rect.size.height< ScreenWidth/10? ScreenWidth/10+5:rect.size.height+10);
    
    _messageLab.frame = CGRectMake(_BubbleImageV.frame.origin.x+ +_BubbleImageV.frame.size.width+5, _systemHeader.frame.origin.y+5, ScreenWidth*3/5, rect.size.height);
 
}
- (NSString *)chageTimeFormatter:(NSString*)timeStr
{
    
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dm dateFromString:timeStr];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * string = [dm stringFromDate:date];
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
