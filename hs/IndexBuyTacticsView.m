//
//  IndexBuyTacticsView.m
//  hs
//
//  Created by RGZ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "IndexBuyTacticsView.h"
#import "IndexBuyTacticsCell.h"
#import "UIImageView+WebCache.h"

@implementation IndexBuyTacticsView
{
    UIView      *_redCoverBgView;//分离层
    UIView      *_greenCoverBgView;//分离层
    UIImageView *_redBgImageView;//闪烁背景
    UIImageView *_greenBgImageView;
    
    UIImageView *_redImageView;//多头，当前持仓总量背景图
    UIImageView *_greenImageView;//空头，当前持仓总量背景图
    UIImageView *_vsImageView;//VS
    
    UILabel     *_redImgLabel;//多头，当前持仓总量Label
    UILabel     *_greenImgLabel;//空头，当前持仓总量Label
    
    UILabel     *_redImgTitleLabel;//多头领先
    UILabel     *_greenImgTitleLabel;//空头领先
    
    UILabel     *_redPercentLabel;//红色百分比
    UILabel     *_greenPercentLabel;//绿色百分比
    
    UIView      *_percentView;
    UIView      *_percentShowRedView;
    UIView      *_percentShowGreenView;
    
    UITableView *_leftTableView;//表格
    UITableView *_rightTableView;
    
    UIView      *_leftHeaderView;
    UIView      *_rightHeaderView;
    
    float   cellHeight;
    float   cellWidth;
    int     percentFont;
    
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    
    NSMutableArray *_leftResultArray;
    NSMutableArray *_righResultArray;
    
    NSString       *_buyNum;
    NSString       *_saleNum;
    
    NSTimer        *_reloadTimer;
    
    NSString       *_currentPrice;//当前价
}

#define LEFT_IMAGE_TAG  720
#define RIGHT_IMAGE_TAG 730

-(instancetype)initWithFrame:(CGRect)frame ProdcutModel:(FoyerProductModel *)productModel{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.productModle = productModel;
        [self loadData];
        [self loadUI];
    }
    return self;
}

-(void)loadData{
    percentFont = 12;
    if (_currentPrice.length <= 0) {
        _currentPrice = @"0";
    }
    cellHeight = 32.0/667*ScreenHeigth;
    _leftArray = [NSMutableArray arrayWithCapacity:0];
    _rightArray = [NSMutableArray arrayWithCapacity:0];
    _leftResultArray = [NSMutableArray arrayWithCapacity:0];
    _righResultArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 5; i++) {
        IndexBuyTacticsModel    *defaultModel = [[IndexBuyTacticsModel alloc]init];
        defaultModel.hands = @"尚无持仓";
        defaultModel.headPic = @"";
        defaultModel.nickName = @"";
        defaultModel.price = @"";
        defaultModel.priceSum = @"";
        defaultModel.userID = @"";
        defaultModel.income = @"";
        [_leftArray addObject:defaultModel];
        [_rightArray addObject:defaultModel];
        [_leftResultArray addObject:defaultModel];
        [_righResultArray addObject:defaultModel];
    }
    
    
    if (_reloadTimer == nil) {
        _reloadTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestToGetTacticsData) userInfo:nil repeats:YES];
        [_reloadTimer fire];
    }
}

-(void)loadUI{
    self.backgroundColor = [UIColor clearColor];
    
    //ImageView宽和高
    [self loadVS];
    
    //百分比
    [self loadPercent];
    
    //列表
    [self loadTable];
    
    //动画
    [self loadAnimation];
    [self loadSpinAnimation];
}

