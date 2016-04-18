//
//  AccountUserView.m
//  hs
//
//  Created by PXJ on 16/2/19.
//  Copyright © 2016年 luckin. All rights reserved.
//
//账户页面用户headerView
#define setBtn_tag 77770
#define loginBtn_tag 77771
#define registBtn_tag 77772
#define userHeaderBtn_tag 77773
#define userQRBtn_tag 77774
#define userHeaderbounds 65*ScreenWidth/375
#import "AccountUserView.h"
#import "UIImageView+WebCache.h"

@implementation AccountUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*

 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){

        [self initUI];
        [self initUnloginUI];
        [self initLoginUI];
    }
    return self;
}
- (void)initUI
{
    UIImageView * backImgV =[[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*200/375)];
    backImgV.image = [UIImage imageNamed:@"account_back"];
    [self addSubview:backImgV];
    
    UIImageView *settingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-44-15+19, 20+12, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    settingImageView.image = [UIImage imageNamed:@"setting"];
    [self addSubview:settingImageView];

    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.frame =CGRectMake(ScreenWidth-44-15, 20, 44, 44);
    self.setBtn.tag = setBtn_tag;
    [self.setBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.setBtn];
    
    
}
- (void)initUnloginUI
{
    _adLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*ScreenWidth/375, ScreenWidth, 20*ScreenWidth/375)];
    _adLab.text = @"金融社交平台，只为更简单";
    _adLab.textAlignment = NSTextAlignmentCenter;
    _adLab.font = FontSize(13);
    _adLab.textColor = [UIColor whiteColor];
    [self addSubview:_adLab];
    

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(35, 120*ScreenWidth/375, (ScreenWidth-80)/2, 42*ScreenWidth/375);
    _loginBtn.backgroundColor = Color_loginYellow;
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.tag = loginBtn_tag;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:FontSize(15)];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    _RegistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _RegistBtn.frame = CGRectMake(CGRectGetMaxX(_loginBtn.frame)+10, 120*ScreenWidth/375, (ScreenWidth-80)/2, 42*ScreenWidth/375);
    _RegistBtn.backgroundColor = Color_registeRed;
    _RegistBtn.layer.cornerRadius = 5;
    _RegistBtn.layer.masksToBounds = YES;
    _RegistBtn.tag = registBtn_tag;
    [_RegistBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_RegistBtn.titleLabel setFont:FontSize(15)];
    [_RegistBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RegistBtn];
}
- (void)initLoginUI
{
    _userHeaderImgV = [[UIImageView alloc] init];
    _userHeaderImgV.center = CGPointMake(ScreenWidth/2, 96*ScreenWidth/375);
    _userHeaderImgV.bounds = CGRectMake(0, 0, userHeaderbounds, userHeaderbounds);
    [Helper imageCutView:_userHeaderImgV cornerRadius:userHeaderbounds/2 borderWidth:2 color:[UIColor whiteColor]];
    [self addSubview:_userHeaderImgV];

    
    _headerEditImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderImgV.frame)-17*ScreenWidth/375, CGRectGetMinY(_userHeaderImgV.frame)+1, 14*ScreenWidth/375, 14*ScreenWidth/375)];
    _headerEditImgV.image = [UIImage imageNamed:@"headerEdit"];
    [self addSubview:_headerEditImgV];
    
    _userHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userHeaderBtn.center = _userHeaderImgV.center;
    _userHeaderBtn.bounds = _userHeaderImgV.bounds;
    _userHeaderBtn.tag = userHeaderBtn_tag;
    [_userHeaderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userHeaderBtn];
    
    
    
    
    _userNickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userNickBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(_userHeaderImgV.frame)+20);
    _userNickBtn.bounds = CGRectMake(0, 0, ScreenWidth-60, 20);
    _userNickBtn.tag = userHeaderBtn_tag;

    [_userNickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userNickBtn.titleLabel setFont:FontSize(15)];
    [_userNickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userNickBtn];
    
    
    _userSignLab = [[UILabel alloc] init ];
    _userSignLab.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(_userNickBtn.frame)+10);
    _userSignLab.bounds = CGRectMake(0, 0, ScreenWidth-60, 20);
    _userSignLab.font = FontSize(12);
    _userSignLab.textColor = [UIColor whiteColor];
    _userSignLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_userSignLab];

    
    
    _userSignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userSignBtn.frame = _userSignLab.frame;
    _userSignBtn.tag = userHeaderBtn_tag;
    [_userSignBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self addSubview:_userSignBtn];

    
    
    _userQRcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userQRcodeBtn.frame = CGRectMake(15, 20, 44, 44);
    _userQRcodeBtn.tag = userQRBtn_tag;
    [_userQRcodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userQRcodeBtn];

    _userQRcodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 32, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    _userQRcodeImgV.image = [UIImage imageNamed:@"userQR"];
    [self addSubview:_userQRcodeImgV];
    
}

- (void)updateUserViewWithDetail:(NSDictionary*)dic
{
    BOOL islogin = [[CMStoreManager sharedInstance] isLogin];
    _headerEditImgV.hidden = _userQRcodeImgV.hidden = _userQRcodeBtn.hidden = _userHeaderBtn.hidden = _userHeaderImgV.hidden = _userNickBtn.hidden = _userSignBtn.hidden = _userSignLab.hidden = !islogin;
    _adLab.hidden = _loginBtn.hidden = _RegistBtn.hidden = islogin;
    if (islogin) {

        [_userHeaderImgV setImage:[[CMStoreManager sharedInstance] getUserHeader]];
        [_userNickBtn setTitle:[[CMStoreManager sharedInstance]getUserNick] forState:UIControlStateNormal];
        NSString * userSign = [[CMStoreManager sharedInstance]getUserSign].length==0?@"编辑个性签名":[[CMStoreManager sharedInstance]getUserSign];
        if(userSign.length>15)
        {
            userSign = [NSString stringWithFormat:@"%@...",[userSign substringToIndex:15]];
        }
        _userSignLab.text = userSign;
    }
}

- (void)btnClick:(UIButton*)btn
{
    self.userclickBlock(btn);
}

@end
