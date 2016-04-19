//
//  AddView.m
//  TheOne
//
//  Created by PXJ on 15/10/20.
//  Copyright © 2015年 PXJ. All rights reserved.
//

#import "AddView.h"
@interface AddView ()
{

    CGFloat addViewWidth;
    CGFloat addViewHeight;
    NSString * imgName;
    NSString * dscText;
}
@end
@implementation AddView

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName dsc:(NSString * )dsc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        addViewWidth = frame.size.width;
        addViewHeight = frame.size.height;
        imgName = imageName;
        dscText = dsc;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _imageV = [[UIImageView alloc] init];
    _imageV.center = CGPointMake(addViewWidth/2, addViewHeight*2/5);
    _imageV.bounds = CGRectMake(0, 0, addViewHeight*2/5, addViewHeight*2/5);
    _imageV.layer.cornerRadius = addViewHeight/5;
    _imageV.layer.masksToBounds = YES;
    _imageV.image = [UIImage imageNamed:@"welcome_14"];
    [self addSubview:_imageV];
    _dscLab = [[UILabel alloc] init];
    _dscLab.center = CGPointMake(addViewWidth/2, _imageV.center.y+addViewHeight/3);
    _dscLab.bounds = CGRectMake(0, 0, addViewWidth, addViewHeight/5);
    _dscLab.font = [UIFont systemFontOfSize:12];
    _dscLab.textColor = [UIColor whiteColor];
    _dscLab.textAlignment = NSTextAlignmentCenter;
    _dscLab.text = dscText;
    [self addSubview:_dscLab];


}
@end