-(void)loadVS{
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.5)];
    lineView.backgroundColor = Color_Gold;
    [self addSubview:lineView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 5, 36, 13);
    [closeButton setImage:[UIImage imageNamed:@"tactics_Close"] forState:UIControlStateNormal];
    closeButton.center = CGPointMake(self.frame.size.width/2, closeButton.frame.size.height/2);
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *closeButton_enlargeClick = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton_enlargeClick.frame = CGRectMake(0, 0, self.frame.size.width/3, 30);
    closeButton_enlargeClick.center = CGPointMake(self.frame.size.width/2, closeButton_enlargeClick.frame.size.height/2);
    [closeButton_enlargeClick addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton_enlargeClick];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [closeButton_enlargeClick addGestureRecognizer: swipeGes];
    
    float   width = self.frame.size.width/5 + self.frame.size.width/50;
    if (ScreenHeigth <= 480) {
        width -= 15;
    }
    _redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    _redImageView.image = [UIImage imageNamed:@"tactics_red"];
    _redImageView.center = CGPointMake(self.frame.size.width/8*2 + self.frame.origin.x, _redImageView.frame.size.width/5*4);
    _redImageView.backgroundColor = [UIColor clearColor];
    
    _redBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _redImageView.frame.size.width+22, _redImageView.frame.size.height+22)];
    _redBgImageView.image = [UIImage imageNamed:@"tactics_red_shadow"];
    _redBgImageView.center = _redImageView.center;
    _redBgImageView.hidden = YES;
    
    [self addSubview:_redBgImageView];
    [self addSubview:_redImageView];
    
    _vsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width/2, (width/2)/(39.0/29.0))];
    _vsImageView.image = [UIImage imageNamed:@"tactics_VS"];
    _vsImageView.center = CGPointMake(self.frame.size.width/8*4 + self.frame.origin.x, _redImageView.center.y);
    [self addSubview:_vsImageView];
    
    _greenImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, _redImageView.frame.size.width)];
    _greenImageView.image = [UIImage imageNamed:@"tactics_green"];
    _greenImageView.backgroundColor = [UIColor clearColor];
    _greenImageView.center = CGPointMake(self.frame.size.width/8*6 + self.frame.origin.x, _redImageView.center.y);
    
    _greenBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _greenImageView.frame.size.width+22, _greenImageView.frame.size.height+22)];
    _greenBgImageView.image = [UIImage imageNamed:@"tactics_green_shadow"];
    _greenBgImageView.center = _greenImageView.center;
    _greenBgImageView.hidden = YES;
    
    [self addSubview:_greenBgImageView];
    [self addSubview:_greenImageView];
    
    //4s : 10 7 15   6:13 9 18
    float   font_title = 9;
    float   font_content = 6;
    float   font_number = 13;
    if (ScreenHeigth <= 480) {
        font_title = 10;
        font_content = 8;
        font_number = 18;
    }
    else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
        font_title = 10;
        font_content = 8;
        font_number = 24;
    }
    else if (ScreenHeigth <= 667 && ScreenHeigth > 568){
        font_title = 11;
        font_content = 9;
        font_number = 26;
    }
    else if (ScreenHeigth <= 736 && ScreenHeigth > 667){
        font_title = 12;
        font_content = 10;
        font_number = 30;
    }
    
    
    float   floatHeight = _redImageView.frame.size.height/10;
    
    _redCoverBgView = [[UIView alloc]initWithFrame:_redImageView.frame];
    [self addSubview:_redCoverBgView];
    
    _greenCoverBgView = [[UIView alloc]initWithFrame:_greenImageView.frame];
    [self addSubview:_greenCoverBgView];
    
    _redImgTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _redCoverBgView.frame.size.height/2 - floatHeight*3 + 3, _redImageView.frame.size.width, floatHeight*2.5)];
    _redImgTitleLabel.text = @"多头";
    _redImgTitleLabel.font = [UIFont boldSystemFontOfSize:font_title];
    _redImgTitleLabel.textAlignment = NSTextAlignmentCenter;
    _redImgTitleLabel.textColor = [UIColor whiteColor];
    [_redCoverBgView addSubview:_redImgTitleLabel];
    
    _redImgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _redCoverBgView.frame.size.height/2 - floatHeight/2 + 3, _redImgTitleLabel.frame.size.width, floatHeight*3)];
    _redImgLabel.text = @"0";
    _redImgLabel.font = [UIFont boldSystemFontOfSize:font_number];
    _redImgLabel.numberOfLines = 0;
    _redImgLabel.textColor = [UIColor whiteColor];
    _redImgLabel.textAlignment = NSTextAlignmentCenter;
    [_redCoverBgView addSubview:_redImgLabel];
    
    
    _greenImgTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _redImgTitleLabel.frame.origin.y, _greenImageView.frame.size.width, _redImgTitleLabel.frame.size.height)];
    _greenImgTitleLabel.text = @"空头";
    _greenImgTitleLabel.font = [UIFont boldSystemFontOfSize:font_title];
    _greenImgTitleLabel.textAlignment = NSTextAlignmentCenter;
    _greenImgTitleLabel.textColor = [UIColor whiteColor];
    [_greenCoverBgView addSubview:_greenImgTitleLabel];
    
    
    _greenImgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _redImgLabel.frame.origin.y, _greenImgTitleLabel.frame.size.width, _redImgLabel.frame.size.height)];
    _greenImgLabel.text = @"0";
    _greenImgLabel.font = [UIFont boldSystemFontOfSize:font_number];
    _greenImgLabel.numberOfLines = 0;
    _greenImgLabel.textColor = [UIColor whiteColor];
    _greenImgLabel.textAlignment = NSTextAlignmentCenter;
    [_greenCoverBgView addSubview:_greenImgLabel];
    
    _redImageView.alpha = 0.6;
    _greenImageView.alpha = 0.6;
    _greenCoverBgView.alpha = 0.6;
    _redCoverBgView.alpha = 0.6;
}

