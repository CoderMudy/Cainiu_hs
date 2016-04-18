//
//  PersionInfoViewController.m
//  hs
//
//  Created by RGZ on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#define ORIGINAL_MAX_WIDTH 640.0f

#import "PersionInfoViewController.h"
#import "PrivateUserInfo.h"
#import "NickViewController.h"
#import "SignViewController.h"
#import "PhoneViewController.h"
#import "RealNameViewController.h"
#import "BankCardViewController.h"
#import "PasswordViewController.h"
#import "MobileBindViewController.h"
#import "PersionInfoCell.h"
#import "NSString+MD5.h"
#import "FindZBarViewController.h"
#import "ShengfenRenZhengViewController.h"
#import "AccountPage.h"
#import "NetRequest.h"
#import "NJImageCropperViewController.h"
#import "UIImageView+WebCache.h"

//结束加载
#define IsEndLoading \
_loadStatusNum+=1;\
if (_loadStatusNum==3) {\
[[NSNotificationCenter defaultCenter] postNotificationName:LoadingEng object:nil];\
}

#define cellHeightDefault 44

@interface PersionInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NJImageCropperDelegate>
{
    CUserData       *_cuserdata;
    NSArray         *_titleArray;
    NSMutableArray  *_detailArray;
    NSMutableArray  *imageDetailArray;
    //头像
    UIImageView     *_headerImageView;
    //账户安全等级状态 1:低   2:中    3:高
    int             _safeState;
    //个人信息
    PrivateUserInfo *_privateUserInfo;
    //加载接口数
    int             _loadStatusNum;
    
    NSString        *infoShenHeStatus;
    NSString        *failinfoMsg;//身份认证失败的原因
    
    NSString        *isHiddleRenZheng;
    
}
@property (nonatomic,strong)NavView * nav;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView * addView;
@property (nonatomic,strong)UIImage * headerImg;
@end

@implementation PersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoShenHeStatus = @" ";
    [self loadNav];
    
    [self loadData];
    
    [self loadTable];
    
    //    [self setNavLeftBut:NSPushMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAttention:) name:@"attention_status" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shenHeRenZhengStatus:) name:@"shenHe_status" object:nil];
    
}

- (void)changeAttention:(NSNotification *)noti
{
    _privateUserInfo = noti.object;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人资料"];
    [[UIEngine sharedInstance] hideProgress];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人资料"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestShenHeStatus];
    if (_privateUserInfo) {
        
        if ([_privateUserInfo.statusRealName floatValue] == 0 && [_privateUserInfo.statusBankCardBind floatValue] == 0) {
            _safeState = 1;
        }
        else if ([_privateUserInfo.statusRealName floatValue] == 2 && [_privateUserInfo.statusBankCardBind floatValue] == 2 ){
            _safeState = 2;
        }else if ([_privateUserInfo.statusRealName floatValue] == 1 && [_privateUserInfo.statusBankCardBind floatValue] == 1 ){
            _safeState = 3;
        }
        [_tableView reloadData];
    }
    
}

#pragma mark - 请求审核状态接口
- (void)requestShenHeStatus
{
    imageDetailArray = [[NSMutableArray alloc]init];
    
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    
    
    [NetRequest postRequestWithNSDictionary:dic url:K_ShenHe_Satus successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSDictionary *dic = dictionary[@"data"];
            [imageDetailArray addObject:[Helper judgeStr:dic[@"image1"]]];
            [imageDetailArray addObject:[Helper judgeStr:dic[@"image2"]]];
            [imageDetailArray addObject:[Helper judgeStr:dic[@"image3"]]];
            failinfoMsg = dic[@"remark"];
            
            if ([dic[@"status"] intValue] == 0)
            {
                infoShenHeStatus = @"审核中";
            }else if ([dic[@"status"] intValue] == 1)
            {
                infoShenHeStatus = @"审核成功";
            }else if ([dic[@"status"] intValue] == 2)
            {
                infoShenHeStatus = @"失败";
            }
            
            if ([dic[@"status"] intValue] == -1) {
                isHiddleRenZheng = @"hiddle";
                //初始化title
                //                _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"修改密码",@"手势密码",@"修改手势"];
                
            }else
            {
                isHiddleRenZheng = @"show";
                if (![isHiddleRenZheng isEqualToString:@"hiddle"]) {
                    //身份认证
                    _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"身份认证",@"修改密码",@"手势密码",@"修改手势"];
                    [_detailArray addObject:infoShenHeStatus];
                }
                
                [_detailArray replaceObjectAtIndex:8 withObject:infoShenHeStatus];
                //                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
                //                NSArray *array=@[indexPath];
                //                [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }else
        {
            //            _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"修改密码",@"手势密码",@"修改手势"];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        //        _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"修改密码",@"手势密码",@"修改手势"];
        [self.tableView reloadData];
    }];
    
}

#pragma mark 数据

