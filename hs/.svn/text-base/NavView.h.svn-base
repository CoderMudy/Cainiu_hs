//
//  NavView.h
//  hs
//
//  Created by PXJ on 15/10/28.
//  Copyright © 2015年 luckin. All rights reserved.
//

typedef void(^ClickBlock)(int);
#import <UIKit/UIKit.h>

@interface NavView : UIView

@property (nonatomic,strong)ClickBlock clickBlock;
@property (nonatomic,strong)UIImageView * leftImg;
@property (nonatomic,strong)UIImageView * rightImg;
@property (nonatomic,strong)UIButton * leftControl;
@property (nonatomic,strong)UIButton * rightControl;
@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UIView * superVC;
@property (nonatomic,strong)UILabel * rightLab;

- (id)initWithFrame:(CGRect)frame;
-(void)setTitle:(NSString *)title;
-(void)hiddenleft;
@end