-(void)loadPercent{
    int font = 12;
    
    if (ScreenHeigth <= 480) {
        font = 12;
    }
    else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
        font = 12;
    }
    else if (ScreenHeigth <= 667 && ScreenHeigth > 568){
        font = 14;
    }
    else{
        font = 15;
    }
    percentFont = font;
    
    _percentView = [[UIView alloc]initWithFrame:CGRectMake(20, _redImageView.frame.origin.y + _redImageView.frame.size.height + 15.0/667*ScreenHeigth, self.frame.size.width - 40, 30/667.0*ScreenHeigth)];
    [self addSubview:_percentView];
    
    _redPercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _percentView.frame.size.width/7*3-5, _percentView.frame.size.height/3*2)];
    _redPercentLabel.textColor = Color_red;
    _redPercentLabel.text = [NSString stringWithFormat:@"+%@0",self.productModle.currencySign];
    _redPercentLabel.font = [UIFont systemFontOfSize:font];
    _redPercentLabel.textAlignment = NSTextAlignmentRight;
    [_percentView addSubview:_redPercentLabel];

    UILabel *topProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _percentView.frame.size.width/7, _percentView.frame.size.height/3*2)];
    topProLabel.textColor = Color_Gold;
    topProLabel.text = [NSString stringWithFormat:@"VS"];
    topProLabel.font = [UIFont boldSystemFontOfSize:13];
    topProLabel.textAlignment = NSTextAlignmentCenter;
    topProLabel.center = CGPointMake(_percentView.frame.size.width/2, topProLabel.center.y);
    [_percentView addSubview:topProLabel];
    UILabel *botProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _percentView.frame.size.height/3*2, _percentView.frame.size.width/7, _percentView.frame.size.height/3)];
    botProLabel.textColor = Color_Gold;
    botProLabel.text = [NSString stringWithFormat:@"浮动总盈亏"];
    botProLabel.font = [UIFont boldSystemFontOfSize:8];
    botProLabel.textAlignment = NSTextAlignmentCenter;
    botProLabel.center = CGPointMake(_percentView.frame.size.width/2, botProLabel.center.y);
    [_percentView addSubview:botProLabel];

    _greenPercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_percentView.frame.size.width/7*4+5, 0, _percentView.frame.size.width/7*3, _percentView.frame.size.height/3*2)];
    _greenPercentLabel.textColor = Color_red;
    _greenPercentLabel.text = [NSString stringWithFormat:@"+%@0",self.productModle.currencySign];
    _greenPercentLabel.font = [UIFont systemFontOfSize:font];
    [_percentView addSubview:_greenPercentLabel];
    
    float   defaultWidth = 0;

    _percentShowRedView = [[UIView alloc]initWithFrame:CGRectMake(_percentView.frame.size.width/7*3-defaultWidth, _percentView.frame.size.height/3*2 + _percentView.frame.size.height/3/2-1.5, defaultWidth, 3)];
    _percentShowRedView.backgroundColor = Color_red;
    [_percentView addSubview:_percentShowRedView];

    _percentShowGreenView = [[UIView alloc]initWithFrame:CGRectMake(_percentView.frame.size.width/7*4, _percentView.frame.size.height/3*2 + _percentView.frame.size.height/3/2 - 1.5 , defaultWidth, 3)];
    _percentShowGreenView.backgroundColor = Color_green;
    [_percentView addSubview:_percentShowGreenView];
}

