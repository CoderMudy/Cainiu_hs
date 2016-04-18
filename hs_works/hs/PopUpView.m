//
//  PopUpView.m
//  hs
//
//  Created by PXJ on 15/8/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PopUpView.h"
#define SelfWidth self.frame.size.width
#define SelfHeight self.frame.size.height

@interface PopUpView()<UITextFieldDelegate>

@end
@implementation PopUpView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        [self initUI];
        
        
        
        
    }
    return self;
}
- (id)initShowAlertWithTitle:(NSString *)title setShowText:(NSString*)showText showLine:(int)numShowLine setBtnTitleArray:(NSArray*)btnTitleArray
{
    self = [super init];
    if (self) {
        self.popUpViewStyle = popUpViewStyleShow;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        [self initUI];
        float titleHeight = ScreenWidth/6;
        float itemHeight = ScreenWidth/8;
        float alertWidth = ScreenWidth-2*itemHeight;
        
        float alertHeight = titleHeight+itemHeight*2;
        
        
        UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-alertWidth)/2, ScreenHeigth/2+alertHeight/2-(titleHeight-itemHeight)-itemHeight/2, alertWidth, titleHeight)];
        btnView.layer.cornerRadius =itemHeight/6;
        btnView.layer.masksToBounds = YES;
        btnView.backgroundColor = K_color_red;
        
        [_shadeView addSubview:btnView];
        
        
        
        UIView * alertView = [[UIView alloc] init];
        alertView.alpha = 1;
        alertView.tag = 60000;
        alertView.layer.cornerRadius = itemHeight/6;
        alertView.layer.masksToBounds = YES;
        alertView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2-itemHeight/2);
        alertView.bounds = CGRectMake(0, 0, alertWidth, alertHeight);
        alertView.backgroundColor = [UIColor whiteColor];
        
        [_shadeView addSubview:alertView];
        
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertWidth, titleHeight)];
        titleLab.text = title;
        titleLab.font = [UIFont systemFontOfSize:itemHeight*4/9];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHeight*3/4, alertWidth, 0.5)];
        lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
        [alertView addSubview:lineView];
        
        
        UILabel * showLab = [[UILabel alloc] initWithFrame:CGRectMake(itemHeight/2, titleHeight+1, alertWidth-itemHeight, itemHeight*4/3)];
        showLab.font = [UIFont systemFontOfSize:itemHeight/3];
        showLab.textAlignment = NSTextAlignmentCenter;
        showLab.numberOfLines = numShowLine;
        showLab.text = showText;
        [alertView addSubview:showLab];
        
        float btnWidth =(alertWidth-(btnTitleArray.count-1))/btnTitleArray.count;
        for (int i=0; i<btnTitleArray.count; i++) {
            if (i!=0) {
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((btnWidth+1)*i-1, titleHeight-itemHeight, 1, itemHeight)];
                lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
                [btnView addSubview:lineView];
                
            }
            
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.frame  = CGRectMake((btnWidth+1)*i,titleHeight-itemHeight, btnWidth, itemHeight);
            confirmBtn.tag = 66666+i;
            NSString * btntitle = btnTitleArray[i];
            [confirmBtn setTitle:btntitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:itemHeight/3]];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:confirmBtn];
            
            
        }
        
        
        
    }
    return self;



}

