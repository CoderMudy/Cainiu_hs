//
//  RecordDetailCell.m
//  hs
//
//  Created by PXJ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordDetailCell.h"
#import "NetRequest.h"

@implementation RecordDetailCell



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

@synthesize storkTitlelab;
@synthesize szDetailLab;
@synthesize priceLab;
@synthesize addView;
@synthesize addLab;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    self.selectionStyle              = UITableViewCellSelectionStyleNone;
    UILabel  *lineLabel              = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, ScreenWidth, 1)];
    [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
    [self addSubview:lineLabel];

    self.storkTitlelab               = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.storkTitlelab.font          = [UIFont systemFontOfSize:15.F];
        [self.storkTitlelab setTextColor:[UIColor grayColor]];

        [self addSubview:self.storkTitlelab];

    self.szDetailLab                 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 15)];
    self.szDetailLab.font            = [UIFont systemFontOfSize:13.F];
        [self.szDetailLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.szDetailLab];

    self.priceLab                    = [[NIAttributedLabel alloc] initWithFrame:CGRectMake((ScreenWidth-150)/2,20, 150, 20)];
        [self.priceLab setBackgroundColor:[UIColor clearColor]];
    self.priceLab.font               = [UIFont systemFontOfSize:14.F];
    self.priceLab.textAlignment      = NSTextAlignmentCenter;
        [self addSubview:self.priceLab];
        
        
    self.addView                     = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-105, 15, ScreenWidth/3, 30)];
    self.addView.backgroundColor     = K_COLOR_CUSTEM(250, 67, 0, 1);
    self.addView.layer.cornerRadius  = 5;
    self.addView.layer.masksToBounds = YES;
        [self.addView setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.addView];

    self.addLab                      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.addView.bounds.size.width, 20)];
    self.addLab.font                 = [UIFont systemFontOfSize:15];
    self.addLab.textAlignment        = NSTextAlignmentCenter;
    self.addLab.textColor            = [UIColor whiteColor];
        [self.addView addSubview:self.addLab];
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict {




    NSArray * array =[dict[@"createDate"] componentsSeparatedByString:@" "];
    self.storkTitlelab.text = [array lastObject]==nil ?@"":array[0];
    if([array lastObject] && [array count] > 1)
        self.szDetailLab.text = array[1];
    self.priceLab.text = (dict[@"intro"]==[NSNull null])?@"":dict[@"intro"];
    self.addLab.text =dict[@"curflowAmt"]==[NSNull null]?@"":dict[@"curflowAmt"];
    self.addView.backgroundColor = [UIColor clearColor];
    if ([dict[@"type"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
       
        self.addLab.text = [NSString stringWithFormat:@"-%@",self.addLab.text];
        self.addLab.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);;

        
    }else
    {
        self.addLab.textColor = [UIColor redColor];
        self.addLab.text = [NSString stringWithFormat:@"+%@",self.addLab.text];

        
    }

    self.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    
    
    int days = [Helper timeSysTime:[[SystemSingleton sharedInstance].timeString stringByAppendingString:@" 00:00:00"] createTime:dict[@"createDate"]];
    if (days==0) {
        self.storkTitlelab.text = @"今天";
        
    }else if (days==1){
        
        self.storkTitlelab.text = @"昨天";
    }else{
        
        self.storkTitlelab.text = array[0];
        
    }
}

- (void)getsystem
{


    
    NSDictionary * timedic = @{@"version":VERSION};
    
    [NetRequest postRequestWithNSDictionary:timedic url:K_systemTime successBlock:^(NSDictionary * dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            
            NSDictionary * dict = dictionary[@"data"];
            _systemTime = dict[@"nowTime"];
        }
        
    } failureBlock:^(NSError *error) {
        
        
        
    }];

}

- (void)layoutSubviews
{
//    [super layoutSubviews];
//    [self.priceLab setFrame:CGRectMake((ScreenWidth-self.priceLab.frame.size.width)/2, (self.frame.size.height-self.priceLab.frame.size.height)/2, self.priceLab.frame.size.width, self.priceLab.frame.size.height)];
}



@end
