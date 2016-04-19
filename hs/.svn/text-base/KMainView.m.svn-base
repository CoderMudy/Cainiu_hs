//
//  KMainView.m
//  CurveTest
//
//  Created by RGZ on 15/11/10.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "KMainView.h"
#import "KlineView.h"
#import "CandleView.h"

//横线右侧的长度
#define Line_Horizontal 60

#define ALLHeight     6


@implementation KMainView
{
    KlineView   *_klineView;
    int         topBaseLineNum;//基线数
    int         botBaseLineNum;
    float       upperPrice;
    float       lowerPrice;
    int         floatNum;
    NSInteger   kLineTimeLine;
    UIView      *_bottomView;
    
    UILabel     *_maShowLabel;//5,10,20 MA
    UILabel     *_nuShowLabel;//12,26,9 DEA
    float       defaultHeight;//默认价格区间高度
    NSString    *_instrumentID;
    
    float   top_top_Y ;
    float   top_low_Y ;
    float   low_top_Y ;
    float   low_low_Y ;
    
    BOOL        isSwitch;//有数据打开开关
    NSMutableArray  *_dataArray;
    NSMutableArray  *_allDataArray;
    //初始化默认移动位置
    int             setAnimationCount;
    
    float   TopHeight;
}
-(instancetype)initWithFrame:(CGRect)frame FloatNum:(int)aFloatNum WithInstrumentID:(NSString *)aID{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = YES;
        if (ScreenHeigth <= 480) {
            TopHeight = 3.3;
        }
        else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
            TopHeight = 3.6;
        }
        else{
            TopHeight = 4;
        }
        floatNum = aFloatNum;
        _instrumentID = aID;
        [self defaultData];
        
        [self drawBotPriceLine];
        [self drawTopPriceLine];
    }
    
    return self;
}

