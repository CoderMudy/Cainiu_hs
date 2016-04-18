//
//  AccountUserView.h
//  hs
//
//  Created by PXJ on 16/2/19.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^UserClickBlock)(UIButton*button);
#import <UIKit/UIKit.h>

@interface AccountUserView : UIView
@property (copy)UserClickBlock userclickBlock;
@property (nonatomic,strong)UIButton * setBtn;
@property (nonatomic,strong)UILabel * adLab;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UIButton * RegistBtn;

@property (nonatomic,strong)UIImageView * headerEditImgV;
@property (nonatomic,strong)UIImageView * userHeaderImgV;
@property (nonatomic,strong)UIButton * userHeaderBtn;
@property (nonatomic,strong)UIButton * userNickBtn;
@property (nonatomic,strong)UIButton * userSignBtn;
@property (nonatomic,strong) UILabel * userSignLab;

@property (nonatomic,strong)UIButton * userQRcodeBtn;
@property (nonatomic,strong)UIImageView * userQRcodeImgV;
- (void)updateUserViewWithDetail:(NSDictionary*)dic;
@end
