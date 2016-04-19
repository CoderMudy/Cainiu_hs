//
//  HSInputView.h
//  hs
//
//  Created by 杨永刚 on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)image  highlightImage:(UIImage *) highlightImage placeholderStr:(NSString *)placeholder;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)textStr  placeholderStr:(NSString *)placeholder;

@property (nonatomic, strong) UITextField *inputText;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *downLine;


@end
