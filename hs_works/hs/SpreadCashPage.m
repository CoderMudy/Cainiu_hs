//
//  SpreadCashPage.m
//  hs
//
//  Created by PXJ on 15/10/27.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpreadCashPage.h"
#import "CommisionCashView.h"
#define colorTextBlack  K_COLOR_CUSTEM(55, 54, 53, 1)
#define colorTextGray  K_COLOR_CUSTEM(110, 110, 110, 1)
#define font_text [UIFont systemFontOfSize:12]
#define font_cashMoney [UIFont systemFontOfSize:13]

#define font_btn [UIFont systemFontOfSize:14]

#define cashMoney_tag 2007
#define realMoneyLab_Tag 2008
#define taxLab_Tag 2009
#define commitBtn_Tag 3009

@interface SpreadCashPage ()<UITextFieldDelegate>
{


}
@property (nonatomic,strong)UITextField * inputTF;
@property (nonatomic,strong)UIView * showView;
@end

@implementation SpreadCashPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = K_color_backView;
    [self initData];
    [self initNav];
    [self initUI];
}
- (void)initData
{
    
    
    
}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"佣金提现";
    [nav.leftControl addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
    
    UILabel * cashLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, ScreenWidth, 40)];
    NSString * cashMoney = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",self.cashMoney]];
    cashLab.text = [NSString stringWithFormat:@"可提现佣金 ￥ %@",cashMoney];
    cashLab.font = font_text;
    cashLab.textColor = K_color_gray;
    [backView addSubview:cashLab];
    
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(0, cashLab.frame.size.height+cashLab.frame.origin.y, ScreenWidth, 40)];
    inputView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:inputView];
    
    UILabel * inputLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth/4, 20)];
    inputLab.text = @"提现金额";
    inputLab.font = font_cashMoney;
    inputLab.textColor = colorTextBlack;
    [inputView addSubview:inputLab];
    
    _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(100*ScreenWidth/320, 10*ScreenWidth/320, 200*ScreenWidth/320, 20)];
    _inputTF.delegate = self;
    _inputTF.placeholder = @"最小提现金额100元";
    _inputTF.tag = cashMoney_tag;
    _inputTF.textColor = colorTextBlack;
    _inputTF.font = font_cashMoney;
    _inputTF.keyboardType = UIKeyboardTypeDecimalPad;
    _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:_inputTF];
    
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, inputView.frame.origin.y+inputView.frame.size.height+10, ScreenWidth, 80)];
    _showView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:_showView];
    
    UILabel * realMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth/4, 20)];
    realMoneyLab.text = @"实际到账";
    realMoneyLab.textColor = colorTextBlack;
    realMoneyLab.font = font_cashMoney;
    [_showView addSubview:realMoneyLab];
    
    UILabel * showRealMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(100*ScreenWidth/320, realMoneyLab.frame.origin.y, ScreenWidth/2, 20)];
    showRealMoneyLab.text = @"--";
    showRealMoneyLab.textColor = colorTextBlack;
    showRealMoneyLab.font = font_cashMoney;
    showRealMoneyLab.tag = realMoneyLab_Tag;
    [_showView addSubview:showRealMoneyLab];
    
    UILabel * taxLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, ScreenWidth/4, 20)];
    taxLab.text = @"代扣税";
    taxLab.textColor = colorTextBlack;
    taxLab.font = font_cashMoney;
    [_showView addSubview:taxLab];
    
    UILabel * showTaxLab = [[UILabel alloc] initWithFrame:CGRectMake(100*ScreenWidth/320, taxLab.frame.origin.y, ScreenWidth/2, 20)];
    showTaxLab.text = @"--";
    showTaxLab.textColor = colorTextBlack;
    showTaxLab.font = font_cashMoney;
    showTaxLab.tag  = taxLab_Tag;
    [_showView addSubview:showTaxLab];
    
    
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, _showView.frame.origin.y+_showView.frame.size.height+15, ScreenWidth-40, 40);
    commitBtn.layer.cornerRadius = 5;
    commitBtn.tag = commitBtn_Tag;
    commitBtn.layer.masksToBounds = YES;
    [commitBtn.titleLabel setFont:font_btn];
    [commitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:K_color_gray];
    commitBtn.enabled = NO;
    [backView addSubview:commitBtn];
    

    UILabel * warnTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(commitBtn.frame) +20, ScreenWidth-40, 20)];
    warnTitleLab.text = @"温馨提示：";
    warnTitleLab.textColor = [UIColor redColor];
    warnTitleLab.font = font_text;
    [backView addSubview:warnTitleLab];
    
    UILabel * warnLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(warnTitleLab.frame), ScreenWidth-40, 100)];
    warnLab.textColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    warnLab.font = font_text;
    warnLab.numberOfLines = 0;
    NSString * warnText = [NSString stringWithFormat:@"1、%@有代扣个人所得税的义务，需个人提供发票或由%@代扣，如有疑问请联系客服。\n2、每日提现最多1次。\n3、提现金额通过审核后即转入%@账户余额",App_appShortName,App_appShortName,App_appShortName];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:warnText];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    warnLab.attributedText = attributedString;
    
    [backView addSubview:warnLab];
    
    [commitBtn addTarget:self action:@selector(addRequest:) forControlEvents:UIControlEventTouchUpInside];

    
    
}
#pragma mark
- (void)addRequest:(UIButton*)button
{
    [self.view endEditing:YES];
    [ManagerHUD showHUD:self.view animated:YES];
    __block  CommisionCashView * showView = [[CommisionCashView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];

    [button setBackgroundImage:[UIImage imageNamed:@"choose_select_on"] forState:UIControlStateHighlighted];
    [RequestDataModel requestPromoteComissionCashMoney:_inputTF.text.floatValue successBlock:^(BOOL success, NSString* sender,int errorCode) {
        [ManagerHUD hidenHUD];
        if (success) {
            
            showView.alertConfirm = ^(){
                [showView removeFromSuperview];
                showView = nil;
                [self.navigationController popViewControllerAnimated:YES];
            
            };
            [self.navigationController.view addSubview:showView];
            
        }else{
            if (sender.length>0) {
                
                if (errorCode==43512) {
                    PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:sender setBtnTitleArray:@[@"确定"]];
                    popView.confirmClick = ^(UIButton * button){
                        
                    };
                    [self.navigationController.view addSubview:popView];
                }else{
                    [UIEngine showShadowPrompt:(NSString*)sender];
                }
             }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;


}
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    
    UILabel * realMoneyLab = (UILabel*)[_showView viewWithTag:realMoneyLab_Tag];
    UILabel * taxLab = (UILabel *)[_showView viewWithTag:taxLab_Tag];
    UIButton * commitBtn = (UIButton*)[self.view viewWithTag:commitBtn_Tag];
    realMoneyLab.text = @"--";
    taxLab.text = @"--";
    [commitBtn setBackgroundColor:K_color_gray];
    commitBtn.enabled = NO;
    return YES;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    
    
    NSString * money = [textField.text stringByAppendingString:string];
    if([string isEqualToString:@""]){
    
        money = [textField.text stringByReplacingCharactersInRange:NSMakeRange((int)textField.text.length-1, 1) withString:@""];
   }
        
    UILabel * realMoneyLab = (UILabel*)[_showView viewWithTag:realMoneyLab_Tag];
    UILabel * taxLab = (UILabel *)[_showView viewWithTag:taxLab_Tag];
    UIButton * commitBtn = (UIButton*)[self.view viewWithTag:commitBtn_Tag];
    if (money.floatValue==0) {
        
        realMoneyLab.text = @"--";
        taxLab.text = @"--";
        [commitBtn setBackgroundColor:K_color_gray];
        commitBtn.enabled = NO;
    }else if(money.floatValue>self.cashMoney){
    
        return NO;
    }else{
        realMoneyLab.text = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",money.floatValue]];
        NSString * taxText = [NSString stringWithFormat:@"0.00  %.2f",money.floatValue*0.20];
        NSMutableAttributedString *atrTax = [[NSMutableAttributedString alloc] initWithString:taxText];
        
        int taxLength = (int)taxText.length;
        int zoreLength = (int)[@"0.00  " length];
        [atrTax addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(zoreLength,taxLength-zoreLength)];
        [atrTax addAttribute:NSStrikethroughColorAttributeName value:colorTextBlack range:NSMakeRange(zoreLength,taxLength-zoreLength)];
        taxLab.attributedText = atrTax;
        
        if (money.floatValue>=100) {
            [commitBtn setBackgroundColor:K_color_red];
            commitBtn.enabled = YES;
        }else{
            [commitBtn setBackgroundColor:K_color_gray];
            commitBtn.enabled = NO;
        
        }
 
        
    }
    return YES;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