-(void)loadTable{
    
    float   y = _percentView.frame.size.height + _percentView.frame.origin.y + 15.0/667*ScreenHeigth;
    
    UIView *tableSuperView = [[UIView alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width - 40, self.frame.size.height - y)];
    [self addSubview:tableSuperView];
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tableSuperView.frame.size.width/7*3, tableSuperView.frame.size.height) style:UITableViewStyleGrouped];
    _leftTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _leftTableView.delegate = self;
    _leftTableView.tag = 10086;
    _leftTableView.showsHorizontalScrollIndicator = NO;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.backgroundColor = [UIColor clearColor];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.scrollEnabled = NO;
    _leftTableView.rowHeight = cellHeight;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableSuperView addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(tableSuperView.frame.size.width - tableSuperView.frame.size.width/7*3, 0, tableSuperView.frame.size.width/7*3, tableSuperView.frame.size.height) style:UITableViewStyleGrouped];
    _rightTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _rightTableView.delegate = self;
    _rightTableView.tag = 10087;
    _rightTableView.showsHorizontalScrollIndicator = NO;
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.backgroundColor = [UIColor clearColor];
    _rightTableView.scrollEnabled = NO;
    _rightTableView.rowHeight = cellHeight;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableSuperView addSubview:_rightTableView];
    
    _leftHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _leftTableView.frame.size.width, _leftTableView.frame.size.width/4)];
    for (int i = 0; i < 3; i++) {
        UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_leftTableView.frame.size.width/4.5*i)+(_leftTableView.frame.size.width/4.5*1.5/2)*i, 0, _leftTableView.frame.size.width/4.5, _leftTableView.frame.size.width/4.5)];
        headerImageView.clipsToBounds = YES;
        headerImageView.layer.cornerRadius = _leftTableView.frame.size.width/4.5/2;
        headerImageView.layer.borderColor = Color_white.CGColor;
        headerImageView.layer.borderWidth = 1;
        headerImageView.tag = LEFT_IMAGE_TAG + i;
        [_leftHeaderView addSubview:headerImageView];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerImageView.frame.size.width, headerImageView.frame.size.height/3)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont systemFontOfSize:8];
        headerLabel.text = [NSString stringWithFormat:@"NO.%d",i+1];
        headerLabel.clipsToBounds = YES;
        headerLabel.layer.cornerRadius = 2;
        headerLabel.layer.borderColor = Color_white.CGColor;
        headerLabel.layer.borderWidth = 1;
        headerLabel.textColor = Color_white;
        headerLabel.backgroundColor = Color_grayDeep;
        headerLabel.center = CGPointMake(headerImageView.center.x, _leftHeaderView.frame.size.height - headerLabel.frame.size.height/2);
        [_leftHeaderView addSubview:headerLabel];
    }
    _leftTableView.tableHeaderView = _leftHeaderView;
    _rightHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _leftTableView.frame.size.width, _leftTableView.frame.size.width/4)];
    for (int i = 0; i < 3; i++) {
        UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_leftTableView.frame.size.width/4.5*i)+(_leftTableView.frame.size.width/4.5*1.5/2)*i, 0, _leftTableView.frame.size.width/4.5, _leftTableView.frame.size.width/4.5)];
        headerImageView.clipsToBounds = YES;
        headerImageView.layer.cornerRadius = _leftTableView.frame.size.width/4.5/2;
        headerImageView.layer.borderColor = Color_white.CGColor;
        headerImageView.layer.borderWidth = 1;
        headerImageView.tag = RIGHT_IMAGE_TAG + i;
        [_rightHeaderView addSubview:headerImageView];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerImageView.frame.size.width, headerImageView.frame.size.height/3)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont systemFontOfSize:8];
        headerLabel.text = [NSString stringWithFormat:@"NO.%d",i+1];
        headerLabel.clipsToBounds = YES;
        headerLabel.layer.cornerRadius = 2;
        headerLabel.layer.borderColor = Color_white.CGColor;
        headerLabel.layer.borderWidth = 1;
        headerLabel.textColor = Color_white;
        headerLabel.backgroundColor = Color_grayDeep;
        headerLabel.center = CGPointMake(headerImageView.center.x, _rightHeaderView.frame.size.height - headerLabel.frame.size.height/2);
        [_rightHeaderView addSubview:headerLabel];
    }
    _rightTableView.tableHeaderView = _rightHeaderView;
    
    UIView  *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _leftTableView.frame.size.width, 10)];
    _leftTableView.tableFooterView = blankView;
    _rightTableView.tableFooterView = blankView;
    
    cellWidth = _leftTableView.frame.size.width;
    
    cellHeight = (_leftTableView.frame.size.height - 10 - _leftTableView.frame.size.width/4)/5;
}

#pragma TableDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_leftResultArray.count == 0 || _righResultArray.count == 0) {
        return nil;
    }
    
    NSString    *identifier = @"cell";
    IndexBuyTacticsModel *model = nil;
    BOOL    isNil = NO;
    if (tableView.tag == 10086) {
        identifier = [identifier stringByAppendingString:@"left"];
        if (indexPath.section <= _leftResultArray.count - 1) {
            if (_leftResultArray != nil) {
                model = _leftResultArray[indexPath.section];
            }
        }
        else{
            isNil = YES;
        }
    }
    else{
        identifier = [identifier stringByAppendingString: @"right"];
        if (indexPath.section < _righResultArray.count) {
            if (_righResultArray != nil) {
                model = _righResultArray[indexPath.section];
            }
        }
        else{
            isNil = YES;
        }
    }
    IndexBuyTacticsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[IndexBuyTacticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier CellHeight:cellHeight CellWidth:cellWidth];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (isNil) {
        [cell changeContent:@"" Content:@"尚无持仓" Money:@""];
    }
    else{
        [cell changeContent:model.nickName Content:model.hands Money:model.income];
    }
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10086) {
        if (_leftResultArray == nil) {
            return 0;
        }
        else if (_leftResultArray.count < 5)
            return 5;
        else
            return _leftResultArray.count;
    }
    else{
        if (_righResultArray == nil) {
            return 0;
        }
        else if (_righResultArray.count < 5)
            return 5;
        else
            return _righResultArray.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, 1)];
    bgView.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    
    //数据的最后一行没有横线
