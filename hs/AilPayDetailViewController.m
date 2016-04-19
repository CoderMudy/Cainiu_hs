//
//  AilPayDetailViewController.m
//  hs
//
//  Created by Xse on 15/11/6.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AilPayDetailViewController.h"
#import "RankButton.h"
@interface AilPayDetailViewController ()

@property(nonatomic,strong) UIScrollView *detailScrollView;

@end

@implementation AilPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self loadDetailNavi];
    [self loadDetailUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 导航栏
- (void)loadDetailNavi
{
    [self setNaviTitle:@"支付宝转账"];
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_NavColor];
}

#pragma mark - 界面展示
- (void)loadDetailUI
{
    _detailScrollView = [[UIScrollView alloc]init];
    _detailScrollView.backgroundColor =  RGBACOLOR(245, 245, 245, 1);
    _detailScrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
    [self.view addSubview:_detailScrollView];

    UILabel *firstLab = [[UILabel alloc]init];
    firstLab.text = @"第一步: 请复制或牢记我们的支付宝账户";
    firstLab.frame = CGRectMake(20, 10, ScreenWidth - 20, 21);
    firstLab.font = [UIFont systemFontOfSize:15.0];
    firstLab.backgroundColor = [UIColor clearColor];
    firstLab.textColor = [UIColor blackColor];
    [_detailScrollView addSubview:firstLab];
    
    UIView *firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    firstView.frame = CGRectMake(0, CGRectGetMaxY(firstLab.frame) + 10, ScreenWidth, 60*ScreenWidth/320);
    [_detailScrollView addSubview:firstView];
    
    UIImageView *alipayImg = [[UIImageView alloc]init];
    alipayImg.image = [UIImage imageNamed:@"way_alipay"];
    alipayImg.frame = CGRectMake(CGRectGetMinX(firstLab.frame), 18*ScreenWidth/320, 77*ScreenWidth/320, 24*ScreenWidth/320);
    [firstView addSubview:alipayImg];
    
    UILabel *alipayLab = [[UILabel alloc]init];
    alipayLab.textAlignment = NSTextAlignmentRight;
    alipayLab.text = [NSString stringWithFormat:@"支付宝账户: %@",App_zfbAccount];
    
    CGSize width = [Helper sizeWithText:alipayLab.text font:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(ScreenWidth - CGRectGetMaxX(alipayImg.frame) - 30, 18)];
    alipayLab.frame = CGRectMake(ScreenWidth - width.width - 20 -10, CGRectGetMinY(alipayImg.frame), width.width, width.height);
    alipayLab.font = [UIFont systemFontOfSize:12.0];
    alipayLab.backgroundColor = [UIColor clearColor];
    alipayLab.textColor = [UIColor blackColor];
    [firstView addSubview:alipayLab];
    
    UILabel *companyLab = [[UILabel alloc]init];
    companyLab.textAlignment = NSTextAlignmentRight;
    companyLab.text = App_zfbName;
//    companyLab.adjustsFontSizeToFitWidth = YES;
    CGSize companySize = [Helper sizeWithText:companyLab.text font:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(ScreenWidth - CGRectGetMaxX(alipayImg.frame) - 30, 18)];
    companyLab.frame = CGRectMake(CGRectGetMinX(alipayLab.frame), CGRectGetMaxY(alipayLab.frame), companySize.width, companySize.height);
    companyLab.font = [UIFont systemFontOfSize:12.0];
    companyLab.backgroundColor = [UIColor clearColor];
    companyLab.textColor = [UIColor lightGrayColor];
    [firstView addSubview:companyLab];
    
    //点击的按钮
    UIButton *copyAlipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyAlipayBtn.frame = CGRectMake(0, 0, firstView.frame.size.width, firstView.frame.size.height);
    [copyAlipayBtn addTarget:self action:@selector(clickCopyAlipayAction:) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:copyAlipayBtn];

    //第二步：手机打开支付宝，完成转账
    UILabel *secondLab = [[UILabel alloc]init];
    secondLab.text = @"第二步: 请复制或牢记我们的支付宝账户";
    secondLab.frame = CGRectMake(CGRectGetMinX(firstLab.frame), CGRectGetMaxY(firstView.frame) + 10, firstLab.frame.size.width, 21);
    secondLab.font = [UIFont systemFontOfSize:15.0];
    secondLab.backgroundColor = [UIColor clearColor];
    secondLab.textColor = [UIColor blackColor];
    [_detailScrollView addSubview:secondLab];
    
    UIView *secondView = [[UIView alloc]init];
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.frame = CGRectMake(0, CGRectGetMaxY(secondLab.frame) + 10, ScreenWidth, 125*ScreenWidth/320);
    [_detailScrollView addSubview:secondView];
    
    //支付宝图标
    RankButton *ranckBtn = [RankButton buttonWithType:UIButtonTypeCustom];
    ranckBtn.frame = CGRectMake(20*ScreenWidth/320, 15, 100, 105);
    [ranckBtn setImage:[UIImage imageNamed:@"alipay_detail_one"] forState:UIControlStateNormal];
    ranckBtn.type = buttonTypePicTop;
//    ranckBtn.backgroundColor = [UIColor redColor];
    ranckBtn.picTileRange = 10;
    //基于图片来计算边距
//    ranckBtn.alignType = buttonAlignWithPic;
//    ranckBtn.picToViewRange = 30;
    [ranckBtn setTitle:@"手机打开支付宝" forState:UIControlStateNormal];
    [secondView addSubview:ranckBtn];
    
    UIImageView *secondImg = [[UIImageView alloc]init];
    secondImg.image = [UIImage imageNamed:@"alipay_detail_two"];
    if ([UIScreen mainScreen].bounds.size.height <=568) {
        secondImg.frame = CGRectMake(CGRectGetMaxX(ranckBtn.frame) + 25*ScreenWidth/320, CGRectGetMinY(ranckBtn.frame) + 20, 23*ScreenWidth/320, 30*ScreenWidth/320);
    }else
    {
        secondImg.frame = CGRectMake(ScreenWidth/2 - 30*ScreenWidth/320/2, CGRectGetMinY(ranckBtn.frame) + 20, 23*ScreenWidth/320, 30*ScreenWidth/320);
        //CGRectGetMaxX(ranckBtn.frame) + 40*ScreenWidth/320
    }
    
    [secondView addSubview:secondImg];
    
    //选择转账到支付宝账户
    RankButton *rankTwoBtn = [RankButton buttonWithType:UIButtonTypeCustom];
    rankTwoBtn.frame = CGRectMake(ScreenWidth - 110 - 10 - 30, 5, 150, 110);
    [rankTwoBtn setImage:[UIImage imageNamed:@"alipay_detail_three"] forState:UIControlStateNormal];
    rankTwoBtn.type = buttonTypePicTop;
//    rankTwoBtn.backgroundColor = [UIColor redColor];
    rankTwoBtn.picTileRange = 0;
    //基于图片来计算边距
//        ranckBtn.alignType = buttonAlignWithPic;
//        ranckBtn.picToViewRange = 5;
    [rankTwoBtn setTitle:@"选择转账到支付宝账户" forState:UIControlStateNormal];
    [secondView addSubview:rankTwoBtn];

    
    //第三步：完成转账后，返回app
    UILabel *thirdLab = [[UILabel alloc]init];
//    thirdLab = [[UILabel alloc]init];
    thirdLab.text = @"第三步: 完成转账后, 返回APP";
    thirdLab.frame = CGRectMake(CGRectGetMinX(firstLab.frame), CGRectGetMaxY(secondView.frame) + 10, firstLab.frame.size.width, 21);
    thirdLab.font = [UIFont systemFontOfSize:15.0];
    thirdLab.backgroundColor = [UIColor clearColor];
    thirdLab.textColor = [UIColor blackColor];
    [_detailScrollView addSubview:thirdLab];
    
    CGFloat btnHeight = CGRectGetMaxY(thirdLab.frame);
    if (!AppStyle_SAlE) {
        UIView *thirdView = [[UIView alloc]init];
        thirdView.backgroundColor = [UIColor whiteColor];
        thirdView.frame = CGRectMake(0, CGRectGetMaxY(thirdLab.frame) + 10, ScreenWidth, 105*ScreenWidth/320);
        [_detailScrollView addSubview:thirdView];
        
        UIImageView *thridImg = [[UIImageView alloc]init];
        thridImg.image = [UIImage imageNamed:@"alipay_detail_third_one"];
        thridImg.frame = CGRectMake(40*ScreenWidth/320, 10, 61*ScreenWidth/320, 74*ScreenWidth/320);
        [thirdView addSubview:thridImg];
        
        UIImageView *thridTwoImg = [[UIImageView alloc]init];
        thridTwoImg.image = [UIImage imageNamed:@"alipay_detail_third_two"];
        thridTwoImg.frame = CGRectMake(CGRectGetMinX(secondImg.frame), CGRectGetMinY(thridImg.frame) + 20, 23*ScreenWidth/320, 30*ScreenWidth/320);
        [thirdView addSubview:thridTwoImg];
        //支付宝图标
        RankButton *cainiuBtn = [RankButton buttonWithType:UIButtonTypeCustom];
        cainiuBtn.frame = CGRectMake(ScreenWidth - 70 - 20 - 30 -30, 15, 120, 80);
        [cainiuBtn setImage:[UIImage imageNamed:@"alipay_detail_third_three"] forState:UIControlStateNormal];
        cainiuBtn.type = buttonTypePicTop;
        //    ranckBtn.backgroundColor = [UIColor redColor];
        cainiuBtn.picTileRange = 10;
        //基于图片来计算边距
        //    ranckBtn.alignType = buttonAlignWithPic;
        //    ranckBtn.picToViewRange = 30;
        NSString * title = [NSString stringWithFormat:@"手机打开%@APP",App_appShortName];
        [cainiuBtn setTitle:title forState:UIControlStateNormal];
        [thirdView addSubview:cainiuBtn];
        btnHeight = CGRectGetMaxY(thirdView.frame);
    }
    UIButton *copyAndOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyAndOpenBtn.frame = CGRectMake(15, btnHeight+ 20, ScreenWidth - 15*2, 40*ScreenWidth/320);
    copyAndOpenBtn.backgroundColor = RGBACOLOR(255, 62, 27, 1);
    [copyAndOpenBtn setTitle:@"复制支付宝账号 并打开支付宝" forState:UIControlStateNormal];
    [copyAndOpenBtn addTarget:self action:@selector(clickOpenAction:) forControlEvents:UIControlEventTouchUpInside];
    copyAndOpenBtn.layer.cornerRadius = 5;
    copyAndOpenBtn.layer.masksToBounds = YES;
    [_detailScrollView addSubview:copyAndOpenBtn];
    
    if ([UIScreen mainScreen].bounds.size.height <=480) {
        _detailScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(copyAndOpenBtn.frame) + 50);
    }
    
}

#pragma mark - 复制支付宝账号
- (void)clickCopyAlipayAction:(UIButton *)sender
{
    [UIEngine showShadowPrompt:@"已经复制到剪贴板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = App_zfbAccount;

}

#pragma mark - 复制支付宝账号并打开支付宝
- (void)clickOpenAction:(UIButton *)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = App_zfbAccount;

    NSString * URLString = @"alipays://";
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]])
    {
        [UIEngine showShadowPrompt:@"请先安装支付宝"];
 
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

-(BOOL) APCheckIfAppInstalled2:(NSString *)urlSchemes
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        NSLog(@" installed");
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
