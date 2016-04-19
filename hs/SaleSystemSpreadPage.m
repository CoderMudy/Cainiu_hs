//
//  SaleSystemSpreadPage.m
//  hs
//
//  Created by PXJ on 15/11/19.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SaleSystemSpreadPage.h"
#import "NetRequest.h"
#import <ShareSDK/ShareSDK.h>

#define topViewHeight     ScreenWidth *90/375
#define dataViewHeight ScreenWidth * 300/375
#define spreadViewHeight ScreenWidth * 190/375


#define textFont     [UIFont systemFontOfSize:12*ScreenWidth/375]
#define websiteLab_Tag 4000
#define userImgV_Tag 5000
#define reloadBtn_Tag 5001
#define reloadLab_Tag 5002
#define topDetail_Tag 3000
#define topDetailRight_Tag 3001


@interface SaleSystemSpreadPage ()<UIScrollViewDelegate>
{
    NSString *_shareAddress;
    CGFloat _cashMoney;
    
    NSString * _invitNum;
    NSString * _costMoney;

}
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * dataView;
@property (nonatomic,strong)UIView * spreadView;


@end

@implementation SaleSystemSpreadPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self requestData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initNav];
    [self initUI];
    // Do any additional setup after loading the view.
}
#pragma mark init初始化
- (void)initData
{
    if (!_shareAddress) {
        _shareAddress = App_showUrl;
    }
    _cashMoney = 0.00;
}
- (void)requestData
{
    
    [self getPromotionLink];
    [self getUserSpreadDetail];
    
}
- (void)getUserSpreadDetail//请求用户推广信息
{
    NSString * urlStr = K_promotion_getPromoteSt;
    
    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken]};
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            
            NSDictionary * dict = dictionary[@"data"];
            
            _invitNum           = [NSString stringWithFormat:@"%@",dict[@"registCount"]==nil?@"0":dict[@"registCount"]];
            _costMoney          = [NSString stringWithFormat:@"%@",dict[@"consumerSum"]==nil?@"0":dict[@"consumerSum"]];
            [self loadTopView];
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
        
        
    }];
}

- (void)initNav
{

    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"推广分享";
    [nav.leftControl addTarget:self action:@selector(leftControl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];

}
- (void)leftControl
{

    [self.navigationController popViewControllerAnimated:YES];

}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView * backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    backScrollView.delegate = self;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth, topViewHeight+dataViewHeight+spreadViewHeight);
    [self.view addSubview:backScrollView];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, topViewHeight)];
    [backScrollView addSubview:_topView];
    _dataView = [[UIView alloc] initWithFrame:CGRectMake(0,20+ topViewHeight, ScreenWidth, dataViewHeight)];
    [backScrollView addSubview:_dataView];
    _spreadView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+ dataViewHeight+topViewHeight, ScreenWidth, spreadViewHeight)];
    [backScrollView addSubview:_spreadView];
    
    [self initTopViewUI];
    [self initDataViewUI];
    [self initSpreadViewUI];
}

