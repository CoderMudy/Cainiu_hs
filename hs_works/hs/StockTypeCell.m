//
//  StockTypeCell.m
//  hs
//
//  Created by PXJ on 15/5/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockTypeCell.h"

@implementation StockTypeCell

@synthesize storkTitlelab;
@synthesize szDetailLab;
@synthesize priceLab;
@synthesize addLab;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
        
        UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [self addSubview:lineLabel];
        
        self.storkTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 16)];
        self.storkTitlelab.font = [UIFont systemFontOfSize:14.f];
        self.storkTitlelab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);

        [self addSubview:self.storkTitlelab];
        
        self.szDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, 100, 13)];
        self.szDetailLab.font = [UIFont systemFontOfSize:12.F];
        self.szDetailLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);

        [self addSubview:self.szDetailLab];
        
        
        self.addLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92, 9, 70, 30)];
        self.addLab.backgroundColor = K_COLOR_CUSTEM(242, 41, 59, 1);
        self.addLab.layer.cornerRadius = 3;
        self.addLab.layer.masksToBounds = YES;
        self.addLab.font = [UIFont systemFontOfSize:16.f];
        self.addLab.textAlignment = NSTextAlignmentRight;
        self.addLab.textColor = [UIColor whiteColor];
        [self addSubview:self.addLab];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-172,8, 70, 30)];
        self.priceLab.font = [UIFont systemFontOfSize:16.f];
        self.priceLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLab];

        

    }
    return self;
}
- (void)setDict:(NSDictionary *)dict
{
    
    NSString* str = @"1232343453453";
    NSRange range = [str rangeOfString:@"a"];
    if (range.length > 0)
    {
    }
    
    self.storkTitlelab.text= dict[@"strProdName"];
    self.szDetailLab.text =dict[@"strProdCode"];
    float newPrice = [dict[@"newPrice"] floatValue];
    if (newPrice==0) {
        self.priceLab.text = @" -- ";
        self.addLab.text = @" -- ";
        self.priceLab.textColor = RGBCOLOR(110, 110, 110);
        self.addLab.backgroundColor = [UIColor grayColor];

    }else{

        self.priceLab.text =[NSString stringWithFormat:@"%.2f",newPrice];
        self.addLab.text = [NSString stringWithFormat:@"+%.2f%%",[dict[@"nRATE"] floatValue]*100 ];
        if ([dict[@"nRATE"] floatValue]/100.0 < 0) {
            self.addLab.text = [NSString stringWithFormat:@"%.2f%%",[dict[@"nRATE"] floatValue]*100];
            self.addLab.backgroundColor = K_COLOR_CUSTEM(8, 186, 66, 1);
            self.priceLab.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
        }else{
            
            self.addLab.backgroundColor = K_COLOR_CUSTEM(250,66,0,1);
            self.priceLab.textColor = K_COLOR_CUSTEM(250,66,0,1);
            
        }

    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    
//    [self.addLab setFrame:CGRectMake(ScreenWidth - self.addLab.frame.size.width-10, self.addLab.frame.origin.y, self.addLab.frame.size.width, self.addLab.frame.size.height)];
//    [self.priceLab setFrame:CGRectMake((ScreenWidth-self.priceLab.frame.size.width)/2, self.priceLab.frame.origin.y, self.priceLab.frame.size.width, self.priceLab.frame.size.height)];
}

@end
