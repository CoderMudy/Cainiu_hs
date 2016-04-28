//
//  IndexViewController.m
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexBuyView.h"
#import "IndexPositionView.h"
#import "IndexSaleRecordPage.h"
#import "IndexOrderController.h"
#import "FoyerProductModel.h"
#import "IndexQuickOrderController.h"
#import "Utility.h"
#import "MoneyDetaillViewController.h"
#import "AsyncSocket.h"
#import "LPSocket.h"
#import "IndexBuyTacticsView.h"
#import "NetRequest.h"
#import "SpotIndexViewController.h"
#import "IndexAgreementPage.h"
#import "MyCashOrderPage.h"//现货订单
#import "CashPositionView.h"//现货持仓
#import "PlayDescriptionController.h"
#import "AccountH5Page.h"
#import "TradeRulesView.h"
#import "RegViewController.h"
#import "RegistRedBagView.h"

#define KEY @"cainiu_luckin"

@interface IndexViewController ()
{
    /**
     *  Title
     */
    UILabel             *_titleLab;
    
    UIScrollView        *_indexScrollView;
    AsyncSocket         *_socket;
    
    IndexBuyView        *_indexBuyV;
    CashPositionView    *_cashPositionV;
    //缓存名称
    NSString            *_infoArrayName;
    
    //是否打开快速下单
    BOOL                isOpenQuickOrder;
    
    BOOL                isOpen;
    //引导
    UIImageView         *guide_OneImg;
    UIImageView         *guide_TwoImg;
    UIImageView         *guide_ThreeImg;
    UIImageView         *guide_FourImg;
    UIView              *guideView;
    UIImageView         *guide_FiveImg;
    
    NSMutableArray      *couPonQuickArray;
    BOOL                isXH;
    
    //交易规则
    TradeRulesView      *_tradeRulesView;
}
@property (nonatomic,strong)IndexPositionView *indexPositionV;
@end



@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self loadNav];
    
    [self loadUI];
    
    [self loadNotification];
    
    [self loadSocket];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    /**
     *  刷新头部是否显示登录、可用金额等
     */
    [self reloadUIAndData];
    /**
     *  头部刷新后，再判断是否需要加载引导页，因为涉及到登录、注册
     */
    if ( !self.productModel.isXH) {
        [self isLoingMethod];
        if ([[CMStoreManager sharedInstance] isLogin]) {
            [self requestPositionData];
        }
    }
    else
    {
        if ([[CMStoreManager sharedInstance] isLogin]&&![[SpotgoodsAccount sharedInstance] isNeedLogin]) {
            [self requestPositionData];
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //关闭实时策略
    [self closeTactics];
    if (!self.productModel.isXH) {
        [_indexPositionV pageDisAppear];
    }
}

-(void)loadNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segValueChange) name:kSegValueChange object:nil];//跳转持仓
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disConToConnection) name:kDisConToConnection object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeConnection) name:kCloseConnection object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPositionData) name:kOrderSuccess object:nil];//下单成功刷新持仓收益
}

#pragma mark - 行情界面的新手引导页
- (void)isLoingMethod
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if ([cacheModel.isOrLogin isEqualToString:@"YES"])
    {
        
        guideView = [[UIView alloc]init];
        guideView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        guideView.backgroundColor = [UIColor blackColor];
        guideView.alpha = 0.7;
        guideView.userInteractionEnabled = YES;
        [self.view addSubview:guideView];
        
        guide_OneImg = [[UIImageView alloc]init];
        guide_OneImg.userInteractionEnabled = YES;
        guide_OneImg.image = [UIImage imageNamed:@"order_guide_1"];
        guide_OneImg.frame = CGRectMake(ScreenWidth - 55*0.9*ScreenWidth/320 - 25, 70*ScreenWidth/320, 55*0.9*ScreenWidth/320 , 74*0.9*ScreenWidth/320);
        [self.view addSubview:guide_OneImg];
        
        guide_TwoImg = [[UIImageView alloc]init];
        guide_TwoImg.image = [UIImage imageNamed:@"order_guide_2"];
        guide_TwoImg.frame = CGRectMake(10, ScreenHeigth-45*ScreenWidth/320 - 204*0.9*ScreenWidth/320 ,156*0.9*ScreenWidth/320 , 204*0.9*ScreenWidth/320);
        guide_TwoImg.userInteractionEnabled = YES;
        [self.view addSubview:guide_TwoImg];
        
        guide_ThreeImg = [[UIImageView alloc]init];
        guide_ThreeImg.image = [UIImage imageNamed:@"order_guide_3"];
        guide_ThreeImg.frame = CGRectMake(CGRectGetMaxX(guide_TwoImg.frame) + 25, CGRectGetMinY(guide_TwoImg.frame), 156*0.9*ScreenWidth/320 , 204*0.9*ScreenWidth/320);
        guide_ThreeImg.userInteractionEnabled = YES;
        [self.view addSubview:guide_ThreeImg];
        
        guide_FourImg = [[UIImageView alloc]init];
        guide_FourImg.image = [UIImage imageNamed:@"order_guide_4"];
        guide_FourImg.frame = CGRectMake(ScreenWidth/2 - 100*ScreenWidth/320/2, CGRectGetMinY(guide_TwoImg.frame) - 23*ScreenWidth/320 - 20 , 100*ScreenWidth/320, 23*ScreenWidth/320);
        guide_FourImg.userInteractionEnabled = YES;
        [self.view addSubview:guide_FourImg];
        
        guide_FiveImg = [[UIImageView alloc]init];
        guide_FiveImg.image = [UIImage imageNamed:@"order_guide_7"];
        guide_FiveImg.frame = CGRectMake(ScreenWidth/2 - (140*ScreenWidth/320.0)/2, 64 - 6.0/480*ScreenHeigth , 140*ScreenWidth/320.0, (140*ScreenWidth/320.0)*(304.0/400));
        guide_FiveImg.userInteractionEnabled = YES;
        [self.view addSubview:guide_FiveImg];
        
        UITapGestureRecognizer *guideViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        UITapGestureRecognizer *guide_OneImgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        UITapGestureRecognizer *guide_TwoImgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        UITapGestureRecognizer *guide_ThreeImgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        UITapGestureRecognizer *guide_FourImgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        UITapGestureRecognizer *guide_FiveImgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [guideView addGestureRecognizer:guideViewGes];
        [guide_OneImg addGestureRecognizer:guide_OneImgGes];
        [guide_TwoImg addGestureRecognizer:guide_TwoImgGes];
        [guide_ThreeImg addGestureRecognizer:guide_ThreeImgGes];
        [guide_FourImg addGestureRecognizer:guide_FourImgGes];
        [guide_FiveImg addGestureRecognizer:guide_FiveImgGes];
    }
    
}

#pragma mark 新手引导

- (void)editPortrait
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.isOrLogin = @"NO";
    [CacheEngine setCacheInfo:cacheModel];
        
    [guideView removeFromSuperview];
    [guide_OneImg removeFromSuperview];
    [guide_TwoImg removeFromSuperview];
    [guide_ThreeImg removeFromSuperview];
    [guide_FourImg removeFromSuperview];
    [guide_FiveImg removeFromSuperview];
}

#pragma mark Data

-(void)loadData{
    
    self.isSecondJump = NO;
    isOpenQuickOrder = NO;
    
    if (self.code.length > 2) {
        _infoArrayName = [NSString stringWithFormat:@"%@InfoArray",[self.code substringToIndex:2]];
    }
    else{
        _infoArrayName = self.code;
    }
    
    isOpen = NO;
    
    //配置缓存路径
    NSString *tradeDicName = @"";
    
    if (self.code != nil) {
        if ([self.productModel.loddyType isEqualToString:@"1"]) {
            tradeDicName = [NSString stringWithFormat:@"%@AmountTradeDic",self.code];
        }
        else {
            tradeDicName = [NSString stringWithFormat:@"%@IntegralTradeDic",self.code];
        }
    }
    
    self.productModel.tradeDicName = tradeDicName;
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.tradeDic[tradeDicName][kOrderQuickIsOpen] == nil || [cacheModel.tradeDic[tradeDicName][kOrderQuickIsOpen] isKindOfClass:[NSNull class]] || [cacheModel.tradeDic[tradeDicName][kOrderQuickIsOpen] isEqualToString:@"NO"]) {
        isOpen = NO;
    }
    else if ([cacheModel.tradeDic[tradeDicName][kOrderQuickIsOpen] isEqualToString:@"YES"] ){
        isOpen = YES;
    }
    else{
        isOpen = NO;
    }
    //配置是否现货
    if ([self.productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound) {
        self.productModel.isXH = 1;
        isXH = YES;
    }
    
}

