//
//  SpreadPage.m
//  hs
//
//  Created by PXJ on 15/8/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SpreadPage.h"
#import "SpreadPageCell.h"
#import <ShareSDK/ShareSDK.h>
#import "NetRequest.h"
#import "SpreadApplyPage.h"
#import "UserSpreadQR.h"
#import "H5LinkPage.h"


@interface SpreadPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _shareAddress;//分享链接
    NSString * _invitNum;
    NSString * _costMoney;
    NSMutableArray  * _brokerageArray;
    
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation SpreadPage

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分享有礼"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self requestData];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initNav];
    [self initUI];
    [self getPromotionLink];
}
- (void)initData
{
    _brokerageArray = [NSMutableArray array];
    
    
    
}
- (void)requestData//请求用户推广信息
{
    NSString * urlStr = K_promotion_getPromoteSt;
    
    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken]};
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            
            NSDictionary * dict = dictionary[@"data"];
            
            _invitNum           = [NSString stringWithFormat:@"%@",dict[@"registCount"]==nil?@"0":dict[@"registCount"]];
            _costMoney          = [NSString stringWithFormat:@"%@",dict[@"consumerSum"]==nil?@"0":dict[@"consumerSum"]];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self requestFinancyStatusData];
        }
    } failureBlock:^(NSError *error) {
    }];
}
#pragma mark - 根据用户推广信息请求返利完成度
- (void)requestFinancyStatusData
{
    if (_costMoney.floatValue < 10) {
        return;
    }else{
        NSString * urlStr   = K_financy_TaskStatus;
        NSString * token    = [[CMStoreManager sharedInstance]getUserToken];
        [NetRequest postRequestWithNSDictionary:@{@"token":token} url:urlStr successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200) {
                
                _brokerageArray = [NSMutableArray arrayWithArray:dictionary[@"data"]];
                for (NSDictionary * dic in dictionary[@"data"]) {
                    if ([dic[@"status"]intValue]==1&&[dic[@"code"]intValue]==3 && _costMoney.intValue>=300) {
                        
                        NSIndexSet  * indexSert = [NSIndexSet indexSetWithIndex:1];
                        [_tableView reloadSections:indexSert withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                NSIndexSet  * indexSert = [NSIndexSet indexSetWithIndex:2];
                [_tableView reloadSections:indexSert withRowAnimation:UITableViewRowAnimationNone];
            }
        } failureBlock:^(NSError *error) {
        }];
    }
}



#pragma mark - 获取分享链接地址
- (void)getPromotionLink
{
    NSString * token = [[CMStoreManager sharedInstance]getUserToken];
    NSDictionary * dic  = @{@"token":token};
    NSString * urlStr = K_promotion_getPromoteId;
    [ManagerHUD  showHUD:self.view animated:YES];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        [ManagerHUD hidenHUD];
        if ([dictionary[@"code"] intValue]==200) {
            
            _shareAddress = dictionary[@"data"];
            NSIndexSet  * indexSert = [NSIndexSet indexSetWithIndex:3];
            [_tableView reloadSections:indexSert withRowAnimation:UITableViewRowAnimationNone];
        }
    } failureBlock:^(NSError *error) {
        [ManagerHUD hidenHUD];
    }];
    
}
- (void)initNav
{
    
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"分享有礼";
    [nav.leftControl addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [nav.rightControl addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    nav.rightLab.text = @"成为推广员";
    [self.view addSubview:nav];
    
//    self.title = @"分享有礼";
//    
//    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
//    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
//    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
//    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
//    leftButton.titleLabel.textColor = [UIColor whiteColor];
//    
//    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
//    image.image = [UIImage imageNamed:@"return_1"];
//    image.userInteractionEnabled = YES;
//    [leftButton addSubview:image];
//    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftbtn;
//    
//    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 60, 44);
//    [rightButton setTitle:@"成为推广员" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [rightButton.titleLabel setTextColor:[UIColor whiteColor]];
//    
//    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBtn;
//    
//    
    
}
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SpreadPageCell class] forCellReuseIdentifier:@"spreadCell"];
    [self.view addSubview:_tableView];
    
}

