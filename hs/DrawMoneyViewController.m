//
//  DrawMoneyViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "DrawMoneyViewController.h"
#import "TSLocateView.h"
#import "BankCardViewController.h"
#import "AccountRechargeViewController.h"
#import "RealNameViewController.h"
#import "HSInputView.h"
#import "SubmitViewController.h"
#import "NetRequest.h"

@interface DrawMoneyViewController ()<UITextFieldDelegate>
{
    UILabel *_nameLabel;
    UILabel *_cardNumLabel;
    HSInputView *_bankNameInput;
    HSInputView *_bankCardInputt;
    HSInputView *_districkInput;
    HSInputView *_openingBankInput;
    UIView *_bottomView;
    TSLocateView *_locateView;
    
    NSMutableArray  *_branArray;
    int             selectRow;
}

@end

@implementation DrawMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _branArray = [NSMutableArray arrayWithCapacity:0];
    [self setNavTitle:@"完善银行卡"];
    [self setNavLeftBut:NSPushMode];
    self.customLeft = YES;
    
    DrawMoneyViewController *drawVC = self;
    
    self.leftClick = ^(void){
        UIViewController *vc = (UIViewController *)drawVC.navigationController.viewControllers[1];
        [drawVC.navigationController popToViewController:vc animated:YES];
    };
    selectRow = 0;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"完善银行卡信息"];
    [self authRealName];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"完善银行卡信息"];
}
- (void)initUI
{
    [self.view setBackgroundColor:RGBCOLOR(244, 244, 244)];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    [_nameLabel setFont:[UIFont systemFontOfSize:16]];
    [_nameLabel setTextColor:SUBTEXTCOLOR];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_nameLabel];
    
    _cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(_nameLabel)+HEIGHT(_nameLabel), WIDTH(_nameLabel), 20)];
    [_cardNumLabel setFont:[UIFont systemFontOfSize:13]];
    [_cardNumLabel setTextColor:SUBTEXTCOLOR];
    [_cardNumLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_cardNumLabel];
    
    _bankNameInput = [[HSInputView alloc] initWithFrame:CGRectMake(0, Y(_cardNumLabel)+HEIGHT(_cardNumLabel)+20, WIDTH(_cardNumLabel), 20) titleText:nil placeholderStr:@"请选择银行"];
    [_bankNameInput setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [_bankNameInput setUserInteractionEnabled:NO];
    [_bankNameInput.inputText setTextColor:SUBTEXTCOLOR];
    [_bankNameInput.inputText setTextAlignment:NSTextAlignmentCenter];
    _bankNameInput.lineImageView.alpha = 0;
    _bankNameInput.inputText.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_bankNameInput];
    
    _bankCardInputt = [[HSInputView alloc] initWithFrame:CGRectMake(0, Y(_bankNameInput)+HEIGHT(_bankNameInput), WIDTH(_bankNameInput), 20) titleText:nil placeholderStr:@"请输入卡号"];
    _bankCardInputt.inputText.returnKeyType = UIReturnKeyDone;
    [_bankCardInputt setBackgroundColor:RGBCOLOR(244, 244, 244)];
    _bankCardInputt.inputText.font = [UIFont systemFontOfSize:13];
    [_bankCardInputt setUserInteractionEnabled:NO];
    [_bankCardInputt.inputText setTextColor:SUBTEXTCOLOR];
    _bankCardInputt.lineImageView.alpha = 0;
    [_bankCardInputt.inputText setTextAlignment:NSTextAlignmentCenter];
    _bankCardInputt.inputText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_bankCardInputt];
    
    _districkInput = [[HSInputView alloc] initWithFrame:CGRectMake(0, Y(_bankCardInputt)+HEIGHT(_bankCardInputt)+20, WIDTH(_bankCardInputt), 44) titleText:nil placeholderStr:@"请选择开户省市"];
        [_districkInput setBackgroundColor:[UIColor whiteColor]];
    _districkInput.inputText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_districkInput];
    
    UIButton *selectDistrickBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectDistrickBut setBackgroundColor:[UIColor clearColor]];
    [selectDistrickBut setFrame:CGRectMake(0, 0, WIDTH(_districkInput), HEIGHT(_districkInput))];
    selectDistrickBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if(!_locateView){
            _branArray = [NSMutableArray arrayWithCapacity:0];
            _locateView = [[TSLocateView alloc] initWithTitle:@"定位城市"  frame:CGRectMake(0,0,ScreenWidth,ScreenHeigth/2)  delegate:self];
        [_locateView showInView:self.view];
        }
        return [RACSignal empty];
    }];
    [_districkInput addSubview:selectDistrickBut];
    
    int tempHeight = 0;
    if (![self isNeedPerfect])
    {
//        _openingBankInput = [[HSInputView alloc] initWithFrame:CGRectMake(0, Y(_districkInput)+HEIGHT(_districkInput), WIDTH(_districkInput), 44) titleText:nil placeholderStr:@"请填写开户支行"];
//        _openingBankInput.inputText.returnKeyType = UIReturnKeyDone;
//        _openingBankInput.inputText.delegate = self;
//        _openingBankInput.inputText.font = [UIFont systemFontOfSize:14];
//        [_openingBankInput setBackgroundColor:[UIColor whiteColor]];
//        _openingBankInput.inputText.enabled = NO;
//        [self.view addSubview:_openingBankInput];
////        [_openingBankInput.inputText.rac_textSignal subscribeNext:^(id x) {
////            self.branName = (NSString *)x;
////        }];
//        
//        tempHeight = 44;
    }
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, tempHeight + Y(_districkInput)+HEIGHT(_districkInput)+10, WIDTH(_districkInput), 100)];
    [_bottomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_bottomView];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_bottomView), 14)];
    [alertLabel setBackgroundColor:[UIColor clearColor]];
    [alertLabel setTextColor:[UIColor redColor]];
    [alertLabel setText:@"卡主信息必须与实名信息一致"];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [alertLabel setFont:[UIFont systemFontOfSize:12]];
    [_bottomView addSubview:alertLabel];
    
    UILabel *alert2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(alertLabel)+HEIGHT(alertLabel), WIDTH(_bottomView), 14)];
    [alert2Label setBackgroundColor:[UIColor clearColor]];
    [alert2Label setTextColor:[UIColor redColor]];
    [alert2Label setText:@"否则无法完成提现"];
    [alert2Label setTextAlignment:NSTextAlignmentCenter];
    [alert2Label setFont:alertLabel.font];
    [_bottomView addSubview:alert2Label];
    
    UIButton *bottomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBut setFrame:CGRectMake(20, Y(alert2Label)+HEIGHT(alert2Label)+20, WIDTH(_bottomView)-40, 44)];
    [bottomBut setBackgroundColor:CanSelectButBackColor];
    [bottomBut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [bottomBut setTitle:@"添加" forState:UIControlStateNormal];
    bottomBut.layer.cornerRadius = 5.0;
    [_bottomView addSubview:bottomBut];
    bottomBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self perfectBank];
        return [RACSignal empty];
    }];
}

