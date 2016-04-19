//
//  FoyerReportView.h
//  scrollow
//
//  Created by PXJ on 15/9/17.
//  Copyright (c) 2015年 PXJ. All rights reserved.
//
typedef enum{
    ReportViewStyleDefault,
    ReportViewStyleImage

}ReportViewStyle;
#import <UIKit/UIKit.h>
#import "FoyerReportShowView.h"
@class ViewController;

@interface FoyerReportView : UIView
{

    NSTimer *   _timer;
    int         _reportNum;
    BOOL        _isReport;
    NSArray *   _nickArray;
    NSArray *   _profitArray;
}
@property (nonatomic,assign)ReportViewStyle reportViewStyle;
@property (nonatomic,strong)FoyerReportShowView * mainView;
@property (nonatomic,strong)FoyerReportShowView * subView;
@property (nonatomic,strong)UIView *    reportView;
@property (nonatomic,assign)float       reportHeight;
- (id)initWithFrame:(CGRect)frame  nickArray:(NSArray*)nickArray profitArray:(NSArray *)profitArray;
- (void)stopReport;
- (void)startReport;
@end
