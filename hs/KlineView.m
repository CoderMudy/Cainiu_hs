//
//  KlineView.m
//  CurveTest
//
//  Created by RGZ on 15/11/4.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "KlineView.h"
#import "CandleView.h"
#import "MAView.h"

@implementation KlineView
{
    float   top_top_Y ;
    float   top_low_Y ;
    float   low_top_Y ;
    float   low_low_Y ;
    
    NSInteger     klineMinute;
    
    float   upperPrice;
    float   lowerPrice;
    
    float   upperVolume;
    float   lowerVoluem;
    
    int     topBaseLineNum;
    int     lowBaseLineNum;
    
    int     floatNum;
    
    NSString        *_instrumentID;
    //所有数据
    NSMutableArray  *_allDataArray;
    
    UIView          *_topHorLineView;
    UIView          *_topVerLineView;
    UILabel         *_topPriceLabel;
    
    UIView          *_botHorLineView;
    UIView          *_botVerLineView;
    UILabel         *_botPriceLabel;
    
    BOOL            isGestureOn;
    //十字线点击到的一组数据
    KLineDataModel  *_lookKLineModel;
    NSInteger       loockCandleTag;//十字线点到的蜡烛的tag值
    //暂时没用
    float           rangeHeight;
    
    //MA
    NSMutableArray  *_ma1PriceArray;
    NSMutableArray  *_ma2PriceArray;
    NSMutableArray  *_ma3PriceArray;
    NSMutableArray  *_maPointArray;
    MAView          *_maView;
    int             candleStyle;
    UIView          *_candleBGView;
}

-(instancetype)initWithFrame:(CGRect)frame FloatNum:(int)aFloatNum WithInstrumentID:(NSString *)aID{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        floatNum = aFloatNum;
        
        _instrumentID = aID;
        loockCandleTag  = 0;
        upperPrice      = 0;
        lowerPrice      = 0;
        upperVolume     = 100;
        lowerVoluem     = 0;
        rangeHeight     = 0;
        candleStyle     = KLineStyleDefault;
        //长按手势
        [self loadLongGesture];
        //点击
//        [self loadTapGesture];
        //缩放
//        [self loadPinchGesture];
    }
    return self;
}

#pragma mark 基线
-(void)setTopBaseLineNum:(int)aTopBaseLineNum BottonBaseLineNum:(int)aBottomBaseLineNum{
    topBaseLineNum = aTopBaseLineNum;
    lowBaseLineNum = aBottomBaseLineNum;
}

#pragma mark 几分钟K线图

-(void)setKLineTimeLine:(NSInteger)timeLine DataArray:(NSMutableArray *)dataArray{
    [self hideCandleView];
    klineMinute = timeLine;
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
}

-(void)hideCandleView{
    for (int i = 0 ; i < _candleBGView.subviews.count ; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            
            CandleView *candleView = (CandleView *)_candleBGView.subviews[i];
            candleView.hidden = YES;
        }
    }
}

-(void)loadCandleAgain{
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            [_candleBGView.subviews[i] removeFromSuperview];
        }
    }
    [self defaultDataConfiger:_dataArray];
    
    //蜡烛
    [self loadTopView];
}

-(void)setDefaultDataArray:(NSMutableArray *)dataArray{
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    _allDataArray = [NSMutableArray arrayWithArray:_dataArray];
}

-(void)setDefaultRange:(float)aRangeHeight{
//    rangeHeight = aRangeHeight;
//    [self update];
}

- (void)setUpperAndLowerPointYWithTop_Top:(float)aTop_Top_Y Top_Low:(float)aTop_Low_Y Low_Top:(float)aLow_Top_Y Low_Low:(float)aLow_Low_Y{
    top_top_Y = aTop_Top_Y;
    top_low_Y = aTop_Low_Y;
    low_top_Y = aLow_Top_Y;
    low_low_Y = aLow_Low_Y;
    
    [self defaultDataConfiger:_dataArray];
    
    //蜡烛
    [self loadTopView];
    [self loadMA];
}