-(void)defaultData{
    _dataArray = [KLineDao getAllKLineDataWithInstrumentID:_instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
    _allDataArray = [NSMutableArray arrayWithArray:_dataArray];
    kLineTimeLine  = 0;
    topBaseLineNum = 4;
    botBaseLineNum = 3;
    setAnimationCount = 0;
    
    [KLineShowNum sharedInstance].showNum = 40;
}

-(void)loadKLineViewAgain{
    isSwitch = NO;
    for (UIView *view in _klineView.subviews) {
        if ([view isKindOfClass:[CandleView class]]) {
            [view removeFromSuperview];
        }
    }
    [self loadKLineView];
    isSwitch = YES;
}

-(void)loadKLineView{
    
    KMainView *kMainView = self;
    
    if (_klineView == nil) {
        _klineView = [[KlineView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height) FloatNum:floatNum WithInstrumentID:_instrumentID];
        _klineView.contentSize = CGSizeMake((DBSaveNum+10)*((self.frame.size.width-10)/DefaultShowNum), _klineView.bounds.size.height);
        _klineView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _klineView.userInteractionEnabled = YES;
        _klineView.showsHorizontalScrollIndicator = NO;
        _klineView.showsVerticalScrollIndicator = NO;
        _klineView.delegate = self;
        _klineView.maShowLabel = _maShowLabel;
        _klineView.klineBlock = ^(NSMutableArray *dataArray){
            _dataArray = dataArray;
        };
        _klineView.beginBlock = ^(KLineDataModel *klineModel){
            kMainView.mainBeginBlock(klineModel);
        };
        _klineView.endBlock = ^(void){
            kMainView.mainEndBlock();
        };
        [self addSubview:_klineView];
    }
    
    [_klineView setTopBaseLineNum:topBaseLineNum BottonBaseLineNum:botBaseLineNum];
    [_klineView setKLineTimeLine:[IndexSingleControl sharedInstance].klineTime DataArray:_dataArray];
    [_klineView setUpperAndLowerPointYWithTop_Top:top_top_Y Top_Low:top_low_Y Low_Top:low_top_Y Low_Low:low_low_Y];
    [_klineView setDefaultDataArray:_dataArray];
    
    
    //6以下，K线图滑动关闭
    if (ScreenWidth <= 320) {
        _klineView.scrollEnabled = NO;
    }
    else{
        _klineView.scrollEnabled = YES;
    }
}

-(void)setDefaultRange:(float)aRangeHeight{
//    [_klineView setDefaultRange:aRangeHeight];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (_dataArray.count >= DefaultShowNum-10) {
        if (scrollView.contentOffset.x+scrollView.frame.size.width >= scrollView.frame.size.width/DefaultShowNum*(_dataArray.count+10)) {
            [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width/DefaultShowNum*(_dataArray.count+10) - scrollView.frame.size.width, 0)];
        }
    }
    else{
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (scrollView.contentOffset.x < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (isSwitch) {
        [_klineView move];
    }
    
    [_klineView removeCrossView];
}

#pragma mark 蜡烛图
-(void)drawTopPriceLine{
    
    _maShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, -3, self.frame.size.width/6*5, 13)];
    _maShowLabel.text = @"5,10,20 MA1:-- MA2:-- MA3:--";
    _maShowLabel.textColor = [UIColor colorWithRed:156/255.0 green:41/255.0 blue:114/255.0 alpha:1];
    _maShowLabel.font = [UIFont boldSystemFontOfSize:10];
    _maShowLabel.attributedText = [DataUsedEngine mutableFontAndColorArray:[NSMutableArray arrayWithObjects:@"5,10,20",@" MA1:--",@" MA2:--",@" MA3:--", nil] fontArray:nil colorArray:[NSMutableArray arrayWithObjects:@"106/106/106/1",@"53/136/221/1",@"230/101/47/1",@"156/41/114/1", nil]];
    [self addSubview:_maShowLabel];
    
    [self drawLineWithFrame:CGRectMake(5, 10, self.frame.size.width-10, 1) Object:self];
    [self rightLabelWithTag:TopPriceLabelTag CenterPointY:10 Object:self];
    
    for (int i = 1; i < topBaseLineNum; i++) {
        [self drawLineWithFrame:CGRectMake(5, ((self.frame.size.height-10)/ALLHeight*TopHeight)/(topBaseLineNum-1)*i+10, self.frame.size.width-10, 1) Object:self];
        [self rightLabelWithTag:TopPriceLabelTag+i CenterPointY:((self.frame.size.height-10)/ALLHeight*TopHeight)/(topBaseLineNum-1)*i+10 Object:self ];
        if ( i == topBaseLineNum-1) {
            top_low_Y = ((self.frame.size.height-10)/ALLHeight*TopHeight)/(topBaseLineNum-1)*i+10;
        }
    }
    top_top_Y = 10;

    for (int i = 0; i < 5; i++) {
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 10)];
        timeLabel.textColor = Color_gray;
        if (i == 0) {
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.frame = CGRectMake(5, top_low_Y + 3, timeLabel.frame.size.width, timeLabel.frame.size.height);
        }
        else if (i == 4){
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.frame = CGRectMake(self.frame.size.width - 5 - timeLabel.frame.size.width, top_low_Y + 3, timeLabel.frame.size.width, timeLabel.frame.size.height);
        }
        else{
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.center = CGPointMake(5+(self.frame.size.width-10)/4*i, top_low_Y + 10 );
            
        }
        timeLabel.tag  = KLineTimeTag + i;
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
    }
    
    for(int i = 0; i < 2; i ++){
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
        timeLabel.textColor = Color_Gold;
        if (i == 0) {
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.frame = CGRectMake(5, top_low_Y + 3 +timeLabel.frame.size.height, timeLabel.frame.size.width, timeLabel.frame.size.height);
        }
        else if (i == 1){
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.frame = CGRectMake(self.frame.size.width - 5 - timeLabel.frame.size.width, top_low_Y + 3 +timeLabel.frame.size.height, timeLabel.frame.size.width, timeLabel.frame.size.height);
        }
        timeLabel.tag  = KLineTimeTag - i - 1;
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
    }
}

#pragma mark 买卖量
-(void)drawBotPriceLine{
    float   point_Y_begin = (self.frame.size.height-10)/ALLHeight*(ALLHeight-1) -5;
    
//    _nuShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, point_Y_begin - 13, self.frame.size.width/3*2, 13)];
//    _nuShowLabel.text = @"12,26,9 DEA:0.77 DIF:1.44 MACD:1.9";
//    _nuShowLabel.textColor = [UIColor colorWithRed:156/255.0 green:41/255.0 blue:114/255.0 alpha:1];
//    _nuShowLabel.font = [UIFont boldSystemFontOfSize:10];
//    _nuShowLabel.attributedText = [DataUsedEngine mutableFontAndColorArray:[NSMutableArray arrayWithObjects:@"12,26,9",@" DEA:0.77",@" DIF:1.44",@" MACD:1.9", nil] fontArray:nil colorArray:[NSMutableArray arrayWithObjects:@"106/106/106/1",@"53/136/221/1",@"230/101/47/1",@"156/41/114/1", nil]];
//    [self addSubview:_nuShowLabel];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, point_Y_begin, self.frame.size.width, self.frame.size.height/ALLHeight +5)];
    [self addSubview:_bottomView];
    
    [self drawLineWithFrame:CGRectMake(5, point_Y_begin, self.frame.size.width-10, 1) Object:self];
    [self rightLabelWithTag:BotPriceLabelTag CenterPointY:point_Y_begin Object:self];
    
    for (int i = 1; i < botBaseLineNum; i++) {
        [self drawLineWithFrame:CGRectMake(5, (self.frame.size.height/ALLHeight +5)/(botBaseLineNum-1)*i + point_Y_begin, self.frame.size.width-10, 1) Object:self];
        [self rightLabelWithTag:BotPriceLabelTag+i CenterPointY:(self.frame.size.height/ALLHeight +5)/(botBaseLineNum-1)*i + point_Y_begin Object:self];
        if (i == botBaseLineNum - 1 ) {
            low_low_Y = (self.frame.size.height/ALLHeight +5)/(botBaseLineNum-1)*i + point_Y_begin;
        }
    }
    
    low_top_Y = point_Y_begin ;
}

