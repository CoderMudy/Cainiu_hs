//
//  AccountRechargeViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AccountRechargeViewController.h"
#import "HSInputView.h"
#import "DetailViewController.h"
#import "SecondStepRechargeController.h"
#import "QuickRechargeWebPage.h"
#import "PopUpView.h"
#import "H5LinkPage.h"
#import "BankPositionLIstViewController.h"
#import "FindKeFuController.h"
@interface AccountRechargeViewController ()
{
    UIView *_contentView;
    UILabel *_banckNameLabel;
    UIImageView *_bankIconView;
    NSArray     *_bankIconArray;
    UILabel *_cardNumLabel;
    UITextField *inputText;
    UIButton *_checkBut;
    UIButton *_addBut;
    
    NSString *_bankID;
    
    UIScrollView    *_scrollView;
}

@end

@implementation AccountRechargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    if (self.appearStyle==2) {
        [self backAccountView];
        self.appearStyle =1;
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    removeTextFileNotification;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appearStyle = 1;
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout                   = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    _bankIconArray=@[@"guangfa",@"pufa",@"xingye",@"zhaoshang",@"zhongguo",
//                     @"nongye",@"jianshe",@"guangda",@"pingan",@"minsheng",
//                     @"huaxia",@"gongshang",@"jiaotong",@"zhongxin"
//                     ];

    [self setNavTitle:@"账户充值"];
    [self setNavLeftBut:NSPushMode];
    [self setUpForDismissKeyboard];

    
    [self initUI];
//    [self authBankCard];
    self.customLeft = YES;
    
    AccountRechargeViewController *accountVC = self;
    
    self.leftClick = ^(void){
        
        if (self.intoStatus == 2) {
            UIViewController *vc = (UIViewController *)accountVC.navigationController.viewControllers[2];
            [accountVC.navigationController popToViewController:vc animated:YES];
        }
        else{
            [accountVC.navigationController popViewControllerAnimated:YES];
        }
        
    };
    
}

-(void)authBankCard
{
    
    NSArray * bankNameArray=@[@"广发银行",@"浦发银行",@"兴业银行",@"招商银行",@"中国银行",
                     @"中国农业银行",@"中国建设银行",@"中国光大银行",@"平安银行",@"中国民生银行",
                     @"华夏银行",@"中国工商银行",@"交通银行",@"中信银行"
                     ];
    
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"])
            {
                
                _banckNameLabel.text = bankName;
                _cardNumLabel.text = [NSString stringWithFormat:@"尾号%@",[bankCard substringFromIndex:bankCard.length-4]];
                
                for (int i = 0; i<bankNameArray.count; i++) {
                    if ([bankName isEqualToString:bankNameArray[i]]) {
                        _bankIconView.image = [UIImage imageNamed:_bankIconArray[i]];
                    }
                }
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            if (status.length>0)
            {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}
- (void)initUI
{
    
    
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _scrollView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeigth+2);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    

    _contentView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    [_scrollView addSubview:_contentView];
    
    if (_rechargeWay==1) {

    }else{
        _banckNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-40, 10, _contentView.frame.size.width, 20)];
        [_banckNameLabel setTextColor:MAINTEXTCOLOR];
        [_contentView addSubview:_banckNameLabel];
        
        _cardNumLabel = [[UILabel alloc]  initWithFrame:CGRectMake(ScreenWidth/2-40, _banckNameLabel.frame.origin.y+_banckNameLabel.frame.size.height, _banckNameLabel.frame.size.width, _banckNameLabel.frame.size.height)];
        [_cardNumLabel setTextColor:SUBTEXTCOLOR];
        _cardNumLabel.font = [UIFont systemFontOfSize:12];
        [_contentView addSubview:_cardNumLabel];
        
        _bankIconView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-24-40-10, 40/2-12+10, 24, 24)];
        [_contentView addSubview:_bankIconView];
        
        
        UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _cardNumLabel.frame.origin.y+_cardNumLabel.frame.size.height+10, ScreenWidth, 25)];
        proLabel.text = @"单笔限额5000元，每日限额50000元，免手续费";
        proLabel.font = [UIFont systemFontOfSize:13];
        proLabel.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.5];
        proLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
        proLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:proLabel];
        
    }
    
    
    addTextFieldNotification(textFieldValueChang);
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(0, 20, ScreenWidth, 45);
    [_contentView addSubview:whiteView];
    
    UILabel *moneyLab = [[UILabel alloc]init];
    moneyLab.text = @"金额";
    moneyLab.frame = CGRectMake(20, 12, 40, 21);
    moneyLab.font = [UIFont systemFontOfSize:14.0];
    moneyLab.textColor = [UIColor blackColor];
    [whiteView addSubview:moneyLab];
    
    inputText = [[UITextField alloc]init];
    inputText.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame) + 20, 5, ScreenWidth - CGRectGetMaxX(moneyLab.frame) - 30, 35);
    inputText.placeholder = @"充值金额≥50";
    inputText.clearButtonMode = UITextFieldViewModeAlways;//系统默认的叉
    inputText.font = [UIFont systemFontOfSize:14];
    inputText.keyboardType = UIKeyboardTypeDecimalPad;
    inputText.backgroundColor = [UIColor whiteColor];
    [inputText addTarget:self action:@selector(textFieldValueChang) forControlEvents:UIControlEventValueChanged];
    [whiteView addSubview:inputText];
    
    NIAttributedLabel *protocolLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteView.frame) + 20, ScreenWidth, 20)];
    [protocolLabel setFont:[UIFont systemFontOfSize:12]];
    [protocolLabel setTextAlignment:NSTextAlignmentCenter];
    protocolLabel.text = @"我已阅读并同意《充值服务协议》";
    protocolLabel.textColor = SUBTEXTCOLOR;
    [protocolLabel setTextColor:RGBACOLOR(48, 115, 204, 1) range:[protocolLabel.text rangeOfString:@"《充值服务协议》"]];
    //[protocolLabel insertImage:[UIImage imageNamed:@"button_09.png"] atIndex:0];
    [protocolLabel setTextAlignment:NSTextAlignmentCenter];
    [protocolLabel setUserInteractionEnabled:YES];
    [_contentView addSubview:protocolLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtocolLabel)];
    [protocolLabel addGestureRecognizer:tap];
    
    CGSize tempSize = [protocolLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    UIImage *checkImage = [UIImage imageNamed:@"button_09"];
    UIImage *unCheckImage = [UIImage imageNamed:@"button_10"];
    _checkBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBut setFrame:CGRectMake((WIDTH(protocolLabel)-tempSize.width)/2-checkImage.size.width+15, Y(protocolLabel)+(HEIGHT(protocolLabel)-checkImage.size.height)/2-2, 15, 15)];
    [_checkBut setImage:checkImage forState:UIControlStateSelected];
    [_checkBut setImage:unCheckImage forState:UIControlStateNormal];
    [_checkBut setSelected:YES];
    [_contentView addSubview:_checkBut];
    
    _checkBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if ([_checkBut isSelected]) {
            [_checkBut setSelected:NO];
            _addBut.enabled = NO;
            [_addBut setBackgroundColor:[UIColor lightGrayColor]];
            
        }else{
            [_checkBut setSelected:YES];
            
            if (inputText.text.length>0) {
                _addBut.enabled = YES;
                [_addBut setBackgroundColor:CanSelectButBackColor];
            }
            else
            {
                _addBut.enabled = NO;
                [_checkBut setSelected:YES];
                [_addBut setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
        return [RACSignal empty];
    }];
    
    _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBut setFrame:CGRectMake(20, protocolLabel.frame.origin.y+protocolLabel.frame.size.height+10, ScreenWidth-40, 44)];
    [_addBut setBackgroundColor:[UIColor lightGrayColor]];
    [_addBut setTitle:@"提交" forState:UIControlStateNormal];
    [_addBut addTarget:self action:@selector(clickAddBut) forControlEvents:UIControlEventTouchUpInside];
    _addBut.layer.cornerRadius = 5.0;
    [_addBut setUserInteractionEnabled:NO];
    [_contentView addSubview:_addBut];
    
    //支付宝
