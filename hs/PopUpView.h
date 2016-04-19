//
//  PopUpView.h
//  hs
//
//  Created by PXJ on 15/8/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^TwoObjectBlock)(id,id);
typedef void(^ItemBtnClick)(id);
typedef void(^ConfirmBtnClick)(id);
typedef enum {
    popUpViewStyleInput,
    popUpViewStyleItemClck,
    popUpViewStyleShow
}PopUpViewStyle;

#import <UIKit/UIKit.h>

@interface PopUpView : UIView

@property(nonatomic,assign)PopUpViewStyle popUpViewStyle;
@property(nonatomic,strong)UIView * shadeView;
@property(nonatomic,strong)UIButton * backConcelBtn;//全屏阴影按钮可点击
@property (nonatomic,strong)NSMutableArray * inputViewArray;//UITextField的数组tag从77777开始
@property (nonatomic,strong)TwoObjectBlock twoObjectblock;
@property (nonatomic,strong)ItemBtnClick itemClick;//button的tag从55555开始
@property (nonatomic,strong)ConfirmBtnClick confirmClick;//button的tag从66666开始

//标题，内容，按钮
- (id)initShowAlertWithTitle:(NSString *)title setShowText:(NSString*)showText showLine:(int)numShowLine setBtnTitleArray:(NSArray*)btnTitleArray;

//内容，按钮
- (id)initShowAlertWithShowText:(NSString *)showText setBtnTitleArray:(NSArray*)btnTitleArray;//只显示内容的警告框

//
- (id)initInpuStyleAlertWithTitle:(NSString *)title setInputItemArray:(NSArray *)inputArray setBtnTitleArray:(NSArray*)btnTitleArray;//含输入框的警告框

- (id)initWithTitle:(NSString *)title setItemtitleArray:(NSArray*)itemTextArray setBtnTitleArray:(NSArray*)btnTitleArray;//充值返回拦截的警告框

@end
