//
//  SecondStepRechargeController.m
//  hs
//
//  Created by RGZ on 15/6/4.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SecondStepRechargeController.h"
#import "SecondStepDefaultCell.h"
#import "SecondStepTextFiledLongCell.h"
#import "SecondStepTFAuthCodeCell.h"
#import "NetRequest.h"
#import "FinishDrawMoneyViewController.h"

@interface SecondStepRechargeController ()
{
    UITableView     *_tableView;
    
    UIButton        *_okBtn;
    
    
    NSString        *_phone;
    NSString        *_authCode;
    NSTimer         *_timer;
    int              timeout;
    
    UIButton        *_timeButton;
    UIButton        *_confirmBut;
    NSString        *_strOrderID;
}
@end

@implementation SecondStepRechargeController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    [MobClick beginLogPageView:@"充值下一步"];
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated  ];
    [MobClick endLogPageView:@"充值下一步"];
    
    [_timer invalidate];
    [[UIEngine sharedInstance] hideProgress];
    [self.view.window endEditing:YES];
    removeTextFileNotification;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIEngine sharedInstance] hideProgress];
    [self.view.window endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self loadData];
    [self loadUI];
}

-(void)loadData
{
    timeout = 60;
}

-(void)loadNav
{
    NavTitle(@"账户充值");
}

-(void)loadUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.frame      = CGRectMake(15, 4*5+44*4+20, ScreenWidth-30, 44);
    _okBtn.backgroundColor = [UIColor lightGrayColor];
    _okBtn.enabled = NO;
    _okBtn.clipsToBounds = YES;
    _okBtn.layer.cornerRadius = 6;
    [_okBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(clickConfirmBut) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_okBtn];
    
}