-(void)loadData
{
    //初始化加载接口数
    _loadStatusNum=0;
    
    isHiddleRenZheng = @"hiddle";
    //    //初始化title
    _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"修改密码",@"手势密码",@"修改手势"];
    _detailArray=[NSMutableArray arrayWithCapacity:0];
    
    
    //个性签名
    NSString *sign=@"";
    
    if ([[CMStoreManager sharedInstance] getUserSign] == nil||[[CMStoreManager sharedInstance] getUserSign].length==0||[[[CMStoreManager sharedInstance] getUserSign] isEqualToString:@""]||[[[CMStoreManager sharedInstance] getUserSign] isEqualToString:@" "]) {
        sign=@"编辑个性签名";
    }
    else
    {
        sign=[[CMStoreManager sharedInstance] getUserSign];
    }
    
    [_detailArray addObject:@" "];
    NSString *strNickname =[[CMStoreManager sharedInstance] getUserNick];
    if(strNickname == nil)
        strNickname = @"";
    //昵称
    [_detailArray addObject:strNickname];
    //签名
    [_detailArray addObject:sign];
    [_detailArray addObject:@" "];
    [_detailArray addObject:@" "];
    //手机号
    [_detailArray addObject:@"未绑定"];
    //实名
    [_detailArray addObject:@"未填写"];
    //银行卡
    [_detailArray addObject:@"未填写"];
    
    //    if (![isHiddleRenZheng isEqualToString:@"hiddle"]) {
    //        //身份认证
    //        _titleArray=@[@"头像",@"昵称",@"个性签名",@"我的推广码",@"",@"手机号",@"实名认证",@"银行卡",@"身份认证",@"修改密码",@"手势密码",@"修改手势"];
    //        [_detailArray addObject:infoShenHeStatus];
    //    }
    
    [_detailArray addObject:@" "];
    //修改密码
    [_detailArray addObject:@" "];
    //手势密码
    [_detailArray addObject:@" "];
    //修改手势
    [_detailArray addObject:@" "];
    
    
    //数据加载完毕,结束加载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingEnd) name:LoadingEng object:nil];
    
    //初始化个人信息类
    
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.accountModel.accountIndexModel.privateUserInfo != nil) {
        _privateUserInfo = cacheModel.accountModel.accountIndexModel.privateUserInfo;
    }
    else{
        _privateUserInfo=[[PrivateUserInfo alloc]init];
        _privateUserInfo.statusBankCardBind =@"0";
        _privateUserInfo.statusMobile       =@"0";
        _privateUserInfo.statusRealName     =@"0";
        _privateUserInfo.realName           =@" ";
        _privateUserInfo.idCard             =@" ";
        _privateUserInfo.bankCard           =@" ";
        _privateUserInfo.bankName           =@" ";
        _privateUserInfo.mobile             =@" ";
        cacheModel.accountModel.accountIndexModel.privateUserInfo = _privateUserInfo;
        [CacheEngine setCacheInfo:cacheModel];
    }
    
    //验证手机号
    [self authMobile];
    //验证实名认证
    [self authRealName];
    //验证银行卡
    [self authBankCard];
    
    
}

//结束加载
-(void)loadingEnd
{
    [[UIEngine sharedInstance] hideProgress];
    
    if (_privateUserInfo) {
        if ([_privateUserInfo.statusRealName floatValue] == 0 && [_privateUserInfo.statusBankCardBind floatValue] == 0) {
            _safeState = 1;
        }
        else if ([_privateUserInfo.statusRealName floatValue] == 2 && [_privateUserInfo.statusBankCardBind floatValue] == 2 ){
            _safeState = 2;
        }else if ([_privateUserInfo.statusRealName floatValue] == 1 && [_privateUserInfo.statusBankCardBind floatValue] == 1 ){
            _safeState = 3;
        }
    }
    [self.tableView reloadData];
}

//验证手机号
-(void)authMobile
{
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    
    //本地存储的用户信息
    _cuserdata = [CUserData sharedInstance];
    UserData *userData=_cuserdata.userBaseClass.data;
    UserUserInfo *userInfo=userData.userInfo;
    
    [DataEngine requestToAuthbindOfMobileWithComplete:^(BOOL SUCCESS, NSString * status, NSString * tel) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]) {
                [_detailArray replaceObjectAtIndex:5 withObject:tel];
                _privateUserInfo.statusMobile=@"1";
                _privateUserInfo.mobile=tel;
                userInfo.tele=tel;
            }
            else
            {
                _privateUserInfo.statusMobile=@"0";
                _privateUserInfo.mobile=@" ";
                userInfo.tele=@" ";
            }
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIndexModel.privateUserInfo.statusMobile = _privateUserInfo.statusMobile;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.mobile = _privateUserInfo.mobile;
            [CacheEngine setCacheInfo:cacheModel];
            
        }
        else
        {
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
                [[UIEngine sharedInstance] hideProgress];
            }
        }
        
        IsEndLoading
    }];
}

//验证真实姓名
-(void)authRealName
{
    
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                if([status isEqualToString:@"1"])
                {
                    [_detailArray replaceObjectAtIndex:6 withObject:@"已认证"];
                }
                else
                {
                    [_detailArray replaceObjectAtIndex:6 withObject:@"已填写"];
                }
                _privateUserInfo.statusRealName=status;
                _privateUserInfo.realName=realName;
                _privateUserInfo.idCard=idCard;
            }
            else{
                _privateUserInfo.statusRealName = @"0";
            }
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIndexModel.privateUserInfo.statusRealName = _privateUserInfo.statusRealName;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.realName = _privateUserInfo.realName;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.idCard = _privateUserInfo.idCard;
            [CacheEngine setCacheInfo:cacheModel];
            
        }
        else
        {
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
                //                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后重试"];
            }
        }
        IsEndLoading
    }];
}

//验证银行卡
-(void)authBankCard
{
    
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                
                if([status isEqualToString:@"1"])
                {
                    [_detailArray replaceObjectAtIndex:7 withObject:@"已绑定"];
                }
                else
                {
                    [_detailArray replaceObjectAtIndex:7 withObject:@"已填写"];
                }
                _privateUserInfo.statusBankCardBind=status;
                _privateUserInfo.bankCard=bankCard;
                _privateUserInfo.bankName=bankName;
                
            }
            else
            {
                _privateUserInfo.statusBankCardBind = @"0";
            }
            
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIndexModel.privateUserInfo.statusBankCardBind = _privateUserInfo.statusBankCardBind;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.bankCard = _privateUserInfo.bankCard;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.bankName = _privateUserInfo.bankName;
            [CacheEngine setCacheInfo:cacheModel];
            
        }
        else
        {
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
                //                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后重试"];
            }
        }
        IsEndLoading
    }];
}

#pragma mark 导航