#pragma mark close Socket

- (void)close{
    NSLog(@"退出登录成功");
    [_socket disconnect];
    _socket = nil;
}

#pragma mark 行情

-(void)closeConnection{
    [self close];
}

//断线重连
-(void)disConToConnection{
    
    _socket = nil;
    [self loadSocket];
    
    if (_indexBuyV != nil) {
        [_indexBuyV disConnection];
    }
}

-(void)loadSocket{
    if (_socket != nil) {
        _socket = nil;
    }
    _socket =  [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    //达旺测试ip：192.168.1.88   port：33333
    if (![_socket connectToHost:self.ip onPort:[self.port intValue] error:&error])
    {
        NSLog(@"Socket连接错误: %@", error);
        [self loadSocket];
    }
}

-(NSString *)toJSON:(id)aParam
{
    NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:aParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

//连接服务器成功 代理方法
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //port:33333
//    if (port == [self.port intValue])
//    {
        NSLog(@"已经连接上服务器");
        //        /1/发送登录命令
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *time = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *dic = @{@"userName":@"cainiu",
                              @"timestamp":time,
                              @"sign":[Utility md5:[NSString stringWithFormat:@"cainiu%@newversion",time]],
                              @"type":@"LOGIN",
                              @"futuresType":[self.productModel.instrumentCode uppercaseString],
                              };
    
        NSString *loginMsg = [self toJSON:dic];
        
        NSData *loginData = [loginMsg dataUsingEncoding:NSUTF8StringEncoding];
        
        uint32_t  pkgsize= (uint32_t)loginData.length; // 157
        uint32_t  swapped = ntohl(pkgsize);
        NSData *data1 = [NSData dataWithBytes:&swapped length:sizeof(swapped)];
        
        //总数据
        NSMutableData *totalData = [NSMutableData dataWithData:data1];
        [totalData appendData:loginData];
        
        
        [sock writeData:totalData withTimeout:30 tag:LOGIN_COMMAND];
        
        [sock readDataWithTimeout:-1 tag:LOGIN_COMMAND];
//    }
}

//接收到服务器发回的数据   ,代理方法
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
//    NSLog(@"接收到服务器的数据了");
    
    @autoreleasepool {
        int nlent  = (int)data.length;
        
        int i;
        [data getBytes:&i length:sizeof(i)];
        long nsize = htonl(i);
        
        if ( nsize != (nlent-4) )
        {
            //        NSLog(@"收到的包有问题");
            
            if (nsize < nlent - 4) {
                //            NSLog(@"数据出错影响不大，继续接收");
            }
            else{
                NSLog(@"数据问题影响过大，接收下个包");
                [_socket readDataWithTimeout:-1 tag:0];
                return;
            }
        }
        
        //    nlent  = (int)data.length;
        
        char *szJson  = new char[nsize +1];
        
        
        NSRange range;
        range.length = nsize;
        range.location = 4;
        
        [data getBytes:szJson range:range];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString * jsonString = [[NSString alloc]initWithBytes:szJson length:strlen(szJson) encoding:enc];
        
        if (jsonString == nil || [jsonString isKindOfClass:[NSNull class]] || jsonString.length < 15) {
            jsonString = [NSString stringWithFormat:@"%s",szJson];
        }
        
        delete szJson;
        
        if ([jsonString rangeOfString:@"clientId"].location != NSNotFound) {
            NSLog(@"Socket登录成功");
            NSLog(@"登录信息：\n %@",jsonString);
            [_socket readDataWithTimeout:-1 tag:0];
            return;
        }
        else{
            for (int i = 0; i < jsonString.length; i++) {
                if ([[jsonString substringToIndex:i] rangeOfString:@"}"].location != NSNotFound) {
                    jsonString = [jsonString substringToIndex:i];
                    break;
                }
            }
            
            if ([jsonString rangeOfString:@"code"].location != NSNotFound) {
                jsonString = [jsonString stringByAppendingString:@"}"];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryWithJsonString:jsonString]];
            if (dic != nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSocket_Buy object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSocket_Positon object:nil userInfo:dic];
                
                //如果是实时策略信息(未使用)
                if (dic[@"code"] != nil && [[NSString stringWithFormat:@"%@",dic[@"code"]] length] > 0) {
                    
                }
                else{
                    [self cacheDictionary:dic];
                }
            }
        }
        
        [_socket readDataWithTimeout:-1 tag:0];
    }
    return;
}

-(void)cacheDictionary:(NSMutableDictionary *)aDic{
    
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.socketInfoDic == nil || [cacheModel.socketInfoDic isKindOfClass:[NSNull class]]) {
        cacheModel.socketInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    if (_infoArrayName == nil) {
        _infoArrayName = @"error";
    }
    
    if (cacheModel.socketInfoDic[_infoArrayName] == nil) {
        cacheModel.socketInfoDic[_infoArrayName] = [NSMutableArray arrayWithCapacity:10];
    }
    
    //添加
    [cacheModel.socketInfoDic[_infoArrayName] addObject:aDic];
    //保存10条数据
    if ([cacheModel.socketInfoDic[_infoArrayName] count] > 10) {
        int count = (int)[cacheModel.socketInfoDic[_infoArrayName] count];
        //移除超出10条的
        for (int i = 0; i < count-10; i++) {
            [cacheModel.socketInfoDic[_infoArrayName] removeObjectAtIndex:0];
        }
    }
    //存储
    [CacheEngine setCacheInfo:cacheModel];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"socket json 解析失败：%@",err);
//        return nil;
    }
    return dic;
}

#pragma mark Nav

-(void)loadNav{
    
    self.view.backgroundColor = Color_black;
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    //Left Button
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];
    
    [navView addSubview:leftButton];
    
    //Right Button
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWidth-60, 0, 60, 44);
    [rightButton setTitle:@"订单" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(rightButton.frame.origin.x + 5 , 17, 10, 10)];
    rightImgView.image = [UIImage imageNamed:@"orderlogo_index"];
    rightImgView.userInteractionEnabled = YES;
    [navView addSubview:rightImgView];
    
    NSString    *str = [NSString stringWithFormat:@"%@  %@",self.name,self.code];
    Self_AddNavTitle(str);
    _titleLab = titleLab;
}

-(void)leftButtonClick{
    
    if (self.isSecondJump) {
        /**
         *  持仓跳转行情
         */
        self.isSecondJump = NO;
        if (isXH) {
            _cashPositionV.frame = CGRectMake(ScreenWidth, _cashPositionV.frame.origin.y, _cashPositionV.frame.size.width, _cashPositionV.frame.size.height);
        }else{
            _indexPositionV.frame = CGRectMake(ScreenWidth, _indexPositionV.frame.origin.y, _indexPositionV.frame.size.width, _indexPositionV.frame.size.height);
            [_indexPositionV requestListData];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        
        [_indexBuyV end];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:_indexBuyV name:kSocket_Buy object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:_indexPositionV name:kSocket_Positon object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kDisConToConnection object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kCloseConnection object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSegValueChange object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderSuccess object:nil];
        
        [self close];
        [[UIEngine sharedInstance]hideProgress];
        if(isXH){
            [_cashPositionV close];
        }
    }
}

#pragma mark 去南交所登录

-(BOOL)spotgoodsLoginResolve{
    if ([[SpotgoodsAccount sharedInstance] isNeedLogin]) {
        IndexViewController *indexVC = self;
    
        NSString * message = @"激活";
        __block int  status = 1;
        if ([[CMStoreManager sharedInstance] getAccountNanJSStatus]) {
            message = @"登录";
            status = 2;
        }
        NSString * title = [NSString stringWithFormat:@"请先%@现货账户",message];
        NSString * btnTitle =  [NSString stringWithFormat:@"去%@",message];
        [[UIEngine sharedInstance]showAlertWithTitle:title ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:            btnTitle];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            if (aIndex == 10087) {
                [indexVC spotgoodsLogin:status];
            }
        };
        return NO;
    }
    else{
        return YES;
    }
}