-(void)defaultDataConfiger:(NSMutableArray *)allArray{
    _dataArray = [NSMutableArray arrayWithArray:allArray];
    for (int i = 0; i < allArray.count; i++) {
        KLineDataModel *klineModel = allArray[i];
        if (i == 0) {
            //默认值
            lowerPrice = klineModel.minPrice;
            upperPrice = klineModel.maxPrice + rangeHeight;
        }
        else{
            if (klineModel.maxPrice >= upperPrice) {
                upperPrice = klineModel.maxPrice;
            }
            
            if (klineModel.minPrice <= lowerPrice) {
                lowerPrice = klineModel.minPrice;
            }
            
            if (klineModel.volume >= upperVolume) {
                upperVolume = klineModel.volume;
            }
        }
    }
    
    int topUpperTag = TopPriceLabelTag;
    int topLowerTag = TopPriceLabelTag+topBaseLineNum-1;
    for (int i = topUpperTag; i<=topLowerTag; i++) {
        UILabel *label = (UILabel *)[self.superview viewWithTag:i];
        if (i == topUpperTag) {
            label.text = [DataUsedEngine conversionFloatNum:upperPrice ExpectFloatNum:floatNum];
        }
        else if (i == topLowerTag){
            label.text = [DataUsedEngine conversionFloatNum:lowerPrice ExpectFloatNum:floatNum];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((upperPrice-lowerPrice)/(topBaseLineNum-1)*((topBaseLineNum-1) - (i-topUpperTag))+lowerPrice) ExpectFloatNum:floatNum];
        }
    }
    
    int botUpperTag = BotPriceLabelTag;
    int botLowerTag = BotPriceLabelTag+lowBaseLineNum-1;
    for (int i = botUpperTag; i<=botLowerTag; i++) {
        UILabel *label = (UILabel *)[self.superview viewWithTag:i];
        if (i == botUpperTag) {
            label.text = [DataUsedEngine conversionFloatNum:upperVolume ExpectFloatNum:0];
        }
        else if (i == botLowerTag){
            label.text = [DataUsedEngine conversionFloatNum:lowerVoluem ExpectFloatNum:0];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((upperVolume-lowerVoluem)/(lowBaseLineNum-1)*((lowBaseLineNum-1) - (i-botUpperTag))+lowerVoluem) ExpectFloatNum:0];
        }
    }
}

#pragma mark - 
#pragma mark K线蜡烛图

-(void)loadTopView{
    if (_candleBGView == nil) {
        _candleBGView = [[UIView alloc]initWithFrame:CGRectMake(0, top_top_Y, self.frame.size.width, top_low_Y - top_top_Y)];
        _candleBGView.userInteractionEnabled = YES;
        [self addSubview:_candleBGView];
    }
    
    NSMutableArray  *allArray = _dataArray;
    for (int i = 0; i < allArray.count; i++) {
        KLineDataModel *klineModel = allArray[i];
        CandleView *candleView = [[CandleView alloc]initWithFrame:CGRectMake(self.frame.size.width/DefaultShowNum * (i), 0, self.frame.size.width/DefaultShowNum, top_low_Y - top_top_Y) Style:candleStyle];
        candleView.hidden = YES;
        [_candleBGView addSubview:candleView];
        [candleView setOpenPo:[self topPriceToPointYWithPrice:klineModel.openPrice]
                      ClosePo:[self topPriceToPointYWithPrice:klineModel.closePrice]
                        MaxPo:[self topPriceToPointYWithPrice:klineModel.maxPrice]
                        MinPo:[self topPriceToPointYWithPrice:klineModel.minPrice]
                     VolumePo:[self lowPriceToPointYWithVolume:klineModel.volume]
                        EndPo:[self lowPriceToPointYWithVolume:0]
         ];
        [candleView setCandleTag:i];
    }
    if (allArray.count > 0) {
        [self update];
        [self setContentOffset:CGPointMake(self.frame.size.width/DefaultShowNum * (allArray.count+10), 0)];
    }else{
//        NSLog(@"进这里了");
        [self update];
//        [self setContentOffset:CGPointMake(self.frame.size.width/DefaultShowNum * (allArray.count+10), 0)];
    }
}

#pragma mark -
#pragma mark 缩放手势

-(void)loadPinchGesture{
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
}

