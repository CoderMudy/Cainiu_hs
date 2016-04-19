//
//  PShowImageV.m
//  hs
//
//  Created by PXJ on 16/3/24.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "PShowImageV.h"
#import "UIImageView+WebCache.h"

@implementation PShowImageV

{

    UIScrollView * _scrollView;
    NSMutableArray * _imgArray;
    NSMutableArray * _imgSizeArray;
    UILabel * _numMarkLab;
    int contentIndex;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithImgArray:(NSMutableArray*)imgArray;
{
    self = [super init];
    if (self) {
        _imgArray = imgArray;
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _scrollView = [[UIScrollView alloc] init ];
    _scrollView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2);
    _scrollView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = 8888;
    _scrollView.layer.masksToBounds = YES;
    [self addSubview:_scrollView];
    
    for (int i=0; i<_imgArray.count; i++) {
        UIScrollView * imgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeigth)];
        imgScrollV.tag = 12200+i;
        imgScrollV.delegate = self;
        imgScrollV.minimumZoomScale = 0.5;
        imgScrollV.maximumZoomScale = 2.0;
        [_scrollView addSubview:imgScrollV];
        
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        imageV.tag = 12300+i;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [imgScrollV addSubview:imageV];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
        [imageV addGestureRecognizer:tap];
   }
    _scrollView.contentSize = CGSizeMake(ScreenWidth*_imgArray.count, ScreenHeigth);
    _numMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeigth-60, 100, 30)];
    _numMarkLab.textColor = [UIColor whiteColor];
    _numMarkLab.font = FontSize(14);
    [self addSubview:_numMarkLab];
}

- (void)showImageVWithImage:(NSString *)imgUrlStr
{
    _imgSizeArray = [[NSMutableArray alloc] init];
    for (int i=0; i<_imgArray.count; i++) {
        if ([imgUrlStr isEqual:_imgArray[i]] ) {
            contentIndex = i;
            _scrollView.contentSize = CGSizeMake(ScreenWidth *_imgArray.count, ScreenHeigth);
        }
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgArray[i]]];
        UIImage * img = [UIImage imageWithData:data];
        CGFloat imgHeight = ScreenWidth*img.size.height/img.size.width;
//        img = [self addImage:img toImage:[UIImage imageNamed:@"k_color_black"] withCenterHeght:imgHeight];
        UIScrollView * scrlV = [_scrollView viewWithTag:12200+i];
        UIImageView * imgV = [scrlV viewWithTag:12300+i];
        imgV.image = img;
        imgV.userInteractionEnabled = YES;
        [_imgSizeArray addObject:[NSString stringWithFormat:@"%f",imgHeight]];
    }

    _numMarkLab.text = [NSString stringWithFormat:@"%d/%lu",contentIndex+1,(unsigned long)_imgArray.count];

    _scrollView.contentOffset = CGPointMake(contentIndex*ScreenWidth, 0);

    self.hidden = NO;
    self.alpha = 0;

    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}


- (void)hiddenSelf
{
   __block UIScrollView * scrlV = [_scrollView viewWithTag:12200+contentIndex];
   __block UIImageView * imgv = [scrlV viewWithTag:12300+contentIndex];
    if (imgv.frame.size.width ==ScreenWidth)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished)
         {
             self.hidden = YES;
         }];
    }else
    {
        [scrlV setZoomScale:1 animated:NO];
 }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==8888) {
        contentIndex = (int)scrollView.contentOffset.x/ScreenWidth;
        _numMarkLab.text = [NSString stringWithFormat:@"%d/%lu",contentIndex+1,(unsigned long)_imgArray.count];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIScrollView * scrlV = [_scrollView viewWithTag:12200+contentIndex];
    UIImageView * imgv = [scrlV viewWithTag:12300+contentIndex];
   
    
    return imgv;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
{
    UIScrollView * scrlV = [_scrollView viewWithTag:12200+contentIndex];

    if (scrlV.zoomScale<1) {
        [scrlV setZoomScale:1 animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.tag==8888)
    {
        for (int i=0; i<scrollView.subviews.count; i++)
        {
            if ([scrollView.subviews[i] isKindOfClass:[UIScrollView class]])
            {
                UIScrollView * subScro =  scrollView.subviews[i];
                [subScro setZoomScale:1 animated:YES];

            }
        }
    }else
    {
        
    }
}
- (UIImage *)addImage:(UIImage *)centerImage1 toImage:(UIImage *)image2 withCenterHeght:(CGFloat)centerHeight {
   
    CGFloat sizeTimes = centerImage1.size.width/ScreenWidth;
    
    CGSize size = CGSizeMake(ScreenWidth*sizeTimes, ScreenHeigth*sizeTimes);
    
    UIGraphicsBeginImageContext(size);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, ScreenWidth*sizeTimes, ScreenHeigth*sizeTimes)];
    
    // Draw image2
    [centerImage1 drawInRect:CGRectMake(0, (ScreenHeigth-centerHeight)*sizeTimes/2, ScreenWidth*sizeTimes, centerHeight*sizeTimes)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end