-(void)chooseBran:(UIButton *)btn
{
    if (_branArray.count == 0) {
        if (!_openingBankInput.inputText) {
            _openingBankInput.inputText.enabled = YES;
        }
        
        [btn removeFromSuperview];
        return;
    }
    
    UIView *coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth/2)];
    coverView.backgroundColor=RGBACOLOR(0, 0, 0, 0.3);
    coverView.tag=1000000;
    [self.view addSubview:coverView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [coverView addGestureRecognizer:tap];
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeigth/2, ScreenWidth, ScreenHeigth/2-40)];
    pickerView.delegate=self;
    pickerView.tag=1000001;
    pickerView.dataSource=self;
    pickerView.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    [self.view addSubview:pickerView];
    
    [pickerView selectRow:selectRow inComponent:0 animated:YES];
    
    UIView *okView = [[UIView alloc]initWithFrame:CGRectMake(0, pickerView.frame.origin.y-40, ScreenWidth, 40)];
    okView.tag = 1000002;
    okView.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    //    okView.backgroundColor = pickerView.backgroundColor;
    //    okView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:okView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    //        [self.titleLabel setBackgroundColor:RGBACOLOR(235, 235, 241, 1)];
    titleLabel.text = @"选择开户支行";
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_023.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]]];
    [okView addSubview:titleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth-10-60, 0, 60, 40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [okView addSubview:button];
}

#pragma mark Picker

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _openingBankInput.inputText.text=_branArray[row];
    _openingBankInput.inputText.textColor=[UIColor blackColor];
    selectRow=(int)row;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _branArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _branArray[row];
}

-(void)close
{
    if (selectRow == 0) {
        _openingBankInput.inputText.text = _branArray[0];
    }
    
    UIView *view=[self.view viewWithTag:1000000];
    [view removeFromSuperview];
    
    UIView *pickerView=[self.view viewWithTag:1000001];
    [pickerView removeFromSuperview];
    
    UIView *okView = [self.view viewWithTag:1000002];
    [okView removeFromSuperview];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    [_locateView removeFromSuperview];
    _locateView=nil;
}