-(void)spotgoodsLogin:(int)status{
    Go_SouthExchange_Login;
    spotgoodsController.status = status;
}

#pragma mark 结算

-(void)rightNavClick{
    
    if ([[CMStoreManager sharedInstance] isLogin]) {
        if (isXH) {
            if ([self spotgoodsLoginResolve]) {
                MyCashOrderPage *myCashPage = [[MyCashOrderPage alloc]init];
                myCashPage.productModel = self.productModel;
                myCashPage.myCashOrderStyle = MyCashOrderViewSuccess;
                if ([self.navigationController.viewControllers.lastObject isKindOfClass:[self class]]) {
                    [self.navigationController pushViewController:myCashPage animated:YES];
                }
            }
        }else{
            IndexSaleRecordPage * indexSaleRecordVC = [[IndexSaleRecordPage alloc] init];
            indexSaleRecordVC.indexSaleRecordType = IndexSaleRecordTypeEnd;
            indexSaleRecordVC.productModel = _productModel;
            if ([self.navigationController.viewControllers.lastObject isKindOfClass:[self class]]) {
                [self.navigationController pushViewController:indexSaleRecordVC animated:YES];
            }
        }
    }
    else{
        [self login];
    }
}

#pragma mark Seg
-(void)segClick:(UISegmentedControl *)seg{

}

#pragma 关闭实时策略
-(void)closeTactics{
    
    for (int i = 0; i < _indexBuyV.subviews.count; i++) {
        if ([_indexBuyV.subviews[i] isKindOfClass:[IndexBuyTacticsView class]]) {
            IndexBuyTacticsView *tacticsView = (IndexBuyTacticsView *)_indexBuyV.subviews[i];
            [tacticsView otherClose];
        }
    }
}

#pragma mark UI

-(void)loadUI{
    [self loadScrollView];
    /**
     *  登录
     */
    [self loadLoginUI];
}

-(void)login{
    [[UIEngine sharedInstance] showAlertWithTitle:@"请先登录"
                                     ButtonNumber:2
                                 FirstButtonTitle:@"返回"
                                SecondButtonTitle:@"登录"];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        if (aIndex == 10087) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.isOtherFutures       = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        _indexScrollView.contentOffset   = CGPointMake(0, 0);
    };
}

