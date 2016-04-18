//
//  UserSpreadQR.m
//  hs
//
//  Created by PXJ on 15/10/12.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "UserSpreadQR.h"

@implementation UserSpreadQR

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame imageUrl:(NSString*)strUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgUrl = strUrl;
        [self initUIView];
        
        
        
    }
    return self;
}
-(void)initUIView
{
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backBtn.backgroundColor = [UIColor blackColor];
    [backBtn addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.alpha = 0.8;
    [self addSubview:backBtn];

    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(50*ScreenWidth/375, 140*ScreenWidth/375, ScreenWidth-100*ScreenWidth/375, ScreenWidth-100*ScreenWidth/375)];
    _imgV.image =[self createNonInterpolatedUIImageFormCIImage:[self createQRForString:_imgUrl] withSize:250];
    [self addSubview:_imgV];
    
    UILabel * showLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgV.frame.size.height+_imgV.frame.origin.y+10, ScreenWidth, 20)];
    showLab.text = @"扫一扫 马上推广赚钱";
    [showLab setFont:[UIFont boldSystemFontOfSize:13]];
    showLab.textColor= [UIColor whiteColor];
    showLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:showLab];
                    
    UIImageView * centerImgV = [[UIImageView alloc] init];
    centerImgV.center = _imgV.center;
    centerImgV.bounds = CGRectMake(0, 0, 65*ScreenWidth/375, 65*ScreenWidth/375);
    centerImgV.image = [UIImage imageNamed:@"findPage_14"];
    [self addSubview:centerImgV];

}
- (void)removeClick
{
    [self removeFromSuperview];


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


@end