//    if (tableView.tag == 10086) {
//        if (section >= _leftArray.count-1) {
//            bgView.backgroundColor = self.backgroundColor;
//        }
//    }
//    else{
//        if (section >= _rightArray.count-1) {
//            bgView.backgroundColor = self.backgroundColor;
//        }
//    }
    
    if (section >= 4) {
        bgView.backgroundColor = self.backgroundColor;
    }
    
    return bgView;
}

#pragma mark 关闭 操作
-(void)close{
    [self closeSelf];
}

-(void)closeSelf{
    [_reloadTimer invalidate];
    _reloadTimer = nil;
    
    self.IndexBuyTacticsBlock();
    
    [self removeFromSuperview];
}

#pragma mark 其他页面关闭操作
-(void)otherClose{
    [self closeSelf];
}

#pragma mark Data

-(void)changeCurrentPrice:(NSString *)currentPrice{
    _currentPrice = currentPrice;
    
    for (int i = 0; i < _leftResultArray.count; i++) {
        IndexBuyTacticsModel *model = _leftResultArray[i];
        float   currentTotalPrice = [model.hands intValue] * [_currentPrice floatValue];
        NSString *resultPrice = @"";
        resultPrice = [NSString stringWithFormat:@"%.0f",(currentTotalPrice - [model.priceSum floatValue])*[self.productModle.multiple floatValue]];
        if (_currentPrice == nil || [_currentPrice floatValue] == 0) {
            resultPrice = @"——";
        }
        if ([model.hands isEqualToString:@"尚无持仓"]) {//尚无持仓判断
            resultPrice = @"";
        }
        model.income = resultPrice;
    }
    
    for (int i = 0; i < _righResultArray.count; i++) {
        IndexBuyTacticsModel *model = _righResultArray[i];
        float   currentTotalPrice = [model.hands intValue] * [_currentPrice floatValue];
        NSString *resultPrice = @"";
        resultPrice = [NSString stringWithFormat:@"%.0f",([model.priceSum floatValue] - currentTotalPrice)*[self.productModle.multiple floatValue]];
        if (_currentPrice == nil || [_currentPrice floatValue] == 0) {
            resultPrice = @"——";
        }
        if ([model.hands isEqualToString:@"尚无持仓"]) {//尚无持仓判断
            resultPrice = @"";
        }
        model.income = resultPrice;
    }
    
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}

-(void)setDefaultCurrentPrice:(NSString *)currentPrice{
    _currentPrice = currentPrice;
    [self changeCurrentPrice:_currentPrice];
}

