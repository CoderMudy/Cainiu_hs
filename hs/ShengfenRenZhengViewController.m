//
//  ShengfenRenZhengViewController.m
//  hs
//
//  Created by Xse on 15/10/19.
//  Copyright © 2015年 luckin. All rights reserved.
//  //  =====身份认证页面

#import "ShengfenRenZhengViewController.h"
#import "ShengFenRenZhengCell.h"
#import "UploadDocuMentsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetRequest.h"
#import "UIImageView+AFNetworking.h"
//#import "AFNetworkActivityIndicatorManager"

@interface ShengfenRenZhengViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSInteger index;//判断点击的是哪个图片，0 ，1，2对应三张图片顺序
    UIButton *submitBtn;
    UIView *addView;
    UIImageView *renZhengimg;//认证失败的图片
    
    UILabel *submitFailDetail;//认证失败的原因/待审核时候显示的文字
    
    CacheModel *cacheModel;
    
    NSInteger isSubmit;//判断是否点击了提交（0为没有提交，1为提交了），如果没有提交点击返回的时候弹出提示框
    
    UIImage *imagceshi;
    
    NSString *jpgPath;
    NSArray *defaultArray;
    
    UIView *greenView;
    UILabel *uploadLab;
}

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UITableView *uMesgTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation ShengfenRenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _imageArray = [[NSMutableArray alloc]init];
    _imageArray = [@[@"",@"",@""]mutableCopy];
    defaultArray = @[@"identity_1",@"identity_2",@"identity_3"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    isSubmit = 0;
    //导航栏
    [self setNaviTitle:@"身份认证"];
//    [self setBackButton];
    [self setLeftBtnWithImageName:@"return_1"];
    [self setNavibarBackGroundColor:K_color_NavColor];
    
    [self initWithTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIEngine sharedInstance] hideProgress];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - 返回按钮
