//
//  InputView.h
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate;

@interface InputView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)NSString * _Nullable placeHolderString;
@property (nonatomic,strong)NSString * _Nullable inputViewText;
@property (nonatomic,strong)UIView * _Nullable backView;
@property (nonatomic,strong)UITextView * _Nullable textView;
@property (nonatomic,strong)UIButton * _Nullable sendBtn;
@property (nonatomic,strong)UILabel * _Nullable titleLab;
@property (nonatomic,strong)UIButton * _Nullable cancelBtn;
@property (nonatomic,strong)UILabel * _Nullable placeholderLab;
@property (nonatomic,weak,nullable) id <InputViewDelegate> delegate;

@end


@protocol InputViewDelegate <NSObject>

////开始编辑
//- (void)beginEditing:(CGRect)inputFrame;
////隐藏
//- (void)hiddenInputView:(CGRect)inputFrame;
//发送
- (void)sendInfo:( NSString * _Nullable )infoStr;

- (void)cancelSendInfo;


@end