-(void)requestToGetTacticsData{
    [DataEngine requestToGetTacticsDataWithType:self.productModle.instrumentCode successBlock:^(BOOL SUCCESS, NSDictionary *data) {
        if (SUCCESS) {
            _buyNum = [DataUsedEngine nullTrimString:data[@"buyNum"]];
            _saleNum = [DataUsedEngine nullTrimString:data[@"saleNum"]];
            
            [_leftArray removeAllObjects];
            [_rightArray removeAllObjects];
            if (data[@"buy"] != nil) {
                for (int i = 0; i < [data[@"buy"] count]; i++) {
                    IndexBuyTacticsModel *model = [[IndexBuyTacticsModel alloc]init];
                    model.nickName = [DataUsedEngine nullTrimString:data[@"buy"][i][@"nickName"]];
                    model.hands = [DataUsedEngine nullTrimString:data[@"buy"][i][@"hands"]];
                    model.price = [DataUsedEngine nullTrimString:data[@"buy"][i][@"price"]];
                    model.priceSum = [DataUsedEngine nullTrimString:data[@"buy"][i][@"priceSum"]];
                    model.headPic = [DataUsedEngine nullTrimString:data[@"buy"][i][@"headPic"]];
                    model.userID = [DataUsedEngine nullTrimString:data[@"buy"][i][@"userId"]];
                    
                    float   currentTotalPrice = [model.hands intValue] * [_currentPrice floatValue];
                    NSString *resultPrice = @"";
                    resultPrice = [NSString stringWithFormat:@"%.0f",(currentTotalPrice - [model.priceSum floatValue])*[self.productModle.multiple floatValue]];
                    if (_currentPrice == nil || [_currentPrice floatValue] == 0) {
                        resultPrice = @"——";
                    }
                    if ([model.hands isEqualToString:@"尚无持仓"]) {//尚无持仓判断
                        resultPrice = @"";
                    }
                    model.income = resultPrice;
                    
                    [_leftArray addObject:model];
                }
            }
            
            if (data[@"sale"] != nil) {
                for (int i = 0; i < [data[@"sale"] count]; i++) {
                    IndexBuyTacticsModel *model = [[IndexBuyTacticsModel alloc]init];
                    model.nickName = [DataUsedEngine nullTrimString:data[@"sale"][i][@"nickName"]];
                    model.hands = [DataUsedEngine nullTrimString:data[@"sale"][i][@"hands"]];
                    model.price = [DataUsedEngine nullTrimString:data[@"sale"][i][@"price"]];
                    model.priceSum = [DataUsedEngine nullTrimString:data[@"sale"][i][@"priceSum"]];
                    model.userID = [DataUsedEngine nullTrimString:data[@"sale"][i][@"userId"]];
                    model.headPic = [DataUsedEngine nullTrimString:data[@"sale"][i][@"headPic"]];
                    
                    float   currentTotalPrice = [model.hands intValue] * [_currentPrice floatValue];
                    NSString *resultPrice = @"";
                    resultPrice = [NSString stringWithFormat:@"%.0f",([model.priceSum floatValue] - currentTotalPrice)*[self.productModle.multiple floatValue]];
                    if (_currentPrice == nil || [_currentPrice floatValue] == 0) {
                        resultPrice = @"——";
                    }
                    if ([model.hands isEqualToString:@"尚无持仓"]) {//尚无持仓判断
                        resultPrice = @"";
                    }
                    model.income = resultPrice;
                    
                    [_rightArray addObject:model];
                }
            }
            
            [self reloadData];
            
            
        }
    }];
}

-(void)reloadData{
    if (![_buyNum isEqualToString:@""] && ![_saleNum isEqualToString:@""]) {
        if ([_buyNum floatValue] > [_saleNum floatValue]) {
            _redImgTitleLabel.text = @"多头领先";
            _greenImgTitleLabel.text = @"空头";
            //图片切换
            _redImageView.image = [UIImage imageNamed:@"tactics_red_highlight"];
            _greenImageView.image = [UIImage imageNamed:@"tactics_green"];
            //隐藏背景动画
            _redBgImageView.hidden = NO;
            _greenBgImageView.hidden = YES;
            
            [self changeAlphaAnimationWithRedAlpha:1 GreenAlpha:0.6];
        }
        else if ([_buyNum floatValue] < [_saleNum floatValue]){
            _redImgTitleLabel.text = @"多头";
            _greenImgTitleLabel.text = @"空头领先";
            
            _redImageView.image = [UIImage imageNamed:@"tactics_red"];
            _greenImageView.image = [UIImage imageNamed:@"tactics_green_highlight"];
            
            _redBgImageView.hidden = YES;
            _greenBgImageView.hidden = NO;
            
            [self changeAlphaAnimationWithRedAlpha:0.6 GreenAlpha:1];
        }
        else{
            _redImgTitleLabel.text = @"多头";
            _greenImgTitleLabel.text = @"空头";
            
            _redImageView.image = [UIImage imageNamed:@"tactics_red"];
            _greenImageView.image = [UIImage imageNamed:@"tactics_green"];
            
            _redBgImageView.hidden = YES;
            _greenBgImageView.hidden = YES;
            
            [self changeAlphaAnimationWithRedAlpha:0.6 GreenAlpha:0.6];
        }
        _redImgLabel.text = _buyNum;
        _greenImgLabel.text = _saleNum;
    }
    
//    [_leftTableView reloadData];
//    [_rightTableView reloadData];
    [self reloadIncome];
}