- (void)leftButtonAction
{
    if ([_shenHeStatus isEqualToString:@" "] || _shenHeStatus == nil) {
        if (isSubmit == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份认证还没有认证，请先认证" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"继续", nil];
            alertView.tag = 123456;
            [alertView show];
        }

    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 初始化表格
- (void)initWithTableView
{
    /**
     *  获取初始化数据
     */
    if (_userInfo.realName == nil || [_userInfo.realName isKindOfClass:[NSNull class]]) {
        _userInfo.realName = @"";
    }
    
    if (_userInfo.idCard == nil || [_userInfo.idCard isKindOfClass:[NSNull class]]) {
        _userInfo.idCard = @"";
    }
    
    if (_userInfo.bankCard == nil || [_userInfo.bankCard isKindOfClass:[NSNull class]]) {
        _userInfo.bankCard = @"";
    }
    
    _dataArray = [@[@{@"name":@"姓名",@"userName":_userInfo.realName},
                    @{@"name":@"身份证号",@"userName":_userInfo.idCard},
                    @{@"name":@"银行卡号",@"userName":_userInfo.bankCard},
                    ]mutableCopy];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth);
    [self.view addSubview:_scrollView];

    _uMesgTableView = [[UITableView alloc]init];
    _uMesgTableView.frame = CGRectMake(0, 0, ScreenWidth, 44*3 + [self drawHeadTableView].frame.size.height);
    _uMesgTableView.delegate = self;
    _uMesgTableView.dataSource = self;
    _uMesgTableView.scrollEnabled = NO;
    [_scrollView addSubview:_uMesgTableView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [_uMesgTableView setTableFooterView:va];
    _uMesgTableView.tableHeaderView = [self drawHeadTableView];
    
//    [self loadPortrait];//加载图片
    
    //提交按钮。。。
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [submitBtn addTarget:self action:@selector(clickSubmibAction) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(15, CGRectGetMaxY(_uMesgTableView.frame) + 45*ScreenWidth/320, ScreenWidth - 15*2, 45*ScreenWidth/320);
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn.layer setCornerRadius:5];
    [submitBtn.layer setMasksToBounds:YES];
    
    [_scrollView addSubview:submitBtn];
    [self updateUIbutton:NO];
    
    submitFailDetail = [[UILabel alloc]init];
    submitFailDetail.hidden = YES;
    submitFailDetail.numberOfLines = 0;
    submitFailDetail.font = [UIFont systemFontOfSize:13.0];
    submitFailDetail.textAlignment = NSTextAlignmentCenter;
    submitFailDetail.textColor = [UIColor lightGrayColor];
    submitFailDetail.frame = CGRectMake(0, CGRectGetMaxY(submitBtn.frame) + 20, ScreenWidth, 21);
    [_scrollView addSubview:submitFailDetail];
    
    NSLog(@"ceshi:%@",_shenHeStatus);
    
    if ([_shenHeStatus isEqualToString:@" "] || _shenHeStatus == nil || [_shenHeStatus isEqualToString:@""])
    {
        [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        [self uplodaImgImport];
       
    }else if ([_shenHeStatus isEqualToString:@"审核中"])
    {
        [submitBtn setTitle:@"待审核" forState:UIControlStateNormal];
        
        submitFailDetail.text = @"您的实名信息已上传，请耐心等待";
        submitFailDetail.hidden = NO;
        
        [self updateUIbutton:NO];//灰掉待审核按钮
    }else if ([_shenHeStatus isEqualToString:@"失败"])
    {
        [submitBtn setTitle:@"重新上传您的实名信息" forState:UIControlStateNormal];
        
        submitFailDetail.text = _faileMsg;
        //调用后台数据接口
        submitFailDetail.hidden = NO;
        [self updateUIbutton:YES];
    }else if ([_shenHeStatus isEqualToString:@"审核成功"])
    {
        submitBtn.hidden = YES;
//        [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
//        [self updateUIbutton:NO];
//        [self uplodaImgImport];
    }
}

#pragma mark - 上传证件的要求
- (void)uplodaImgImport
{
    //下面证件图片上传要求
    NSArray *titleArray = @[@"证件图片要求:",@"* 上传的身份证和银行卡应与您所绑定的信息相一致",@"* 各项信息及头像清晰可见,容易识别",@"* 证件必须真实拍摄,不能使用复印件",@"* 照片大小不大于8MB"];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UILabel *labelText = [[UILabel alloc]init];
        labelText.font = [UIFont systemFontOfSize:12.0];
        labelText.textColor = [UIColor colorWithRed:116/255.0 green:108/255.0 blue:102/255.0 alpha:1];
        labelText.text = titleArray[i];
        labelText.frame = CGRectMake(CGRectGetMinX(submitBtn.frame) + 2,CGRectGetMaxY(submitBtn.frame) + 15 + i*21, ScreenWidth - CGRectGetMinX(submitBtn.frame) - 2, 21);
        [_scrollView addSubview:labelText];
        
        if (i == 1) {
            CGSize sizeW = [Helper sizeWithText:labelText.text font:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(ScreenWidth - CGRectGetMinX(submitBtn.frame) - 2, 21)];
            if (sizeW.width > ScreenWidth - CGRectGetMinX(submitBtn.frame) - 2- 5) {
                [labelText sizeToFit];
            }
        }
        
        if ([UIScreen mainScreen].bounds.size.height <=480 && i == 3) {
            _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(labelText.frame) + 100);
        }
    }

}

#pragma mark - 读取缓存中得图片
- (void)readCheModelImg
{
    
}

#pragma mark - 提交/待审核/重新上传按钮点击事件
- (void)clickSubmibAction
{
    isSubmit = 1;
//    [self  requestCeshi];
//   [self requestTijian];
    
    NSLog(@"按钮上的文字：%@",[submitBtn titleForState:UIControlStateNormal]);
    
    if ([[submitBtn titleForState:UIControlStateNormal] isEqualToString:@"重新上传您的实名信息"]) {
        //清空数据，并且吧button上的文字改为提交认证
        [self updateUIbutton:NO];
        [self uplodaImgImport];
        _shenHeStatus = @"";
        [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        
        UIImageView *imageOne = (UIImageView *)[_uMesgTableView.tableHeaderView viewWithTag:200];
        UIImageView *imageTwo = (UIImageView *)[_uMesgTableView.tableHeaderView viewWithTag:201];
        UIImageView *imageThree = (UIImageView *)[_uMesgTableView.tableHeaderView viewWithTag:202];
        
        imageOne.userInteractionEnabled = YES;
        imageTwo.userInteractionEnabled = YES;
        imageThree.userInteractionEnabled = YES;
        
        imageOne.image = [UIImage imageNamed:defaultArray[0]];
        imageTwo.image = [UIImage imageNamed:defaultArray[1]];
        imageThree.image = [UIImage imageNamed:defaultArray[2]];
        
        renZhengimg.hidden = YES;
        submitFailDetail.hidden = YES;
        _imageArray = [@[@"",@"",@""]mutableCopy];
        
    }else
    {
//         [ManagerHUD showHUD:self.view animated:YES];
        self.view.backgroundColor = [UIColor grayColor];
        _scrollView.frame = CGRectMake(0, 40 + 64, ScreenWidth, ScreenHeigth - 30);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(submitBtn.frame) + 21*4 + 100);
        
        uploadLab = [[UILabel alloc]init];
        uploadLab.font = [UIFont systemFontOfSize:12.0];
        uploadLab.textColor = [UIColor whiteColor];
        uploadLab.backgroundColor = [UIColor clearColor];
        uploadLab.frame = CGRectMake(0, 64 + 6, ScreenWidth, 20);
        uploadLab.textAlignment = NSTextAlignmentCenter;
        uploadLab.text = @"正在上传1个文件...";
        [self.view addSubview:uploadLab];
        
        //进度条
        //灰条
        UIView *redBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(uploadLab.frame) + 5, ScreenWidth, 3)];
        redBackgroundView.backgroundColor=[UIColor whiteColor];;
        [self.view addSubview:redBackgroundView];
        
        //绿色条
        greenView=[[UIView alloc]initWithFrame:CGRectMake(-ScreenWidth-14, 0, ScreenWidth+14, 3)];
        greenView.backgroundColor=[UIColor greenColor];
//        greenView.clipsToBounds=YES;
//        greenView.layer.cornerRadius=6;
        [redBackgroundView addSubview:greenView];
        
        [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            greenView.frame=CGRectMake(greenView.frame.origin.x+ScreenWidth/3+7, greenView.frame.origin.y, greenView.frame.size.width, greenView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        
        submitBtn.enabled = NO;
        [self upload];

    }

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
    
    addView = [[UIView alloc]init];
    addView.backgroundColor = [UIColor blackColor];
    addView.alpha = 0.3;
    addView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    [self.view addSubview:addView];
    
    NSArray *titleArray = @[@"拍照",@"从相册选择",@"取消"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i*45*ScreenWidth/320 + self.view.frame.size.height - 45*ScreenWidth/320*3 - 10, ScreenWidth, 45*ScreenWidth/320);
        
        if (i == 2) {
            button.frame = CGRectMake(0, i*45*ScreenWidth/320 + 10 + self.view.frame.size.height - 45*ScreenWidth/320*3 - 10 , ScreenWidth, 45*ScreenWidth/320);
        }
        button.tag = 10000 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.view addSubview:button];
    }
    
    
}


