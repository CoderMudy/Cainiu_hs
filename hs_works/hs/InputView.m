//
//  InputView.m
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "InputView.h"
#import "EmojiClass.h"

@implementation InputView 
{
    CGFloat _inputVHeight;
    NSString * _lastStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputVHeight  = frame.size.height;
        _placeHolderString = @"说点什么吧...";
        _inputViewText = @"";
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor = RGBCOLOR(244, 244, 244);
    _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, _inputVHeight-45)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderColor = K_color_line.CGColor;
    _backView.layer.borderWidth = 1;
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont: FontSize(14)];
    [_cancelBtn addTarget:self action:@selector(cancelSend) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(CGRectGetMaxX(_backView.frame)-60, 0, 60, 40);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:K_color_grayBlack forState:UIControlStateNormal];
    [_sendBtn.titleLabel setFont: FontSize(14)];
    [_sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
    _sendBtn.enabled = NO;
    
    _titleLab = [[UILabel alloc] init ];
    _titleLab.center = CGPointMake(CGRectGetWidth(_backView.frame)/2, 20);
    _titleLab.bounds = CGRectMake(0, 0, 100, 20);
    _titleLab.text = @"回复";
    _titleLab.font = FontSize(16);
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(_backView.frame)-20, CGRectGetHeight(_backView.frame)-10)];
//    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = FontSize(15);
    [_backView addSubview:_textView];
    _textView.returnKeyType = UIReturnKeySend;
    
    _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(_backView.frame)-20, 18)];
    _placeholderLab.text = _placeHolderString;
    _placeholderLab.font = FontSize(15);
    _placeholderLab.textColor = K_color_grayLine;
    [_backView addSubview:_placeholderLab];
    
 
    
}
- (void)sendMessage
{
    [_delegate sendInfo:_inputViewText];
}
- (void)cancelSend
{
    [_delegate cancelSendInfo];
    _placeHolderString = @"说点什么吧...";
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView;
{
    NSString *content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length>0)
    {
        _placeholderLab.text = @"";
        _placeholderLab.hidden = YES;
        _sendBtn.enabled = YES;
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        _placeholderLab.text = _placeHolderString;
        _placeholderLab.hidden = NO;
        _sendBtn.enabled = NO;
        [_sendBtn setTitleColor:K_color_grayBlack forState:UIControlStateNormal];
    }
    
    
//    if(_inputViewText.length>500)
//    {
//        textView.text = _lastStr;
//        _inputViewText = [_inputViewText substringWithRange:NSMakeRange(0, 500)];
//        return;
//    }
//    else{
//    
//        _textView.text = _lastStr;
//    }
    _inputViewText = textView.text;

    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
    {
        BOOL isEmoji = [EmojiClass stringContainsEmoji:substring];
        if (substring.length>=2||isEmoji)
        {
                _inputViewText = [_inputViewText stringByReplacingOccurrencesOfString:substring withString:[EmojiClass encodeToPercentEscapeString:substring]];
        }

    }];
  

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"])
    {
        [_delegate sendInfo:_textView.text];
        return NO;
    }
  
    if(_inputViewText.length>=500)
    {
        if (text.length>0) {
            return NO;
        }else{
            return YES;
        }
        
    }
    return YES;
}
@end