- (id)initShowAlertWithShowText:(NSString *)showText setBtnTitleArray:(NSArray*)btnTitleArray;
{
    self = [super init];
    if (self) {
        
        self.popUpViewStyle = popUpViewStyleShow;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        [self initUI];
        float itemHeight = ScreenWidth/8;
        float alertHeight = itemHeight*3;
        float alertWidth = ScreenWidth - itemHeight*2;
        float btnViewHeight = ScreenWidth/6;
        
        UIView * btnView = [[UIView alloc] init];
        btnView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2+alertHeight/2-(btnViewHeight-itemHeight)/2);
        btnView.bounds = CGRectMake(0, 0, alertWidth, btnViewHeight);
        btnView.layer.cornerRadius =itemHeight/6;
        btnView.layer.masksToBounds = YES;
        btnView.backgroundColor = K_color_red;
        [_shadeView addSubview:btnView];
        
        UIView * alertView = [[UIView alloc] init];
        alertView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2-itemHeight/2);
        alertView.bounds = CGRectMake(0, 0, alertWidth, alertHeight);
        alertView.layer.cornerRadius = itemHeight/6;
        alertView.layer.masksToBounds = YES;
        alertView.backgroundColor = [UIColor whiteColor];
        [_shadeView addSubview:alertView];

        
        UILabel * showLab = [[UILabel alloc] initWithFrame:CGRectMake(itemHeight/2, itemHeight/2, alertWidth-itemHeight, alertHeight-itemHeight)];
        showLab.text = showText;
        showLab.numberOfLines = 0;
        showLab.textAlignment = NSTextAlignmentCenter;
        showLab.font = [UIFont systemFontOfSize:itemHeight/3];
        [alertView addSubview:showLab];
        
        
        float btnWidth =(alertWidth-(btnTitleArray.count-1))/btnTitleArray.count;
        for (int i=0; i<btnTitleArray.count; i++) {
            if (i!=0) {
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((btnWidth+1)*i-1, btnViewHeight-itemHeight, 1, itemHeight)];
                lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
                [btnView addSubview:lineView];
                
            }
            
            
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.frame  = CGRectMake((btnWidth+1)*i,btnViewHeight-itemHeight, btnWidth, itemHeight);
            confirmBtn.tag = 66666+i;
            NSString * btntitle = btnTitleArray[i];
            [confirmBtn setTitle:btntitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:itemHeight/3]];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:confirmBtn];
            
            
        }
 
    }
    return self;
}
- (id)initInpuStyleAlertWithTitle:(NSString *)title setInputItemArray:(NSArray *)inputArray setBtnTitleArray:(NSArray*)btnTitleArray
{
    self = [super init];
    if (self) {
        self.popUpViewStyle = popUpViewStyleInput;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        _inputViewArray = [NSMutableArray array];
        [self initUI];
        float titleHeight = ScreenWidth/6;
        float itemHeight = ScreenWidth/8;
        float alertWidth = ScreenWidth - 2*itemHeight;
        float alertHeight =  itemHeight*(inputArray.count+2);
        
        UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-alertWidth)/2, ScreenHeigth/2+alertHeight/2-(titleHeight-itemHeight)-itemHeight/2, alertWidth, titleHeight)];
        btnView.layer.cornerRadius =itemHeight/6;
        btnView.layer.masksToBounds = YES;
        btnView.backgroundColor = K_color_red;
        
        [_shadeView addSubview:btnView];
        
        
        
        UIView * alertView = [[UIView alloc] init];
        alertView.alpha = 1;
        alertView.tag =50000;
        alertView.layer.cornerRadius = itemHeight/6;
        alertView.layer.masksToBounds = YES;
        alertView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2-itemHeight/2);
        alertView.bounds = CGRectMake(0, 0, alertWidth, alertHeight);
        alertView.backgroundColor = [UIColor whiteColor];
        
        
        [_shadeView addSubview:alertView];

        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,itemHeight*2/5, alertWidth, itemHeight)];
        titleLab.text = title;
        titleLab.font = [UIFont systemFontOfSize:itemHeight/3];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        
        for (int i=0; i<inputArray.count; i++) {
            
            UITextField * TF = [[UITextField alloc] initWithFrame:CGRectMake(itemHeight/2, itemHeight*3/2+i*itemHeight, alertWidth-itemHeight, itemHeight*3/4)];
            TF.borderStyle = UITextBorderStyleRoundedRect;
            TF.placeholder = inputArray[i];
            TF.delegate = self;
            TF.font = [UIFont systemFontOfSize:itemHeight/3];
            TF.tag = 77777+i;
            TF.secureTextEntry = YES;
            [alertView addSubview:TF];
            [_inputViewArray addObject:TF];
            
        }
        
        float btnWidth =(alertWidth-(btnTitleArray.count-1))/btnTitleArray.count;
        for (int i=0; i<btnTitleArray.count; i++) {
            if (i!=0) {
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((btnWidth+1)*i-1, titleHeight-itemHeight, 1, itemHeight)];
                lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
                [btnView addSubview:lineView];
                
            }
            
            
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.frame  = CGRectMake((btnWidth+1)*i,titleHeight-itemHeight, btnWidth, itemHeight);
            confirmBtn.tag = 66666+i;
            NSString * btntitle = btnTitleArray[i];
            [confirmBtn setTitle:btntitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:itemHeight/3]];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:confirmBtn];
            
            
        }

        
    }
    return self;
}