#pragma mark - 向服务器提交图片
-(void)upload
{
    NSMutableArray *newFileArray = [[NSMutableArray alloc]init];
    
    if (_imageArray.count > 0) {
        for (NSInteger i = 0; i < _imageArray.count; i++) {
            NSString *imageName = @"image";
            NSString *newImgName = [NSString stringWithFormat:@"%@%ld%@",imageName,(long)i + 1,@".png"];
            jpgPath = NSHomeDirectory();
            NSString *newFile = [[jpgPath stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:newImgName];
            NSLog(@"newfile:%@",newFile);
            [newFileArray addObject:newFile];
        }

    }
    
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    NSDictionary *dic = @{@"token":token};

//     [ManagerHUD hidenHUD];
        AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
        [requestManager POST:K_Upload_UploadIMg parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            /**
             *  appendPartWithFileURL   //  指定上传的文件
             *  name                    //  指定在服务器中获取对应文件或文本时的key
             *  fileName                //  指定上传文件的原始文件名
             *  mimeType                //  指定商家文件的MIME类型
             */
//            for (NSInteger i = 0; i<newFileArray.count; i++) {
//                NSLog(@"====file:%@",newFileArray[i]);
//                [formData appendPartWithFileURL:[NSURL fileURLWithPath:newFileArray[i]] name: [NSString stringWithFormat:@"@image%ld",i + 1] fileName:newFileArray[i] mimeType:@"image/jpeg" error:nil];
//            }
            
            BOOL dataYes = [formData appendPartWithFileURL:[NSURL fileURLWithPath:newFileArray[0]] name:@"image1" fileName:newFileArray[0] mimeType:@"image/jpeg" error:nil];
            BOOL dataYes1 = [formData appendPartWithFileURL:[NSURL fileURLWithPath:newFileArray[1]] name:@"image2" fileName:newFileArray[1] mimeType:@"image/jpeg" error:nil];
            BOOL dataYes2 = [formData appendPartWithFileURL:[NSURL fileURLWithPath:newFileArray[2]] name:@"image3" fileName:newFileArray[2] mimeType:@"image/jpeg" error:nil];
//
            if (dataYes == YES) {
                NSLog(@"上传中");
                
            }
            
            if (dataYes1 == YES) {
                NSLog(@"上传中");
            }
            
            if (dataYes2 == YES) {
                NSLog(@"上传中");
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"code"] intValue]== 200) {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    greenView.frame=CGRectMake(0, greenView.frame.origin.y, greenView.frame.size.width, greenView.frame.size.height);
                    //                greenView.frame=CGRectMake(ScreenWidth, greenView.frame.origin.y, greenView.frame.size.width, greenView.frame.size.height);
                } completion:^(BOOL finished) {
                    uploadLab.text = @"上传成功";
                }];
                
                [[UIEngine sharedInstance] showAlertWithTitle:@"身份认证提交成功，待审核" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                } ;
                
            }else
            {
                //如果上传失败，就让提交按钮可以点击
                submitBtn.enabled = YES;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //如果上传失败，就让提交按钮可以点击
            submitBtn.enabled = YES;
        }];
        
}