-(void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    if (pinchGestureRecognizer.scale > 1) {
        if ([KLineShowNum sharedInstance].showNum > 16) {
            float scale = pinchGestureRecognizer.scale*10;
            switch ((int)scale) {
                case 13:{
                    [self zoomMinus];
                }
                    break;
                case 16:{
                    [self zoomMinus];
                }
                    break;
                case 19:{
                    [self zoomMinus];
                }
                    break;
                case 21:{
                    [self zoomMinus];
                }
                    break;
                case 24:{
                    [self zoomMinus];
                }
                    break;
                case 27:{
                    [self zoomMinus];
                }
                    break;
                case 30:{
                    [self zoomMinus];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else{
        if ([KLineShowNum sharedInstance].showNum < 100) {
            float scale = pinchGestureRecognizer.scale;
            scale = scale*10;
            switch ((int)scale) {
                case 9:{
                    [self zoomPlus];
                }
                    break;
                case 8:{
                    [self zoomPlus];
                }
                    break;
                case 7:{
                    [self zoomPlus];
                }
                    break;
                case 6:{
                    [self zoomPlus];
                }
                    break;
                case 5:{
                    [self zoomPlus];
                }
                    break;
                case 4:{
                    [self zoomPlus];
                }
                    break;
                case 3:{
                    [self zoomPlus];
                }
                    break;
                case 2:{
                    [self zoomPlus];
                }
                    break;
                case 1:{
                    [self zoomPlus];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)zoomPlus{
    [KLineShowNum sharedInstance].showNum += 5;
    [self reload];
}

-(void)zoomMinus{
    [KLineShowNum sharedInstance].showNum -= 5;
    [self reload];
}

-(void)reload{
    self.contentSize = CGSizeMake((DBSaveNum+10)*((self.frame.size.width)/DefaultShowNum), self.bounds.size.height);
    NSInteger maxTag = 0;
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        CandleView *candleView = _candleBGView.subviews[i];
        if (i == 0) {
            maxTag = candleView.candleTag;
        }
        if (candleView.candleTag >= maxTag) {
            maxTag = candleView.candleTag;
        }
    }
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        CandleView *candleView = _candleBGView.subviews[i];
        candleView.frame = CGRectMake((self.frame.size.width/DefaultShowNum)*candleView.candleTag, candleView.frame.origin.y, self.frame.size.width/DefaultShowNum, candleView.frame.size.height);
    }
    [self setContentOffset:CGPointMake((self.frame.size.width/DefaultShowNum)*maxTag - self.frame.size.width, 0)];
    [self update];
}

#pragma mark - 
#pragma mark 点击手势

-(void)loadTapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTap)];
    [self addGestureRecognizer:tapGesture];
}

-(void)gestureTap{
    candleStyle ++;
    if (candleStyle > KLineStyleALL) {
        candleStyle = KLineStyleDefault;
    }
    
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            CandleView *candleView = _candleBGView.subviews[i];
            [candleView changeStyle:candleStyle];
        }
    }
}

#pragma mark - 
#pragma mark 长按手势

-(void)loadLongGesture{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.3f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark 长按就开始生成十字线
-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    CGPoint point = [longResture locationInView:self];
    if (_dataArray.count > 0) {
        if(longResture.state == UIGestureRecognizerStateBegan){
            [self loadCrossView];
            
            isGestureOn = YES;
            
            CGPoint crossPoint = [self findCandleView:point];
            _topVerLineView.center = CGPointMake(crossPoint.x, _topVerLineView.center.y);
            _topHorLineView.center = CGPointMake(_topHorLineView.center.x, crossPoint.y);
            _topPriceLabel.center = CGPointMake(_topPriceLabel.center.x, _topHorLineView.center.y);
            
            CGPoint volumPoint = [self findVolumeView:point];
            _botVerLineView.center = CGPointMake(volumPoint.x, _botVerLineView.center.y);
            _botHorLineView.center = CGPointMake(_botHorLineView.center.x, volumPoint.y);
            _botPriceLabel.center = CGPointMake(_botPriceLabel.center.x, _botHorLineView.center.y);
            
            self.beginBlock(_lookKLineModel);
            
            [self changeMAShowLabel];
        }
        if (longResture.state == UIGestureRecognizerStateChanged) {
            if ((_topVerLineView != nil || _topHorLineView != nil) && (_botVerLineView != nil || _botHorLineView != nil)) {
                CGPoint crossPoint = [self findCandleView:point];
                CGFloat topVerLineViewCenterX = crossPoint.x;
                _topVerLineView.center = CGPointMake(topVerLineViewCenterX, _topVerLineView.center.y);
                _topHorLineView.center = CGPointMake(_topHorLineView.center.x, crossPoint.y);
                _topPriceLabel.center = CGPointMake(_topPriceLabel.center.x, _topHorLineView.center.y);
                
                CGPoint volumPoint = [self findVolumeView:point];
                CGFloat botVerLineViewCenterX = volumPoint.x;
                _botVerLineView.center = CGPointMake(botVerLineViewCenterX, _botVerLineView.center.y);
                _botHorLineView.center = CGPointMake(_botHorLineView.center.x, volumPoint.y);
                _botPriceLabel.center = CGPointMake(_botPriceLabel.center.x, _botHorLineView.center.y);
                self.beginBlock(_lookKLineModel);
                
                [self changeMAShowLabel];
            }
            else{
                self.endBlock();
            }
        }
        
        if (longResture.state == UIGestureRecognizerStateEnded || longResture.state == UIGestureRecognizerStateFailed || longResture.state == UIGestureRecognizerStateCancelled) {
            isGestureOn = NO;
            [self removeCrossView];
            [self endMAShowLabel];
            self.endBlock();
        }
    }
}

-(void)loadCrossView{
    
    [self removeCrossView];
    
    _topHorLineView = [[UIView alloc]initWithFrame:CGRectMake(self.contentOffset.x, top_top_Y, self.frame.size.width-CrossCurveLabelWidth, 0.5)];
    _topHorLineView.backgroundColor = Color_Gold;
    [self addSubview:_topHorLineView];
    
    _topVerLineView = [[UIView alloc]initWithFrame:CGRectMake(self.contentOffset.x, top_top_Y, 0.5, top_low_Y - top_top_Y)];
    _topVerLineView.backgroundColor = Color_Gold;
    [self addSubview:_topVerLineView];
    
    _topPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width+self.contentOffset.x - CrossCurveLabelWidth, 0, CrossCurveLabelWidth, 13)];
    _topPriceLabel.backgroundColor = Color_Gold;
    _topPriceLabel.center = CGPointMake(_topPriceLabel.center.x, _topHorLineView.center.y);
    _topPriceLabel.alpha = 0.6;
    _topPriceLabel.clipsToBounds = YES;
    _topPriceLabel.layer.cornerRadius = 1.5;
    _topPriceLabel.font = [UIFont systemFontOfSize:10];
    _topPriceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_topPriceLabel];
    
    _botHorLineView = [[UIView alloc]initWithFrame:CGRectMake(self.contentOffset.x, low_top_Y, self.frame.size.width-CrossCurveLabelWidth, 0.5)];
    _botHorLineView.backgroundColor = Color_Gold;
    [self addSubview:_botHorLineView];
    
    _botVerLineView = [[UIView alloc]initWithFrame:CGRectMake(self.contentOffset.x, low_top_Y, 0.5, low_low_Y - low_top_Y)];
    _botVerLineView.backgroundColor = Color_Gold;
    [self addSubview:_botVerLineView];
    
    _botPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width+self.contentOffset.x - CrossCurveLabelWidth, low_top_Y, CrossCurveLabelWidth, 13)];
    _botPriceLabel.backgroundColor = Color_Gold;
    _botPriceLabel.center = CGPointMake(_botPriceLabel.center.x, _botHorLineView.center.y);
    _botPriceLabel.alpha = 0.6;
    _botPriceLabel.clipsToBounds = YES;
    _botPriceLabel.layer.cornerRadius = 1.5;
    _botPriceLabel.font = [UIFont systemFontOfSize:10];
    _botPriceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_botPriceLabel];
}