#pragma mark TableVIew

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            SecondStepDefaultCell * cell = [[SecondStepDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%ld.00",self.rechargeMoney];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell       * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            cell.textLabel.text = self.bankName;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.text = self.cardNum;
            cell.imageView.image = self.bankIcon;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            SecondStepTextFiledLongCell *cell = [[SecondStepTextFiledLongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell.mobileTF.text = _phone;
            [cell.mobileTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
            cell.mobileTF.returnKeyType = UIReturnKeyDone;
            [cell.mobileTF becomeFirstResponder];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            SecondStepTFAuthCodeCell    *cell = [[SecondStepTFAuthCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            cell.authTF.text = _authCode;
            cell.authTF.returnKeyType = UIReturnKeyDone;
            [cell.authTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
            
            cell.authBtn.frame = CGRectMake(ScreenWidth-15-80, 0, 80, cell.frame.size.height);
            [cell.authBtn setTitle:@"立即获取" forState:UIControlStateNormal];
            [cell.authBtn setTitleColor:CanSelectButBackColor forState:UIControlStateNormal];
            [cell.authBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
            cell.authBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            
            _timeButton = cell.authBtn;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    
    return nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    return YES;
}

-(void)textFieldValueChange
{
    
    SecondStepTextFiledLongCell *cellLong = (SecondStepTextFiledLongCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    SecondStepTFAuthCodeCell *cellAuth = (SecondStepTFAuthCodeCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    _phone = cellLong.mobileTF.text;
    
    _authCode = cellAuth.authTF.text;
    
    if (cellLong.mobileTF.text.length>11) {
        cellLong.mobileTF.text = [cellLong.mobileTF.text substringToIndex:11];
    }
    
    if (cellAuth.authTF.text.length>6) {
        cellAuth.authTF.text = [cellAuth.authTF.text substringToIndex:6];
    }
    
    if (cellLong.mobileTF.text.length == 11 && cellAuth.authTF.text.length>0)
    {
        _okBtn.backgroundColor = CanSelectButBackColor;
        _okBtn.enabled = YES;
    }
    else
    {
        _okBtn.backgroundColor = [UIColor lightGrayColor];
        _okBtn.enabled = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
#pragma mark 验证手机号是否正确
-(BOOL)checkPhoneNumber
{
    NSString *loginUserNum = [_phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL  telFormat = [Helper checkTel:loginUserNum];
    
    if (!telFormat)
    {
        [UIEngine showShadowPrompt:@"您输入的手机号格式有误"];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark 验证码

- (void)startTime{
    
    if (_phone.length==0) {
        [UIEngine showShadowPrompt:@"请输入银行预留手机号"];
        return;
    }
    
    if (_phone.length!=11) {
        [UIEngine showShadowPrompt:@"请输入正确的手机号"];
        return;
    }
    
    if (![self checkPhoneNumber])
    {
        return;
    }
    
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    
    SecondStepTFAuthCodeCell *cell = (SecondStepTFAuthCodeCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       [NSString stringWithFormat:@"%ld",self.rechargeMoney],@"amt",
                       _phone,@"cardBindMobilePhoneNo",
                       nil];
//    NSLog(@"提交%@",dic);
    NSString     *url=[NSString stringWithFormat:@"http://%@/financy/topup/getDynNum",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200){
            NSNumber *data  =dictionary[@"data"][@"fioId"];
            _strOrderID =[NSString stringWithFormat:@"%d",[data intValue]];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOn) userInfo:nil repeats:YES];
            [_timer fire];
            
            [cell.authTF becomeFirstResponder];
        }else{
            _strOrderID = @"";
            
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }
        [[UIEngine sharedInstance] hideProgress];
        
    } failureBlock:^(NSError *error) {
        errorPro=error;
//        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后重试"];
        [[UIEngine sharedInstance] hideProgress];
    }];
    
    
    
    
}

-(void)timeOn
{
    
    timeout--;
    _timeButton.enabled = NO;
    
    
    if (timeout<=0) {
        [_timer invalidate];
        [_timeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        _timeButton.titleLabel.text = [NSString stringWithFormat:@"重新获取"];
        timeout = 60;
        [_timer invalidate];
        _timer = nil;
        _timeButton.enabled = YES;
    }
    else
    {
        [_timeButton setTitle:[NSString stringWithFormat:@"%ds",timeout] forState:UIControlStateNormal];
        _timeButton.titleLabel.text = [NSString stringWithFormat:@"%ds",timeout];
    }
}

#pragma mark 确认充值

- (void)clickConfirmBut
{
    if(_strOrderID==nil || [_strOrderID isEqualToString:@""])
    {
        [UIEngine showShadowPrompt:@"验证码输入不正确！"];
        return;
    }
    
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       _authCode,@"dynamicCode",//短信验证码
                       [NSString stringWithFormat:@"%@",_strOrderID],@"financyIoId",//接口回调的充值订单ID
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/financy/topup/pay",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] integerValue] == 200) {
            FinishDrawMoneyViewController *finishCharge = [[FinishDrawMoneyViewController alloc]init];
            finishCharge.isChargeMoney = YES;
            finishCharge.moneyStr = [NSString stringWithFormat:@"%ld",(long)self.rechargeMoney];
            [self.navigationController pushViewController:finishCharge animated:YES];
        }
        else if([dictionary[@"code"] integerValue] == 43001)
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                
                //删除定时器
                [_timeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
                _timeButton.titleLabel.text = [NSString stringWithFormat:@"重新获取"];
                [_timer invalidate];
                _timer = nil;
                timeout = 60;
                [self startTime];
                
                //清空验证码输入框获取焦点
                SecondStepTFAuthCodeCell *cellAuth = (SecondStepTFAuthCodeCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                cellAuth.authTF.text = @"";
                [cellAuth.authTF becomeFirstResponder];
                
            };
        }
        else{
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }
//        NSLog(@"充值结果%@",dictionary);
    } failureBlock:^(NSError *error) {
        [[UIEngine sharedInstance] hideProgress];
        errorPro=error;
        [[UIEngine sharedInstance] showAlertWithTitle:@"充值失败" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){};
    }];
    
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