- (void)initTopViewUI
{

//    spreadHeight = ScreenWidth*90/375;
    
    
    UIImageView * itemImageV = [[UIImageView alloc] init];
    itemImageV.center          = CGPointMake(20+(ScreenWidth-40)/4, topViewHeight*5/16);
    itemImageV.bounds          = CGRectMake(0, 0,topViewHeight*2/5 , topViewHeight*6/25);
    [_topView addSubview:itemImageV];
   
    UIImageView * itemRightImgeV = [[UIImageView alloc] init];
    [_topView addSubview:itemRightImgeV];
    itemRightImgeV.center      = CGPointMake(20+(ScreenWidth-40)*3/4, topViewHeight*5/16);
    itemRightImgeV.bounds      = CGRectMake(0, 0, topViewHeight*3/10, topViewHeight*27/100);
    
    
    UILabel * titleLab = [[UILabel alloc] init];
    [_topView addSubview:titleLab];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    titleLab.center            = CGPointMake(20+(ScreenWidth-40)/4, topViewHeight*3/5);
    titleLab.bounds            = CGRectMake(0, 0, (ScreenWidth-40)/2, topViewHeight/5);
    titleLab.font              = [UIFont systemFontOfSize:topViewHeight*3/25];
    
    
    
    
    UILabel * titleRightLab = [[UILabel alloc] init];
    [_topView addSubview:titleRightLab];
    
    titleRightLab.textAlignment = NSTextAlignmentCenter;

    titleRightLab.center       = CGPointMake(20+(ScreenWidth-40)*3/4, topViewHeight*3/5);
    titleRightLab.bounds       = CGRectMake(0, 0, (ScreenWidth-40)/2, topViewHeight/5);
    titleRightLab.font         = [UIFont systemFontOfSize:topViewHeight*3/25];
    
    
    
    
    UILabel * detailLab = [[UILabel alloc] init];
    [_topView addSubview:detailLab];
    
    detailLab.textAlignment = NSTextAlignmentCenter;

    detailLab.center           = CGPointMake(20+(ScreenWidth-40)/4, topViewHeight*4/5);
    detailLab.bounds           = CGRectMake(0, 0, (ScreenWidth-40)/2, topViewHeight/5);
    detailLab.textColor        = K_color_red;
    detailLab.font             = [UIFont systemFontOfSize:topViewHeight/5];
    
    
    UILabel * detailRightLab = [[UILabel alloc] init];
    [_topView addSubview:detailRightLab];
    
    detailRightLab.textAlignment = NSTextAlignmentCenter;

    detailRightLab.center      = CGPointMake(20+(ScreenWidth-40)*3/4, topViewHeight*4/5);
    detailRightLab.bounds      = CGRectMake(0, 0, (ScreenWidth-40)/2, topViewHeight/5);
    detailRightLab.textColor   = K_color_red;
    detailRightLab.font        = [UIFont systemFontOfSize:topViewHeight/5];
    
    [itemImageV setImage:[UIImage imageNamed:@"01"]];
    [itemRightImgeV setImage:[UIImage imageNamed:@"02"]];
    
    titleLab.attributedText    = nil;
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.textColor       = [UIColor blackColor];
    titleLab.text              = @"成功邀请好友";
    titleRightLab.backgroundColor = [UIColor whiteColor];
    titleRightLab.textColor       = [UIColor blackColor];
    titleRightLab.attributedText    = nil;
    titleRightLab.text         = @"好友累计交易手数";
    
    detailLab.text             = @"0";
    detailLab.tag              = topDetail_Tag;
    detailRightLab.text        = @"0";
    detailRightLab.tag         = topDetailRight_Tag;
    
    UIView   *  seperatorLine       = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-1, topViewHeight/6, 1, topViewHeight* 3/4)];
    seperatorLine.backgroundColor= K_COLOR_CUSTEM(213, 213, 213, 1);
    [_topView addSubview:seperatorLine];
    
    

}
- (void)initDataViewUI
{
    
    
    UILabel * dataTopLine = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 0.5)];
    dataTopLine.backgroundColor = K_color_gray;
    [_dataView addSubview:dataTopLine];
    
    UIImageView * userImgV = [[UIImageView alloc] init];
    userImgV.center = CGPointMake(ScreenWidth/2, dataViewHeight/2);
    userImgV.bounds = CGRectMake(0, 0, dataViewHeight*4/5, dataViewHeight*4/5);
    userImgV.tag = userImgV_Tag;
    [_dataView addSubview:userImgV];
    
    
    UIButton * reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.tag = reloadBtn_Tag;
    [reloadBtn setImage:[UIImage imageNamed:@"findPage_update"] forState:UIControlStateNormal];
    reloadBtn.center = userImgV.center;
    reloadBtn.bounds = CGRectMake(0, 0, 90, 90);
    reloadBtn.hidden  = YES;
    [reloadBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    [_dataView addSubview:reloadBtn];
    
    
    UILabel * reloadLab = [[UILabel alloc] init];
    reloadLab.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(reloadBtn.frame)+15);
    reloadLab.bounds = CGRectMake(0, 0, ScreenWidth, 20);
    reloadLab.text = @"点击重新加载";
    reloadLab.font = [UIFont systemFontOfSize:13.0];
    reloadLab.textAlignment = NSTextAlignmentCenter;
    reloadLab.textColor = K_color_gray;
    reloadLab.tag = reloadLab_Tag;
    [_dataView addSubview:reloadLab];
    reloadLab.hidden = YES;
    
    
    
    UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(20, _dataView.frame.size.height-1, ScreenWidth-40, 0.5)];
    bottomLine.backgroundColor = K_color_gray;
    [_dataView addSubview:bottomLine];
    

    
    
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
    [control addTarget:self action:@selector(pasteLink) forControlEvents:UIControlEventTouchUpInside];
    [_spreadView addSubview:control];
    
    
    
    UILabel * typeSecondLab = [[UILabel alloc] init];
    typeSecondLab.center        = CGPointMake(ScreenWidth/2 ,websiteLab.frame.size.height+websiteLab.frame.origin.y+20);
    typeSecondLab.textColor     = [UIColor whiteColor];
    typeSecondLab.bounds        = CGRectMake(0, 0, ScreenWidth*60/375, ScreenWidth*18/375);
    typeSecondLab.backgroundColor = K_color_red;
    typeSecondLab.text               = @"方式二";
    typeSecondLab.font               = textFont;
    typeSecondLab.textAlignment      = NSTextAlignmentCenter;
    typeSecondLab.layer.cornerRadius = 2;
    typeSecondLab.layer.masksToBounds = YES;
    [_spreadView addSubview:typeSecondLab];
    
    
    
    UIImageView * shareImgV = [[UIImageView alloc] init];
    shareImgV.center = CGPointMake(typeSecondLab.center.x, typeSecondLab.center.y+ScreenWidth*30/375);
    shareImgV.bounds = CGRectMake(0, 0, ScreenWidth*120/375, ScreenWidth*20/375);
    shareImgV.image = [UIImage imageNamed:@"findPage_11"];
    [_spreadView addSubview:shareImgV];
    
    
    
    
    CGFloat clickBtnLength =ScreenWidth*200/375;
    
    UIButton * spreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [spreadBtn addTarget:self action:@selector(selectShare) forControlEvents:UIControlEventTouchUpInside];
    spreadBtn.center        = shareImgV.center;
    spreadBtn.bounds        = CGRectMake(0, 0, clickBtnLength, ScreenWidth*44/375);
    [_spreadView addSubview:spreadBtn];
    
    
 
    
}
- (void)loadTopView
{

    UILabel * detailLab = (UILabel *)[_topView viewWithTag:topDetail_Tag];
    UILabel * detailRightLab = (UILabel *)[_topView viewWithTag:topDetailRight_Tag];
  
    detailLab.text = _invitNum==nil?@"0":_invitNum;
    detailRightLab.text = _costMoney==nil?@"0":_costMoney;


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
    NSString * title = @"我已经领了十万积分，再送十万积分给你！";
    NSString * content = [NSString stringWithFormat:@"下载就送十万积分，你不试试看？\n%@",url];
    [PageChangeControl goShareWithTitle:title content:content urlStr:url imagePath:imagePath];
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
        [self loadPromoteWebsite];

        NSLog(@"%@",error.localizedDescription);
    }];
    
}
- (void)loadPromoteWebsite
{
    UIImageView * userImgV = (UIImageView *)[_dataView viewWithTag:userImgV_Tag];
    UIButton * reloadBtn = (UIButton*)[_dataView viewWithTag:reloadBtn_Tag];
    UILabel * reloadLab = (UILabel *)[_dataView viewWithTag:reloadLab_Tag];
    if (_shareAddress.length>21) {
     
        UIImage * clickImage =  [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:_shareAddress] withSize:250.0f];
        UIImage * centerImage = [UIImage imageNamed:@"findPage_14"];
        
        clickImage = [self addImage:centerImage toImage:clickImage];
        
        userImgV.image = clickImage;
        reloadBtn.hidden = YES;
        reloadLab.hidden = YES;
        
        
        UILabel * websiteLab = (UILabel *)[_spreadView viewWithTag:websiteLab_Tag];
        NSMutableAttributedString *str  = [[NSMutableAttributedString alloc] initWithString:_shareAddress];
        NSRange strRange                = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        websiteLab.attributedText = str;

        
        
    }else{
        
        userImgV.image  = [UIImage imageNamed:@""];
        reloadBtn.hidden = NO;
        reloadLab.hidden = NO;
    }

  
    
    
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
