//
//  PartnerPage.m
//  hs
//
//  Created by PXJ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "PartnerPage.h"
#import "SpreadApplyPage.h"
#import "SpreadPageCell.h"
#import "UserSpreadQR.h"
#import "NetRequest.h"
#import <ShareSDK/ShareSDK.h>
#import "CommissionPage.h"
#import "SpreadUserDetail.h"
#import "H5LinkPage.h"
#import "SpreadCashPage.h"
#import "CommissionExplain.h"


#define topViewHeight     ScreenWidth *180/375
#define dataViewHeight ScreenWidth * 210/375
#define spreadViewHeight ScreenWidth * 190/375
#define textFont     [UIFont systemFontOfSize:12*ScreenWidth/375]
#define control_Tag 3000

#define websiteLab_Tag 4000
#define top_CenterImg_Tag 4100
#define top_moneyLab_Tag 5000
#define top_commisionLab_Tag 5001
#define top_updateTimeLab_Tag 5002
#define data_numLab_Tag 5003 //5003/5004/5005三个
#define data_getMoney_Tag 5006

@interface PartnerPage ()<UIScrollViewDelegate>
{

    NSString *_shareAddress;
    CGFloat _cashMoney;
    NSString * _systemTime;

}
@property(nonatomic,strong)NSDictionary * promoteMsgDic;

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * dataView;
@property (nonatomic,strong)UIView * spreadView;
@end

