//
//  FoyerHolidayView.h
//  hs
//
//  Created by PXJ on 16/1/4.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef enum{
    FoyerHolidayProductStyle,
    FoyerHolidayPopViewStyle,
    FoyerHolidayWarningStyle
} FoyerHolidayViewStyle;
#import <UIKit/UIKit.h>

@interface FoyerHolidayView : UIView

@property (nonatomic,strong)UIImageView * positionImg;
@property (nonatomic,strong)UIImageView * productImg;
@property (nonatomic,strong)UILabel * productName;
@property (nonatomic,strong)UILabel * price;
@property (nonatomic,strong)UILabel * rise;
@property (nonatomic,strong)UIControl * goTrade;
@property (nonatomic,assign)FoyerHolidayViewStyle style;

- (id)initWithFrame:(CGRect)frame style:(FoyerHolidayViewStyle)style;

@end
