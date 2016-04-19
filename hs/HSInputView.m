//
//  HSInputView.m
//  hs
//
//  Created by 杨永刚 on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HSInputView.h"

@implementation HSInputView
{
    UIImage *_imgae;
    UIImage *_highlightImage;
    
    UILabel *_textLable;
    
    UILabel *_upLine;
//    UILabel *_downLine;
}

- (instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)image  highlightImage:(UIImage *) highlightImage placeholderStr:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgae = image;
        _highlightImage = highlightImage;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (frame.size.height-image.size.height)/2+1, 25, 25)];
        _lineImageView.center = CGPointMake(_lineImageView.center.x, self.center.y);
        [_iconImageView setBackgroundColor:[UIColor clearColor]];
        _iconImageView.image = image;
        [self addSubview:_iconImageView];
        
        _inputText = [[UITextField alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+10, 0, ScreenWidth-_iconImageView.frame.origin.x-_iconImageView.frame.size.width-20, self.frame.size.height)];
        [_inputText setBackgroundColor:[UIColor clearColor]];
        _inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputText.placeholder = placeholder;
        [_inputText addTarget:self action:@selector(textFieldBeginInput:) forControlEvents:UIControlEventEditingDidBegin];
        [_inputText addTarget:self action:@selector(textFieldEndInput:) forControlEvents:UIControlEventEditingDidEnd];
        [self addSubview:_inputText];
        
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        [_lineImageView setBackgroundColor:RGBCOLOR(178, 178, 178)];
        [self addSubview:_lineImageView];
        
        _upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        [_upLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_upLine];
        
        _downLine = [[UILabel alloc] initWithFrame:_lineImageView.frame];
        [_downLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_downLine];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)textStr  placeholderStr:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *attrubributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor grayColor]};
        CGSize size = [textStr sizeWithAttributes:attrubributeDic];
        
        _textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, (HEIGHT(self)-size.height)/2, size.width, size.height)];
        [_textLable setText:textStr];
        [_textLable setFont:[UIFont systemFontOfSize:14]];
        [_textLable setTextColor:[UIColor colorWithHexString:@"373635"]];
        [_textLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_textLable];
        
        _inputText = [[UITextField alloc] initWithFrame:CGRectMake(_textLable.frame.origin.x+_textLable.frame.size.width+10, 0, ScreenWidth-_textLable.frame.origin.x-_textLable.frame.size.width-20, self.frame.size.height)];
        [_inputText setBackgroundColor:[UIColor clearColor]];
        _inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputText.placeholder = placeholder;
        //[_inputText setFont:[UIFont systemFontOfSize:12]];
        [_inputText addTarget:self action:@selector(textFieldBeginInput:) forControlEvents:UIControlEventEditingDidBegin];
        [_inputText addTarget:self action:@selector(textFieldEndInput:) forControlEvents:UIControlEventEditingDidEnd];
        [self addSubview:_inputText];
        
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        [_lineImageView setBackgroundColor:RGBCOLOR(178, 178, 178)];
        [self addSubview:_lineImageView];
        
        _upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        [_upLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_upLine];
        
        _downLine = [[UILabel alloc] initWithFrame:_lineImageView.frame];
        [_downLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_downLine];
    }
    
    return self;
}


- (void)textFieldBeginInput:(UITextField *)textField
{
    [_lineImageView setBackgroundColor:[UIColor clearColor]];
    [_upLine setBackgroundColor:RGBCOLOR(250, 66, 0)];
    [_downLine setBackgroundColor:RGBCOLOR(250, 66, 0)];
   _iconImageView.image = _highlightImage;
}

- (void)textFieldEndInput:(UITextField *)textField
{
    [_lineImageView setBackgroundColor:RGBCOLOR(178, 178, 178)];
    [_upLine setBackgroundColor:[UIColor clearColor]];
    [_downLine setBackgroundColor:[UIColor clearColor]];
     _iconImageView.image = _imgae;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