-(void)loadNav
{
//    NavTitle(@"个人资料")
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [_nav.leftControl  addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    _nav.titleLab.text = @"个人资料";
    [self.view addSubview:_nav];
    
    
    
    
    //如果是身份认证进入然后在进入
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    
}

- (void)leftAction
{
    if ([_isRegister isEqualToString:@"YES"]) {//注册跳转
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.rdv_tabBarController.selectedIndex = 3;
    }else{//向淑娥特殊需要
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[AccountPageName class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark 表

-(void)loadTable
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244, 1);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UserInfo    *userInfo = getUser_Info;
    if (![isHiddleRenZheng isEqualToString:@"hiddle"])//身份认证显示的时候
    {
        if ([userInfo.userGestureIsOpenidLogin isEqualToString:@"1"]) {
            return 9;
        }
        else
        {
            if ([CacheEngine isOpenGes]) {
                return 12;
            }
            else
            {
                return 11;
            }
            
        }
        
    }else
    {
        if ([userInfo.userGestureIsOpenidLogin isEqualToString:@"1"]) {
            return 8;
        }
        else
        {
            if ([CacheEngine isOpenGes]) {
                return 11;
            }
            else
            {
                return 10;
            }
            
        }
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 69;
        }
        else if (indexPath.row==4)
        {
            return 70;
        }
        else
        {
            return cellHeightDefault;
        }
    }
    else
    {
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

//账户安全等级
-(UIView *)loadSafeView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    
    //    view.backgroundColor=[UIColor grayColor];
    //账户安全等级
    UILabel *safePro=[[UILabel alloc]init];
    safePro.frame=CGRectMake(0, 12, ScreenWidth, 18);
    safePro.font=[UIFont systemFontOfSize:12];
    safePro.text=@"账户安全等级";
    safePro.textColor=RGBACOLOR(187, 33, 34, 1);
    safePro.textAlignment=NSTextAlignmentCenter;
    [view addSubview:safePro];
    
    //灰条
    UIView *redBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, safePro.frame.size.height+safePro.frame.origin.y+3, ScreenWidth, 13)];
    redBackgroundView.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    [view addSubview:redBackgroundView];
    
    //红条
    UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(-ScreenWidth-14, 0, ScreenWidth+14, 13)];
    redView.backgroundColor=RGBACOLOR(187, 33, 34, 1);
    redView.clipsToBounds=YES;
    redView.layer.cornerRadius=6;
    [redBackgroundView addSubview:redView];
    
    //低
    UILabel *safeLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, redView.frame.size.width-24, 13)];
    safeLabel.text=@"低";
    safeLabel.textColor=[UIColor whiteColor];
    safeLabel.font=[UIFont systemFontOfSize:12];
    safeLabel.textAlignment=NSTextAlignmentRight;
    [redView addSubview:safeLabel];
    
    //请完善以下资料来保护账号
    UILabel *addInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, redBackgroundView.frame.size.height+redBackgroundView.frame.origin.y+3, ScreenWidth, 18)];
    addInfoLabel.textColor=RGBACOLOR(187, 33, 34, 1);
    addInfoLabel.text=@"请完善以下资料来保护账号";
    addInfoLabel.textAlignment=NSTextAlignmentCenter;
    addInfoLabel.font=[UIFont systemFontOfSize:12];
    addInfoLabel.hidden=YES;
    [view addSubview:addInfoLabel];
    
    switch (_safeState) {
        case 0:
        {
            safeLabel.text=@"低";
            [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                redView.frame=CGRectMake(redView.frame.origin.x+ScreenWidth/3+7, redView.frame.origin.y, redView.frame.size.width, redView.frame.size.height);
            } completion:^(BOOL finished) {
                //显示‘完善资料’提示
                addInfoLabel.hidden=NO;
            }];
        }
            break;
        case 1:
        {
            safeLabel.text=@"低";
            [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                redView.frame=CGRectMake(redView.frame.origin.x+ScreenWidth/3+7, redView.frame.origin.y, redView.frame.size.width, redView.frame.size.height);
            } completion:^(BOOL finished) {
                //显示‘完善资料’提示
                addInfoLabel.hidden=NO;
            }];
        }
            break;
        case 2:
        {
            safeLabel.text=@"中";
            [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                redView.frame=CGRectMake(redView.frame.origin.x+ScreenWidth/3*2+7, redView.frame.origin.y, redView.frame.size.width, redView.frame.size.height);
            } completion:^(BOOL finished) {
                //显示‘完善资料’提示
                addInfoLabel.hidden=NO;
                
            }];
        }
            break;
        case 3:
        {
            safeLabel.text=@"高";
            safeLabel.frame = CGRectMake(safeLabel.frame.origin.x-ScreenWidth/2+10, safeLabel.frame.origin.y, safeLabel.frame.size.width, safeLabel.frame.size.height);
            safeLabel.alpha = 0;
            
            redView.backgroundColor=RGBACOLOR(78, 179, 53, 1);
            safePro.textColor=RGBACOLOR(78, 179, 53, 1);
            [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                redView.frame=CGRectMake(redView.frame.origin.x+ScreenWidth+7, redView.frame.origin.y, redView.frame.size.width, redView.frame.size.height);
                
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    safeLabel.alpha = 1;
                } completion:nil];
                
                //                safeLabel.textAlignment=NSTextAlignmentCenter;
                //隐藏‘完善资料’提示
                addInfoLabel.hidden=YES;
            }];
        }
            break;
            
        default:
            break;
    }
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersionInfoCell *cell=[[PersionInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.titleLabel.text=_titleArray[indexPath.section*3+indexPath.row];
    
    if (![isHiddleRenZheng isEqualToString:@"hiddle"])//身份认证显示的时候
    {
        if (indexPath.row==4||indexPath.row==10) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else
    {
        if (indexPath.row==4||indexPath.row==9) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    float cellHeight=0.0;
    
    cell.detailTextLabel.textColor=RGBACOLOR(180, 180, 180, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text=_detailArray[indexPath.row];
    //获取用户信息
    UserInfo *userInfo = getUser_Info;
    
    //===========修改的代码
    if (![isHiddleRenZheng isEqualToString:@"hiddle"])
    {
        switch (indexPath.row) {
            case 0:
            {
                cellHeight=69;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, 69);
                _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-45-45, 69/2-23, 50, 50)];
//                [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[[CMStoreManager sharedInstance] getUserHeader]] placeholderImage:[UIImage imageNamed:@"head_01"]];
                [_headerImageView setImage:[[CMStoreManager sharedInstance] getUserHeader]];

                _headerImageView.clipsToBounds=YES;
                _headerImageView.layer.cornerRadius=50/2;
                [cell addSubview:_headerImageView];
                [Helper imageCutView:_headerImageView cornerRadius:CGRectGetWidth(_headerImageView.frame)/2 borderWidth:1 color:[UIColor whiteColor]];
                if (_headerImg!=nil) {
                    _headerImageView.image = _headerImg;
                }
            }
                break;
            case 1:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                
            }
                break;
            case 2:
            {
                cellHeight=cellHeightDefault;
                cell.textLabel.text = @"                  ";
                cell.titleLabel.frame = CGRectMake(20, 2, 65, cellHeight);
            }
                break;
            case 3:{
                cellHeight = cellHeightDefault;
                CGFloat imgVLength = cellHeight-30;
                cell.userImgV.frame = CGRectMake(ScreenWidth-40-imgVLength, 15, imgVLength, imgVLength);
                cell.userImgV.hidden = NO;
                
            }
                break;
            case 4:
            {
                cellHeight=70;
                
                [cell addSubview:[self loadSafeView]];
            }
                break;
            case 5:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 6:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 7:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 8:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                
            }break;
            case 9:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 10:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                cell.gesSwitch.hidden = NO;
                cell.gesSwitch.frame = CGRectMake(ScreenWidth-20-50, cellHeight/2-17, 30,20 );
                //大小
                cell.gesSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                [cell.gesSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                
                if ([CacheEngine isSetPwd] && [CacheEngine isOpenGes]) {
                    [cell.gesSwitch setOn:YES animated:NO];
                }
                else
                {
                    [cell.gesSwitch setOn:NO animated:NO];
                }
            }
                break;
            case 11:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
                
            default:
                break;
        }
        
    }else
    {
        //不显示身份认证的时候
        switch (indexPath.row) {
            case 0:
            {
                cellHeight=69;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, 69);
                _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-45-45, 69/2-23, 50, 50)];
