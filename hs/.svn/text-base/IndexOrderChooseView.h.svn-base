//
//  IndexOrderChooseView.h
//  hs
//
//  Created by RGZ on 16/4/11.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IndexOrderChooseView : UIView<UITextFieldDelegate>

typedef void(^IndexOrderChooseMinusBlock)(IndexOrderChooseView *);
typedef void(^IndexOrderChoosePlusBlock)(IndexOrderChooseView *);
typedef void(^IndexOrderChooseEditEndBlock)(IndexOrderChooseView *);

@property (nonatomic,strong)UIButton    *minusButton;

@property (nonatomic,strong)UIButton    *plusButton;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UIView  *plusLineView;

@property (nonatomic,strong)UIView  *minusLineView;

@property (nonatomic,strong)IndexOrderChooseMinusBlock minusBlock;

@property (nonatomic,strong)IndexOrderChoosePlusBlock plusBlock;

@property (nonatomic,strong)IndexOrderChooseEditEndBlock editEndBlock;

@property (nonatomic,assign)int     jump;

@end
