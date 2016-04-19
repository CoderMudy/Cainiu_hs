//
//  HotTableViewCell.m
//  hs
//
//  Created by PXJ on 15/5/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

@synthesize storkTitlelab;
@synthesize szDetailLab;
@synthesize upDownLab;
@synthesize typeLab;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 0.3);
        
        self.typeLab = [[UILabel alloc] initWithFrame:CGRectMake(22,16, ScreenWidth/3.0, 15)];
        self.typeLab.textAlignment= NSTextAlignmentLeft;
        self.typeLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        self.typeLab.font = [UIFont systemFontOfSize:14.F];
        [self addSubview:self.typeLab];
        
        self.storkTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92,10, 70, 15)];
        self.storkTitlelab.textAlignment = NSTextAlignmentRight;
        self.storkTitlelab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        self.storkTitlelab.font = [UIFont systemFontOfSize:14.F];
        [self addSubview:self.storkTitlelab];
        
        self.szDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92, 26, 70, 13)];
        self.szDetailLab.font = [UIFont systemFontOfSize:12.F];
        self.szDetailLab.textColor =  K_COLOR_CUSTEM(110, 110, 110, 1);
        self.szDetailLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.szDetailLab];
        

        
       
        self.upDownLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-172, 9, 69, 30)];
        self.upDownLab.font = [UIFont systemFontOfSize:14.f];
        self.upDownLab.textAlignment = NSTextAlignmentRight;
        self.upDownLab.textColor = [UIColor whiteColor];
        self.upDownLab.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        self.upDownLab.layer.cornerRadius = 3;
        self.upDownLab.layer.masksToBounds = YES;
        [self addSubview:self.upDownLab];
        
        
        UILabel * linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        linelab.backgroundColor = K_COLOR_CUSTEM(200, 200, 200, 200);
        [self addSubview:linelab];
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict
{
    
    
    

    self.storkTitlelab.text= dict[@"upFirstStockName"];
    self.szDetailLab.text =dict[@"upFirstStockCode"];
    
    self.upDownLab.text = [NSString stringWithFormat:@"+%.2f%%",[dict[@"nRATE"] floatValue]*100 ];
    if ([dict[@"nRATE"] floatValue]/100.0 < 0) {
        self.upDownLab.text = [NSString stringWithFormat:@"%.2f%%",[dict[@"nRATE"] floatValue]*100];
        self.upDownLab.backgroundColor = K_COLOR_CUSTEM(8, 186, 66, 1);
    }else{
        
        self.upDownLab.backgroundColor = K_COLOR_CUSTEM(250,66,0,1);
    }

    self.typeLab.text = dict[@"strProdName"];
    

}

- (void)layoutSubviews
{
//    [super layoutSubviews];
//    [self.storkTitlelab setFrame:CGRectMake(ScreenWidth - self.storkTitlelab.frame.size.width-10, self.storkTitlelab.frame.origin.y, self.storkTitlelab.frame.size.width, self.storkTitlelab.frame.size.height)];
//    [self.szDetailLab setFrame:CGRectMake(ScreenWidth - self.szDetailLab.frame.size.width-10, self.szDetailLab.frame.origin.y, self.szDetailLab.frame.size.width, self.szDetailLab.frame.size.height)];
//    [self.upDownLab setFrame:CGRectMake((ScreenWidth-self.upDownLab.frame.size.width)/2, self.upDownLab.frame.origin.y, self.upDownLab.frame.size.width, self.upDownLab.frame.size.height)];
}

@end