- (void)leftButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)rightButtonPressed
{
 

    __block SpreadApplyPage * applyVC = [[SpreadApplyPage alloc] init];
    [ManagerHUD showHUD:self.view animated:YES];
    [RequestDataModel requestUserIsSpreadSuccess:^(BOOL success, int isSpreadUser) {
        [ManagerHUD hidenHUD];
        if (success) {
            
            //                isSpreadUser = YES;
            switch (isSpreadUser) {
                case 0:
                {
                    if (_costMoney.floatValue>=300)
                    {
                        if (_brokerageArray.count>0)
                        {
                            int t = 2 ;
                            for (NSDictionary *dic in _brokerageArray)
                            {
                                if ([dic[@"status"]intValue]==2) {
                                    t=2;
                                    break;
                                }else if([dic[@"status"]intValue]==1){
                                    t = t==0?0:1;
                                }else{
                                    t= 0;
                                }
                            }
                        switch (t)
                        {
                            case 2:
                            {
                                applyVC.userSpreadStyle = UserSpreadUnableApply;
                            }
                                break;
                            case 1:
                            {
                                applyVC.userSpreadStyle = UserSpreadApply;
                            }
                                break;
                            case 0:
                            {
                                applyVC.userSpreadStyle = UserSpreadGetMoney;
                            }
                                break;
                            default:
                                break;
                        }
                        break;
                        }
                    }else{
                        applyVC.userSpreadStyle = UserSpreadUnableApply;
                    }
                    
                }
                    break;
                case 1:
                {
                    applyVC.userSpreadStyle = UserSpreadChecking;
                    
                }
                    break;
                case 2:
                {
                    applyVC.userSpreadStyle = UserSpreadUnAgree;
                    
                }
                    break;
                case 3:
                {
                    applyVC.userSpreadStyle = userSpread;
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }else{
            applyVC.userSpreadStyle = UserSpreadUnableApply;
        }
        [self.navigationController pushViewController:applyVC animated:YES];

    }];

    
   
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
    NSString * title = @"我已经领了50元现金，再送50元给你！";
    NSString * content = [NSString stringWithFormat:@"下载就能赚钱，你不试试看？\n%@",url];
    [PageChangeControl goShareWithTitle:title content:content urlStr:url imagePath:imagePath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 3;
            
        }
            break;
        case 3:
        {
            return 2;
            
        }
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpreadPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spreadCell" forIndexPath:indexPath];
    
    [cell setSpreadPageCellAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            cell.detailLab.text         = _invitNum==nil?@"0":_invitNum;
            cell.detailRightLab.text    = _costMoney==nil?@"0":_costMoney;
        }
            break;
        case 1:
        {
            int status = 2;
            for (NSDictionary * dic in _brokerageArray)
            {
                if ([dic[@"code"]intValue] ==3)
                {
//                    status = [dic[@"status"] intValue];
                    status = 1;
                    if (status ==1) {
                        
                        cell.titleLab.text              = @"已完成任务 ! 可申请成为推广员 !";
                        
                    }
                }
            }
        }
            break;
        case 2:
        {
            if (indexPath.section !=2) {
                break;
            }
            int status = 2;
            if (indexPath.row == 0) {
                if (_costMoney.floatValue<10) {
                    status = 2;
                }else{
                    for (NSDictionary * dic in _brokerageArray)
                    {
                        if ([dic[@"code"]intValue] ==indexPath.row+1)
                        {
                            status = [dic[@"status"] intValue];
                            break;
                        }
                    }
                }
            }else
                if (indexPath.row == 1) {
                    if (_costMoney.floatValue<100) {
                        status = 2;
                    }else{
                        
                        for (NSDictionary * dic in _brokerageArray)
                        {
                            if ([dic[@"code"]intValue] ==indexPath.row+1)
                            {
                                status = [dic[@"status"] intValue];
                                break;
                            }
                        }
                    }
                    
                }else
                    if(indexPath.row ==2){
                        
                        if (_costMoney.floatValue<300) {
                            status = 2;
                            
                        }else{
                            
                            for (NSDictionary * dic in _brokerageArray)
                            {
                                if ([dic[@"code"]intValue] ==indexPath.row+1)
                                {
                                    status = [dic[@"status"] intValue];
                                    break;
                                }
                            }
                            
                        }
                    }
            
            if (status ==2||status ==1) {
                
                cell.clickBlock = ^(UIButton * button){};
                
            }else if(status==0){
                
                UIImageView* imageV = cell.itemImageV;
                UIButton * btn = cell.clickBtn;
                cell.clickBlock= ^(UIButton *button)
                {
                    [self getBrokerageClickIndexPath:indexPath withClickBtn:btn btnBackImageV:imageV];
                };
                
            }
            
            [self setClickImageIndexPath:indexPath withClickBtn:cell.clickBtn ImageV:cell.itemImageV status:status];
            
        }
            break;
        case 3:
        {
            if (indexPath.row==0) {
                
                if (!_shareAddress) {
                    _shareAddress = @"http://www.cainiu.com";
                    
                }
                NSMutableAttributedString *str  = [[NSMutableAttributedString alloc] initWithString:_shareAddress];
                NSRange strRange                = {0,[str length]};
                [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
                cell.detailLab.attributedText       = str;
                cell.clickBlock = ^(UIButton *button){
                    [self pasteLink];
                };
            }else {
                if (_shareAddress.length>21) {
                    UIImage * clickImage =  [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:_shareAddress] withSize:250.0f];
                    UIImage * centerImage = [UIImage imageNamed:@"findPage_14"];
                    
                    clickImage = [self addImage:centerImage toImage:clickImage];
                    [cell.clickRightBtn setBackgroundImage:clickImage forState:UIControlStateNormal];
                }
                
                cell.clickBlock = ^(UIButton *button){
                    if (button.tag ==1001) {
                        if (_shareAddress.length>21) {
                            
                            
                            UserSpreadQR *spreadImageV = [[UserSpreadQR alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) imageUrl:_shareAddress];
                            [self.navigationController.view addSubview:spreadImageV];
                        }else{
                            [self getPromotionLink];
                        
                        
                        }
                        
                    }else{
                        
                        [self selectShare];
                    }
                    
                };
                
            }
            
            
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            return ScreenWidth*95/375;
            
            
        }
            break;
        case 1:
        {
            return ScreenWidth*40/375;
            
        }
            break;
        case 2:
        {
            return ScreenWidth* 77/375;
            
        }
            break;
        case 3:
        {
            if (indexPath.row==0) {
                return ScreenWidth* 80/375;

            }else{
            
                return  ScreenWidth*100/375;
            }
            
        }
            break;
            
            
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0;
    
    switch (section) {
        case 0:
            headerHeight = 0;
            
            break;
        case 1:{
            
            headerHeight = 12;
        }
            break;
        case 2:case 3:
            headerHeight = 10;
            break;
            
        default:
            break;
    }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footHeight = 0;
    switch (section) {
        case 0: case 1:case 3:
        {
            footHeight = 0;
        }
            break;
        case 2:
        {
            footHeight = 15;
        }
            break;
            
        default:
            break;
    }
    return footHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    switch (section) {
        case 0:case 2:
            break;
        case 1:case 3:
        {   UIView * lineView  = [[UIView alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 1.5)];
            [headerView addSubview:lineView];
            lineView.backgroundColor = K_COLOR_CUSTEM(213, 213, 213, 1);
            
        }    break;
            
        default:
            break;
    }
    return  headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    return footView;
    
    
    
}
//点击领取佣金
- (void)getBrokerageClickIndexPath:(NSIndexPath*)indexPath withClickBtn:(UIButton*)button btnBackImageV:(UIImageView*)backImageV
{
    
    
    NSString * urlStr   = K_financy_FriendTotalConsume;
    
    NSString * token    = [[CMStoreManager sharedInstance] getUserToken];
    NSString * code     = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    NSDictionary * dic  = @{@"token":token,
                            @"code":code};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        int status =2;
        if ([dictionary[@"code"] intValue]==200) {
            
            status = 1;
            
        }else{
            
            status = 0;
        }
        
        NSString * code = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        NSString * statusStr = [NSString stringWithFormat:@"%d",status];
        NSDictionary * dict =@{@"code":code,@"status":statusStr};
        for (int i = 0; i<_brokerageArray.count; i++) {
            NSDictionary * dic = _brokerageArray[i];
            if ([dic[@"code"]intValue]==[dict[@"code"] intValue]) {
                
                [_brokerageArray replaceObjectAtIndex:i withObject:dict];
                break;
            }
        }
        
        int t = 2 ;
        for (NSDictionary *dic in _brokerageArray)
        {
            if ([dic[@"status"]intValue]==2) {
                t=2;
                break;
            }else if([dic[@"status"]intValue]==1){
                t = t==0?0:1;
            }else{
                t= 0;
            }
        }
        if (t==1) {
            
            NSIndexPath * loadIndex = [NSIndexPath indexPathForRow:0 inSection:1];
            [_tableView reloadRowsAtIndexPaths:@[loadIndex] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self setClickImageIndexPath:indexPath withClickBtn:button ImageV:backImageV status:status];
        PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:dictionary[@"msg"] setBtnTitleArray:@[@"确定"]];
        alertView.confirmClick= ^(UIButton * button){
        };
        [self.navigationController.view addSubview:alertView];
        
    } failureBlock:^(NSError *error) {
    }];
    
    
    
}
#pragma mark 两张图片合成为一张 （image1在前，image2在后）
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

#pragma mark - 设置每一项按钮的显示与可点击状态
- (void)setClickImageIndexPath:(NSIndexPath*)indexPath withClickBtn:(UIButton *)button ImageV:(UIImageView *)imageV status:(int)status
{
    
    NSString * btnImageName;
    if (status==0) {
        btnImageName = [NSString stringWithFormat:@"0%d_1",(int)indexPath.row+3];
        imageV.image = [UIImage imageNamed:btnImageName];
        button.enabled = YES;
    }else if(status==1)
    {
        btnImageName = [NSString stringWithFormat:@"0%d_2",(int)indexPath.row+3];
        imageV.image = [UIImage imageNamed:btnImageName];
        button.enabled = NO;
        
    }else
    {
        btnImageName = [NSString stringWithFormat:@"0%d",(int)indexPath.row+3];
        imageV.image = [UIImage imageNamed:btnImageName];
        button.enabled = NO;
        
    }
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