-(CGPoint)findCandleView:(CGPoint)currentPoint{
    
    CGPoint resultPoint;
    _topHorLineView.hidden = YES;
    _topPriceLabel.hidden = YES;
    _topVerLineView.hidden = YES;
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            CandleView *candleView = _candleBGView.subviews[i];
            if (candleView.frame.origin.x <= currentPoint.x && candleView.frame.origin.x + candleView.frame.size.width >= currentPoint.x) {
                resultPoint.x = candleView.center.x;
                resultPoint.y = candleView.openPo + top_top_Y;
                
                if (_dataArray != nil && _dataArray.count-1 >= candleView.candleTag && _dataArray[candleView.candleTag] != nil) {
                    loockCandleTag = candleView.candleTag;
                    _topHorLineView.hidden = NO;
                    _topPriceLabel.hidden = NO;
                    _topVerLineView.hidden = NO;
                    KLineDataModel *klineModel = _dataArray[candleView.candleTag];
                    //Block回调需要(行情页Title改变)
                    _lookKLineModel = klineModel;
                    _topPriceLabel.text = [DataUsedEngine conversionFloatNum:klineModel.openPrice ExpectFloatNum:floatNum];
                    float width = [Helper calculateTheHightOfText:_topPriceLabel.text height:_topPriceLabel.frame.size.height font:_topPriceLabel.font];
                    _topPriceLabel.bounds = CGRectMake(0, 0, width+6, _topPriceLabel.frame.size.height) ;
                    _topPriceLabel.center = CGPointMake(self.contentOffset.x + self.frame.size.width-_topPriceLabel.frame.size.width/2, _topPriceLabel.center.y);
                    _topHorLineView.bounds = CGRectMake(0, 0, self.frame.size.width - _topPriceLabel.frame.size.width, _topHorLineView.frame.size.height);
                    _topHorLineView.center = CGPointMake(self.contentOffset.x + _topHorLineView.frame.size.width/2, _topHorLineView.center.y);
                }
            }
        }
    }
    
    return resultPoint;
}

-(CGPoint)findVolumeView:(CGPoint)currentPoint{
    
    CGPoint resultPoint;
    _botHorLineView.hidden = YES;
    _botPriceLabel.hidden = YES;
    _botVerLineView.hidden = YES;
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            CandleView *candleView = _candleBGView.subviews[i];
            if (candleView.frame.origin.x <= currentPoint.x && candleView.frame.origin.x + candleView.frame.size.width >= currentPoint.x) {
                resultPoint.x = candleView.center.x;
                resultPoint.y = candleView.voluPo + top_top_Y;
                
                if (_dataArray != nil && _dataArray.count-1 >= candleView.candleTag && _dataArray[candleView.candleTag] != nil) {
                    _botHorLineView.hidden = NO;
                    _botPriceLabel.hidden = NO;
                    _botVerLineView.hidden = NO;
                    KLineDataModel *klineModel = _dataArray[candleView.candleTag];
                    _botPriceLabel.text = [DataUsedEngine conversionFloatNum:klineModel.volume ExpectFloatNum:0];
                    float width = [Helper calculateTheHightOfText:_botPriceLabel.text height:_botPriceLabel.frame.size.height font:_botPriceLabel.font];
                    _botPriceLabel.bounds = CGRectMake(0, 0, width+6, _botPriceLabel.frame.size.height) ;
                    _botPriceLabel.center = CGPointMake(self.contentOffset.x + self.frame.size.width-_botPriceLabel.frame.size.width/2, _botPriceLabel.center.y);
                    _botHorLineView.bounds = CGRectMake(0, 0, self.frame.size.width - _botPriceLabel.frame.size.width, _botHorLineView.frame.size.height);
                    _botHorLineView.center = CGPointMake(self.contentOffset.x + _botHorLineView.frame.size.width/2, _botHorLineView.center.y);
                }
            }
        }
    }
    
    return resultPoint;
}