-(void)loadScrollView{
    float  spPercent = 5;
    if (ScreenHeigth <= 568 && ScreenHeigth > 480) {
        spPercent = 4.5;
    }
    else if (ScreenHeigth <= 480){
        spPercent = 4.0;
    }
    
    _indexScrollView                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeigth/spPercent, ScreenWidth, ScreenHeigth-ScreenHeigth/spPercent)];
    _indexScrollView.pagingEnabled  = YES;
    _indexScrollView.contentSize    = CGSizeMake(ScreenWidth*2, ScreenHeigth-ScreenHeigth/spPercent);
    _indexScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _indexScrollView.showsHorizontalScrollIndicator     = NO;
    _indexScrollView.showsVerticalScrollIndicator       = NO;
    _indexScrollView.delegate       = self;
    _indexScrollView.bounces        = NO;
    _indexScrollView.clipsToBounds  = YES;
    _indexScrollView.scrollEnabled  = NO;
    [self.view addSubview:_indexScrollView];
    
    IndexViewController *indexVC = self;
    
    //买入View
    _indexBuyV                  = [[IndexBuyView alloc]initWithFrame:
                  CGRectMake(0, 0,_indexScrollView.frame.size.width,_indexScrollView.frame.size.height)
                                               Name:self.productModel.commodityName
                                               Code:self.productModel.instrumentID
                                       ProductModel:self.productModel];
    _indexBuyV.segSelectIndex   = 0;
    _indexBuyV.instrumentCode   = self.productModel.instrumentCode;
    _indexBuyV.superScrollView  = _indexScrollView;
    _indexBuyV.block            = ^(IndexBuyModel *buyModel,int buyState , int canUse , BOOL  isQuick){
        if ([[CMStoreManager sharedInstance] isLogin]) {
            if (indexVC.productModel.isXH) {
                if ([indexVC spotgoodsLoginResolve]) {
                    [indexVC buyPush:buyModel BuyState:buyState canUse:canUse isQuickOrder:isQuick];
                }
            }
            else{
                [indexVC buyPush:buyModel BuyState:buyState canUse:canUse isQuickOrder:isQuick];
            }
        }
        //未登录
        else{
            [indexVC login];
        }
    };
    _indexBuyV.backGroundHeightBlock = ^ (UIButton *btn){
        
        BOOL isopen = NO;
        
        CacheModel *cacheModel = [CacheEngine getCacheInfo];
        if (cacheModel.tradeDic[indexVC.productModel.tradeDicName][kOrderQuickIsOpen] == nil || [cacheModel.tradeDic[indexVC.productModel.tradeDicName][kOrderQuickIsOpen] isKindOfClass:[NSNull class]] || [cacheModel.tradeDic[indexVC.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"NO"]) {
            isopen = NO;
        }
        else if ([cacheModel.tradeDic[indexVC.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"YES"] ){
            isopen = YES;
        }
        else{
            isopen = NO;
        }
        
        if (isopen) {
            if (btn.tag == 90) {
                [indexVC animationButton:0];
            }
            else{
                [indexVC animationButton:1];
            }
        }
    };
    [_indexScrollView addSubview:_indexBuyV];
    
    if (isOpen) {
        _indexBuyV.bullishBtnLabel.textColor = Color_red;
        _indexBuyV.bearishBtnLabel.textColor = Color_green;
        [_indexBuyV.bullishBtn setImage:[UIImage imageNamed:Image_Color_Red_Black] forState:UIControlStateHighlighted];
        [_indexBuyV.bearishBtn setImage:[UIImage imageNamed:Image_Color_Green_Black] forState:UIControlStateHighlighted];
        
    }
    else{
        _indexBuyV.bullishBtnLabel.textColor = [UIColor whiteColor];
        _indexBuyV.bearishBtnLabel.textColor = [UIColor whiteColor];
        [_indexBuyV.bullishBtn setImage:nil forState:UIControlStateHighlighted];
        [_indexBuyV.bearishBtn setImage:nil forState:UIControlStateHighlighted];
    }
    
    //持仓View
    CGRect rect = CGRectMake(ScreenWidth, 55, ScreenWidth, ScreenHeigth - 55);
    if (isXH) {
        _cashPositionV = [[CashPositionView alloc]initWithFrame:rect model:self.productModel];
        _cashPositionV.superVC = self;
        _cashPositionV.goBuyViewBlock = ^(){
            [indexVC leftButtonClick];
        };
        [self.view addSubview:_cashPositionV];
    }
    else{
        _indexPositionV = [[IndexPositionView alloc]initWithFrame:rect withProductModel:_productModel];
        _indexPositionV.indexName = self.name;
        _indexPositionV.indexCode = self.code;
        _indexPositionV.isPosi = _isPosition;
        _indexPositionV.superVC = self;
        _indexPositionV.block = ^(){
            [indexVC leftButtonClick];
        };
        [self.view addSubview:_indexPositionV];
    }
}

#pragma mark 玩法
-(void)playDescription{
    //期指、现货玩法隐藏    self.productModel.isXH == 1 ||
    if ([self.productModel.instrumentCode isEqualToString:@"IF"]) {
        
    }
    else{
        PlayDescriptionController *playVC = [[PlayDescriptionController alloc]init];
        playVC.name = self.name;
        playVC.code = self.productModel.instrumentCode;
        playVC.productModel = self.productModel;
        [self.navigationController pushViewController:playVC animated:YES];
    }
}


#pragma mark - positionView请求持仓数据
- (void)requestPositionData
{
    if(isXH)
    {
        [_cashPositionV  cashPosionViewAppear];
    }else{
        [_indexPositionV pageAppearRequestListData];
    }
}

#pragma mark 买入

//买入跳转
-(void)buyPush:(IndexBuyModel *)indexBuyModel BuyState:(int)aBuyState canUse:(int)aCanUse isQuickOrder:(BOOL)isQuickOrder{
    
    if ([self.productModel.loddyType isEqualToString:@"1"]) {
        if (self.cainiuStatus == 1 || self.nanjsStatus == 1) {
            [self proActivitionAccount];
            return;
        }
    }
    else{
            if (self.scoreStatus == 1) {
            [self proActivitionAccount];
            return;
        }
    }
    
    if (isXH) {
        NSString *buyPrice              = _indexBuyV.bullishBtnLabel.text;
        NSString *salePrice             = _indexBuyV.bearishBtnLabel.text;
        if (buyPrice != nil) {
            buyPrice    = [buyPrice stringByReplacingOccurrencesOfString:@"买多价" withString:@""];
        }
        if (salePrice != nil) {
            salePrice   = [salePrice stringByReplacingOccurrencesOfString:@"买空价" withString:@""];
        }
        SpotIndexViewController *spotViewController = [[SpotIndexViewController alloc]init];
        spotViewController.productModel = self.productModel;
        spotViewController.canBuy       = aCanUse;
        spotViewController.buyState     = aBuyState;
        spotViewController.floatNum     = [self.productModel.decimalPlaces integerValue];
        spotViewController.buyPrice     = buyPrice;
        spotViewController.salePrice    = salePrice;
        [self.navigationController pushViewController:spotViewController animated:YES];
    }
    else{
        
        //是否可售 0  禁买1  闭市2
        BOOL    canUse = NO;
        
        if (aCanUse == 0) {
            canUse = YES;
        }
        else{
            canUse = NO;
        }
        //快速下单
        if (isQuickOrder) {
            IndexQuickOrderController *indexQuickVC = [[IndexQuickOrderController alloc]init];
            indexQuickVC.buyState = aBuyState;
            indexQuickVC.indexBuyModel = indexBuyModel;
            indexQuickVC.canUse = canUse;
            indexQuickVC.isOpen = isOpen;
            indexQuickVC.isQuickOrder = YES;
            indexQuickVC.productModel = self.productModel;
            indexQuickVC.quickOpen = ^(BOOL open){
                if (open) {
                    [_indexBuyV.orderLightningBtn setImage:[UIImage imageNamed:@"order_lightning_on"] forState:UIControlStateNormal];
                    //高亮颜色
                    [_indexBuyV.bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red_Black] forState:UIControlStateHighlighted];
                    [_indexBuyV.bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green_Black] forState:UIControlStateHighlighted];
                    [_indexBuyV.bullishBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    [_indexBuyV.bearishBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    _indexBuyV.bullishBtn.layer.borderWidth = 1;
                    _indexBuyV.bullishBtn.layer.borderColor = Color_red.CGColor;
                    _indexBuyV.bearishBtn.layer.borderWidth = 1;
                    _indexBuyV.bearishBtn.layer.borderColor = Color_green.CGColor;
                    //字体颜色
                    _indexBuyV.bullishBtnLabel.textColor = Color_red;
                    _indexBuyV.bearishBtnLabel.textColor = Color_green;
                    //闪电显示
                    _indexBuyV.lightningGreenView.hidden = NO;
                    _indexBuyV.lightningRedView.hidden = NO;
                }
                else{
                    [_indexBuyV.orderLightningBtn setImage:[UIImage imageNamed:@"order_lightning_off"] forState:UIControlStateNormal];
                    [_indexBuyV.bullishBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
                    [_indexBuyV.bearishBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
                    [_indexBuyV.bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
                    [_indexBuyV.bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
                    _indexBuyV.bullishBtn.layer.borderWidth = 0;
                    _indexBuyV.bearishBtn.layer.borderWidth = 0;
                    _indexBuyV.bearishBtnLabel.textColor = [UIColor whiteColor];
                    _indexBuyV.bullishBtnLabel.textColor = [UIColor whiteColor];
                    _indexBuyV.lightningRedView.hidden = YES;
                    _indexBuyV.lightningGreenView.hidden = YES;
                }
                isOpen = open;
            };
            if ([self.navigationController.viewControllers.lastObject isKindOfClass:[IndexViewController class]]) {
                [self.navigationController pushViewController:indexQuickVC animated:YES];
            }
        }
        else{
            
            if (isOpen) {
                if (aCanUse == 1) {
                    [[UIEngine sharedInstance] showAlertWithTitle:@"今日禁买" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                    [UIEngine sharedInstance].alertClick = ^ (int aIndex){};
                    return;
                }
                
                BOOL   canUse = YES;
                
                if (aCanUse == 0) {
                    canUse = YES;
                }
                else{
                    canUse = NO;
                }
                
                //闪电下单
                [self getSystemDate:aBuyState TradeDicName:self.productModel.tradeDicName CanUse:canUse IndexModel:indexBuyModel];
            }
            else{
                CacheModel *model = [CacheEngine getCacheInfo];
                //无协议，直接跳转订单
                if (model.tradeDic == nil) {
                    model.tradeDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    [CacheEngine setCacheInfo:model];
                }
                if (model.tradeDic[self.productModel.tradeDicName] == nil) {
                    model.tradeDic[self.productModel.tradeDicName] = [NSMutableDictionary dictionaryWithCapacity:0];
                    [CacheEngine setCacheInfo:model];
                }
                if (model.tradeDic[self.productModel.tradeDicName][@"agreement"] != nil && [model.tradeDic[self.productModel.tradeDicName][@"agreement"] isEqualToString:@"1"]) {
                    IndexOrderController    *orderVC = [[IndexOrderController alloc]init];
                    orderVC.buyState = aBuyState;
                    orderVC.indexBuyModel = indexBuyModel;
                    orderVC.canUse = canUse;
                    orderVC.productModel = self.productModel;
                    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[IndexViewController class]]) {
                        [self.navigationController pushViewController:orderVC animated:YES];
                    }
                }
                //有协议
                else{
                    //积分和周末娱乐场下单取消协议
                    if ([self.productModel.loddyType isEqualToString:@"1"]) {
                        IndexAgreementPage *agreementVC = [[IndexAgreementPage alloc]init];
                        agreementVC.name = @"签署协议";
                        agreementVC.urlStr = [NSString stringWithFormat:@"%@/activity/tradeAndCost.html?type=%@&version=8",K_MGLASS_URL,self.productModel.instrumentCode];
                        agreementVC.buyState = aBuyState;
                        agreementVC.indexBuyModel = indexBuyModel;
                        agreementVC.canUse = canUse;
                        agreementVC.productModel = self.productModel;
                        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[IndexViewController class]]) {
                            [self.navigationController pushViewController:agreementVC animated:YES];
                        }
                    }
                    else{
                        IndexOrderController    *orderVC = [[IndexOrderController alloc]init];
                        orderVC.buyState = aBuyState;
                        orderVC.indexBuyModel = indexBuyModel;
                        orderVC.canUse = canUse;
                        orderVC.productModel = self.productModel;
                        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[IndexViewController class]]) {
                            [self.navigationController pushViewController:orderVC animated:YES];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark 去充值

-(void)getAccountMoney{
    AccountH5Page *accountH5Page = [[AccountH5Page alloc]init];
    accountH5Page.url = [NSString stringWithFormat:@"http://%@/account/banks.html?type=original",HTTP_IP];
    [self.navigationController pushViewController:accountH5Page animated:YES];
}

#pragma mark A50暂不支持现金交易

-(void)a50CantTrade:(IndexOrderController *)aIndexVC{
    [aIndexVC quickOrderClose];
    
    
    [_indexBuyV.orderLightningBtn setImage:[UIImage imageNamed:@"order_lightning_off"] forState:UIControlStateNormal];
    [_indexBuyV.bullishBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_indexBuyV.bearishBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_indexBuyV.bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
    [_indexBuyV.bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
    _indexBuyV.bullishBtn.layer.borderWidth = 0;
    _indexBuyV.bearishBtn.layer.borderWidth = 0;
    _indexBuyV.bearishBtnLabel.textColor = [UIColor whiteColor];
    _indexBuyV.bullishBtnLabel.textColor = [UIColor whiteColor];
    _indexBuyV.lightningGreenView.hidden = YES;
    _indexBuyV.lightningRedView.hidden = YES;
    
    isOpen = NO;
}

#pragma mark Change

-(void)backGroundChange{
    [_indexBuyV.bullishBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [_indexBuyV.bearishBtn setBackgroundImage:nil forState:UIControlStateNormal];
}

-(void)animationButton:(int)aBuyState{

    if (aBuyState == 0) {
        [_indexBuyV.bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red_Black] forState:UIControlStateNormal];
        [self performSelector:@selector(backGroundChange) withObject:nil afterDelay:0.2];
    }
    else if (aBuyState == 1){
        [_indexBuyV.bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green_Black] forState:UIControlStateNormal];
        [self performSelector:@selector(backGroundChange) withObject:nil afterDelay:0.2];
    }
}

//系统时间

-(void)getSystemDate:(int)aState TradeDicName:(NSString *)aTradeName CanUse:(BOOL)aCanUse IndexModel:(IndexBuyModel *)aIndexBuyModel
{
    
    IndexViewController *indexVC = self;
    
    IndexOrderController    *orderVC = [[IndexOrderController alloc]init];
    orderVC.buyState = aState;
    orderVC.indexBuyModel = aIndexBuyModel;
    orderVC.canUse = aCanUse;
    orderVC.productModel = self.productModel;
    orderVC.isOpen = isOpen;
    //充值
    orderVC.accountBlock = ^{
        [indexVC getAccountMoney];
    };
    //返回大厅
    orderVC.backBlock = ^() {
        [indexVC.navigationController popToRootViewControllerAnimated:YES];
    };
    
    __block IndexOrderController   *orderIndexVC = orderVC;
    
    //A50不支持现金交易
    orderVC.cantTradeBlock = ^ {
        [self a50CantTrade:orderIndexVC];
    };
    
    
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        NSString    *systemTime = @"";
        if (SUCCESS) {
            systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        
        NSDictionary *dic = @{
                              @"tradeType": [NSNumber numberWithInt:aState], //看多看空
                              @"userBuyDate": systemTime,              //购买时间
                              @"userBuyPrice": _indexBuyV.indexBuyModel.currentPrice, //价格
                              @"futuresCode": _productModel.instrumentID,      //代码
                              };
        
        //调用优惠券接口
        CacheModel *cacheModel = [CacheEngine getCacheInfo];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:cacheModel.tradeDic[aTradeName][kOrderQuickDic]];
        
        couPonQuickArray = [[NSMutableArray alloc]init];
        
        NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
        
        NSDictionary * dicCouPon = @{@"token":token,@"futuresId":@([_productModel.productID intValue])};
        
        [NetRequest postRequestWithNSDictionary:dicCouPon url:K_User_CouponList successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200)
            {
                if ([dictionary[@"data"] count] != 0) {
                    
                    for (NSDictionary *dic in dictionary[@"data"]) {
                        [couPonQuickArray addObject:dic];
                    }
                }
                
                if (![dataDic[@"isQuickCouponStatus"] isEqualToString:@"NO"])
                {
                    NSMutableArray *couPonIDQuickArray = [[NSMutableArray alloc]init];
                    NSInteger numCount;
                    
                    if (couPonQuickArray.count > 0 && couPonQuickArray != nil) {
                        if (couPonQuickArray.count >[dataDic[@"count"] intValue]) {
                            numCount = [dataDic[@"count"] intValue];
                        }else
                        {
                            numCount = couPonQuickArray.count;
                        }
                        for (NSInteger i = 0; i<numCount; i++)
                        {
                            NSDictionary *couDic = couPonQuickArray[i];
                            [couPonIDQuickArray addObject:couDic[@"id"]];
                        }
                        [dataDic setValue:couPonIDQuickArray forKey:@"couponIds"];
                    }
                    
                }

            }
            
            //需要删除是否选择自动抵扣的那个字段
            [dataDic removeObjectForKey:@"isQuickCouponStatus"];
            
            [dataDic setValuesForKeysWithDictionary:dic];
            [orderVC orderBegin:dataDic];
            
        } failureBlock:^(NSError *error) {
            
            //需要删除是否选择自动抵扣的那个字段
            [dataDic removeObjectForKey:@"isQuickCouponStatus"];
            
            [dataDic setValuesForKeysWithDictionary:dic];
            [orderVC orderBegin:dataDic];
        }];

        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    ReceiveMemaryWarning;
}

@end


@implementation IndexViewController (Login)


-(void)reloadUIAndData{
    [self loadDefaultData];
    
    [self loadSubUI];
}

-(void)loadLoginUI{
    
    [self loadViewDidLoadData];//首次加载数据
    
    [self loadViewDidLoadUI];
    
    [self loadDefaultData];//支持账户
    
    [self loadIncomeData];//持仓收益数据
    
    [self loadTradeRules];//交易规则
}

-(void)loadIncomeData{
    indexIsPosition = NO;
    IndexViewController *selfView = self;
    if (isXH) {//是否有持仓   、  可用余额   、  持仓收益
        _cashPositionV.fundLoadBlock = ^(BOOL isPosition,NSString * userFund,NSString *userProfit){
            if (indexIsPosition != isPosition) {
                indexIsPosition = isPosition;
                [selfView topChange];
            }
            
            _userFund = userFund;
            _userProfit = userProfit;
            
            if (isPosition) {//有持仓
                [selfView setIncomeMoney:userProfit];
            }
            else{
                [selfView setUsedMoney:userFund];
            }
        };

    }else {
        _indexPositionV.fundLoadBlock = ^(BOOL isPosition,NSString * userFund,NSString *userProfit){
            if (indexIsPosition != isPosition) {
                indexIsPosition = isPosition;
                [selfView topChange];
            }
            
            _userFund = userFund;
            _userProfit = userProfit;
            
            if (isPosition) {//有持仓
                [selfView setIncomeMoney:userProfit];
            }
            else{
                [selfView setUsedMoney:userFund];
            }
        };
    }
}

-(void)topChange{
    [_topSubView removeFromSuperview];
    _topSubView = nil;
    [self loadSubUI];
}

-(void)loadViewDidLoadData{
    indexIsPosition = NO;
}

-(void)loadViewDidLoadUI{
    if (_topSubView != nil) {
        [_topSubView removeFromSuperview];
        _topSubView = nil;
    }
    if (_topSubLabel != nil) {
        [_topSubLabel removeFromSuperview];
        _topSubLabel = nil;
    }
    if (_incomeView != nil) {
        [_incomeView removeFromSuperview];
        _incomeView = nil;
    }
    if (_incomeMoneyLabel != nil) {
        [_incomeMoneyLabel removeFromSuperview];
        _incomeMoneyLabel = nil;
    }
    if (_optionButton != nil) {
        [_optionButton removeFromSuperview];
        _optionButton = nil;
    }
    if (_switchView != nil) {
        [_switchView removeFromSuperview];
        _switchView = nil;
    }
    if (_coverView != nil) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }
    if (_tableView != nil) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_saleButton != nil) {
        [_saleButton removeFromSuperview];
        _saleButton = nil;
    }
    
    _userFund = nil;
    _userProfit = nil;
}

-(void)loadDefaultData{
    
    self.cainiuStatus = 0;
    self.scoreStatus = 0;
    self.nanjsStatus = 0;
    
    NSArray *typeArray = [self.productModel.accountCode componentsSeparatedByString:@";"];
    for (int i = 0; i < typeArray.count; i++) {
        if ([typeArray[i] isEqualToString:@"cainiu"]) {
            self.cainiuStatus = 1;
            if ([[CMStoreManager sharedInstance] getAccountCainiuStatus]) {
                self.cainiuStatus = 2;
            }
        }
        else if ([typeArray[i] isEqualToString:@"score"]){
            self.scoreStatus = 1;
            if ([[CMStoreManager sharedInstance] getAccountScoreStatus]) {
                self.scoreStatus = 2;
            }
        }
        else if ([typeArray[i] isEqualToString:@"nanjs"]){
            self.nanjsStatus = 1;
            if ([[CMStoreManager sharedInstance] getAccountNanJSStatus]) {
                self.nanjsStatus = 2;
            }
        }
    }
    NSLog(@"%d,%d,%d",self.cainiuStatus,self.scoreStatus,self.nanjsStatus);
}

#pragma mark 交易规则
/**
 *  交易规则
 */
-(void)loadTradeRules{
    _tradeRulesView = [[TradeRulesView alloc]initWithFrame:CGRectMake(0, 55, 80, 20.0/667.0*ScreenHeigth) TimeLabelHeight:0];
    _tradeRulesView.center = CGPointMake(ScreenWidth/2, _tradeRulesView.center.y);
    if (![self.productModel.instrumentCode isEqualToString:@"IF"]) {
        [self.view addSubview:_tradeRulesView];
        UITapGestureRecognizer *tradeRulesGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tradeRulesTap)];
        [_tradeRulesView addGestureRecognizer:tradeRulesGes];
    }
}

#pragma mark 交易规则Tap
/**
 *  交易规则Tap
 */
-(void)tradeRulesTap{
    [_tradeRulesView stopAnimation];
    [CacheEngine tradeRulsShow];
    [self playDescription];
}

-(void)loadSubUI{
    
    NSLog(@"123-------");
    
    if (_topSubView == nil) {
        _topSubView = [[UIView   alloc]initWithFrame:CGRectMake(0, _tradeRulesView.frame.origin.y + _tradeRulesView.frame.size.height+5, ScreenWidth, _indexScrollView.frame.origin.y - (_tradeRulesView.frame.origin.y + _tradeRulesView.frame.size.height+5))];
        [self.view addSubview:_topSubView];
        
        _topSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
        _topSubLabel.textColor = [UIColor whiteColor];
        _topSubLabel.font = [UIFont systemFontOfSize:9];
        _topSubLabel.textAlignment = NSTextAlignmentCenter;
        _topSubLabel.text = @"";
        [_topSubView addSubview:_topSubLabel];
    }
    
    if (![CMStoreManager sharedInstance].isLogin) {
        [self loadSub_Login];
    }
    else{
        if (![DataUsedEngine nullTrim:self.productModel.minPrice]) {
            self.productModel.minPrice = @"0";
        }
        if (isXH) {
            _topSubLabel.text = [NSString stringWithFormat:@"每次跳动=%.2f%@x手数",[self.productModel.minPrice floatValue] * [self.productModel.multiple floatValue],self.productModel.currencyUnit];
        }
        else{
            _topSubLabel.text = [NSString stringWithFormat:@"每次跳动=%.0f%@",[self.productModel.minPrice floatValue] * [self.productModel.multiple floatValue],self.productModel.currencyUnit];
        }
        
        _topSubLabel.textColor = Color_Gold;
        
        BOOL isIntegral = NO;
        if ([self .productModel.loddyType isEqualToString:@"1"]) {
            isIntegral = NO;
        }
        else{
            isIntegral = YES;
        }
        
        /**
         *  需激活积分账户
         */
        if (isIntegral) {//积分
            if (self.scoreStatus == 1) {//激活积分账户
                [self removeFromSupperViewUnlessView:All];
                [self loadSub_Stock];
            }
            else{//可以使用积分账户
                _topSubLabel.text = @"";//还原提示语
                
                if (!indexIsPosition) {//如果无持仓
                    [self removeFromSupperViewUnlessView:Capital];
                    [self loadSub_Capital];//加载可用资金
                }
                else{//加载持仓
                    [self removeFromSupperViewUnlessView:Income];
                    [self loadSub_Income];
                }
            }
        }
        else{//现金
            /**
             *  需要激活财牛
             *  需激活南交所账户
             */
            if (self.cainiuStatus == 1 || self.nanjsStatus == 1) {
                [self removeFromSupperViewUnlessView:All];
                [self loadSub_Activate];
            }
            
            /**
             *  财牛已经激活,并且已登录
             */
            if (self.cainiuStatus == 2){
                _topSubLabel.text = @"";//还原提示语
                
                if (!indexIsPosition) {//如果无持仓
                    [self removeFromSupperViewUnlessView:Capital];
                    [self loadSub_Capital];//加载可用资金
                }
                else{//加载持仓
                    [self removeFromSupperViewUnlessView:Income];
                    [self loadSub_Income];
                }
            }
            
            /**
             *  南交所账户已激活，需判断是否登录
             */
            else if (self.nanjsStatus == 2){
                
                if ([SpotgoodsAccount sharedInstance].isNeedLogin && [SpotgoodsAccount sharedInstance].isNeedRegist)
                {
                    [self removeFromSupperViewUnlessView:All];
                    [self loadSub_Activate];

                }else
                {
                    _topSubLabel.text = @"";//还原提示语
                    
                    if (!indexIsPosition) {//如果无持仓
                        [self removeFromSupperViewUnlessView:Capital];
                        [self loadSub_Capital];//加载可用资金
                    }
                    else{//加载持仓
                        [self removeFromSupperViewUnlessView:Income];
                        [self loadSub_Income];
                    }
                }
               
            }
        }
    }
    
    [self saleUp];
    [self positionUp];
    [self guideUp];
    
}

-(void)removeFromSupperViewUnlessView:(int)aIndexView{
    if (aIndexView != Income) {
        [_incomeView removeFromSuperview];
        _incomeView = nil;
        
        [_saleButton removeFromSuperview];
        _saleButton = nil;
    }
    
    if (aIndexView != Capital) {
        [_switchView removeFromSuperview];
        _switchView = nil;
    }
    
    if (aIndexView != Activate) {
        [_optionButton removeFromSuperview];
        _optionButton = nil;
    }
}

#pragma mark 加载登录UI
/**
 *  加载登录UI
 */
-(void)loadSub_Login{
    _tradeRulesView.hidden = NO;//显示交易规则
    
    UIButton    *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(ScreenWidth/2 - 5 - ScreenWidth/3.5, _topSubView.frame.size.height - 28.0/667*ScreenHeigth - 10, ScreenWidth/3.5 , 28.0/667*ScreenHeigth);
    loginButton.backgroundColor = Color_loginYellow;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [_topSubView addSubview:loginButton];
    
    UIButton    *registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registeButton.frame = CGRectMake(ScreenWidth/2 + 5, loginButton.frame.origin.y , ScreenWidth/3.5, 28.0/667*ScreenHeigth);
    registeButton.backgroundColor = Color_registeRed;
    [registeButton setTitle:@"注册" forState:UIControlStateNormal];
    registeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    registeButton.clipsToBounds = YES;
    registeButton.layer.cornerRadius = 3;
    [registeButton addTarget:self action:@selector(goRegiste) forControlEvents:UIControlEventTouchUpInside];
    [_topSubView addSubview:registeButton];
}
//去登录页
-(void)goLogin{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.isOtherFutures       = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
//去注册页
-(void)goRegiste{
    RegViewController * regVC = [[RegViewController alloc] init];
    regVC.sourceStr = @"注册";
    [self.navigationController pushViewController:regVC animated:YES];
}

#pragma mark 加载激活UI
/**
 *  加载激活UI
 */
-(void)loadSub_Activate{
    
    _tradeRulesView.hidden = NO;//显示交易规则
    IndexViewController *selfView = self;
    _optionButton = [[IndexOptionButton alloc]initWithFrame:CGRectMake(ScreenWidth/4*0.5, _topSubView.frame.size.height - 28.0/667*ScreenHeigth - 10, ScreenWidth/4*3 , 28.0/667*ScreenHeigth)];
    _optionButton.optionBlock = ^(NSMutableArray *titleArray,NSMutableArray *imgArray,NSMutableArray *statusArray){
        _titleArray = titleArray;
        _imgArray = imgArray;
        _statusArray = statusArray;
        [selfView goAccountChoose];
    };
    [_topSubView addSubview:_optionButton];
    [_optionButton setCainiuStatus:self.cainiuStatus ScoreStatus:self.scoreStatus NanjsStatus:self.nanjsStatus];
}


#pragma mark 加载资金UI
/**
 *  加载资金UI
 */
-(void)loadSub_Capital{
    _tradeRulesView.hidden = NO;//显示交易规则
    
    IndexViewController *selfView = self;
    _switchView = [[IndexSwitchView alloc]initWithFrame:CGRectMake(ScreenWidth/4*0.5, 0, ScreenWidth/4*3 , _topSubView.frame.size.height - 10)];
    _switchView.switchRightBlock = ^(void){//点击充值模块
        [selfView recharge];
    };
    _switchView.switchleftBlock = ^(void){//点击切换模块
        
    };
    _switchView.switchCenterBlock = ^(void){//点击资金模块
        [selfView centerClick];
    };
    [_topSubView addSubview:_switchView];
    
    if ([self.productModel.loddyType isEqualToString:@"1"]) {
        if (isXH) {
            [_switchView setCenterPro:[NSString stringWithFormat:@"南方稀贵金属交易所可用资金（元）"]];
        }
        else{
            [_switchView setCenterPro:[NSString stringWithFormat:@"%@账户可用资金（元）",App_appShortName]];
        }
        
    }
    else //if ([self.productModel.loddyType isEqualToString:@"2"])积分包含积分盘和假期盘
    {
        [_switchView setIntegral];//积分更换Image
        [_switchView setCenterPro:[NSString stringWithFormat:@"模拟交易可用积分"]];
    }
    if (_userFund != nil) {//刷新可用资金
        [self setUsedMoney:_userFund];
    }
}

-(void)setUsedMoney:(NSString *)aMoney{
    [_switchView setUsedMoney:aMoney];
}

#pragma mark 入金按钮点击

-(void)recharge{
    //产品类型 1:现金实盘 2:积分模拟 3:假日模拟盘
//    if ([self.productModel.loddyType isEqualToString:@"1"]) {//现金
//        if (!isXH) {//非现货入金
//            AccountH5Page *accountH5Page = [[AccountH5Page alloc]init];
//            accountH5Page.url = [NSString stringWithFormat:@"http://%@/account/banks.html?type=original",HTTP_IP];
//            [self.navigationController pushViewController:accountH5Page animated:YES];
//        }
//        else{//现货入金
//            SpotgoodsWebController  *spotgoodsVC = [[SpotgoodsWebController alloc]init];
//            spotgoodsVC.isDeposit = YES;
//            [self.navigationController pushViewController:spotgoodsVC animated:YES];
//        }
//    }
//    else //if ([self.productModel.loddyType isEqualToString:@"2"])//积分盘和模拟盘
//    {//积分兑换  --无解
//        [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:nil];
//        [UIEngine sharedInstance].alertClick = ^(int aIndex){};
//    }
    
    if ([self.productModel.loddyType isEqualToString:@"2"]) {//积分
        [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:nil];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){};
    }
    else if ([self.productModel.loddyType isEqualToString:@"1"]){//现金
        if (isXH) {//现货
            SpotgoodsWebController  *spotgoodsVC = [[SpotgoodsWebController alloc]init];
            spotgoodsVC.isDeposit = YES;
            [self.navigationController pushViewController:spotgoodsVC animated:YES];
        }
        else{//非现货跳转财牛账户
//            AccountModel *accountModel = [AccountModel accountModelWithDictionary:[[CMStoreManager sharedInstance] getAccountCainiuDetailDic]];
//            [self goCainiuPage:accountModel];
            AccountH5Page *h5 = [[AccountH5Page alloc]init];
            h5.url = [NSString stringWithFormat:@"http://%@/account/banks.html?type=original",HTTP_IP];
            h5.isHaveToken = YES;
            [self.navigationController pushViewController:h5 animated:YES];
        }
    }
}

#pragma mark 中心点击
/**
 *  CenterClick
 */
-(void)centerClick{
//    if ([self.productModel.loddyType isEqualToString:@"2"]) {//积分
//        
//    }
//    else if ([self.productModel.loddyType isEqualToString:@"1"]){//现金
//        if (isXH) {//现货
//            
//        }
//        else{//非现货跳转财牛账户
//            AccountModel *accountModel = [AccountModel accountModelWithDictionary:[[CMStoreManager sharedInstance] getAccountCainiuDetailDic]];
//            [self goCainiuPage:accountModel];
//        }
//    }
    
    [self goPosition];
}

#pragma mark 进入财牛账户页
//进入财牛账户页
- (void)goCainiuPage:(AccountModel*)model
{
    AccountH5Page  * openPage = [[AccountH5Page alloc] init];
    openPage.usedMoney = model.amt;
    openPage.url = [NSString stringWithFormat:@"%@?abc=%@",model.url,[Helper randomGet]];
    [self.navigationController pushViewController:openPage animated:YES];
}

#pragma mark 加载收益UI
/**
 *  加载收益UI
 */
-(void)loadSub_Income{
    if (self.isSecondJump == NO && _incomeView == nil) {
        
        _tradeRulesView.hidden = YES;//隐藏交易规则
        
        _incomeView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*0.5, -10/667.0*ScreenHeigth, ScreenWidth/3*2 , _topSubView.frame.size.height)];
        _incomeView.backgroundColor = [UIColor clearColor];
        [_topSubView addSubview:_incomeView];
        
        UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _incomeView.frame.size.width, 10)];
        proLabel.text = [NSString stringWithFormat:@"持仓总收益（%@）",self.productModel.currencyUnit];
        if ([self.productModel.loddyType isEqualToString:@"2"]||[self.productModel.loddyType isEqualToString:@"3"]) {
            proLabel.text = [NSString stringWithFormat:@"持仓总收益（积分）"];
        }
        
        proLabel.textColor = Color_white;
        proLabel.textAlignment = NSTextAlignmentCenter;
        [_incomeView addSubview:proLabel];
        
        _incomeMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, proLabel.frame.origin.y + proLabel.frame.size.height, proLabel.frame.size.width - 10, _incomeView.frame.size.height - proLabel.frame.origin.y - proLabel.frame.size.height - 10 )];
        _incomeMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _incomeMoneyLabel.textColor = [UIColor whiteColor];
        _incomeMoneyLabel.text = @"+0.00";
        [_incomeView addSubview:_incomeMoneyLabel];
        
        UILabel *lookDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _incomeMoneyLabel.frame.origin.y + _incomeMoneyLabel.frame.size.height, _incomeMoneyLabel.frame.size.width, 10)];
        lookDetailLabel.text = @"点击查看详情";
        lookDetailLabel.textColor = [UIColor whiteColor];
        lookDetailLabel.textAlignment = NSTextAlignmentCenter;
        [_incomeView addSubview:lookDetailLabel];
        
        /**
         *  闪电平仓
         */
        _saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saleButton.frame = CGRectMake(ScreenWidth - 20 - _topSubView.frame.size.height/3*2, 0, _topSubView.frame.size.height/3*2, _topSubView.frame.size.height/3*2);
        _saleButton.center = CGPointMake(_saleButton.center.x, _topSubView.center.y - 10);
        [_saleButton setImage:[UIImage imageNamed:@"CashPosition_8"] forState:UIControlStateNormal];
        [_saleButton addTarget:self action:@selector(salePosition) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saleButton];
        
        if (ScreenHeigth <= 480) {
            _incomeMoneyLabel.font = [UIFont boldSystemFontOfSize:18];
            lookDetailLabel.font = [UIFont boldSystemFontOfSize:8];
            proLabel.font = [UIFont systemFontOfSize:8];
        }
        else if (ScreenHeigth > 480 && ScreenHeigth <= 667){
            _incomeMoneyLabel.font = [UIFont boldSystemFontOfSize:26];
            lookDetailLabel.font = [UIFont boldSystemFontOfSize:9];
            proLabel.font = [UIFont systemFontOfSize:9];
        }
        else{
            _incomeMoneyLabel.font = [UIFont boldSystemFontOfSize:36];
            lookDetailLabel.font = [UIFont boldSystemFontOfSize:10];
            proLabel.font = [UIFont systemFontOfSize:10];
        }
        
        UITapGestureRecognizer  *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPosition)];
        [_incomeView addGestureRecognizer:centerTap];
    }
    
    if (_userProfit != nil) {//刷新收益
        [self setIncomeMoney:_userProfit];
    }
}

