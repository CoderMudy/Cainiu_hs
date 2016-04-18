//
//  FindZBarViewController.m
//  hs
//
//  Created by Xse on 15/10/10.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FindZBarViewController.h"
#import "NetRequest.h"

#define button_tag 100001
#define textLab_tag 100002
#define centerImg_tag 100003
@interface FindZBarViewController ()
{
    UIImageView *_imgV;
    NSString *shareUrl;
}
@end

@implementation FindZBarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    shareUrl = @"";
    [self initNav];
    [self loadZBarUI];
    [self getPromotionLink];

}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.leftControl addTarget:self action:@selector(leftControl) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLab.text = @"我的推广码";
    [self.view addSubview:nav];
}

- (void)leftControl
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadZBarUI
{
    
    _imgV = [[UIImageView alloc]init];
    _imgV.frame = CGRectMake(50*ScreenWidth/375, 140*ScreenWidth/375-20+64, ScreenWidth-100*ScreenWidth/375, ScreenWidth-100*ScreenWidth/375);
    [self.view addSubview:_imgV];
    
    CGFloat centerLength = (ScreenWidth-100*ScreenWidth/375)/4;
    UIImageView * centerImage = [[UIImageView alloc] init];
    centerImage.tag = centerImg_tag;
    centerImage.center = _imgV.center;
    centerImage.bounds = CGRectMake(0, 0, centerLength, centerLength);
    [self.view addSubview:centerImage];
    
    
    
//    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:shareUrl] withSize:250.0f];
    //    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
//    imageView.image = qrcode;
    // set shadow123456qwe
    _imgV.userInteractionEnabled = YES;

    
    UIButton * button = [[UIButton alloc] init ];
    button.center = _imgV.center;
    button.bounds = CGRectMake(0, 0, 44*ScreenWidth/375, 50*ScreenWidth/375);
    button.hidden = YES;
    button.tag = button_tag;
    [button addTarget:self action:@selector(getPromotionLink) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"findPage_update"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    
    
   
    UILabel *textLab = [[UILabel alloc]init];
    textLab.frame = CGRectMake(0, _imgV.frame.size.height+_imgV.frame.origin.y+10, ScreenWidth, 20);
    textLab.font = [UIFont systemFontOfSize:13.0];
    textLab.tag = textLab_tag;
    textLab.textColor = [UIColor whiteColor];
    textLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLab];

}

- (void)updateImage:(BOOL)success
{
    UIButton * button = (UIButton*)[self.view viewWithTag:button_tag];
    UILabel * textLab = (UILabel*)[self.view viewWithTag:textLab_tag];
    button.hidden = success;
    _imgV.hidden = !success;
    if (success) {
        textLab.frame = CGRectMake(0, _imgV.frame.size.height+_imgV.frame.origin.y+10, ScreenWidth, 20);
        UIImageView * centerImg = (UIImageView*)[self.view viewWithTag:centerImg_tag];
        centerImg.image =[UIImage imageNamed:@"findPage_14"];
        UIImage *boundImg = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:shareUrl] withSize:250.0f];
        _imgV.image =boundImg;
//        [self addImage:centerImg toImage:boundImg];
        textLab.text = @"扫一扫 马上推广赚钱";

        
    }else{
        textLab.frame = CGRectMake(0, button.frame.size.height+button.frame.origin.y+20, ScreenWidth, 20);
        textLab.text = @"点击重新加载";
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

#pragma mark - 获取分享链接地址
- (void)getPromotionLink
{
    [RequestDataModel requestUserQRSuccessBlock:^(BOOL success, BOOL clickStatus, NSString *msg) {
        if (success) {
            shareUrl = msg;
        }
        [self updateImage:success];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