- (void)perfectBank
{
    self.branName = _openingBankInput.inputText.text;
    
    if (((NSNull*)self.cityName == [NSNull null]) || !self.cityName || [self.cityName length] < 1) {
        [UIEngine showShadowPrompt:@"请选择省份与城市"];
//          [[[iToast makeText:@"请选择省份与城市"] setGravity:iToastGravityCenter] show];
        return;
    }
    if ((((NSNull*)self.branName == [NSNull null]) || !self.branName || [self.branName length] < 1)
        && ![self isNeedPerfect]) {
//        [[[iToast makeText:@"请填写开户支行"] setGravity:iToastGravityCenter] show];
        return;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       self.ID,@"id",
                       self.provName,@"provName",
                       self.cityName,@"cityName",
                       self.branName,@"branName",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"%@/user/user/perfectBank",K_MGLASS_URL];
    
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] integerValue] == 200) {
            
            SubmitViewController *submitVC = [[SubmitViewController alloc]init];
            submitVC.bankName = self.bankName;
            submitVC.bankCard = self.bankCard;
            submitVC.provName = self.provName;
            submitVC.cityName = self.cityName;
            submitVC.branName = self.branName;
            submitVC.ID       = self.ID;
            [self.navigationController pushViewController:submitVC animated:YES];
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }else{
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){};
        }
        
        
    } failureBlock:^(NSError *error) {
//        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
        [[UIEngine sharedInstance] hideProgress];
    }];

}

- (BOOL)isNeedPerfect
{
    if((NSNull *)self.bankName  == [NSNull null])
        return NO;
    
    NSArray *array = @[@"中国建设银行",@"中国农业银行",@"招商银行"];

    for (NSString *name  in array) {
        if ([name isEqualToString:self.bankName]) {
            break;
        }
    }
    //不填写支行
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//验证真实姓名
-(void)authRealName
{
    
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                if (realName == nil) {
                    realName = @"";
                }
                
                if (idCard == nil) {
                    idCard = @"";
                }
                if (realName.length>1) {
                    _nameLabel.text = [NSString stringWithFormat:@"*%@",[realName substringFromIndex:1]];
                }else{
                    _nameLabel.text = realName;
                }
                
                if (idCard.length > 14) {
                    _cardNumLabel.text = [NSString stringWithFormat:@"%@****%@",[idCard substringToIndex:6],[idCard substringFromIndex:idCard.length-4]];
                }else{
                    _cardNumLabel.text = idCard;
                }
                
                
                [self authBankCard];
            }else{
                RealNameViewController *realVC=[[RealNameViewController alloc]init];
                realVC.isAuth=NO;
                realVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                };
                [self.navigationController pushViewController:realVC animated:YES];
            }
        }
        else
        {
            if (status.length>0) {
                
                [UIEngine showShadowPrompt:[NSString stringWithFormat:@"%@",status]];
                [[UIEngine sharedInstance] hideProgress];
            }
            else
            {
                [[UIEngine sharedInstance] hideProgress];
            }
        }
    }];
}

//验证银行卡
- (void)authBankCard
{
    
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                
                if (bankName == nil) {
                    bankName = @"";
                }
                
                _bankNameInput.inputText.text = bankName;
                
                if (bankCard != nil &&bankCard.length >= 4) {
                    _bankCardInputt.inputText.text = [NSString stringWithFormat:@"尾号%@",[NSString stringWithFormat:@"%@",[bankCard substringFromIndex:bankCard.length-4]]];
                }
                else
                {
                    _bankCardInputt.inputText.text = @"";
                }
                
            }else{
                BackButtonHeader
                BankCardViewController *bankVC=[[BankCardViewController alloc]init];
                bankVC.isBinding=NO;
                bankVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    
                };
                [self.navigationController pushViewController:bankVC animated:YES];
            }
        }
        else
        {
            if (status.length>0) {
                
                [UIEngine showShadowPrompt:[NSString stringWithFormat:@"%@",status]];
                [[UIEngine sharedInstance] hideProgress];
                
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                [[UIEngine sharedInstance] hideProgress];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TSLocateViewDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    NSLog(@"country:%@ city:%@ lat:%f lon:%f", location.state,location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NSLog(@"Select");
        _districkInput.inputText.text = [NSString stringWithFormat:@"%@%@",location.state,location.city];
        self.cityName = location.city;
        self.provName = location.state;
        if (_openingBankInput) {
            _openingBankInput.inputText.text = @"";
        }
        
        [UIEngine sharedInstance].progressStyle = 1;
        [[UIEngine sharedInstance] showProgress];
        [DataEngine requestToGetSubBankName:self.bankName Province:self.provName City:self.cityName Complete:^(BOOL SUCCESS, NSString *msg, NSArray *dataArray) {
            [[UIEngine sharedInstance] hideProgress];
            if (SUCCESS) {
                if (dataArray.count>0) {
                    UIButton *chooseBran= [UIButton buttonWithType:UIButtonTypeCustom];
                    chooseBran.frame = _openingBankInput.frame;
                    [chooseBran addTarget:self action:@selector(chooseBran:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:chooseBran];
                    _branArray = [NSMutableArray arrayWithArray:dataArray];
                }
                else
                {
                    _openingBankInput.inputText.enabled = YES;
                }
            }
            else{
                if (msg != nil) {
                    [UIEngine showShadowPrompt:msg];
                }
                else{
//                    [UIEngine showShadowPrompt:@"您当前网络不佳，请稍后再试"];
                }
                
                _openingBankInput.inputText.enabled = YES;
            }
        }];
    }
    _locateView = nil;
}

@end