@implementation PartnerPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    [self requestData];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initNav];
    [self initUI];

}
#pragma mark init初始化
- (void)initData
{
    if (!_shareAddress) {
        
        NSString * tgAddress = @"";
        
#if defined (YQB)
        tgAddress = @"www.100zjgl.com";
#else
        tgAddress = @"www.cainiu.com";
        
#endif
        
        _shareAddress = tgAddress;
    }
    _cashMoney = 0.00;
}
- (void)requestData
{
    [self getPromotionLink];
    [self getPromotionDetail];


}
#pragma mark - 获取分享链接地址
- (void)getPromotionLink
{
    NSString * token = [[CMStoreManager sharedInstance]getUserToken];
    NSDictionary * dic  = @{@"token":token};
    NSString * urlStr = K_promotion_getPromoteId;
    [ManagerHUD  showHUD:self.view animated:YES];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        [ManagerHUD hidenHUD];
        if ([dictionary[@"code"] intValue]==200) {
            
            _shareAddress = dictionary[@"data"];
            [self loadPromoteWebsite];
        }
    } failureBlock:^(NSError *error) {
        [ManagerHUD hidenHUD];
        
    }];
    
}
#pragma mark - 获取推广详细信息
- (void)getPromotionDetail
{
    [RequestDataModel requestPromoteUserMessageSuccessBlock:^(BOOL success, NSDictionary *dictionary) {
        
        [self loadNewData:dictionary];
    
    }];
    
}
- (void)loadNewData:(NSDictionary*)dictionary
{
    __block NSDictionary * dic = dictionary;
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS) {
            _systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            _systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        [self uploadUI:dic];
    }];
    
    
    
}
- (void)uploadUI:(NSDictionary*)dictionary
{
    NSString * centerImgName = [NSString stringWithFormat:@"sLevel4-%@",dictionary[@"promoteLevel"]==nil?@"0":dictionary[@"promoteLevel"]];
    
    UIImageView * centerImgV = (UIImageView*)[_topView viewWithTag:top_CenterImg_Tag];
    centerImgV.image = [UIImage imageNamed:centerImgName];
    
    
    
    UILabel *moneyLab = (UILabel*)[_topView viewWithTag:top_moneyLab_Tag];
    float money;
    if (dictionary[@"commissionsCurDraw"] != nil && ![dictionary[@"commissionsCurDraw"] isKindOfClass:[NSNull class]])
    {
        money= [dictionary[@"commissionsCurDraw"] floatValue];
        _cashMoney = money;
    }else
    {
        money = 0.00;
    }
    if (_cashMoney>=100000) {
        
        NSString * moneyText;
        moneyText = [NSString stringWithFormat:@"%f",money/10000];
        moneyText = [moneyText substringToIndex:moneyText.length-4];
        moneyText = [DataEngine addSign:moneyText];
        moneyText = [NSString stringWithFormat:@"%@万元",moneyText];
        moneyLab.text = moneyText;
    }else{
    
        moneyLab.text = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",money]];
    }
    UILabel * commisionLab = (UILabel *)[_topView viewWithTag:top_commisionLab_Tag];
    CGFloat commision;
    if (dictionary[@"commissionTotal"] != nil && ![dictionary[@"commissionTotal"] isKindOfClass:[NSNull class]])
    {
        commision = [dictionary[@"commissionTotal"] floatValue];
    }else
    {
        commision = 0.00;
    }
    
    if (_cashMoney>=100000) {
        
        NSString * commisionText;
        commisionText = [NSString stringWithFormat:@"%f",money/10000];
        commisionText = [commisionText substringToIndex:commisionText.length-4];
        commisionText = [DataEngine addSign:commisionText];
        commisionText = [NSString stringWithFormat:@"￥%@万元",commisionText];
        commisionLab.text = commisionText;
    }else{
        
        commisionLab.text = [DataEngine addSign:[NSString stringWithFormat:@"￥%.2f",commision]];
        
    }
    
    
    UILabel * updateTimeLab =(UILabel *)[_topView viewWithTag:top_updateTimeLab_Tag];
    NSString * updateTime;
    if (dictionary[@"lastModifyTime"] != nil && ![dictionary[@"lastModifyTime"] isKindOfClass:[NSNull class]]&&![dictionary[@"lastModifyTime"] isEqualToString:@""])
    {
        NSString * timerStr = dictionary[@"lastModifyTime"];
        timerStr = [self timetransform:timerStr];
        NSArray * timerArray = [timerStr componentsSeparatedByString:@" "];
        NSArray * subTimeArray = [timerArray[1] componentsSeparatedByString:@":"];
        updateTime = [NSString stringWithFormat:@"统计更新时间 %@ %@时%@分",timerArray[0],subTimeArray[0],subTimeArray[1]];
        updateTimeLab.hidden = NO;
    }else
    {
        updateTime = @"更新统计时间--:-- ";
        updateTimeLab.hidden = YES;
    }
    updateTimeLab.text = updateTime;
    
    
    
    
    UILabel * registCountLab = (UILabel *)[_dataView viewWithTag:data_numLab_Tag+0];
    NSString * registCount;
    if (dictionary[@"registCount"] != nil && ![dictionary[@"registCount"] isKindOfClass:[NSNull class]])
    {
        registCount = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",[dictionary[@"registCount"] intValue]]];
    }else
    {
        registCount = @"0";
    }
    registCountLab.text = registCount;
    
    
  
    UILabel * consumerCountLab = (UILabel *)[_dataView viewWithTag:data_numLab_Tag+1];
    NSString * consumerCount;
    
    if (dictionary[@"consumerCount"] != nil && ![dictionary[@"consumerCount"] isKindOfClass:[NSNull class]])
    {
        consumerCount = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",[dictionary[@"consumerCount"] intValue]]];
    }else
    {
        consumerCount = @"0";
    }
    consumerCountLab.text = consumerCount;
    
    
    
    
    UILabel * consumerHandSumLab = (UILabel *)[_dataView viewWithTag:data_numLab_Tag+2];
    
    NSString *  consumerHandSum;
    
    if (dictionary[@"consumerHandSum"] != nil && ![dictionary[@"consumerHandSum"] isKindOfClass:[NSNull class]])
    {
        consumerHandSum = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",[dictionary[@"consumerHandSum"] intValue]]];
    }else
    {
        consumerHandSum = @"0";
    }
    consumerHandSumLab.text = consumerHandSum;
    UIButton * getMoneyBtn = (UIButton *)[_dataView viewWithTag:data_getMoney_Tag];
    int enableClick;
    if (dictionary[@"canDraw"] != nil && ![dictionary[@"canDraw"] isKindOfClass:[NSNull class]])
    {
        enableClick =[dictionary[@"canDraw"] intValue];
    }else
    {
        enableClick  = 1;
    }

    if (enableClick==0&&money>=100 ) {
        getMoneyBtn.backgroundColor = K_color_red;
        getMoneyBtn.enabled = YES;
    }else{
        getMoneyBtn.backgroundColor =  K_COLOR_CUSTEM(193, 193, 193, 1);
        getMoneyBtn.enabled = NO;
    }
}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = [NSString stringWithFormat:@"%@合伙人",App_appShortName];
    [nav.leftControl addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    nav.rightLab.text = @"赚钱说明";
    [nav.rightControl addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];

}
- (void)initUI
{
    UIScrollView * backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    backScrollView.delegate = self;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth, topViewHeight+dataViewHeight+spreadViewHeight);
    [self.view addSubview:backScrollView];


    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    [backScrollView addSubview:_topView];
    _dataView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, dataViewHeight)];
    [backScrollView addSubview:_dataView];
    _spreadView = [[UIView alloc] initWithFrame:CGRectMake(0, dataViewHeight+topViewHeight, ScreenWidth, spreadViewHeight)];
    [backScrollView addSubview:_spreadView];

    UIImageView * topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*141/750)];
    topImgV.image = [UIImage imageNamed:@"spread_5"];
    [_topView addSubview:topImgV];
    [self initTopViewUI];
    [self initDataViewUI];
    [self initSpreadViewUI];
}
- (void)initTopViewUI
{
    
    UIImageView * topCenterImgV = [[UIImageView alloc] init];
    topCenterImgV.tag = top_CenterImg_Tag;
    topCenterImgV.center = CGPointMake(ScreenWidth/2, ScreenWidth*187*0.25/375);
    topCenterImgV.bounds = CGRectMake(0, 0, ScreenWidth*247*0.5/375, ScreenWidth*157*0.5/375);
    topCenterImgV.image = [UIImage imageNamed:@"sLevel4-0"];
    [_topView addSubview:topCenterImgV];
    
    UILabel * moneyToplab = [[UILabel alloc] initWithFrame:CGRectMake(30,90*ScreenWidth/375, ScreenWidth-60, 15*ScreenWidth/375)];
    moneyToplab.textColor = K_color_grayBlack;
    moneyToplab.text = @"可转佣金";
    moneyToplab.font = textFont;
    [_topView addSubview:moneyToplab];
    CGFloat topLabLength = [Helper calculateTheHightOfText:moneyToplab.text height:20 font:textFont];
  
    
    UILabel * lookLab = [[UILabel alloc] initWithFrame:CGRectMake(35+topLabLength, moneyToplab.frame.origin.y , topLabLength+5, 15*ScreenWidth/375)];
    lookLab.text = @"查看流水";
    lookLab.backgroundColor = K_color_red;
    lookLab.textAlignment = NSTextAlignmentCenter;
    lookLab.font = textFont;
    lookLab.textColor = [UIColor whiteColor];
    lookLab.layer.cornerRadius = 2;
    lookLab.layer.masksToBounds = YES;
    [_topView addSubview:lookLab];
    
    UIButton * lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.center = lookLab.center;
    lookBtn.bounds = CGRectMake(0, 0, topLabLength, 44);
    [lookBtn addTarget:self action:@selector(goLookMessage) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:lookBtn];
    
    UILabel * markLab = [[UILabel alloc] initWithFrame:CGRectMake(30, moneyToplab.frame.origin.y+moneyToplab.frame.size.height, 20, 20)];
    markLab.textColor = K_color_red;
    markLab.font = [UIFont systemFontOfSize:18];
    markLab.text = @"￥";
    [_topView addSubview:markLab];
    
    UILabel * moneyLab  = [[UILabel alloc] initWithFrame:CGRectMake(50, markLab.frame.origin.y, ScreenWidth/2, ScreenWidth*40/375)];
    moneyLab.textColor  = K_color_red;
    moneyLab.font       = [UIFont systemFontOfSize:35];
    moneyLab.tag        = top_moneyLab_Tag;
    moneyLab.text       = @"0.00";
    [_topView addSubview:moneyLab];
    
    UILabel * historyTopLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+50, markLab.frame.origin.y, ScreenWidth/2-80, 20*ScreenWidth/375)];
    historyTopLab.text = @"累计佣金";
    historyTopLab.textAlignment = NSTextAlignmentRight;
    historyTopLab.textColor = K_color_grayBlack;
    historyTopLab.font = textFont;
    [_topView addSubview:historyTopLab];
    
    UILabel *commisionLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+50, historyTopLab.frame.origin.y+historyTopLab.frame.size.height, ScreenWidth/2-80, 20*ScreenWidth/375)];
    commisionLab.textAlignment = NSTextAlignmentRight;
    commisionLab.text = @"￥0.00";
    commisionLab.textColor = K_color_grayBlack;
    commisionLab.tag = top_commisionLab_Tag;
    commisionLab.font = textFont;
    [_topView addSubview:commisionLab];
    
    UILabel * updateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(30,moneyLab.frame.size.height+moneyLab.frame.origin.y+10 , ScreenWidth-60, 10)];
    updateTimeLab.text = @"更新统计时间 23点58分";
    updateTimeLab.font = [UIFont systemFontOfSize:9];
    updateTimeLab.tag = top_updateTimeLab_Tag;
    updateTimeLab.textColor = K_color_grayBlack;
    [_topView addSubview:updateTimeLab];
    

}
- (void)initDataViewUI
{
    
    
    UILabel * dataTopLine = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 0.5)];
    dataTopLine.backgroundColor = K_color_gray;
    [_dataView addSubview:dataTopLine];
    
    
    
    UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(20, _dataView.frame.size.height-1, ScreenWidth-40, 0.5)];
    bottomLine.backgroundColor = K_color_gray;
    [_dataView addSubview:bottomLine];
    
    
    UIImageView * registMark = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15*ScreenWidth/375, 26*ScreenWidth/375, 17*ScreenWidth/375)];
    registMark.image = [UIImage imageNamed:@"spread_6"];
    [_dataView addSubview:registMark];
    
    
    UILabel * registMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 15*ScreenWidth/375, 26*ScreenWidth/375, 13*ScreenWidth/375)];
    registMarkLab.text = @"明细";
    registMarkLab.textColor = [UIColor whiteColor];
    registMarkLab.textAlignment = NSTextAlignmentCenter;
    registMarkLab.font = [UIFont systemFontOfSize:10*ScreenWidth/375];
    [_dataView addSubview:registMarkLab];
    
    NSArray * titleArray = @[@"注册用户数",@"累计交易用户数",@" 累计交易手数"];
    CGFloat length = (ScreenWidth-60)/3.0;
    for (int i=0; i<titleArray.count; i++) {
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30+i*length, 30*ScreenWidth/375, length-1, 15*ScreenWidth/375)];
        titleLab.text = titleArray[i];
        titleLab.textColor = K_color_grayBlack;
        titleLab.font = textFont;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_dataView addSubview:titleLab];
        
        UILabel * numLab = [[UILabel alloc] initWithFrame:CGRectMake(30+i*length, 45*ScreenWidth/375, length-1, 15*ScreenWidth/375)];
        numLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        numLab.font = textFont;
        numLab.tag = data_numLab_Tag+i;
        numLab.text = @"0";
        numLab.textAlignment = NSTextAlignmentCenter;
        [_dataView addSubview:numLab];
        if (i!=0) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x-1, titleLab.frame.origin.y-5, 0.5, 40*ScreenWidth/375)];
            lineView.backgroundColor = K_color_gray;
            [_dataView addSubview:lineView];
        }
        
        
    }
    UIButton * lookOffLine = [UIButton buttonWithType:UIButtonTypeCustom];
    lookOffLine.frame = CGRectMake(30, 15*ScreenWidth/375, length, 50*ScreenWidth/375);
    lookOffLine.tag = control_Tag+4;
    [lookOffLine addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dataView addSubview:lookOffLine];
    
    
    
    
    UIButton * getMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getMoneyBtn.backgroundColor = K_COLOR_CUSTEM(193, 193, 193, 1);
    getMoneyBtn.enabled = NO;
    getMoneyBtn.tag = data_getMoney_Tag;
    getMoneyBtn.frame = CGRectMake(75*ScreenWidth/375, 90*ScreenWidth/375, 225*ScreenWidth/375, 44*ScreenWidth/375);
    getMoneyBtn.layer.cornerRadius = 4;
    getMoneyBtn.layer.masksToBounds = YES;
    [getMoneyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [getMoneyBtn setTitle:[NSString stringWithFormat:@"申请转入%@账户",App_appShortName] forState:UIControlStateNormal];
    [getMoneyBtn addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [getMoneyBtn setBackgroundImage:[UIImage imageNamed:@"choose_select_on"] forState:UIControlStateHighlighted];
    [_dataView addSubview:getMoneyBtn];
    
    UILabel * detailLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 155*ScreenWidth/375, ScreenWidth-60, 15*ScreenWidth/375)];
    detailLab.text = @"详情请登录商户后台";
    detailLab.textColor = K_color_grayBlack;
    detailLab.font = textFont;
    detailLab.textAlignment = NSTextAlignmentCenter;
    [_dataView addSubview:detailLab];
    UILabel * webLab = [[UILabel alloc] initWithFrame:CGRectMake(30, detailLab.frame.size.height+ detailLab.frame.origin.y, ScreenWidth-60, 20*ScreenWidth/375)];