//    UIImageView *zfbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _addBut.frame.origin.y+_addBut.frame.size.height+20, 20, 20)];
////    zfbImageView.backgroundColor = [UIColor redColor];
//    zfbImageView.image  = [UIImage imageNamed:@"zhifubao"];
//    zfbImageView.clipsToBounds = YES;
//    zfbImageView.layer.cornerRadius = 15/2.0;
//    [_contentView addSubview:zfbImageView];
//    
//    UILabel *zfbLabel = [[UILabel alloc]initWithFrame:CGRectMake((zfbImageView.frame.origin.x+zfbImageView.frame.size.width+6), 0, ScreenWidth-40-16, 15)];
//    zfbLabel.center = CGPointMake(zfbLabel.center.x, zfbImageView.center.y);
//    zfbLabel.text = @"浙江来客赢信息科技有限公司  支付宝：zfb@cainiu.com";
//    zfbLabel.font = [UIFont systemFontOfSize:10];
//    [_contentView addSubview:zfbLabel];
//    
//    UILabel *zfbProLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, zfbLabel.frame.origin.y+zfbLabel.frame.size.height+10, ScreenWidth-20, 15)];
//    zfbProLabel.text = @"可转账至公司支付宝账户并备注手机号，完成后请及时联系客服！";
//    zfbProLabel.font = [UIFont systemFontOfSize:10];
//    zfbProLabel.textColor = [UIColor lightGrayColor];
//    [_contentView addSubview:zfbProLabel];
    