-(void)removeCrossView{
    if (_topHorLineView != nil || _topVerLineView != nil || _topPriceLabel != nil) {
        [_topHorLineView removeFromSuperview];
        [_topVerLineView removeFromSuperview];
        [_topPriceLabel removeFromSuperview];
        
        _topHorLineView = nil;
        _topPriceLabel = nil;
        _topVerLineView = nil;
    }
    
    if (_botHorLineView != nil || _botPriceLabel != nil || _botVerLineView != nil) {
        [_botHorLineView removeFromSuperview];
        [_botPriceLabel removeFromSuperview];
        [_botVerLineView removeFromSuperview];
        
        _botVerLineView = nil;
        _botPriceLabel = nil;
        _botHorLineView = nil;
    }
}

#pragma mark 计算

-(float)topPriceToPointYWithPrice:(float)aPrice{
    if(isnan(aPrice)){
        aPrice = 0;
    }
    
    float point_Y = (top_low_Y - top_top_Y) * (1 - (aPrice - lowerPrice)/(upperPrice - lowerPrice)) ;
    return point_Y;
}

-(float)lowPriceToPointYWithVolume:(float)aVolume{
    if(isnan(aVolume)){
        aVolume = 0;
    }
    
    float point_Y = (low_low_Y - low_top_Y) * (1 - (aVolume - lowerVoluem)/(upperVolume - lowerVoluem)) + low_top_Y - top_top_Y;
    return point_Y;
}

#pragma mark 更新数据

-(void)update{
    [self removeCrossView];
//    _dataArray = [KLineDao getAllKLineDataWithInstrumentID:_instrumentID];
//    _allDataArray = [NSMutableArray arrayWithArray:_dataArray];
    self.klineBlock(_dataArray);
    
    [self createNewCandelView];
    
    [self move];
}
/**
 *  左右滑动
 */