- (id)initWithTitle:(NSString *)title setItemtitleArray:(NSArray*)itemTextArray setBtnTitleArray:(NSArray*)btnTitleArray
{
    self = [super init];
    if (self) {
        self.popUpViewStyle = popUpViewStyleItemClck;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        [self initUI];
        float titleHeight = ScreenWidth/6;
        float itemHeight = ScreenWidth/8;
        float alertWidth = ScreenWidth-2*itemHeight;
        
        float alertHeight = titleHeight+itemHeight*(itemTextArray.count-1)+(titleHeight+itemHeight)/2;
        
        
        UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-alertWidth)/2, ScreenHeigth/2+alertHeight/2-(titleHeight-itemHeight)-itemHeight/2, alertWidth, titleHeight)];
        btnView.layer.cornerRadius =itemHeight/6;
        btnView.layer.masksToBounds = YES;
        btnView.backgroundColor = K_color_red;
        
        [_shadeView addSubview:btnView];
        

        
        UIView * alertView = [[UIView alloc] init];
        alertView.alpha = 1;
        alertView.tag = 60000;
        alertView.layer.cornerRadius = itemHeight/6;
        alertView.layer.masksToBounds = YES;
        alertView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2-itemHeight/2);
        alertView.bounds = CGRectMake(0, 0, alertWidth, alertHeight);
        alertView.backgroundColor = [UIColor whiteColor];
        
        
        [_shadeView addSubview:alertView];

        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertWidth, titleHeight)];
        titleLab.text = title;
        titleLab.font = [UIFont systemFontOfSize:itemHeight*4/9];
        titleLab.textColor = K_color_red;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:titleLab];
        
        
        
        
        for (int i=0; i<itemTextArray.count; i++) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHeight+i*itemHeight, alertWidth, 1)];
            lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
            [alertView addSubview:lineView];
            
            UIButton * itembtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itembtn.frame  = CGRectMake(0, titleHeight+i*itemHeight+1, alertWidth, itemHeight-1);
            itembtn.tag = 55555+i;
            [itembtn setTitle:itemTextArray[i] forState:UIControlStateNormal];
            [itembtn.titleLabel setFont:[UIFont systemFontOfSize:itemHeight/3]];
            [itembtn setTitleColor:K_COLOR_CUSTEM(64, 64, 64, 1) forState:UIControlStateNormal];
            [itembtn addTarget:self action:@selector(itembtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [alertView addSubview:itembtn];

        }
        
        float btnWidth =(alertWidth-(btnTitleArray.count-1))/btnTitleArray.count;
        for (int i=0; i<btnTitleArray.count; i++) {
            if (i!=0) {
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((btnWidth+1)*i-1, titleHeight-itemHeight, 1, itemHeight)];
                lineView.backgroundColor = K_COLOR_CUSTEM(153, 153, 153, 1);
                [btnView addSubview:lineView];
                
            }

            
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.frame  = CGRectMake((btnWidth+1)*i,titleHeight-itemHeight, btnWidth, itemHeight);
            confirmBtn.tag = 66666+i;
            NSString * btntitle = btnTitleArray[i];
            [confirmBtn setTitle:btntitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:itemHeight/3]];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:confirmBtn];
            
  
        }
        [self bringSubviewToFront:alertView];
        
        
    }
    
    return self;
    
    
}
- (void)initUI
{
    //
    _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeigth, SelfHeight)];
    [self addSubview:_shadeView];
    
    _backConcelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backConcelBtn.center = CGPointMake(SelfWidth/2, SelfHeight/2);
    _backConcelBtn.bounds = CGRectMake(0, 0, SelfWidth, SelfHeight);
    _backConcelBtn.alpha = 0.5;

    _backConcelBtn.backgroundColor = Color_black;
    [_backConcelBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [_shadeView addSubview:_backConcelBtn];

}

- (void)hideSelf
{
    [self endEditing:YES];

}
- (void)itembtnClick:(UIButton*)button
{
    
    if (self.popUpViewStyle==popUpViewStyleItemClck) {
        self.itemClick(button);
        [self removeFromSuperview];
        

    }
}
- (void)confirmbtnClick:(UIButton*)button
{

    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    switch (self.popUpViewStyle) {
        case popUpViewStyleInput:
        {
            NSMutableArray * inputTextArray = [NSMutableArray array];
            for (UITextField *TF in _inputViewArray) {
                NSString * text = TF.text==nil?@"":TF.text;
                [inputTextArray addObject:text];
            }
            self.twoObjectblock(button,(NSArray*)inputTextArray);
        }
            break;
        case popUpViewStyleItemClck:
        {
        
            self.confirmClick(button);
            [self removeFromSuperview];

        }
            break;
        case popUpViewStyleShow:
        {
        
        
            self.confirmClick(button);
            [self removeFromSuperview];

        }
            break;
            
        default:
            break;
    }


}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (!textField.window.isKeyWindow) {
//        [textField.window makeKeyAndVisible];
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>=20) {
      
        [textField resignFirstResponder];
//        return NO;
    }

    return YES;


}

@end