//    UIButton    *zfbClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    zfbClickBtn.frame = CGRectMake(0, zfbLabel.frame.origin.y, ScreenWidth, zfbProLabel.frame.origin.y+zfbProLabel.frame.size.height-zfbLabel.frame.origin.y);
//    [zfbClickBtn addTarget:self action:@selector(goZFB) forControlEvents:UIControlEventTouchUpInside];
//    [_contentView addSubview:zfbClickBtn];
    
    UILabel     *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_addBut.frame), ScreenWidth-40, 120)];
    NSString * proText = [NSString stringWithFormat:@"温馨提示： \n\n1、为防止套现和洗钱，单笔充值无消费者提现时需提供身份证和银行卡给风控进行核实。如信息核实无误，%@将会在7-15个工作日内处理，银行收取2%%的手续费自理，最低2元； ",App_appShortName];
    proLabel.text = proText;
    
    proLabel.font = [UIFont systemFontOfSize:12];
    proLabel.textAlignment = NSTextAlignmentLeft;
    proLabel.numberOfLines = 0;
    proLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
//    proLabel.userInteractionEnabled = YES;
    [_contentView addSubview:proLabel];
    
    proLabel.attributedText = [self attributeString:proLabel.text];
    
    //===
    UILabel *bankLab = [[UILabel alloc]init];
//    bankLab.backgroundColor = [UIColor redColor];
    bankLab.frame = CGRectMake(CGRectGetMinX(proLabel.frame), CGRectGetMaxY(proLabel.frame) - 20, ScreenWidth - 40, 20);
    bankLab.textAlignment = NSTextAlignmentLeft;
    bankLab.font = [UIFont systemFontOfSize:12.0];
    bankLab.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    bankLab.userInteractionEnabled = YES;
    NSString *bankStr = @"2、各银行具体充值额度查看《银行卡额度表》";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:bankStr];
     NSMutableAttributedString * mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [mulStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(bankStr.length - 8, 8)];
    bankLab.attributedText = mulStr;
    
    [_contentView addSubview:bankLab];
    
    UITapGestureRecognizer *supportBinkTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(supportBink)];
    [bankLab addGestureRecognizer:supportBinkTapGes];
    
    
    [inputText.rac_textSignal subscribeNext:^(id text){
        if ([text integerValue] >= 0 && [_checkBut isSelected]) {
            [_addBut setBackgroundColor:CanSelectButBackColor];
            [_addBut setUserInteractionEnabled:YES];
        }else{
            [_addBut setBackgroundColor:[UIColor lightGrayColor]];
            [_addBut setUserInteractionEnabled:NO];
        }
    }];
}


-(NSMutableAttributedString *)attributeString:(NSString *)aStr
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:13] range:NSMakeRange(0, 5)];
    NSMutableAttributedString * mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [mulStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
//    [mulStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(aStr.length-8, 8)];
    return mulStr;
}

-(void)supportBink{
    BankPositionLIstViewController   *supprotVC = [[BankPositionLIstViewController alloc]init];
    [self.navigationController pushViewController:supprotVC animated:YES];
}

-(void)goZFB{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = App_zfbAccount;
    
    [[UIEngine sharedInstance] showAlertWithTitle:@"账号已复制到剪切板！支付宝最低充值金额50元，您确定要充值吗？" ButtonNumber:2 FirstButtonTitle:@"去充值" SecondButtonTitle:@"不了"];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        if (aIndex == 10086) {
            NSString * URLString = @"alipays://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        }
    };
}

-(void)textFieldValueChang
{
    if (inputText.text.length > 0) {
        _addBut.enabled = YES;
    }
}

- (void)clickAddBut
{
    
    [self.view endEditing:YES];
    if ([UIEngine checkMoney:inputText]) {
        //过滤最小充值
        if ([inputText.text floatValue] < 50) {
            [[UIEngine sharedInstance] showAlertWithTitle:@"最小充值金额50元" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
            };
            return ;
        }else if([inputText.text floatValue] > 50000)
        {
        
            [[UIEngine sharedInstance] showAlertWithTitle:@"最大可输入金额50000元" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
            };
            return ;
        
        
        
        
        
        }
        switch (self.rechargeWay) {
            case 1:
            {
            
                
                [self rechargeRequest];
                
                
                
            }
                break;
            case 2:
            {
                
                
                
                
                SecondStepRechargeController *secondVC = [[SecondStepRechargeController alloc] init];
                secondVC.rechargeMoney = [inputText.text integerValue];
                secondVC.bankName = _banckNameLabel.text;
                secondVC.cardNum = _cardNumLabel.text;
                secondVC.bankID = _bankID;
                secondVC.bankIcon = _bankIconView.image;
                [secondVC setNavLeftBut:NSPushMode];
                [self.navigationController pushViewController:secondVC animated:YES];
                
            }
                break;
            default:
                break;
        }
        

    }
}