-(void)setIncomeMoney:(NSString *)aMoney{
    _incomeMoneyLabel.text = aMoney;
    if ([aMoney rangeOfString:@"-"].location != NSNotFound) {
        _incomeMoneyLabel.textColor = Color_green;
    }
    else{
        _incomeMoneyLabel.textColor = [UIColor redColor];
    }
}

#pragma mark 去持仓页
/**
 *  去持仓页
 */
-(void)goPosition{
    self.isSecondJump = YES;
    if (isXH) {
        _cashPositionV.frame = CGRectMake(0, _cashPositionV.frame.origin.y, _cashPositionV.frame.size.width, _cashPositionV.frame.size.height);
        [self.view bringSubviewToFront:_cashPositionV];
    }else{
        _indexPositionV.frame = CGRectMake(0, _indexPositionV.frame.origin.y, _indexPositionV.frame.size.width, _indexPositionV.frame.size.height);
        [self.view bringSubviewToFront:_indexPositionV];
    }
    [self requestPositionData];
    //关闭实时策略
    [self closeTactics];
}

#pragma mark 闪电平仓
/**
 *  闪电平仓
 */
-(void)salePosition{
    if(isXH){
        [_cashPositionV keySaleOrder];
    }else{
        [_indexPositionV keySaleOrder];

    }
    [self goPosition];
}