#pragma mark  - 绘制表格头的视图

- (UIView *)drawHeadTableView
{
    
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 150*ScreenWidth/320);
    
    CGFloat imgW = (ScreenWidth - 30*2 - 15*2)/3;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.tag = i + 200;
        imageview.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFill
        
        if ([_shenHeStatus isEqualToString:@" "] || _shenHeStatus == nil || [_shenHeStatus isEqualToString:@""])
        {
            imageview.image = [UIImage imageNamed:defaultArray[i]];
//            imageview.backgroundColor = [UIColor redColor];
            imageview.userInteractionEnabled = YES;

        }else if([_shenHeStatus isEqualToString:@"审核中"] || [_shenHeStatus isEqualToString:@"失败"])
        {
            //需要判断是否有3张图片
            if (_infoArray.count != 0) {
                [imageview setImageWithURL:[NSURL URLWithString:_infoArray[i]] placeholderImage:[UIImage imageNamed:defaultArray[i]]];
            }
            
            imageview.userInteractionEnabled = NO;
            
        }else if([_shenHeStatus isEqualToString:@"审核成功"])
        {
            imageview.hidden = YES;
        }
        
//        if ([UIScreen mainScreen].bounds.size.height <= 568) {
//            imageview.frame = CGRectMake(20 + i*15 + i*(ScreenWidth- 20*2 - 30)/3,headView.frame.size.height/2 - 50/2, (ScreenWidth- 20*2 - 30)/3 , 50);
//        }else
//        {
            imageview.frame = CGRectMake(20 + i*15 + i*(ScreenWidth- 20*2 - 30)/3,headView.frame.size.height/2 - 60*ScreenWidth/320/2, (ScreenWidth- 20*2 - 30)/3 , 60*ScreenWidth/320);
//        }
        
        [imageview.layer setCornerRadius:5];
        [imageview.layer setMasksToBounds:YES];
        [headView addSubview:imageview];
        
        UITapGestureRecognizer *portraitTapTWo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
        portraitTapTWo.view.tag = i + 1000;
        [imageview addGestureRecognizer:portraitTapTWo];
        
        UIButton *rightCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightCancelBtn.tag = i + 123456;
        rightCancelBtn.hidden = YES;
