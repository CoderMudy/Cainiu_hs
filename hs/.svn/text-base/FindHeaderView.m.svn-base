//
//  FindHeaderView.m
//  hs
//
//  Created by PXJ on 15/10/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FindHeaderView.h"

#define nameFont  [UIFont italicSystemFontOfSize:17*ScreenWidth/375];
#define dscFont  [UIFont systemFontOfSize:12*ScreenWidth/375];

@interface FindHeaderView ()
{

    
    CGFloat  mainHeight;
    
}
@end

@implementation FindHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mainHeight = frame.size.height-2;
        self.backgroundColor = [UIColor whiteColor];
        [self initUIView];
    }
    return self;
}
- (void)initUIView
{
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth*8/21, mainHeight)];
    [self addSubview:self.mainView];
    
    UITapGestureRecognizer  * mainSingleRecognizer = [[UITapGestureRecognizer alloc] init];
    [mainSingleRecognizer addTarget:self action:@selector(mainClick)];
    mainSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.mainView addGestureRecognizer:mainSingleRecognizer];
    
    UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.mainView.frame.size.width, 10, 0.5, mainHeight-20)];
    verticalLine.backgroundColor = K_color_line;
    [self addSubview:verticalLine];
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(self.mainView.frame.size.width+1, 0, ScreenWidth*3/5, mainHeight/2)];
    [self addSubview:self.secondView];
    
    UITapGestureRecognizer  * secondSingleRecognizer = [[UITapGestureRecognizer alloc] init];
    [secondSingleRecognizer addTarget:self action:@selector(secondClick)];
    secondSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.secondView addGestureRecognizer:secondSingleRecognizer];
    

    UIView * horizenLine = [[UIView alloc] initWithFrame:CGRectMake(self.mainView.frame.size.width+10, mainHeight/2, ScreenWidth*3/5-20, 0.5)];
    horizenLine.backgroundColor = K_color_line;
    [self addSubview:horizenLine];
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(self.secondView.frame.origin.x, mainHeight/2+1, ScreenWidth*3/5, mainHeight/2)];
    [self addSubview:self.thirdView];
    
    UITapGestureRecognizer  * thirdSingleRecognizer = [[UITapGestureRecognizer alloc] init];
    [thirdSingleRecognizer addTarget:self action:@selector(thirdClick)];
    thirdSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.thirdView addGestureRecognizer:thirdSingleRecognizer];
    
    
    
    
    UIView * separatLine = [[UIView alloc] initWithFrame:CGRectMake(0, mainHeight+1, ScreenWidth, 0.5)];
    separatLine.backgroundColor = K_color_line;
    [self addSubview:separatLine];
    
    
    CGFloat mainWidth = self.mainView.frame.size.width;
    
    
    UIImageView * mainImgV = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth/2-ScreenWidth*24*6/375/5, mainHeight/2- ScreenWidth*45*6/375/5-5, ScreenWidth*48*6/375/5, ScreenWidth*45*6/375/5)];
    [self.mainView addSubview:mainImgV];
    UILabel * mainNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainHeight/2+5, mainWidth, 20)];
    mainNameLab.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:mainNameLab];
    UILabel * mainDscLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainNameLab.frame.size.height+mainNameLab.frame.origin.y, mainWidth, 20)];
    mainDscLab.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:mainDscLab];
    
    
    CGFloat secondWidth = self.secondView.frame.size.width;
    CGFloat imgVWidth = mainWidth*5/16;
    CGFloat imgVHeight = imgVWidth*71/76;
    
    
    UIImageView * secondImgV = [[UIImageView alloc] initWithFrame:CGRectMake(secondWidth/9, mainHeight/4-imgVHeight/2,imgVWidth, imgVHeight)];
    [self.secondView addSubview:secondImgV];
    UILabel * secondNameLab = [[UILabel alloc] initWithFrame:CGRectMake(secondImgV.frame.origin.x+mainWidth/4+20, secondImgV.frame.origin.y, secondWidth-secondImgV.frame.origin.x-mainWidth/4, 20)];
    [self.secondView addSubview:secondNameLab];
    UILabel * secondDscLab = [[UILabel alloc] initWithFrame:CGRectMake(secondImgV.frame.origin.x+mainWidth/4+20, secondNameLab.frame.size.height+secondNameLab.frame.origin.y, secondWidth-secondImgV.frame.origin.x-mainWidth/4, 20)];
    [self.secondView addSubview:secondDscLab];
    
    
    
    UIImageView * thirdImgV = [[UIImageView alloc] initWithFrame:CGRectMake(secondWidth/9,mainHeight/4- imgVHeight/2, imgVWidth, imgVHeight)];
    [self.thirdView addSubview:thirdImgV];
    UILabel * thirdNameLab = [[UILabel alloc] initWithFrame:CGRectMake(secondImgV.frame.origin.x+mainWidth/4+20, secondImgV.frame.origin.y, secondWidth-secondImgV.frame.origin.x-mainWidth/4, 20)];
    [self.thirdView addSubview:thirdNameLab];
    UILabel * thirdDscLab = [[UILabel alloc] initWithFrame:CGRectMake(secondImgV.frame.origin.x+mainWidth/4+20, secondNameLab.frame.size.height+secondNameLab.frame.origin.y, secondWidth-secondImgV.frame.origin.x-mainWidth/4, 20)];
    [self.thirdView addSubview:thirdDscLab];
    
    
    mainNameLab.font        = nameFont
    secondNameLab.font      = nameFont;
    thirdNameLab.font       = nameFont;
    mainDscLab.font         = dscFont;
    secondDscLab.font       = dscFont;
    thirdDscLab.font        = dscFont;

    mainDscLab.textColor    = K_color_gray;
    secondDscLab.textColor    = K_color_gray;
    thirdDscLab.textColor    = K_color_gray;
    
    if(AppStyle_SAlE){
        mainNameLab.text = @"推广分享";
        mainDscLab.text = @"轻松分享给好友" ;
    }else{
        mainNameLab.text = @"推广赚钱";
        mainDscLab.text = @"0成本 轻松赚" ;
    }


    secondNameLab.text = @"消息中心";
    thirdNameLab.text = @"客服中心";
    secondDscLab.text = @"重大消息都在这";
    thirdDscLab.text = @"您的专属客服";

    mainImgV.image  = [UIImage imageNamed:@"findPage_01"];
    secondImgV.image = [UIImage imageNamed:@"findPage_02"];
    thirdImgV.image = [UIImage imageNamed:@"findPage_03"];
    

}
- (void)mainClick
{
    self.clickViewBlock(1);
    self.mainView.backgroundColor =  K_COLOR_CUSTEM(210, 210, 210, 1);
    [self performSelector:@selector(changeViewBackGround:) withObject:self.mainView afterDelay:0.1];
}
- (void)secondClick
{
    self.clickViewBlock(2);
    self.secondView.backgroundColor =  K_COLOR_CUSTEM(210, 210, 210, 1);
    [self performSelector:@selector(changeViewBackGround:) withObject:self.secondView afterDelay:0.1];

}
- (void)thirdClick
{
    self.clickViewBlock(3);
    self.thirdView.backgroundColor =  K_COLOR_CUSTEM(210, 210, 210, 1);
    [self performSelector:@selector(changeViewBackGround:) withObject:self.thirdView afterDelay:0.1];

}

- (void)changeViewBackGround:(UIView*)view
{

    view.backgroundColor = [UIColor whiteColor];

}
@end