NSString * tgAddress = @"";
    
#if defined (YQB)
    tgAddress = @"tg.100zjgl.com";
#else
    tgAddress = @"tg.cainiu.com";
    
#endif
    webLab.text = tgAddress;
    webLab.textColor = K_color_red;
    webLab.textAlignment  = NSTextAlignmentCenter;
    webLab.font = [UIFont systemFontOfSize:17*ScreenWidth/375] ;
    [_dataView addSubview:webLab];
    
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(75,  150*ScreenWidth/375, ScreenWidth-150, 44*ScreenWidth/375)];
    [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    control.alpha = 0.3;
    control.tag = control_Tag;
    [_dataView addSubview:control];
    
}
- (void)initSpreadViewUI
{
    UILabel * typeOneLab = [[UILabel alloc] init];
    typeOneLab.center = CGPointMake(ScreenWidth/2, 25*ScreenWidth/375);
    typeOneLab.bounds = CGRectMake(0, 0, 60*ScreenWidth/375, 18*ScreenWidth/375);
    typeOneLab.font = textFont;
    typeOneLab.backgroundColor = K_color_red;
    typeOneLab.textColor = [UIColor whiteColor];
    typeOneLab.layer.cornerRadius = 2;
    typeOneLab.layer.masksToBounds = YES;
    typeOneLab.text = @"方式一";
    typeOneLab.textAlignment = NSTextAlignmentCenter;
    [_spreadView addSubview:typeOneLab];
   
    UILabel * pasteLab = [[UILabel alloc] initWithFrame:CGRectMake(30, typeOneLab.frame.size.height+typeOneLab.frame.origin.y+10, ScreenWidth-60, 15*ScreenWidth/375)];
    pasteLab.text = @"选择复制链接分享给好友";
    pasteLab.textColor = K_color_black;
    pasteLab.font = textFont;
    pasteLab.textAlignment = NSTextAlignmentCenter;
    [_spreadView addSubview:pasteLab];
    
    UILabel * websiteLab = [[UILabel alloc] initWithFrame:CGRectMake(30, pasteLab.frame.size.height+pasteLab.frame.origin.y, ScreenWidth-60, 20*ScreenWidth/375)];
    websiteLab.tag = websiteLab_Tag;
    NSMutableAttributedString *str  = [[NSMutableAttributedString alloc] initWithString:_shareAddress];
    NSRange strRange                = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    websiteLab.attributedText = str;
    websiteLab.textColor = K_color_gray;
    websiteLab.font = [UIFont systemFontOfSize:13];
    websiteLab.textAlignment = NSTextAlignmentCenter;
    [_spreadView addSubview:websiteLab];
   
    
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(30, pasteLab.frame.origin.y-5, ScreenWidth-60, 44*ScreenWidth/375)];
    control.alpha = 0.3;
    [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    control.tag = control_Tag+1;
    [_spreadView addSubview:control];
    
    
    
    UILabel * typeSecondLab = [[UILabel alloc] init];
    typeSecondLab.center        = CGPointMake(20+(ScreenWidth-40)/4 ,websiteLab.frame.size.height+websiteLab.frame.origin.y+20);
    typeSecondLab.textColor     = [UIColor whiteColor];
    typeSecondLab.bounds        = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*18/375);
    typeSecondLab.backgroundColor = K_color_red;
    typeSecondLab.text               = @"方式二";
    typeSecondLab.font               = textFont;
    typeSecondLab.textAlignment      = NSTextAlignmentCenter;
    typeSecondLab.layer.cornerRadius = 2;
    typeSecondLab.layer.masksToBounds = YES;
    [_spreadView addSubview:typeSecondLab];
    
    
    
    UILabel * typeThreeLab = [[UILabel alloc] init];
    
    typeThreeLab.text             = @"方式三";
    typeThreeLab.font             = textFont;
    typeThreeLab.center           = CGPointMake(20+(ScreenWidth-40)*3/4, typeSecondLab.center.y);
    typeThreeLab.bounds           = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*18/375);
    typeThreeLab.backgroundColor  = K_color_red;
    typeThreeLab.textColor        = [UIColor whiteColor];
    typeThreeLab.textAlignment    = NSTextAlignmentCenter;
    typeThreeLab.layer.cornerRadius = 2;
    typeThreeLab.layer.masksToBounds = YES;
    [_spreadView addSubview:typeThreeLab];
    
    CGFloat clickBtnLength =ScreenWidth*55/375;
    UIButton * spreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    spreadBtn.tag = control_Tag+2;
    [spreadBtn addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    spreadBtn.center        = CGPointMake(typeSecondLab.center.x, typeSecondLab.center.y+ScreenWidth*50/375);
    spreadBtn.bounds        = CGRectMake(0, 0, clickBtnLength, clickBtnLength);
    [spreadBtn setBackgroundImage:[UIImage imageNamed:@"findPage_11"] forState:UIControlStateNormal];
    [_spreadView addSubview:spreadBtn];
    
    UIButton * zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zbarBtn.tag = control_Tag+3;
    [zbarBtn addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    zbarBtn.center   = CGPointMake(typeThreeLab.center.x, typeThreeLab.center.y+ScreenWidth*50/375);
    zbarBtn.bounds   = CGRectMake(0, 0, clickBtnLength, clickBtnLength);
    [zbarBtn setBackgroundImage:[UIImage imageNamed:@"findPage_12"] forState:UIControlStateNormal];
    [_spreadView addSubview:zbarBtn];
}
- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonPressed
{
    //赚钱说明
    
    CommissionExplain * vc =[[CommissionExplain alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)goLookMessage
{
    CommissionPage * commissionVC = [[CommissionPage alloc] init];
    [self.navigationController pushViewController:commissionVC animated:YES];

    

}
- (void)controlClick:(UIControl*)control
{
    
    
    switch (control.tag) {//登录商户后台
        case 3000:
        {
            NSString * tgAddress = @"";
            
#if defined (YQB)
            tgAddress = @"http://tg.100zjgl.com";
#else
            tgAddress = @"http://tg.cainiu.com";
            
#endif
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tgAddress]];
        }
            break;
        case 3001:
        {
            [self pasteLink];//复制链接
        }
            break;
        case 3002:
        {
            [self selectShare];//分享
        }
            break;
        case 3003:
        {
            //点击二维码
            if (_shareAddress.length>21) {
               UserSpreadQR *spreadImageV = [[UserSpreadQR alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) imageUrl:_shareAddress];
                [self.navigationController.view addSubview:spreadImageV];
            }else{
                [self getPromotionLink];
           }
       }
            break;
        case 3004:
        {
            //注册用户明细
            SpreadUserDetail * userDetailVC = [[SpreadUserDetail alloc] init];
            [self.navigationController pushViewController:userDetailVC animated:YES];
        
        }break;
        case data_getMoney_Tag://申请转入财牛账户
        {
            [self transfer];
        }break;
        default:
            break;
    }
    
}

#pragma mark 复制链接
- (void)pasteLink
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =_shareAddress;
    
    [UIEngine showShadowPrompt:@"已添加到剪切板"];
    
    
}
#pragma mark 分享