//        rightCancelBtn.backgroundColor = [UIColor redColor];
        [rightCancelBtn addTarget:self action:@selector(clickCancelImgAction:) forControlEvents:UIControlEventTouchUpInside];
        rightCancelBtn.frame = CGRectMake(CGRectGetMaxX(imageview.frame) - 25 , CGRectGetMinY(imageview.frame) - 10, 40, 40);
        [headView addSubview:rightCancelBtn];
        
        UIImageView *cancelImg = [[UIImageView alloc]init];
        cancelImg.hidden = YES;
        cancelImg.tag = 987654 + i;
        cancelImg.image = [UIImage imageNamed:@"renzheng_cancel"];
        cancelImg.userInteractionEnabled = YES;
        cancelImg.frame = CGRectMake(CGRectGetMaxX(imageview.frame) - 10 , CGRectGetMinY(imageview.frame) - 6, 14*ScreenWidth/320, 14*ScreenWidth/320);
        [headView addSubview:cancelImg];
    }
    
    ///如果认证失败
    if ([_shenHeStatus isEqualToString:@"失败"]) {
       //认证失败图片
        renZhengimg = [[UIImageView alloc]init];
        renZhengimg.image = [UIImage imageNamed:@"renzheng_fail"];
        renZhengimg.frame = CGRectMake(ScreenWidth - 92*ScreenWidth/320, headView.frame.size.height/2 - imgW/2 + 30, 92*ScreenWidth/320, 92*ScreenWidth/320);
        [headView addSubview:renZhengimg];
    }
    
    if([_shenHeStatus isEqualToString:@"审核成功"])
    {
        headView.frame = CGRectMake(0, 0, ScreenWidth, 70 + 104*ScreenWidth/320 + 20);
        
        UIImageView *headImg = [[UIImageView alloc]init];
        headImg.image = [UIImage imageNamed:@"renzheng_sucess"];
        headImg.frame = CGRectMake(ScreenWidth/2 - 104*ScreenWidth/320/2, 70, 104*ScreenWidth/320, 68*ScreenWidth/320);
        [headView addSubview:headImg];
        
        UILabel *successLab = [[UILabel alloc]init];
        successLab.textAlignment = NSTextAlignmentCenter;
        successLab.font = [UIFont systemFontOfSize:13.0];
        successLab.text = @"身份认证成功";
        successLab.textColor = [UIColor grayColor];
        successLab.frame = CGRectMake(0, CGRectGetMaxY(headImg.frame) + 10, ScreenWidth, 21);
        [headView addSubview:successLab];
    }

    
    return headView;
}