-(void)reloadIncome{
    
    //持仓百分比
    int   leftSumIncome = 0;
    for (int i = 0; i < _leftArray.count; i++) {
        IndexBuyTacticsModel *model = _leftArray[i];
        if (model.income == nil || [model.income isEqualToString:@"——"] || [model.income isEqualToString:@"0"] || [model.income isEqualToString:@""]) {
            leftSumIncome += 0;
        }
        else{
            leftSumIncome += [model.income floatValue];
        }
    }
    
    int   rightSumIncome = 0;
    for (int i = 0; i < _rightArray.count; i++) {
        IndexBuyTacticsModel *model = _rightArray[i];
        if (model.income == nil || [model.income isEqualToString:@"——"] || [model.income isEqualToString:@"0"] || [model.income isEqualToString:@""]) {
            rightSumIncome += 0;
        }
        else{
            rightSumIncome += [model.income floatValue];
        }
    }
    
    //排序
    NSArray *leftSortedArray = [_leftArray sortedArrayUsingComparator:^NSComparisonResult(IndexBuyTacticsModel *model1, IndexBuyTacticsModel *model2) {
        if ([model1.income intValue] < [model2.income intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];

    NSArray *rightSortedArray = [_rightArray sortedArrayUsingComparator:^NSComparisonResult(IndexBuyTacticsModel *model1, IndexBuyTacticsModel *model2) {
        if ([model1.income intValue] < [model2.income intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];

    _leftArray = [NSMutableArray arrayWithArray:leftSortedArray];
    _rightArray = [NSMutableArray arrayWithArray:rightSortedArray];
    
    
    NSString    *leftSign = @"+";
    NSString    *rightSign = @"+";
    
    _redPercentLabel.textColor = Color_red;
    _greenPercentLabel.textColor = Color_red;
    
    _percentShowRedView.backgroundColor = Color_red;
    _percentShowGreenView.backgroundColor = Color_red;
    
    if (leftSumIncome < 0) {
        leftSign = @"-";
        leftSumIncome = abs(leftSumIncome);
        _redPercentLabel.textColor = Color_green;
        _percentShowRedView.backgroundColor = Color_green;;
    }
    if (rightSumIncome < 0) {
        rightSign = @"-";
        rightSumIncome = abs(rightSumIncome);
        _greenPercentLabel.textColor = Color_green;
        _percentShowGreenView.backgroundColor = Color_green;
    }
    _redPercentLabel.text = [NSString stringWithFormat:@"%@%@%@",leftSign,_productModle.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%d",leftSumIncome] pointNum:0]];
    _greenPercentLabel.text = [NSString stringWithFormat:@"%@%@%@",rightSign,_productModle.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%d",rightSumIncome] pointNum:0]];
    
    //持仓比例
    if (!(leftSumIncome == 0 && rightSumIncome == 0)) {
        float   leftScale = (float)leftSumIncome / (rightSumIncome + leftSumIncome);
        float   rightScale = (float)rightSumIncome / (rightSumIncome + leftSumIncome);
        
        _percentShowRedView.frame = CGRectMake(_percentView.frame.size.width/7*3-(_leftTableView.frame.size.width * leftScale),
                                               _percentShowRedView.frame.origin.y,
                                               _leftTableView.frame.size.width * leftScale -5,
                                               _percentShowRedView.frame.size.height);
        _percentShowGreenView.frame = CGRectMake(_percentView.frame.size.width/7*4 + 5,
                                                 _percentShowGreenView.frame.origin.y,
                                                 _rightTableView.frame.size.width * rightScale,
                                                 _percentShowGreenView.frame.size.height);
    }
    
    if (_leftArray.count < 5) {
        NSInteger leftCount = 5 - _leftArray.count;
        for (NSInteger i = 0; i < leftCount; i++) {
            IndexBuyTacticsModel    *defaultModel = [[IndexBuyTacticsModel alloc]init];
            defaultModel.hands = @"尚无持仓";
            defaultModel.headPic = @"";
            defaultModel.nickName = @"";
            defaultModel.price = @"";
            defaultModel.priceSum = @"";
            defaultModel.userID = @"";
            defaultModel.income = @"";
            [_leftArray addObject:defaultModel];
        }
    }
    
    if (_rightArray.count < 5) {
        NSInteger rightCount = 5 - _rightArray.count;
        for (int i = 0; i < rightCount; i++) {
            IndexBuyTacticsModel    *defaultModel = [[IndexBuyTacticsModel alloc]init];
            defaultModel.hands = @"尚无持仓";
            defaultModel.headPic = @"";
            defaultModel.nickName = @"";
            defaultModel.price = @"";
            defaultModel.priceSum = @"";
            defaultModel.userID = @"";
            defaultModel.income = @"";
            [_rightArray addObject:defaultModel];
        }
    }
    
    if (_leftArray.count >= 5 && _rightArray.count >= 5) {
        _leftResultArray = [NSMutableArray arrayWithArray:_leftArray];
        _righResultArray = [NSMutableArray arrayWithArray:_rightArray];
        //排序
        [_leftTableView reloadData];
        [_rightTableView reloadData];
        
        [self reloadHeaderView];
    }
    
    
}

-(void)reloadHeaderView{
    
    NSMutableArray *leftArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *rightArray = [NSMutableArray arrayWithCapacity:0];
    //去重
    for (int i = 0; i < _leftArray.count; i++) {
        IndexBuyTacticsModel    *model = _leftArray[i];
        BOOL    isAgain = NO;
        for (int j = 0; j < leftArray.count; j++) {
            IndexBuyTacticsModel    *leftModel = leftArray[j];
            if ([model.userID isEqualToString:leftModel.userID]) {
                isAgain = YES;
            }
        }
        if (!isAgain) {
            if (model != nil) {
                [leftArray addObject:model];
            }
        }
        else{
            isAgain = NO;
        }
    }
    
    for (int i = 0; i < _rightArray.count; i++) {
        IndexBuyTacticsModel    *model = _rightArray[i];
        BOOL    isAgain = NO;
        for (int j = 0; j < rightArray.count; j++) {
            IndexBuyTacticsModel    *rightModel = rightArray[j];
            if ([model.userID isEqualToString:rightModel.userID]) {
                isAgain = YES;
            }
        }
        if (!isAgain) {
            if (model != nil) {
                [rightArray addObject:model];
            }
        }
        else{
            isAgain = NO;
        }
    }
    
    if (leftArray != nil && leftArray.count != 0) {
        for (int i = 0; i < leftArray.count; i++) {
            IndexBuyTacticsModel    *model = leftArray[i];
            UIImageView *headerImageView = [_leftHeaderView viewWithTag:LEFT_IMAGE_TAG + i];
            if ([DataUsedEngine nullTrim:model.headPic] && ![model.hands isEqualToString:@"尚无持仓"]) {
                [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headPic]] placeholderImage:[UIImage imageNamed:@"head_01"]];
            }
        }
    }
    
    if (rightArray != nil && rightArray.count != 0) {
        for (int i = 0; i < rightArray.count; i++) {
            IndexBuyTacticsModel    *model = rightArray[i];
            UIImageView *headerImageView = [_rightHeaderView viewWithTag:RIGHT_IMAGE_TAG + i];
            if ([DataUsedEngine nullTrim:model.headPic] && ![model.hands isEqualToString:@"尚无持仓"]) {
                [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headPic]] placeholderImage:[UIImage imageNamed:@"head_01"]];
            }
        }
    }
}

#pragma mark animation

-(void)changeAlphaAnimationWithRedAlpha:(float)redAlpha GreenAlpha:(float)greenAlpha{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _redImageView.alpha = redAlpha;
        _greenImageView.alpha = greenAlpha;
        _greenCoverBgView.alpha = greenAlpha;
        _redCoverBgView.alpha = redAlpha;
    } completion:^(BOOL finished) {
        
    }];
}

//旋转动画
-(void)loadSpinAnimation{
    [UIView animateWithDuration:0.4 delay:3 options:UIViewAnimationOptionCurveLinear animations:^{
        _redImageView.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0f));
        _greenImageView.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0f));
    } completion:^(BOOL finished) {
        [self spinRestoreAnimation];
    }];
}