//                [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[[CMStoreManager sharedInstance] getUserHeader]] placeholderImage:[UIImage imageNamed:@"head_01"]];
                [_headerImageView setImage:[[CMStoreManager sharedInstance] getUserHeader]];
                _headerImageView.clipsToBounds=YES;
                _headerImageView.layer.cornerRadius=50/2;
                [cell addSubview:_headerImageView];
            }
                break;
            case 1:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                
            }
                break;
            case 2:
            {
                cellHeight=cellHeightDefault;
                cell.textLabel.text = @"                  ";
                cell.titleLabel.frame = CGRectMake(20, 2, 65, cellHeight);
            }
                break;
            case 3:{
                cellHeight = cellHeightDefault;
                CGFloat imgVLength = cellHeight-30;
                cell.userImgV.frame = CGRectMake(ScreenWidth-40-imgVLength, 15, imgVLength, imgVLength);
                cell.userImgV.hidden = NO;
                
            }
                break;
            case 4:
            {
                cellHeight=70;
                
                [cell addSubview:[self loadSafeView]];
            }
                break;
            case 5:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 6:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 7:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
            case 8:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                
            }break;
            case 9:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
                cell.gesSwitch.hidden = NO;
                cell.gesSwitch.frame = CGRectMake(ScreenWidth-20-50, cellHeight/2-17, 30,20 );
                //大小
                cell.gesSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
                [cell.gesSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                
                if ([CacheEngine isSetPwd] && [CacheEngine isOpenGes]) {
                    [cell.gesSwitch setOn:YES animated:NO];
                }
                else
                {
                    [cell.gesSwitch setOn:NO animated:NO];
                }
            }
                break;
            case 10:
            {
                cellHeight=cellHeightDefault;
                cell.titleLabel.frame = CGRectMake(20, 0, 65, cellHeight);
            }
                break;
                
            default:
                break;
        }
        
    }
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight-0.5, ScreenWidth, 0.5)];
    lineView.backgroundColor=RGBACOLOR(180, 180, 180, 1);
    [cell addSubview:lineView];
    
    //隐藏线
    
    if (![isHiddleRenZheng isEqualToString:@"hiddle"])//身份认证显示的时候
    {
        //第三方登录
        if ([userInfo.userGestureIsOpenidLogin isEqualToString:@"1"]) {
            if (indexPath.row==3||indexPath.row==4||indexPath.row == 7) {
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        //正常用户登录但未开启手势密码
        else if(![CacheEngine isOpenGes]){
            if (indexPath.row==3||indexPath.row==4||indexPath.row==10){
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        //开启手势密码
        else if ([CacheEngine isOpenGes]){
            if (indexPath.row==3||indexPath.row==4||indexPath.row==11){
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        
        //隐藏箭头
        if (indexPath.row==4||indexPath.row==10){
            cell.accessoryView = nil;
        }
        else{
            UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
            accessoryImageView.image = [UIImage imageNamed:@"button_02"];
            
            cell.accessoryView = accessoryImageView;
        }
        
        if (indexPath.row==9){
            if([_privateUserInfo.statusMobile isEqualToString:@"1"]){
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            
            
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        
        
    }else
    {//不显示身份认证
        //第三方登录
        if ([userInfo.userGestureIsOpenidLogin isEqualToString:@"1"]) {
            if (indexPath.row==3||indexPath.row==4||indexPath.row == 7) {
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        //正常用户登录但未开启手势密码
        else if(![CacheEngine isOpenGes]){
            if (indexPath.row==3||indexPath.row==4||indexPath.row==9){
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        //开启手势密码
        else if ([CacheEngine isOpenGes]){
            if (indexPath.row==3||indexPath.row==4||indexPath.row==10){
                lineView.hidden=YES;
            }
            else{
                lineView.hidden=NO;
            }
        }
        
        //隐藏箭头
        if (indexPath.row==4||indexPath.row==9){
            cell.accessoryView = nil;
        }
        else{
            UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
            accessoryImageView.image = [UIImage imageNamed:@"button_02"];
            
            cell.accessoryView = accessoryImageView;
        }
        
        if (indexPath.row==8){
            if([_privateUserInfo.statusMobile isEqualToString:@"1"]){
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            
            
            else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        
        
    }
    
    //是否绑定的颜色变化
    switch (indexPath.row) {
        case 5:
        {
            if ([_privateUserInfo.statusMobile isEqualToString:@"0"]) {
                cell.detailTextLabel.textColor=RGBACOLOR(226, 50, 42, 1);
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                cell.detailTextLabel.textColor=RGBACOLOR(180, 180, 180, 1);
                cell.accessoryType=UITableViewCellAccessoryNone;
                if (_privateUserInfo.mobile.length>5) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@****%@",[_privateUserInfo.mobile substringToIndex:3],[_privateUserInfo.mobile substringFromIndex:_privateUserInfo.mobile.length-4]];
                }
            }
            
        }
            break;
        case 6:
        {
            if ([_privateUserInfo.statusRealName isEqualToString:@"0"]) {
                cell.detailTextLabel.textColor=RGBACOLOR(226, 50, 42, 1);
            }
            else
            {
                cell.detailTextLabel.textColor=RGBACOLOR(180, 180, 180, 1);
                
                if ([_privateUserInfo.statusRealName isEqualToString:@"1"]) {
                    cell.detailTextLabel.text = @"已认证";
                }
                else if ([_privateUserInfo.statusRealName isEqualToString:@"2"]){
                    cell.detailTextLabel.text = @"已填写";
                }
            }
        }
            break;
        case 7:
        {
            if ([_privateUserInfo.statusBankCardBind isEqualToString:@"0"]) {
                cell.detailTextLabel.textColor=RGBACOLOR(226, 50, 42, 1);
            }
            else
            {
                cell.detailTextLabel.textColor=RGBACOLOR(180, 180, 180, 1);
                
                if ([_privateUserInfo.statusBankCardBind isEqualToString:@"1"]) {
                    cell.detailTextLabel.text = @"已绑定";
                }
                else if ([_privateUserInfo.statusBankCardBind isEqualToString:@"2"]){
                    cell.detailTextLabel.text = @"已填写";
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    cell.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![isHiddleRenZheng isEqualToString:@"hiddle"])//显示身份认证
    {
        if (indexPath.row==4||indexPath.row==10) {
            
        }else{
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
        switch (indexPath.row) {
            case 0:{
                [self initWithCamerView];
                
            }
                break;
                //昵称
            case 1:
            {
                BackButtonHeader
                NickViewController *nickVC=[[NickViewController alloc]init];
                nickVC.block=^(NSString * nick)
                {
                    [_detailArray replaceObjectAtIndex:1 withObject:nick];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                    NSArray *array=@[indexPath];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:nickVC animated:YES];
            }
                break;
                //个性签名
            case 2:
            {
                BackButtonHeader
                SignViewController *signVC=[[SignViewController alloc]init];
                signVC.privateUserInfo = _privateUserInfo;
                signVC.block=^(NSString *sign)
                {
                    if([sign isEqualToString:@""])
                    {
                        [_detailArray replaceObjectAtIndex:2 withObject:@"编辑您的个性签名"];
                    }
                    else
                    {
                        [_detailArray replaceObjectAtIndex:2 withObject:sign];
                    }
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                    NSArray *array=@[indexPath];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:signVC animated:YES];
            }
                break;
                
                
            case 3:{
                
                FindZBarViewController * findZBar = [[FindZBarViewController alloc] init];
                [self.navigationController pushViewController:findZBar animated:YES];
                
            }break;
                
                //手机号
            case 5:
            {
                
                BackButtonHeader;
                
                UIBarButtonItem *item=[[UIBarButtonItem alloc]init];
                UIImage* image = [UIImage imageNamed:@"return_1.png"];
                [item setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 80)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
                [item setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
                self.navigationItem.backBarButtonItem = item;
                
                MobileBindViewController *phoneVC=[[MobileBindViewController alloc]init];
                phoneVC.privateUserInfo = _privateUserInfo;
                if ([_privateUserInfo.statusMobile isEqualToString:@"1"]) {
                    phoneVC.isBind = YES;
                }
                else
                {
                    phoneVC.isBind = NO;
                }
                phoneVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    _privateUserInfo = privateUserInfo;
                    NSString *phone = [NSString stringWithFormat:@"%@****%@",[privateUserInfo.mobile substringToIndex:3],[privateUserInfo.mobile substringFromIndex:privateUserInfo.mobile.length-4]];
                    [_detailArray replaceObjectAtIndex:4 withObject:phone];
                    //                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                    //                NSArray *array=@[indexPath];
                    [self.tableView reloadData];
                    //                [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
                break;
                //实名认证
            case 6:
            {
                BackButtonHeader
                RealNameViewController *realVC=[[RealNameViewController alloc]init];
                //                realVC.isRenZheng = YES;
                if (![_privateUserInfo.statusRealName isEqualToString:@"1"]) {
                    realVC.isAuth=NO;
                }
                else
                {
                    realVC.isAuth=YES;
                }
                realVC.privateUserInfo=_privateUserInfo;
                realVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    _privateUserInfo=privateUserInfo;
                    [_detailArray replaceObjectAtIndex:5 withObject:@"已填写"];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
                    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                    NSArray *array=@[indexPath,indexPath3];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:realVC animated:YES];
            }
                break;
                //银行卡
            case 7:
            {
                if (![_privateUserInfo.statusRealName isEqualToString:@"0"]) {
                    BackButtonHeader
                    BankCardViewController *bankVC=[[BankCardViewController alloc]init];
                    if (![_privateUserInfo.statusBankCardBind isEqualToString:@"1"]) {
                        bankVC.isBinding=NO;
                    }
                    else
                    {
                        bankVC.isBinding=YES;
                    }
                    bankVC.privateUserInfo=_privateUserInfo;
                    bankVC.block=^(PrivateUserInfo *privateUserInfo)
                    {
                        [_detailArray replaceObjectAtIndex:6 withObject:@"已填写"];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                        NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                        NSArray *array=@[indexPath,indexPath3];
                        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                    };
                    [self.navigationController pushViewController:bankVC animated:YES];
                }
                else
                {
                    [[UIEngine sharedInstance] showAlertWithTitle:@"真实信息是您今后提现的唯一凭证，请先进行实名认证" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"认证"];
                    [UIEngine sharedInstance].alertClick=^(int aIndex)
                    {
                        if (aIndex==10087) {
                            BackButtonHeader
                            RealNameViewController *realVC=[[RealNameViewController alloc]init];
                            if (![_privateUserInfo.statusRealName isEqualToString:@"1"]) {
                                realVC.isAuth=NO;
                            }
                            else
                            {
                                realVC.isAuth=YES;
                            }
                            realVC.privateUserInfo=_privateUserInfo;
                            realVC.block=^(PrivateUserInfo *privateUserInfo)
                            {
                                _privateUserInfo=privateUserInfo;
                                [_detailArray replaceObjectAtIndex:5 withObject:@"已填写"];
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
                                NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                                NSArray *array=@[indexPath,indexPath3];
                                [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                            };
                            [self.navigationController pushViewController:realVC animated:YES];
                        }
                    };
                }
            }
                break;
            case 8:
            {
                //身份认证
                //先判断用户是否进行了实名认证和银行卡信息填写
                BOOL idCard = [_privateUserInfo.statusRealName isEqualToString:@"1"] || [_privateUserInfo.statusRealName isEqualToString:@"2"];
                BOOL bank = [_privateUserInfo.statusBankCardBind isEqualToString:@"1"] || [_privateUserInfo.statusBankCardBind isEqualToString:@"2"];
                if (idCard && bank) {
                    
                    ShengfenRenZhengViewController *shenCtrl = [[ShengfenRenZhengViewController alloc]init];
                    shenCtrl.userInfo = _privateUserInfo;
                    shenCtrl.shenHeStatus = _detailArray[8];
                    shenCtrl.infoArray = imageDetailArray;
                    shenCtrl.faileMsg  = failinfoMsg;
                    
                    [self.navigationController pushViewController:shenCtrl animated:YES];
                    
                }else if(!idCard)
                {
                    [UIEngine showShadowPrompt:@"实名信息未填写"];
                }else
                {
                    [UIEngine showShadowPrompt:@"银行卡信息未填写"];
                }
            }
                break;
                
                //修改密码
            case 9:
            {
                if ([_privateUserInfo.statusMobile isEqualToString:@"1"]) {
                    BackButtonHeader
                    PasswordViewController *passVC=[[PasswordViewController alloc]init];
                    [self.navigationController pushViewController:passVC animated:YES];
                }
            }
                break;
                //修改手势
            case 11:
            {
                [[UIEngine sharedInstance] showAuthLoginPWD];
                [UIEngine sharedInstance].authClick = ^(int aIndex, NSString *loginPwd){
                    if (aIndex == 10086) {
                        
                    }
                    else if (aIndex == 10087){
                        
                        if (loginPwd != nil && loginPwd.length<6) {
                            [UIEngine showShadowPrompt:@"密码长度不够"];
                        }
                        else{
                            [UIEngine sharedInstance].progressStyle = 1;
                            [[UIEngine sharedInstance] showProgress];
                            [DataEngine requestToAuthLoginPWD:loginPwd Complete:^(BOOL SUCCESS, NSString *msg, NSString *data) {
                                [[UIEngine sharedInstance] hideProgress];
                                if (SUCCESS) {
                                    [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *gesPwd) {
                                        [CacheEngine setGesPwd:gesPwd];
                                        [CacheEngine setOpenGes:YES];
                                        [lockVC dismiss:0.0f];
                                    }];
                                }
                                else
                                {
                                    if (msg.length>0) {
                                        [UIEngine showShadowPrompt:msg];
                                        if ([data floatValue] == 2) {
                                            [self exit];
                                        }
                                    }else{
                                        //                                        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                                    }
                                }
                            }];
                        }
                        
                    }
                };
                
            }
                break;
            default:
                break;
        }
        
    }else
    {//不显示身份认证
        if (indexPath.row==4||indexPath.row==9) {
            
        }else{
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
        switch (indexPath.row) {
            case 0:{
                [self initWithCamerView];
                
            }
                break;
                //昵称
            case 1:
            {
                BackButtonHeader
                NickViewController *nickVC=[[NickViewController alloc]init];
                nickVC.block=^(NSString * nick)
                {
                    [_detailArray replaceObjectAtIndex:1 withObject:nick];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                    NSArray *array=@[indexPath];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:nickVC animated:YES];
            }
                break;
                //个性签名
            case 2:
            {
                BackButtonHeader
                SignViewController *signVC=[[SignViewController alloc]init];
                signVC.privateUserInfo = _privateUserInfo;
                signVC.block=^(NSString *sign)
                {
                    if([sign isEqualToString:@""])
                    {
                        [_detailArray replaceObjectAtIndex:2 withObject:@"编辑您的个性签名"];
                    }
                    else
                    {
                        [_detailArray replaceObjectAtIndex:2 withObject:sign];
                    }
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                    NSArray *array=@[indexPath];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:signVC animated:YES];
            }
                break;
                
                
            case 3:{
                
                FindZBarViewController * findZBar = [[FindZBarViewController alloc] init];
                [self.navigationController pushViewController:findZBar animated:YES];
                
            }break;
                
                //手机号
            case 5:
            {
                
                BackButtonHeader;
                
                UIBarButtonItem *item=[[UIBarButtonItem alloc]init];
                UIImage* image = [UIImage imageNamed:@"return_1.png"];
                [item setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 80)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
                [item setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
                self.navigationItem.backBarButtonItem = item;
                
                MobileBindViewController *phoneVC=[[MobileBindViewController alloc]init];
                phoneVC.privateUserInfo = _privateUserInfo;
                if ([_privateUserInfo.statusMobile isEqualToString:@"1"]) {
                    phoneVC.isBind = YES;
                }
                else
                {
                    phoneVC.isBind = NO;
                }
                phoneVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    _privateUserInfo = privateUserInfo;
                    NSString *phone = [NSString stringWithFormat:@"%@****%@",[privateUserInfo.mobile substringToIndex:3],[privateUserInfo.mobile substringFromIndex:privateUserInfo.mobile.length-4]];
                    [_detailArray replaceObjectAtIndex:4 withObject:phone];
                    //                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                    //                NSArray *array=@[indexPath];
                    [self.tableView reloadData];
                    //                [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
                break;
                //实名认证
            case 6:
            {
                BackButtonHeader
                RealNameViewController *realVC=[[RealNameViewController alloc]init];
                //                realVC.isRenZheng = YES;
                if (![_privateUserInfo.statusRealName isEqualToString:@"1"]) {
                    realVC.isAuth=NO;
                }
                else
                {
                    realVC.isAuth=YES;
                }
                realVC.privateUserInfo=_privateUserInfo;
                realVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    _privateUserInfo=privateUserInfo;
                    [_detailArray replaceObjectAtIndex:5 withObject:@"已填写"];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
                    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                    NSArray *array=@[indexPath,indexPath3];
                    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:realVC animated:YES];
            }
                break;
                //银行卡
            case 7:
            {
                if (![_privateUserInfo.statusRealName isEqualToString:@"0"]) {
                    BackButtonHeader
                    BankCardViewController *bankVC=[[BankCardViewController alloc]init];
                    if (![_privateUserInfo.statusBankCardBind isEqualToString:@"1"]) {
                        bankVC.isBinding=NO;
                    }
                    else
                    {
                        bankVC.isBinding=YES;
                    }
                    bankVC.privateUserInfo=_privateUserInfo;
                    bankVC.block=^(PrivateUserInfo *privateUserInfo)
                    {
                        [_detailArray replaceObjectAtIndex:6 withObject:@"已填写"];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                        NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                        NSArray *array=@[indexPath,indexPath3];
                        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                    };
                    [self.navigationController pushViewController:bankVC animated:YES];
                }
                else
                {
                    [[UIEngine sharedInstance] showAlertWithTitle:@"真实信息是您今后提现的唯一凭证，请先进行实名认证" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"认证"];
                    [UIEngine sharedInstance].alertClick=^(int aIndex)
                    {
                        if (aIndex==10087) {
                            BackButtonHeader
                            RealNameViewController *realVC=[[RealNameViewController alloc]init];
                            if (![_privateUserInfo.statusRealName isEqualToString:@"1"]) {
                                realVC.isAuth=NO;
                            }
                            else
                            {
                                realVC.isAuth=YES;
                            }
                            realVC.privateUserInfo=_privateUserInfo;
                            realVC.block=^(PrivateUserInfo *privateUserInfo)
                            {
                                _privateUserInfo=privateUserInfo;
                                [_detailArray replaceObjectAtIndex:5 withObject:@"已填写"];
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
                                NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
                                NSArray *array=@[indexPath,indexPath3];
                                [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                            };
                            [self.navigationController pushViewController:realVC animated:YES];
                        }
                    };
                }
            }
                break;
                //修改密码
            case 8:
            {
                if ([_privateUserInfo.statusMobile isEqualToString:@"1"]) {
                    BackButtonHeader
                    PasswordViewController *passVC=[[PasswordViewController alloc]init];
                    [self.navigationController pushViewController:passVC animated:YES];
                }
            }
                break;
                //修改手势
            case 10:
            {
                [[UIEngine sharedInstance] showAuthLoginPWD];
                [UIEngine sharedInstance].authClick = ^(int aIndex, NSString *loginPwd){
                    if (aIndex == 10086) {
                        
                    }
                    else if (aIndex == 10087){
                        
                        if (loginPwd != nil && loginPwd.length<6) {
                            [UIEngine showShadowPrompt:@"密码长度不够"];
                        }
                        else{
                            [UIEngine sharedInstance].progressStyle = 1;
                            [[UIEngine sharedInstance] showProgress];
                            [DataEngine requestToAuthLoginPWD:loginPwd Complete:^(BOOL SUCCESS, NSString *msg, NSString *data) {
                                [[UIEngine sharedInstance] hideProgress];
                                if (SUCCESS) {
                                    [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *gesPwd) {
                                        [CacheEngine setGesPwd:gesPwd];
                                        [CacheEngine setOpenGes:YES];
                                        [lockVC dismiss:0.0f];
                                    }];
                                }
                                else
                                {
                                    if (msg.length>0) {
                                        [UIEngine showShadowPrompt:msg];
                                        if ([data floatValue] == 2) {
                                            [self exit];
                                        }
                                    }else{
                                        //                                        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                                    }
                                }
                            }];
                        }
                        
                    }
                };
                
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark 退出登录

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil]];
}

- (void)resetDefaults {
    //    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    //    NSDictionary * dict = [defs dictionaryRepresentation];
    //    for (id key in dict) {
    //        if ([key isEqualToString:@"Environment"]||[key isEqualToString:@"UmengCode"]) {
    //
    //        }else{
    //
    //            [defs removeObjectForKey:key];
    //        }}
    //    [defs synchronize];
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
    
}


-(void)exit
{
    
    [self sendNotification];
    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
    [self resetDefaults];
    [[CMStoreManager sharedInstance] setbackgroundimage];
    [[CMStoreManager sharedInstance] storeUserToken:nil];
    [self.navigationController popViewControllerAnimated:NO];
    saveUserDefaults(firstLoginStr, @"FirstLogin");
}

-(void)setHeader
{
    [self initWithCamerView];
    
}

#pragma mark - 初始化拍照，从相册选择，取消按钮
- (void)initWithCamerView
{
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //
    //    NSArray * array = [[UIApplication sharedApplication] windows];
    //
    //    if (array.count >= 2) {
    //
    //        window = [array objectAtIndex:1];
    //
    //    }
    
    _addView = [[UIView alloc]init];
    _addView.backgroundColor = [UIColor blackColor];
    _addView.alpha = 0.3;
    _addView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    [self.view addSubview:_addView];
    
    NSArray *titleArray = @[@"拍照",@"从相册选择",@"取消"];
    CGFloat btnHeight = 45*ScreenWidth/320;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i*(btnHeight+1) + ScreenHeigth - btnHeight*3 - 10, ScreenWidth, btnHeight);
        if (i == 2) {
            button.frame = CGRectMake(0,ScreenHeigth - btnHeight, ScreenWidth, btnHeight);
        }
        button.tag = 10000 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.view addSubview:button];
        if (i == 0)
        {
            [button setTitleColor:K_color_red forState:UIControlStateNormal];
        }
        

    }
    
    
}
#pragma mark UIActionSheetDelegate
- (void)clickAction:(UIButton *)sender
{
    if (sender.tag == 10000) {
        [self removeCamerView];
        //判断是否可以打开相机，模拟器此功能无法使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = NO;  //是否可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
            [alert show];
        }
        // 拍照
        
    } else if (sender.tag == 10001) {
        [self removeCamerView];
        // 从相册中选取
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if(sender.tag == 10002)
    {
        [self removeCamerView];
    }
}
- (void)removeCamerView
{
    [_addView removeFromSuperview];
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:10000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:10001];
    
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:10002];
    [btn1 removeFromSuperview];
    [btn2 removeFromSuperview];
    [btn3 removeFromSuperview];
}

#pragma mark - 打开相机后，需要调用UINavigationControllerDelegate里的方法，拍摄完成后执行的方法和点击Cancel之后的执行方法。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        NJImageCropperViewController *imgEditorVC = [[NJImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(NJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _headerImg=editedImage;
//    UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil);
    NSString * userHeader = @"photoFile";
    NSString * imgPath = NSHomeDirectory();
    NSString * newFilePath = [[imgPath stringByAppendingPathComponent:@"Documents" ]stringByAppendingPathComponent:@"photoFile.png"];
    NSLog(@"%@",newFilePath);
    NSData * userHeaderData = UIImageJPEGRepresentation(editedImage, 1);
    [userHeaderData writeToFile:newFilePath atomically:YES];
    [RequestDataModel updateUserHeaderImageWithImage:userHeaderData imageDetail:@{@"name":userHeader,@"fileName":newFilePath} successBlock:^(BOOL success, NSDictionary* dictionary) {
        NSLog(@"%@",dictionary);
        if (success) {
            NSString * str = [NSString stringWithFormat:@"%@?abc=%@",dictionary[@"data"],[Helper randomGet]];
            [[CMStoreManager sharedInstance] setUSerHeaderAddress:str];
            [_tableView reloadData];
            [UIEngine showShadowPrompt:@"头像设置成功"];
        }else
        {
            [UIEngine showShadowPrompt:@"头像设置失败"];
        }
    }];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}
- (void)imageCropperDidCancel:(NJImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}




#pragma mark Cell Switch -- -- 手势开关

-(void)switchChange:(UISwitch *)aSwitch
{
    if ([aSwitch isOn]) {
        if (![CacheEngine isOpenGes] && ![CacheEngine isSetPwd]) {
            [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                [lockVC dismiss:0.0f];
                [CacheEngine setGesPwd:pwd];
                [CacheEngine setOpenGes:YES];
                [self isOpenGesture:@"1"];
            }];
        }
        else{
            [CacheEngine setOpenGes:YES];
            
            [self isOpenGesture:@"1"];
        }
    }
    //关闭手势密码
    else{
        [[UIEngine sharedInstance] showAuthLoginPWD];
        [UIEngine sharedInstance].authClick = ^(int aIndex, NSString * pwd){
            if (aIndex == 10086) {
                [aSwitch setOn:YES animated:YES];
            }
            else if (aIndex == 10087){
                
                if (pwd != nil && pwd.length<6) {
                    [UIEngine showShadowPrompt:@"密码长度不够"];
                    [aSwitch setOn:YES animated:YES];
                }
                else{
                    [UIEngine sharedInstance].progressStyle = 1;
                    [[UIEngine sharedInstance] showProgress];
                    [DataEngine requestToAuthLoginPWD:pwd Complete:^(BOOL SUCCESS, NSString *msg, NSString *data) {
                        [[UIEngine sharedInstance] hideProgress];
                        if (SUCCESS) {
                            
                            [self isOpenGesture:@"0"];
                            [CacheEngine setOpenGes:NO];
                        }
                        else{
                            [[UIEngine sharedInstance] hideProgress];
                            [aSwitch setOn:YES animated:YES];
                            if (msg.length>0) {
                                [UIEngine showShadowPrompt:msg];
                                if ([data floatValue] == 2) {
                                    [self exit];
                                }
                            }
                            else
                            {
                                //                                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                            }
                        }
                    }];
                }
                
                
            }
        };
    }
}

//是否开启手势密码 0：不开启，1：开启

-(void)isOpenGesture:(NSString *)aState
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
    PersionInfoCell *cell = (PersionInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    if ([aState isEqualToString:@"0"]) {
        [CacheEngine setOpenGes:NO];
        [cell.gesSwitch setOn:NO animated:YES];
    }
    else if ([aState isEqualToString:@"1"]){
        [CacheEngine setOpenGes:YES];
        [cell.gesSwitch setOn:YES animated:YES];
    }
    [_tableView reloadData];
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