-(void)move{
    
    if (_dataArray == nil || _dataArray.count == 0) {
        return;
    }
    
    float beginPointX = self.contentOffset.x;
    float endPointX = beginPointX + self.frame.size.width;
    NSInteger   minTag = -1;
    NSInteger   maxTag = -1;
    
    for (int i = 0 ; i < _candleBGView.subviews.count ; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            
            CandleView *candleView = (CandleView *)_candleBGView.subviews[i];
            if (candleView.frame.origin.x + (self.frame.size.width/DefaultShowNum) > beginPointX && candleView.frame.origin.x + candleView.frame.size.width < endPointX) {
                if (minTag == -1) {
                    minTag = candleView.candleTag;
                    maxTag = candleView.candleTag;
                }
                if (candleView.candleTag <= minTag) {
                    minTag = candleView.candleTag;
                }
                if (candleView.candleTag >= maxTag) {
                    maxTag = candleView.candleTag;
                }
            }
        }
    }
    
    if (minTag - 2 >= 0) {
        minTag = minTag - 2;
    }
    else{
        minTag = 0;
    }
    
    if (maxTag + 2 < _dataArray.count) {
        maxTag = maxTag + 2;
    }
    else{
        maxTag = _dataArray.count - 1;
    }
    
    for (NSInteger i = minTag ; i <= maxTag; i++) {
        if(i < _dataArray.count){
            KLineDataModel *klineModel = _dataArray[i];
            if (i == minTag) {
                //默认值
                lowerPrice = klineModel.minPrice;
                upperPrice = klineModel.maxPrice + rangeHeight;
                upperVolume = klineModel.volume;
            }
            else{
                if (klineModel.maxPrice >= upperPrice) {
                    upperPrice = klineModel.maxPrice;
                }
                
                if (klineModel.minPrice <= lowerPrice) {
                    lowerPrice = klineModel.minPrice;
                }
                
                if (klineModel.volume >= upperVolume) {
                    upperVolume = klineModel.volume;
                }
            }
        }
    }
    int topUpperTag = TopPriceLabelTag;
    int topLowerTag = TopPriceLabelTag+topBaseLineNum-1;
    for (int i = topUpperTag; i<=topLowerTag; i++) {
        UILabel *label = (UILabel *)[self.superview viewWithTag:i];
        if (i == topUpperTag) {
            label.text = [DataUsedEngine conversionFloatNum:upperPrice ExpectFloatNum:floatNum];
        }
        else if (i == topLowerTag){
            label.text = [DataUsedEngine conversionFloatNum:lowerPrice ExpectFloatNum:floatNum];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((upperPrice-lowerPrice)/(topBaseLineNum-1)*((topBaseLineNum-1) - (i-topUpperTag))+lowerPrice) ExpectFloatNum:floatNum];
        }
    }
    int botUpperTag = BotPriceLabelTag;
    int botLowerTag = BotPriceLabelTag+lowBaseLineNum-1;
    for (int i = botUpperTag; i<=botLowerTag; i++) {
        UILabel *label = (UILabel *)[self.superview viewWithTag:i];
        if (i == botUpperTag) {
            label.text = [DataUsedEngine conversionFloatNum:upperVolume ExpectFloatNum:0];
        }
        else if (i == botLowerTag){
            label.text = [DataUsedEngine conversionFloatNum:lowerVoluem ExpectFloatNum:0];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((upperVolume-lowerVoluem)/(lowBaseLineNum-1)*((lowBaseLineNum-1) - (i-botUpperTag))+lowerVoluem) ExpectFloatNum:0];
        }
    }
    
    
    for (int i = 0 ; i < _candleBGView.subviews.count ; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            
            CandleView *candleView = (CandleView *)_candleBGView.subviews[i];
            if (candleView.frame.origin.x+(self.frame.size.width/DefaultShowNum) > beginPointX && candleView.frame.origin.x + candleView.frame.size.width < endPointX) {
                if (minTag == 0) {
                    minTag = candleView.candleTag;
                }
                if (candleView.candleTag <= minTag) {
                    minTag = candleView.candleTag;
                }
                if (candleView.candleTag < _dataArray.count) {
                    KLineDataModel *klineModel = _dataArray[candleView.candleTag];
                    [candleView changeOpenPo:[self topPriceToPointYWithPrice:klineModel.openPrice]
                                     ClosePo:[self topPriceToPointYWithPrice:klineModel.closePrice]
                                       MaxPo:[self topPriceToPointYWithPrice:klineModel.maxPrice]
                                       MinPo:[self topPriceToPointYWithPrice:klineModel.minPrice]
                                    VolumePo:[self lowPriceToPointYWithVolume:klineModel.volume]
                                       EndPo:[self lowPriceToPointYWithVolume:0]
                     ];
                    candleView.hidden = NO;
                }
            }
        }
    }
    
    [self timeChange];
    
    [self updateMA];
}

-(void)createNewCandelView{
    
    NSInteger maxTag = 0;
    
    [self defaultDataConfiger:_dataArray];
    
    for (int i = 0; i < _candleBGView.subviews.count; i++) {
        if ([_candleBGView.subviews[i] isKindOfClass:[CandleView class]]) {
            CandleView *candleView = (CandleView *)_candleBGView.subviews[i];
            if (maxTag == 0) {
                maxTag = candleView.candleTag;
            }
            if (candleView.candleTag >= maxTag) {
                maxTag = candleView.candleTag;
            }
        }
    }
    
    for (NSInteger i = maxTag; i < _dataArray.count; i++) {
        KLineDataModel *klineModel = _dataArray[i];
        CandleView *candleView = [[CandleView alloc]initWithFrame:CGRectMake(self.frame.size.width/DefaultShowNum * (i), 0, self.frame.size.width/DefaultShowNum, top_low_Y - top_top_Y) Style:candleStyle];
        [_candleBGView addSubview:candleView];
        [candleView setOpenPo:[self topPriceToPointYWithPrice:klineModel.openPrice]
                      ClosePo:[self topPriceToPointYWithPrice:klineModel.closePrice]
                        MaxPo:[self topPriceToPointYWithPrice:klineModel.maxPrice]
                        MinPo:[self topPriceToPointYWithPrice:klineModel.minPrice]
                     VolumePo:[self lowPriceToPointYWithVolume:klineModel.volume]
                        EndPo:[self lowPriceToPointYWithVolume:0]
         ];
        [candleView setCandleTag:i];
        candleView.hidden = YES;
    }
    
    
    //首次加载的时候
    if (self.contentOffset.x == 0) {
        [self setContentOffset:CGPointMake(self.frame.size.width/DefaultShowNum * (_dataArray.count+10), 0)];
    }
}

#pragma mark 时间轴