-(void)selectShare
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:App_shareIconName ofType:@"png"];
    NSString *url = _shareAddress;
    NSString * title  = @"我已经领了50元现金，再送50元给你！";
    NSString * content = [NSString stringWithFormat:@"下载就能赚钱，你不试试看？\n%@",url];
    [PageChangeControl goShareWithTitle:title content:content urlStr:url imagePath:imagePath];

   }

#pragma mark 申请转入财牛账户
- (void)transfer
{
    
    
    
    int num = 0;
    if (num==0) {
        SpreadCashPage  * cashVC = [[SpreadCashPage alloc] init];
        cashVC.cashMoney = _cashMoney;
        [self.navigationController pushViewController:cashVC animated:YES];
  
    }else{
        PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:@"今日提现已到达上限" setBtnTitleArray:@[@"确定"]];
        popView.confirmClick = ^(UIButton * button){};
        [self.navigationController.view addSubview:popView];
    
    
    }
   
}
- (NSString *)timetransform:(NSString*)time
{
    NSArray * dateArray =[time componentsSeparatedByString:@" "];
    NSArray * systemArray = [_systemTime componentsSeparatedByString:@" "];
    NSString * timeStr;
    //    int date= [Helper timeSysTime:_systemTime createTime:time];
    int date = [Helper timeSysDateStr:systemArray[0] createDateStr:dateArray[0]];
    switch (date) {
        case 0:
            timeStr = @"今天";
            break;
        case 1:
            timeStr = @"昨天";
            break;
        default:
            timeStr = dateArray[0];
            break;
    }
    
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSDateFormatter * strFormatter = [[NSDateFormatter alloc] init];
    [strFormatter setDateFormat:@"HH:mm"];
    NSDate * timeDate = [timeFormatter dateFromString:dateArray[1]];
    NSString * timeString = [strFormatter stringFromDate:timeDate];
    
    NSString * showTime = [NSString stringWithFormat:@"%@ %@",timeStr,timeString];
    return showTime;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y>=topViewHeight+dataViewHeight+spreadViewHeight-ScreenHeigth+64) {
        scrollView.contentOffset = CGPointMake(0, topViewHeight+dataViewHeight+spreadViewHeight-ScreenHeigth+64);
    }

}

- (void)loadPromoteWebsite
{
    
    UIImage * clickImage =  [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:_shareAddress] withSize:250.0f];
    UIImage * centerImage = [UIImage imageNamed:@"findPage_14"];
    
    clickImage = [self addImage:centerImage toImage:clickImage];

    UIButton * button = (UIButton *)[_spreadView viewWithTag:control_Tag+3];
    [button setBackgroundImage:clickImage forState:UIControlStateNormal];
    
    
    
    UILabel * websiteLab = (UILabel *)[_spreadView viewWithTag:websiteLab_Tag];
    NSMutableAttributedString *str  = [[NSMutableAttributedString alloc] initWithString:_shareAddress];
    NSRange strRange                = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    websiteLab.attributedText = str;



}
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    CGFloat  length = image2.size.width;
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, length, length)];
    
    // Draw image2
    [image1 drawInRect:CGRectMake(length*3/8, length*3/8, length/4, length/4)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - InterpolatedUIImage=因为生成的二维码是一个CIImage，我们直接转换成UIImage的话大小不好控制，所以使用下面方法返回需要大小的UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator--首先是二维码的生成，使用CIFilter很简单，直接传入生成二维码的字符串即可
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