#pragma mark 加载激活积分
/**
 *  加载激活积分
 */
-(void)loadSub_Stock{
    UIButton    *activateStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    activateStockButton.frame = CGRectMake(ScreenWidth/4*0.5, _topSubView.frame.size.height - 28.0/667*ScreenHeigth - 10, ScreenWidth/4*3 , 28.0/667*ScreenHeigth);
    activateStockButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:8.0/255.0 blue:27.0/255.0 alpha:1];
    [activateStockButton setTitle:@"激活积分模拟" forState:UIControlStateNormal];
    activateStockButton.titleLabel.font = [UIFont systemFontOfSize:13];
    activateStockButton.clipsToBounds = YES;
    activateStockButton.layer.cornerRadius = 3;
    [activateStockButton addTarget:self action:@selector(goActivateStock) forControlEvents:UIControlEventTouchUpInside];
    [_topSubView addSubview:activateStockButton];
    
}
#pragma mark 激活积分模拟操作
//激活积分模拟操作
-(void)goActivateStock{
    
    [RequestDataModel requestOpenScoreAccountSuccessBlock:^(BOOL success, id Info) {
        if (success) {
            [self showRegRedBag];//积分弹窗
            [self reloadUIAndData];
        }
        else{
            if ([DataUsedEngine nullTrim:Info[@"msg"]]) {
                [[UIEngine sharedInstance] showAlertWithTitle:Info[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:nil];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            }
        }
    }];
}

- (void)showRegRedBag
{
    RegistRedBagView * regRedView = [[RegistRedBagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    regRedView.redBagBlock = ^(){
        [self getUserAccout];
    };
    [self.rdv_tabBarController.view  addSubview:regRedView];
}

- (void)getUserAccout
{
    [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
    }];
}

#pragma mark TableView 和 蒙层

float rowHeight;

-(void)goAccountChoose{
    
    
    
    if (_tableView != nil) {
        [_tableView removeFromSuperview];
        _tableView = nil;
        if (_coverView != nil) {
            [_coverView removeFromSuperview];
            _coverView = nil;
        }
        return;
    }
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _coverView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
    [self.view addSubview:_coverView];
    UITapGestureRecognizer *coverViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeCoverView)];
    [_coverView addGestureRecognizer:coverViewTap];
    
    rowHeight = 50.0/667*ScreenHeigth;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(_optionButton.frame.origin.x, _optionButton.frame.origin.y + _optionButton.frame.size.height + _topSubView.frame.origin.y - 5, _optionButton.frame.size.width, _titleArray.count * rowHeight + 5) style:UITableViewStyleGrouped];
    _tableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = Color_black;
    _tableView.layer.cornerRadius = 3;
    _tableView.clipsToBounds = YES;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = Color_line.CGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.view bringSubviewToFront:_topSubView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
        if (indexPath.row < _titleArray.count-1) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, rowHeight-0.5, _optionButton.frame.size.width - 30, 0.5)];
            lineView.backgroundColor = Color_line;
            [cell addSubview:lineView];
        }
        
        UIButton    *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(tableView.frame.size.width - 15 - 35, 0, 35, 17);
        rightButton.center = CGPointMake(rightButton.center.x, rowHeight/2);
        [rightButton setTitleColor:Color_Red forState:UIControlStateNormal];
        rightButton.backgroundColor = Color_black;
        rightButton.clipsToBounds = YES;
        rightButton.layer.cornerRadius = 2;
        rightButton.layer.borderColor = Color_Red.CGColor;
        rightButton.layer.borderWidth = 1;
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        rightButton.tag = indexPath.row+10;
        [rightButton addTarget:self action:@selector(activationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:rightButton];
    }
    cell.backgroundColor = Color_black;
    cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = Color_Gold;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    
    UIButton *rightButton = [cell viewWithTag:indexPath.row+10];
    if ([_statusArray[indexPath.row] isEqualToString:@"0"]) {
        [rightButton setTitle:@"激活" forState:UIControlStateNormal];
        [rightButton setTitleColor:Color_Red forState:UIControlStateNormal];
        rightButton.layer.borderColor = Color_Red.CGColor;
    }
    else{
        [rightButton setTitle:@"登录" forState:UIControlStateNormal];
        [rightButton setTitleColor:Color_Gold forState:UIControlStateNormal];
        rightButton.layer.borderColor = Color_Gold.CGColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goAccountChoose];
    
    if ([_titleArray[indexPath.row] rangeOfString:[NSString stringWithFormat:@"%@账户",App_appShortName]].location != NSNotFound) {
        AccountH5Page *h5 = [[AccountH5Page alloc]init];
        h5.url = [NSString stringWithFormat:@"%@/account/openAccount.html?token=%@&abc=%u&type=original",K_MGLASS_URL,[[CMStoreManager sharedInstance] getUserToken],arc4random()%999];;
        [self.navigationController pushViewController:h5 animated:YES];
    }
    else if ([_titleArray[indexPath.row] rangeOfString:@"南方稀贵金属"].location != NSNotFound){
        SpotgoodsWebController *spotgoodsController = [[SpotgoodsWebController alloc]init];
        if ([_statusArray[indexPath.row] isEqualToString:@"0"]) {
            spotgoodsController.status = 1;
        }
        else if ([_statusArray[indexPath.row] isEqualToString:@"1"]){
            spotgoodsController.status = 2;
        }
        spotgoodsController.otherPage = YES;
        [self.navigationController pushViewController:spotgoodsController animated:YES];
    }
}

