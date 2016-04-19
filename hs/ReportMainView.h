//
//  ReportMainView.h
//  ReportTest
//
//  Created by RGZ on 15/7/15.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportMainView : UIView


@property (nonatomic,assign)BOOL isReport;

-(instancetype)initWithFrame:(CGRect)frame Title:(NSMutableArray *)titleArray Detail:(NSMutableArray *)detailArray;

-(void)setFont:(UIFont *)aFont;

-(void)setColor:(UIColor *)aColor;

- (void)stop;

@end
