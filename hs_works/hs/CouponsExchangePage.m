//
//  CouponsExchangePage.m
//  hs
//
//  Created by PXJ on 15/11/16.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CouponsExchangePage.h"
#import "NetRequest.h"

@interface CouponsExchangePage ()<UITextFieldDelegate>
{
    NSString *resultStr;
}
@property (nonatomic,strong)UITextField * inputTF;
@property (nonatomic,strong)UIButton * confirmBtn;


@end

@implementation CouponsExchangePage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initNav];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chageCouPonTextField) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 20+64, ScreenWidth-40, 50*ScreenWidth/375)];
    _inputTF.borderStyle = UITextBorderStyleRoundedRect;
    _inputTF.keyboardType = UIKeyboardTypeASCIICapable;
    _inputTF.layer.cornerRadius = 6;
    _inputTF.placeholder = @"请输入兑换码";
    _inputTF.layer.masksToBounds = YES;
    _inputTF.layer.borderColor = K_COLOR_CUSTEM(240, 200, 200, 1).CGColor;
    _inputTF.layer.borderWidth = 1;
    _inputTF.delegate = self;
//    [_inputTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_inputTF];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(20, CGRectGetMaxY(_inputTF.frame)+15, ScreenWidth-40, 44);
//    _confirmBtn.backgroundColor = K_color_gray;
    [self updateUIbutton:NO];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setTitle:@"确定兑换" forState:UIControlStateNormal];
    [_confirmBtn setTintColor:[UIColor whiteColor]];
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    
    NSString * exchangeString = @"1) 兑换的优惠券直接绑定您的账户。\n2) 优惠券即时生效,有效期和使用规则请到“我的优惠券” 中查看详细信息。\n3) 优惠券不能兑换现金。\n4) 兑换的优惠券仅能使用一次,不找零,不退换。";
    UILabel * showTextLab = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_confirmBtn.frame)+5, ScreenWidth-50, 120)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:exchangeString];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:5];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    showTextLab.attributedText = attributedString;
    showTextLab.textAlignment = NSTextAlignmentJustified;
    showTextLab.numberOfLines = 0;
    showTextLab.font = [UIFont systemFontOfSize:13];
    showTextLab.textColor = K_color_black;
    [self.view addSubview:showTextLab];
    
}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.leftControl addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLab.text = @"兑换优惠券";
    [self.view addSubview:nav];
    
}
#pragma mark -----Button click-----
- (void)leftClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)chageCouPonTextField
{
       _inputTF.text = resultStr;
    
}

//确定兑换
- (void)confirmClick
{
    [self requestBindCouPon];
}

#pragma mark - 兑换接口
- (void)requestBindCouPon
{
    NSString *couPonStr = _inputTF.text;
    couPonStr = [couPonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"number":couPonStr};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_BindCouPon successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];

}

- (BOOL)isChinese:(NSString *)string
{
    NSString* number=@"^[A-Za-z0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    if(![numberPre evaluateWithObject:string] && ![string isEqualToString:@""])
    {
        return NO;
    }else
    {
        return YES;
    }

}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [self updateUIbutton:NO];
    return  YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
   NSString * kAlphaNum  = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange == NO)
    {
        return NO;
    }
    
    toBeingString = toBeingString.uppercaseString;
    
    toBeingString = [toBeingString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (textField == _inputTF)
    {
        if ([toBeingString length] > 4) {
            
            NSString * allStr = [NSString stringWithString:toBeingString];
            NSString * appStr = @"";
        
            unsigned long  allvalue = [toBeingString length]%4==0?[toBeingString length]/4:[toBeingString length]/4+1;
            for (int i = 0; i < allvalue; i++) {
                NSString * valueStr ;
                if (i+1 != allvalue) {
                    valueStr = [NSString stringWithString:[allStr substringWithRange:NSMakeRange(i*4, 4)]];
                    valueStr = [valueStr stringByAppendingString:@" "];
                }else
                {
                    valueStr = [NSString stringWithString:[allStr substringWithRange:NSMakeRange(i*4, [allStr length]%4==0?4:[allStr length]%4)]];
                }
                appStr = [appStr stringByAppendingString:valueStr];
            }
            resultStr = appStr;
            NSLog(@"fuck:%@",resultStr);

        }
        else
        {
            resultStr = toBeingString;
            
            NSLog(@" a a :%@",resultStr);
        }

    }
    
    if (toBeingString.length > 0) {
        [self updateUIbutton:YES];
    }
    
    if ([toBeingString isEqualToString:@""]) {
        [self updateUIbutton:NO];
    }else
    {
        [self updateUIbutton:YES];
    }

    return YES;
}


-(void )updateUIbutton:(BOOL) bEnable
{
    _confirmBtn.enabled = bEnable;
    [_confirmBtn setBackgroundColor:(bEnable ? RGBACOLOR(255, 62, 27, 1):[UIColor lightGrayColor])];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