-(void)spinRestoreAnimation{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _redImageView.transform = CGAffineTransformMakeRotation(0 * (M_PI / 180.0f));
        _greenImageView.transform = CGAffineTransformMakeRotation(0 * (M_PI / 180.0f));
    } completion:^(BOOL finished) {
        [self loadSpinAnimation];
    }];
}

-(void)loadAnimation{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (!_redBgImageView.hidden) {
            _redBgImageView.bounds = CGRectMake(0, 0, _redImageView.frame.size.width+12/375.0*ScreenWidth, _redImageView.frame.size.height+12/375.0*ScreenWidth);
        }
        
        if (!_greenBgImageView.hidden) {
            _greenBgImageView.bounds = CGRectMake(0, 0, _greenImageView.frame.size.width+12/375.0*ScreenWidth, _greenImageView.frame.size.height+12/375.0*ScreenWidth);
        }
    } completion:^(BOOL finished) {
        if (self != nil) {
            [self loadAnimationAgain];
        }
    }];
}

-(void)loadAnimationAgain{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (!_redBgImageView.hidden) {
            _redBgImageView.bounds = CGRectMake(0, 0, _redImageView.frame.size.width+22/375.0*ScreenWidth, _redImageView.frame.size.height+22/375.0*ScreenWidth);
        }
        
        if (!_greenBgImageView.hidden) {
            _greenBgImageView.bounds = CGRectMake(0, 0, _greenImageView.frame.size.width+22/375.0*ScreenWidth, _greenImageView.frame.size.height+22/375.0*ScreenWidth);
        }
    } completion:^(BOOL finished) {
        if (self != nil) {
            [self loadAnimation];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