#pragma mark 关闭蒙层
-(void)closeCoverView{
    [self goAccountChoose];
}

#pragma mark 激活按钮点击
/**
 *  激活按钮点击
 */
-(void)activationButtonClick:(UIButton *)button{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag-10 inSection:0];
    [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark 引导页置顶。
/**
 *  引导页置顶。
 */
-(void)guideUp{
    if (guideView != nil) {
        [self.view bringSubviewToFront:guideView];
        [self.view bringSubviewToFront:guide_OneImg];
        [self.view bringSubviewToFront:guide_TwoImg];
        [self.view bringSubviewToFront:guide_ThreeImg];
        [self.view bringSubviewToFront:guide_FourImg];
        [self.view bringSubviewToFront:guide_FiveImg];
    }
}

-(void)positionUp{
    if (_indexPositionV != nil) {
        [self.view bringSubviewToFront:_indexPositionV];
    }
    
    if (_cashPositionV != nil) {
        [self.view bringSubviewToFront:_cashPositionV];
    }
}

-(void)saleUp{
    if (_saleButton != nil) {
        [self.view bringSubviewToFront:_saleButton];
    }
}

#pragma mark 提示激活账户
/**
 *  提示激活账户
 */
-(void)proActivitionAccount{
    NSString    *msg = @"";
    if ([self.productModel.loddyType isEqualToString:@"1"]) {
        msg = @"请先激活实盘账户";
    }
    else{
        msg = @"请先激活模拟积分";

    }
    
    [[UIEngine sharedInstance] showAlertWithTitle:msg ButtonNumber:2 FirstButtonTitle:@"返回" SecondButtonTitle:@"激活"];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        if (aIndex == 10086) {
            
        }
        else{
            if ([self.productModel.loddyType isEqualToString:@"1"]) {
                [_optionButton goActivateMoney];//点击激活实盘账户

            }
            else{
                [self goActivateStock];

            }
        }
    };
}

@end