-(void)timeChange{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1], nil];
    for (int i = 0; i < 5; i++) {
        UILabel *timeLabel = (UILabel *)[self.superview viewWithTag:KLineTimeTag+i];
        
        for (int j = 0; j < _candleBGView.subviews.count; j++) {
            if ([_candleBGView.subviews[j] isKindOfClass:[CandleView class]]) {
                CandleView *candleView = _candleBGView.subviews[j];
                if (!candleView.hidden) {
                    float   timeCenterX = timeLabel.center.x;
                    if (i == 0) {
                        timeCenterX = 0;
                    }
                    else if (i == 4){
                        timeCenterX = self.frame.size.width - self.frame.size.width/DefaultShowNum - 1  ;
                    }
                    if(candleView.frame.origin.x-self.contentOffset.x <= timeCenterX && candleView.frame.origin.x-self.contentOffset.x+candleView.frame.size.width >= timeCenterX){
                        [tmpArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(int)candleView.candleTag]];
                        continue;
                    }
                }
            }
        }
    }
    for (int i = 0; i < 5; i++) {
        UILabel *timeLabel = (UILabel *)[self.superview viewWithTag:KLineTimeTag+i];
        
        if ([tmpArray[i] intValue] > _dataArray.count-1) {
            if ([tmpArray[i] intValue] > -1) {
                [tmpArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:(int)_dataArray.count-1]];
            }
        }
        if ([tmpArray[i] intValue] <= -1) {
            if(i != 0) {
                if (_dataArray.count>30) {
                    if (self.contentOffset.x >= (self.frame.size.width/DefaultShowNum)*(_dataArray.count) - self.frame.size.width) {
                        timeLabel.text = @"";
                    }
                }
                else{
                    timeLabel.text = @"";
                }
            }
            else{
                timeLabel.text = @"";
            }
        }
        else{
            KLineDataModel *klineModel = _dataArray[[tmpArray[i] intValue]];
            /**
             *  日K线显示日期
             */
            if (klineMinute == 1440) {
                NSString *timeStr = [NSString stringWithFormat:@"%@",[[klineModel.time substringFromIndex:4] substringToIndex:4]];
                timeLabel.text = [NSString stringWithFormat:@"%@/%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
            }
            else{
                NSString *timeStr = [NSString stringWithFormat:@"%@",[[klineModel.time substringFromIndex:8] substringToIndex:4]];
                timeLabel.text = [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
            }
        }
    }
    for(int i = 0; i < 2 ; i ++){
        UILabel *timeLabel = (UILabel *)[self.superview viewWithTag:KLineTimeTag-i-1];
        if (i == 1) {
            if ([tmpArray[4] intValue] < 0 || [[NSString stringWithFormat:@"%@",tmpArray[4]] length] > 12) {
                /**
                 *  空数据重置结束日期
                 */
                timeLabel.text = @"";
                break;
            }
            if ([tmpArray[4] intValue] > _dataArray.count-1) {
                [tmpArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:(int)_dataArray.count-1]];
            }
            KLineDataModel *klineModel = _dataArray[[tmpArray[4] intValue]];
            NSString *dateStr = @"";
            if (klineModel.time.length >= 8) {
                dateStr = [klineModel.time substringToIndex:8];
            }
            timeLabel.text = dateStr;
        }
        else{
            if ([tmpArray[0] intValue] < 0 || [[NSString stringWithFormat:@"%@",tmpArray[4]] length] > 12) {
                /**
                 *  空数据重置起始日期
                 */
                timeLabel.text = @"";
                break;
            }
            KLineDataModel *klineModel = _dataArray[[tmpArray[0] intValue]];
            NSString *dateStr = @"";
            if (klineModel.time.length >= 8) {
                dateStr = [klineModel.time substringToIndex:8];
            }
            timeLabel.text = dateStr;
        }
        if (timeLabel.text.length >= 8) {
            timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",[timeLabel.text substringToIndex:4],[[timeLabel.text substringFromIndex:4] substringToIndex:2],[timeLabel.text substringFromIndex:6]];
        }
    }
}

#pragma mark MA线

-(void)loadMA{
    if (_maView ==nil) {
        _maView = [[MAView alloc]initWithFrame:CGRectMake(0, top_top_Y, self.frame.size.width, top_low_Y-top_top_Y)];
        _maView.userInteractionEnabled = YES;
        _maView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maView];
    }
    
}

-(void)updateMA{
    _maView.frame = CGRectMake(self.contentOffset.x, top_top_Y, self.frame.size.width, top_low_Y-top_top_Y);
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
    
    _ma1PriceArray = [self calculateMAPriceArray:MA5];
    [pointArray addObject:[self calculateMAPointArray:MA5 PriceArray:_ma1PriceArray]];
   
    _ma2PriceArray = [self calculateMAPriceArray:MA10];
    [pointArray addObject:[self calculateMAPointArray:MA10 PriceArray:_ma2PriceArray]];
    
    _ma3PriceArray = [self calculateMAPriceArray:MA20];
    [pointArray addObject:[self calculateMAPointArray:MA20 PriceArray:_ma3PriceArray]];
    
    [_maView setPointArray:pointArray];
    
    [self endMAShowLabel];
}

