//
//  UserInfoPage.m
//  hs
//
//  Created by PXJ on 16/2/25.
//  Copyright © 2016年 luckin. All rights reserved.
//－－个人资料－－

#define header_user @"头像"
#define nick_user @"昵称"
#define sign_user @"个性签名"
#define changePSW_user @"修改密码"
#define setGes_user @"设置手势密码"
#define changeGes_user @"修改手势"
#define userCheck @"身份认证"
#define cellHeight 50
#define ORIGINAL_MAX_WIDTH 640.0f

#import "ShengfenRenZhengViewController.h"
#import "PersonInfoPage.h"
#import "PersionInfoCell.h"
#import "NJImageCropperViewController.h"
#import "NickViewController.h"
#import "SignViewController.h"
#import "PasswordViewController.h"


@interface PersonInfoPage ()<UITableViewDataSource,UITableViewDelegate,NJImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CUserData       *_cuserdata;
    NSMutableArray * _titleArray;
    NSMutableArray * _detailArray;
    NSString * _statusMobile;
    NSMutableArray  *imageDetailArray;
    NSString        *infoShenHeStatus;
    NSString        *failinfoMsg;//身份认证失败的原因
    NSString        *isHiddleRenZheng;
    //个人信息
    PrivateUserInfo *_privateUserInfo;

}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * addView;
@property (nonatomic,strong)UIImage * headerImg;


@end

@implementation PersonInfoPage
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initData];
    [self initUI];
    [self loadData];
    [self authMobile];
    [self requestShenHeStatus];
    // Do any additional setup after loading the view.
}
- (void)loadData{
    
    
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
        [[UIEngine sharedInstance] hideProgress];

    }];
}

//验证真实姓名
-(void)authRealName
{
    
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
              
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
        [[UIEngine sharedInstance] hideProgress];

    }];
}

//验证银行卡
-(void)authBankCard
{
    
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                
             
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
        [[UIEngine sharedInstance] hideProgress];

    }];
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

            }else
            {
                isHiddleRenZheng = @"show";
                if (![isHiddleRenZheng isEqualToString:@"hiddle"]) {
                    //身份认证
                    NSString * nick = [[CMStoreManager sharedInstance]getUserNick];
                    NSString * sign = [[CMStoreManager sharedInstance]getUserSign].length==0?@"编辑个性签名":[[CMStoreManager sharedInstance]getUserSign];
                    

                    _titleArray = [NSMutableArray arrayWithArray:@[header_user,nick_user,sign_user,userCheck,changePSW_user,setGes_user,changeGes_user]];
                    _detailArray = [NSMutableArray arrayWithArray:@[@"",nick,sign,infoShenHeStatus,@"",@"",@""]];
                }
                
            }
            
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        

        [self.tableView reloadData];
    }];
    
}



- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"个人资料";
    [nav.leftControl addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
}
- (void)initData
{
    NSString * nick = [[CMStoreManager sharedInstance]getUserNick];
    NSString * sign = [[CMStoreManager sharedInstance]getUserSign].length==0?@"编辑个性签名":[[CMStoreManager sharedInstance]getUserSign];
    _titleArray = [NSMutableArray arrayWithArray:@[header_user,nick_user,sign_user,changePSW_user,setGes_user,changeGes_user]];
    _detailArray = [NSMutableArray arrayWithArray:@[@"",nick,sign,@"",@"",@""]];
    
}
- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244, 1);
//    [_tableView registerClass:[PersionInfoCell class] forCellReuseIdentifier:@"personCell"];
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([CacheEngine isOpenGes]) {
        return _titleArray.count;
    }else{
        return _titleArray.count-1;
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
    return cellHeight;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersionInfoCell *cell=[[PersionInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.detailLab.text=_detailArray[indexPath.row];
    cell.titleLabel.frame = CGRectMake(20, 0, 120, cellHeight);
    cell.userImgV.hidden = YES;
    cell.userImgV.backgroundColor = [UIColor redColor];
    if ([cell.titleLabel.text isEqualToString:header_user])
    {//头像
        CGFloat headerLength = 40;
        cell.userImgV.hidden = NO;
        cell.userImgV.frame=CGRectMake(ScreenWidth-40-headerLength, cellHeight/2-headerLength/2, headerLength, headerLength);
        cell.userImgV.image = [[CMStoreManager sharedInstance] getUserHeader];
        [Helper imageCutView:cell.userImgV cornerRadius:headerLength/2 borderWidth:2 color:[UIColor whiteColor]];
        if (_headerImg!=nil) {
            cell.userImgV.image = _headerImg;
        }

        
    }else if([cell.titleLabel.text isEqualToString:setGes_user])
    {//手势
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
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight-0.5, ScreenWidth, 0.5)];
    lineView.backgroundColor=RGBACOLOR(180, 180, 180, 1);
    [cell addSubview:lineView];
    //隐藏箭头
    if (indexPath.row==4){
        cell.accessoryView = nil;
    }
    else{
        UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        accessoryImageView.image = [UIImage imageNamed:@"button_02"];
        
        cell.accessoryView = accessoryImageView;
    }

    
    //获取用户信息
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * rowName = _titleArray[indexPath.row];
    if ([rowName isEqualToString:header_user]) {
        [self initWithCamerView];
    }
    if ([rowName isEqualToString:nick_user]) {
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
    if ([rowName isEqualToString:sign_user]) {
        SignViewController *signVC=[[SignViewController alloc]init];
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
    if ([rowName isEqualToString:changePSW_user]) {
        if ([_privateUserInfo.statusMobile isEqualToString:@"1"]) {
            PasswordViewController *passVC=[[PasswordViewController alloc]init];
            [self.navigationController pushViewController:passVC animated:YES];
        }

    }
    if ([rowName isEqualToString:setGes_user]) {
        
    }
    if ([rowName isEqualToString:changeGes_user]) {
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
    if ([rowName isEqualToString:userCheck]){
    
        //身份认证
        //先判断用户是否进行了实名认证和银行卡信息填写
        BOOL idCard = [_privateUserInfo.statusRealName isEqualToString:@"1"] || [_privateUserInfo.statusRealName isEqualToString:@"2"];
        BOOL bank = [_privateUserInfo.statusBankCardBind isEqualToString:@"1"] || [_privateUserInfo.statusBankCardBind isEqualToString:@"2"];
        if (idCard && bank) {
            
            ShengfenRenZhengViewController *shenCtrl = [[ShengfenRenZhengViewController alloc]init];
            shenCtrl.userInfo = _privateUserInfo;
            shenCtrl.shenHeStatus = _detailArray[indexPath.row];
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
  

}
//---------------------------设置头像--------------------------
#pragma mark - 初始化拍照，从相册选择，取消按钮
- (void)initWithCamerView
{
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

- (void)resetDefaults
{
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
}
#pragma mark 退出登录

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil]];
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