-(void)rightLabelWithTag:(int)aTag CenterPointY:(CGFloat)aCenterY Object:(UIView *)view{
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, 0, Line_Horizontal, 10)];
    rightLabel.center = CGPointMake(rightLabel.center.x, aCenterY-6);
    rightLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    rightLabel.font = [UIFont systemFontOfSize:10];
    rightLabel.tag = aTag;
    rightLabel.userInteractionEnabled = YES;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor grayColor];
    [view addSubview:rightLabel];
}

-(void)drawLineWithFrame:(CGRect)aRect Object:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:aRect];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {1,10};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, aRect.size.width, 0.0);
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

//设置几分钟K线
-(void)klineTimeChange{
    if (kLineTimeLine != [IndexSingleControl sharedInstance].klineTime) {
        kLineTimeLine = [IndexSingleControl sharedInstance].klineTime;
        [self loadKLineViewAgain];
    }
}

//设置默认价格区间高度
-(void)setKLineDefaultHeight:(float)aHeight{
    defaultHeight = aHeight;
}

-(void)updateWithMarket:(BOOL)isOpen{
    isSwitch = YES;
    [_klineView update];
    
    //图表移动，查看历史数据,偏移量不变
    if (!(_klineView != nil && _dataArray.count >= 40 && _klineView.contentOffset.x < _klineView.frame.size.width/DefaultShowNum * (_dataArray.count - 40))) {
        if (setAnimationCount == 0) {
            setAnimationCount++;
            if (_dataArray.count > DefaultShowNum - 10) {
                [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum-10)), 0)];
            }
        }
        if (_klineView.contentOffset.x + _klineView.frame.size.width >= _klineView.frame.size.width/DefaultShowNum*_dataArray.count) {
            [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum-10)), 0)];
        }
        
        if (isOpen == NO) {
            [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum)), 0)];
            [_klineView update];
        }
    }
    
    
}
//手动移动到最后
-(void)moveLast:(BOOL)isOpen{
    if (_dataArray.count > DefaultShowNum - 10) {
        [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum-10)), 0)];
    }
    if (_klineView.contentOffset.x + _klineView.frame.size.width >= _klineView.frame.size.width/DefaultShowNum*_dataArray.count) {
        [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum-10)), 0)];
    }
    
    if (isOpen == NO) {
        [_klineView setContentOffset:CGPointMake(_klineView.frame.size.width/DefaultShowNum*(_dataArray.count-(DefaultShowNum)), 0)];
        [_klineView update];
    }
}

-(void)klineShowData:(NSMutableArray *)dataArray{
    
    _dataArray = [KLineDao getAllKLineDataWithInstrumentID:_instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
    KLineDataModel *klineModel = _dataArray.lastObject;
    
    KLineDataModel *newKlineModel = dataArray.firstObject;
    
    if (klineModel != nil) {
        if ([klineModel.time isEqualToString:newKlineModel.time]) {
            [dataArray removeObjectAtIndex:0];
        }
    }
    if (dataArray.count > 0) {
        [_dataArray addObjectsFromArray:dataArray];
        [_allDataArray addObjectsFromArray:dataArray];
    }
    [_klineView setDefaultDataArray:_dataArray];
    [_klineView setKLineTimeLine:kLineTimeLine DataArray:_dataArray];
}

-(void)loadDefaultView{
    [self klineTimeChange];
}

-(void)setLastMove{
    setAnimationCount = 0;
}

-(void)timeChange{
    [_klineView timeChange];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