//快钱支付请求

- (void)rechargeRequest
{
    
    [DataEngine requestRecharge:inputText.text Complete:^(BOOL SUCCESS, NSString *string ) {
        
        
        if (SUCCESS) {
            
            QuickRechargeWebPage * VC = [[QuickRechargeWebPage alloc] init];
            VC.webUrl = string;
            VC.superVC = self;
            VC.intoStatus = self.intoStatus;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
        
            NSLog(@"%@",string);
        }

    }];
}

//充值返回拦截；
- (void)backAccountView
{
    
    NSArray * array = [NSArray array];
    
    if (AppStyle_SAlE) {
        array = @[@"联系在线客服",@"查看常见问题"];
        
    }else {
        NSString * tel = @"";
#if defined (YQB)
        tel = @"拨打客服电话400-8915-690";
        
#else
        tel = @"拨打客服电话400-6666-801";
        
#endif
        array = @[@"联系在线客服",tel,@"查看常见问题"];
    }
    
    PopUpView * popAlertView = [[PopUpView alloc] initWithTitle:@"是否充值成功？" setItemtitleArray:array setBtnTitleArray:@[@"充值成功",@"再次尝试"]];
    popAlertView.itemClick = ^(UIButton *button){
        switch (button.tag) {
            case 55555:
            {
                [self clickKefu];
            }
                break;
            case 55556:
            {
                
                if (AppStyle_SAlE) {
                    H5LinkPage * linkVC = [[H5LinkPage alloc] init];
                    linkVC.name = @"常见问题";
                    linkVC.urlStr = [NSString stringWithFormat:@"%@/rule/question.html",K_MGLASS_URL];
                    [self.navigationController pushViewController:linkVC animated:YES];
 
                }else{
                    NSString * tel = @"";
#if defined (YQB)
                    tel = @"tel://400-8915-690";
                    
#else
                    tel = @"tel://400-6666-801";
                    
#endif
                
                  [[UIApplication sharedApplication]openURL:[NSURL URLWithString:tel]];
                }
              
            }
                break;
            case 55557:
            {
                H5LinkPage * linkVC = [[H5LinkPage alloc] init];
                linkVC.name = @"常见问题";
                linkVC.urlStr = [NSString stringWithFormat:@"%@/rule/question.html",K_MGLASS_URL];
                [self.navigationController pushViewController:linkVC animated:YES];
                
                
            }
                break;
                
            default:
                break;
        }
    
        
        
    
    
    };
    popAlertView.confirmClick = ^(UIButton *button){
        
        switch (button.tag) {
            case 66666:
            {
                if(self.intoStatus==1){
                
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            
            }
                break;
            case 66667:
            {
                
            }
                break;
          
                
                
            default:
                break;
        }
        
        
    };
    array = nil;
    [self.navigationController.view addSubview:popAlertView];
}

- (void)clickProtocolLabel
{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.index = 6;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickKefu
{
    [PageChangeControl goKeFuWithSource:self];
}
#pragma mark - 点击屏幕任意地方键盘消失
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}


-(void)getBankCardList{
    
    [DataEngine requestToGetBankCardList:^(NSMutableArray *bankNameArray, NSMutableArray *imageAddArray) {
        if (bankNameArray != nil && imageAddArray != nil) {
            
        }
        else{
            bankNameArray = [NSMutableArray arrayWithObjects:@"广发银行",@"浦发银行",@"兴业银行",@"招商银行",@"中国银行",
                             @"中国农业银行",@"中国建设银行",@"中国光大银行",@"平安银行",@"中国民生银行",
                             @"华夏银行",@"中国工商银行",@"交通银行",@"中信银行", nil];
            
            imageAddArray= [NSMutableArray arrayWithObjects:@"guangfa",@"pufa",@"xingye",@"zhaoshang",@"zhongguo",
                            @"nongye",@"jianshe",@"guangda",@"pingan",@"minsheng",
                            @"huaxia",@"gongshang",@"jiaotong",@"zhongxin",nil
                            ];
        }
        
        _bankIconArray = [NSMutableArray arrayWithArray:imageAddArray];
        
    }];
}

@end