- (void)clickCancelImgAction:(UIButton*)sender
{
    UIButton *btn = (UIButton *)sender;

    switch (sender.tag) {
        case 123456:
        {
            NSLog(@"1111111");
            btn.hidden = YES;
            //点击删除的时候，吧图片设置为nil，吧对应的数据里面的数据也清除
            UIImageView *imageView = (UIImageView*)[_scrollView viewWithTag:200];
            imageView.image = [UIImage imageNamed:defaultArray[0]];
            [_imageArray replaceObjectAtIndex:0 withObject:@""];
            
            //吧删除按钮隐藏
            UIImageView *cancelImg = (UIImageView *)[_scrollView viewWithTag:987654];
            cancelImg.hidden = YES;
        }
            break;
        case 123457:
        {
            NSLog(@"222222");
            btn.hidden = YES;
            //点击删除的时候，吧图片设置为nil，吧对应的数据里面的数据也清除
            UIImageView *imageView = (UIImageView*)[_scrollView viewWithTag:201];
            imageView.image = [UIImage imageNamed:defaultArray[1]];
            [_imageArray replaceObjectAtIndex:1 withObject:@""];
            
            //吧删除按钮隐藏
            UIImageView *cancelImg = (UIImageView *)[_scrollView viewWithTag:987655];
            cancelImg.hidden = YES;

        }
            break;
        case 123458:
        {
           NSLog(@"333333");
            btn.hidden = YES;
            //点击删除的时候，吧图片设置为nil，吧对应的数据里面的数据也清除
            UIImageView *imageView = (UIImageView*)[_scrollView viewWithTag:202];
            imageView.image = [UIImage imageNamed:defaultArray[2]];
            [_imageArray replaceObjectAtIndex:2 withObject:@""];

            //吧删除按钮隐藏
            UIImageView *cancelImg = (UIImageView *)[_scrollView viewWithTag:987656];
            cancelImg.hidden = YES;

        }
            break;
            
        default:
            break;
    }
    
    //只要删除了一张照片。就不让用户点击提交认证按钮
    [self updateUIbutton:NO];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    ShengFenRenZhengCell *cell = (ShengFenRenZhengCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[ShengFenRenZhengCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置自定义单元格不能点击
    [cell fillWithData:_dataArray[indexPath.row]];
//    NSLog(@"====:%@",_dataArray[indexPath.row]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (void)editPortrait:(UITapGestureRecognizer *)ges
{
    if (ges.view.tag == 200)
    {
        index = 0;
        
    }else if (ges.view.tag == 201)
    {
        index = 1;
        
    }else if (ges.view.tag == 202)
    {
        index = 2;
        
    }
    
    [self initWithCamerView];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (alertView.tag == 123456) {
        return;
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

#pragma mark - 移除拍照视图
- (void)removeCamerView
{
    [addView removeFromSuperview];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    
//    NSArray * array = [[UIApplication sharedApplication] windows];
//    
//    if (array.count >= 2) {
//        
//        window = [array objectAtIndex:1];
//    }

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
    //得到图片
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageName = @"image";
    
    //吧删除按钮显示出来
    UIImageView *cancelImgOne = (UIImageView *)[_scrollView viewWithTag:987654];
    
    UIImageView *cancelImgTwo = (UIImageView *)[_scrollView viewWithTag:987655];
    
    //吧删除按钮显示出来
    UIImageView *cancelImgThree = (UIImageView *)[_scrollView viewWithTag:987656];
    
    if (index == 0)
    {
        UIImageView *imgOne = (UIImageView *)[_scrollView viewWithTag:200];
        imgOne.image = image;
        
        //如果选择了第一张图片就把删除按钮显示出来
        UIButton *buttonOne = (UIButton *)[_scrollView viewWithTag:123456];
        buttonOne.hidden = NO;
        
        NSData *imageDataOne = UIImageJPEGRepresentation(imgOne.image, 0.3);
        [_imageArray replaceObjectAtIndex:0 withObject:imageDataOne];
        
        imagceshi = imgOne.image;
        
        NSString *newImgName = [NSString stringWithFormat:@"%@%ld%@",imageName,(long)1,@".png"];
        jpgPath = NSHomeDirectory();
        jpgPath = [[jpgPath stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:newImgName];
        [_imageArray[0] writeToFile:jpgPath atomically:YES];
        
        cancelImgOne.hidden = NO;
    }else if (index == 1)
    {
        UIImageView *imgTwo = (UIImageView *)[_scrollView viewWithTag:201];
        imgTwo.image = image;
        NSData *imageDataTwo = UIImageJPEGRepresentation(imgTwo.image, 0.3);
        [_imageArray replaceObjectAtIndex:1 withObject:imageDataTwo];
        
        NSString *newImgName = [NSString stringWithFormat:@"%@%ld%@",imageName,(long)2,@".png"];
        jpgPath = NSHomeDirectory();
        jpgPath = [[jpgPath stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:newImgName];
        [_imageArray[1] writeToFile:jpgPath atomically:YES];
        
        UIButton *buttonOne = (UIButton *)[_scrollView viewWithTag:123457];
        buttonOne.hidden = NO;
        
        cancelImgTwo.hidden = NO;
        //吧删除按钮显示出来
        
    }else if (index == 2)
    {
        UIImageView *imgThree = (UIImageView *)[_scrollView viewWithTag:202];
        imgThree.image = image;
        
        NSData *imageDataThree = UIImageJPEGRepresentation(imgThree.image, 0.3);
        [_imageArray replaceObjectAtIndex:2 withObject:imageDataThree];
        
        NSString *newImgName = [NSString stringWithFormat:@"%@%ld%@",imageName,(long)3,@".png"];
        jpgPath = NSHomeDirectory();
        jpgPath = [[jpgPath stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:newImgName];
        [_imageArray[2] writeToFile:jpgPath atomically:YES];
        
        UIButton *buttonOne = (UIButton *)[_scrollView viewWithTag:123458];
        buttonOne.hidden = NO;
        cancelImgThree.hidden = NO;
    
    }
    
    if(cancelImgOne.hidden == NO && cancelImgTwo.hidden == NO && cancelImgThree.hidden == NO)
    {
        [self updateUIbutton:YES];
    }

}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void )updateUIbutton:(BOOL) bEnable
{
    submitBtn.enabled = bEnable;
    [submitBtn setBackgroundColor:(bEnable ? RGBACOLOR(255, 62, 27, 1):[UIColor lightGrayColor])];
}


//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