-(void)changeMAShowLabel{
    NSString *ma1Str = @"--";
    NSString *ma2Str = @"--";
    NSString *ma3Str = @"--";
    if (loockCandleTag - MA5 + 1 >= 0) {
        ma1Str = [DataUsedEngine conversionFloatNum:[_ma1PriceArray[loockCandleTag - MA5 + 1] floatValue] ExpectFloatNum:2];
    }
    if (loockCandleTag - MA10 + 1>= 0) {
        ma2Str = [DataUsedEngine conversionFloatNum:[_ma2PriceArray[loockCandleTag - MA10 + 1] floatValue] ExpectFloatNum:2];
    }
    if (loockCandleTag - MA20 + 1>= 0) {
        ma3Str = [DataUsedEngine conversionFloatNum:[_ma3PriceArray[loockCandleTag - MA20 + 1] floatValue] ExpectFloatNum:2];
    }
    
    _maShowLabel.text = @"";
    _maShowLabel.attributedText = nil;
    _maShowLabel.text = [NSString stringWithFormat:@"5,10,20 MA1:%@ MA2:%@ MA3:%@",ma1Str,ma2Str,ma3Str];
    _maShowLabel.attributedText = [DataUsedEngine mutableFontAndColorArray:[NSMutableArray arrayWithObjects:@"5,10,20",[NSString stringWithFormat:@" MA1:%@",ma1Str],[NSString stringWithFormat:@" MA2:%@",ma2Str],[NSString stringWithFormat:@" MA3:%@",ma3Str], nil] fontArray:nil colorArray:[NSMutableArray arrayWithObjects:@"106/106/106/1",@"53/136/221/1",@"230/101/47/1",@"156/41/114/1", nil]];
}

-(void)endMAShowLabel{
    NSString *ma1Str = @"--";
    NSString *ma2Str = @"--";
    NSString *ma3Str = @"--";
    if (_ma1PriceArray.count > 0) {
        ma1Str = [DataUsedEngine conversionFloatNum:[_ma1PriceArray.lastObject floatValue] ExpectFloatNum:2];
    }
    
    if (_ma2PriceArray.count > 0) {
        ma2Str = [DataUsedEngine conversionFloatNum:[_ma2PriceArray.lastObject floatValue] ExpectFloatNum:2];
    }
    
    if (_ma3PriceArray.count > 0) {
        ma3Str = [DataUsedEngine conversionFloatNum:[_ma3PriceArray.lastObject floatValue] ExpectFloatNum:2];
    }
    
    _maShowLabel.text = @"";
    _maShowLabel.attributedText = nil;
    _maShowLabel.text = [NSString stringWithFormat:@"5,10,20 MA1:%@ MA2:%@ MA3:%@",ma1Str,ma2Str,ma3Str];
    _maShowLabel.attributedText = [DataUsedEngine mutableFontAndColorArray:[NSMutableArray arrayWithObjects:@"5,10,20",[NSString stringWithFormat:@" MA1:%@",ma1Str],[NSString stringWithFormat:@" MA2:%@",ma2Str],[NSString stringWithFormat:@" MA3:%@",ma3Str], nil] fontArray:nil colorArray:[NSMutableArray arrayWithObjects:@"106/106/106/1",@"53/136/221/1",@"230/101/47/1",@"156/41/114/1", nil]];
}

-(NSMutableArray *)calculateMAPriceArray:(MA)aMA{
    NSMutableArray *maArray = [NSMutableArray arrayWithCapacity:0];
    if (_dataArray.count >= aMA) {
        for (int i = aMA-1; i < _dataArray.count; i++) {
            float closePrice = 0;
            for (int j = i; j > i-aMA; j--) {
                KLineDataModel *klineModel = _dataArray[j];
                closePrice += klineModel.closePrice;
            }
            closePrice = closePrice/aMA;
            if ([NSNumber numberWithFloat:closePrice] != nil) {
                [maArray addObject:[NSNumber numberWithFloat:closePrice]];
            }
        }
    }
    else{
    }
    return maArray;
}

-(NSMutableArray *)calculateMAPointArray:(MA)aMA PriceArray:(NSMutableArray *)aPriceArray{
    NSMutableArray  *pointArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < aPriceArray.count; i++) {
        @autoreleasepool {
            float   point_X = 0;
            float   point_Y = 0;
            
            point_X = (self.frame.size.width/DefaultShowNum)*(i+aMA)-((self.frame.size.width/DefaultShowNum)/2);
            point_Y = [self topPriceToPointYWithPrice:[aPriceArray[i] floatValue]];
            CGPoint point = CGPointMake(point_X, point_Y);
            [pointArray addObject:NSStringFromCGPoint(point)];
        }
    }
    return pointArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
