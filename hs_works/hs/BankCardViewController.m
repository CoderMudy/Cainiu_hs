//
//  BankCardViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "BankCardViewController.h"
#import "AccountRechargeViewController.h"
#import "NetRequest.h"
#import "SubmitViewController.h"
#import "PersionInfoViewController.h"

@interface BankCardViewController ()
{
    UIScrollView    *_scrollView;
    UITextField     *_bankCardTF;
    UIButton        *_bankNameBtn;
    UILabel         *_bankNameLabel;
    UIButton        *_addButton;
    UIView          *_addBtnCoverView;
    UITextField     *_proTF;
    
    NSArray         *_bankNameArray;
    
    int             _selectRow;
    NSArray         *_bankIconArray;
    int             type;
}
@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEdit) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[UIEngine sharedInstance] hideProgress];
    [self.view.window endEditing:YES];
}

-(void)loadNav
{
    NavTitle(@"添加银行卡");
}

-(void)loadData
{
    _selectRow=0;
    
    _bankIconArray=@[@"guangfa",@"pufa",@"xingye",@"zhaoshang",@"zhongguo",
                              @"nongye",@"jianshe",@"guangda",@"pingan",@"minsheng",
                              @"huaxia",@"gongshang",@"jiaotong",@"zhongxin"
                              ];
    _bankNameArray=@[@"广发银行",@"浦发银行",@"兴业银行",@"招商银行",@"中国银行",
                             @"中国农业银行",@"中国建设银行",@"中国光大银行",@"平安银行",@"中国民生银行",
                             @"华夏银行",@"中国工商银行",@"交通银行",@"中信银行"
                             ];
    
    
    if(_privateUserInfo.realName == nil)
    {
        _privateUserInfo.realName = @"";
    }
    
    if(_privateUserInfo.idCard == nil)
    {
        _privateUserInfo.idCard = @"";
    }
    
    if(_privateUserInfo.bankName == nil)
    {
        _privateUserInfo.bankName = @"";
    }
    
    if(_privateUserInfo.bankCard == nil)
    {
        _privateUserInfo.bankCard = @"";
    }
}

-(void)loadUI
{
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    
    
    if (_isBinding) {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStyleGrouped];
        tableView.delegate=self;
        tableView.dataSource=self;
        [self.view addSubview:tableView];
    }
    else
    {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _scrollView.backgroundColor =  RGBACOLOR(239, 239, 244, 1);
        _scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
        _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeigth+2);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.userInteractionEnabled=YES;
        _scrollView.delegate=self;
        [self.view addSubview:_scrollView];
        
        
        
        [self loadTextField];
    }
}

-(void)loadTextField
{
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 22)];
    if (_privateUserInfo.realName.length>1) {
        nameLabel.text=[NSString stringWithFormat:@"*%@",[_privateUserInfo.realName substringFromIndex:1]];
    }else{
        nameLabel.text=_privateUserInfo.realName;
    }
    
    nameLabel.textColor=RGBACOLOR(188, 188, 188, 1);
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:17];
    [_scrollView addSubview:nameLabel];
    
    UILabel *idCardLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.frame.size.height+nameLabel.frame.origin.y, ScreenWidth, 22)];
    idCardLabel.text=_privateUserInfo.idCard;
    if (_privateUserInfo.idCard.length>14) {
        idCardLabel.text=[NSString stringWithFormat:@"%@****%@",[_privateUserInfo.idCard substringToIndex:6],[_privateUserInfo.idCard substringFromIndex:_privateUserInfo.idCard.length-4]];
    }
    idCardLabel.textColor=RGBACOLOR(188, 188, 188, 1);
    idCardLabel.textAlignment=NSTextAlignmentCenter;
    idCardLabel.font=[UIFont systemFontOfSize:17];
    [_scrollView addSubview:idCardLabel];
    
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, idCardLabel.frame.origin.y+idCardLabel.frame.size.height+8, ScreenWidth, 100)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:backGroundView];
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 0.5)];
    lineFooter.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineFooter];
    
    UIView *lineLast=[[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 0.5)];
    lineLast.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineLast];
    
    _bankNameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bankNameBtn.frame=CGRectMake(20, 0, ScreenWidth-40, 50);
    _bankNameBtn.tag=10086;
    [_bankNameBtn addTarget:self action:@selector(chooseBankName) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:_bankNameBtn];
    
    _bankNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 50)];
    _bankNameLabel.text=@"请选择开户银行";
    _bankNameLabel.textColor=RGBACOLOR(188, 188, 188, 1);
    [_bankNameBtn addSubview:_bankNameLabel];
    
    _bankCardTF=[[UITextField alloc]initWithFrame:CGRectMake(20, 50, ScreenWidth-40, 50)];
    _bankCardTF.delegate=self;
    _bankCardTF.tag=10010;
    _bankCardTF.keyboardType=UIKeyboardTypeNumberPad;
    _bankCardTF.returnKeyType=UIReturnKeyDone;
    _bankCardTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _bankCardTF.placeholder=@"请输入您的银行卡号";
    [_bankCardTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_bankCardTF];
    
    _addBtnCoverView=[[UIView alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height+backGroundView.frame.origin.y+8, ScreenWidth, 100)];
    _addBtnCoverView.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:_addBtnCoverView];
    
    
    UILabel *proLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    proLabel.text=@"持卡人须与账户信息一致，否则无法提现 \n 首次提现成功后，系统将核实并绑定，不可更改";
    proLabel.numberOfLines = 0;
    proLabel.textColor=[UIColor redColor];
    proLabel.textAlignment=NSTextAlignmentCenter;
    proLabel.font=[UIFont systemFontOfSize:13];
    [_addBtnCoverView addSubview:proLabel];
    
    _addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame=CGRectMake(20, proLabel.frame.size.height+proLabel.frame.origin.y+8, ScreenWidth-40, 44);
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    _addButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    _addButton.clipsToBounds=YES;
    _addButton.layer.cornerRadius=6;
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addBank) forControlEvents:UIControlEventTouchUpInside];
    [_addBtnCoverView addSubview:_addButton];
    
    if ([_privateUserInfo.statusBankCardBind isEqualToString:@"2"]) {
        [_addButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    
    if ([_privateUserInfo.statusBankCardBind isEqualToString:@"2"]) {
        _bankNameLabel.text = _privateUserInfo.bankName;
        _bankCardTF.text = _privateUserInfo.bankCard;
        _bankNameLabel.textColor=[UIColor blackColor];
        [self textFieldEdit];
    }
    
    //记录加载时picker滑动的位置
    if (_bankNameLabel.text.length>0) {
        for ( int i = 0; i<_bankNameArray.count; i++) {
            if ([_bankNameArray[i] isEqualToString:_bankNameLabel.text]) {
                _selectRow = i;
            }
        }
    }
}

-(void)chooseBankName
{
    [self.view.window endEditing:YES];
    _scrollView.scrollEnabled=NO;
    
    if ([_bankNameLabel.text isEqualToString:@"请选择开户银行"]) {
        _bankNameLabel.text = _bankNameArray[0];
        _bankNameLabel.textColor = [UIColor blackColor];
    }
    
    UIView *coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth/2)];
    coverView.backgroundColor=RGBACOLOR(0, 0, 0, 0.3);
    coverView.tag=1000000;
    [_scrollView addSubview:coverView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [coverView addGestureRecognizer:tap];
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeigth/2, ScreenWidth, ScreenHeigth/2-40)];
    pickerView.delegate=self;
    pickerView.tag=1000001;
    pickerView.dataSource=self;
    pickerView.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    [_scrollView addSubview:pickerView];
    
    [pickerView selectRow:_selectRow inComponent:0 animated:YES];
    
    UIView *okView = [[UIView alloc]initWithFrame:CGRectMake(0, pickerView.frame.origin.y-40, ScreenWidth, 40)];
    okView.tag = 1000002;
    okView.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    //    okView.backgroundColor = pickerView.backgroundColor;
    //    okView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:okView];
    
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

-(void)close
{
    UIView *view=[_scrollView viewWithTag:1000000];
    [view removeFromSuperview];
    
    UIView *pickerView=[_scrollView viewWithTag:1000001];
    [pickerView removeFromSuperview];
    
    UIView *okView = [_scrollView viewWithTag:1000002];
    [okView removeFromSuperview];
    
    _scrollView.scrollEnabled=YES;
}

#pragma mark Picker

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _bankNameLabel.text=_bankNameArray[row];
    _bankNameLabel.textColor=[UIColor blackColor];
    _selectRow=(int)row;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _bankNameArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _bankNameArray[row];
}

-(void)addBank
{
    if ([_bankNameBtn.titleLabel.text isEqualToString:@"请选择开户银行"]) {
        [UIEngine showShadowPrompt:@"请选择开户银行"];
        return;
    }
    
    if (_bankCardTF.text.length<12||_bankCardTF.text.length>24) {
        [UIEngine showShadowPrompt:@"您输入的银行卡号有误"];
        return;
    }
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    
    int methodType = 0;
    
    if ([_privateUserInfo.statusBankCardBind isEqualToString:@"2"]) {
        methodType = 1;
    }
    
    [DataEngine requestToAddBankCard:_bankCardTF.text BankName:_bankNameLabel.text Type:methodType Complete:^(BOOL SUCCESS, NSString * msg) {
        if (SUCCESS) {
            _privateUserInfo.statusBankCardBind=@"2";
            _privateUserInfo.bankName=_bankNameLabel.text;
            _privateUserInfo.bankCard=_bankCardTF.text;
            
            self.block(_privateUserInfo);
            self.isBinding=YES;
            
            _privateUserInfo.bankCard=_bankCardTF.text;
            _privateUserInfo.bankName=_bankNameLabel.text;
            
            _addButton.enabled=NO;
            if (self.isOtherPage) {
                
                _addButton.enabled = YES;
                if (self.isCharge) {
                    AccountRechargeViewController *accountVC = [[AccountRechargeViewController alloc]init];
                    accountVC.bankCard = _bankCardTF.text;
                    [accountVC setNavLeftBut:NSPushMode];
                    [self.navigationController pushViewController:accountVC animated:YES];
                }else{
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = _bankNameLabel.text ;
                    submitPage.bankCard = _bankCardTF.text ;
                    submitPage.branName = @"" ;
                    submitPage.cityName = @"" ;
                    submitPage.provName = @"" ;
                    submitPage.ID = @"" ;
                    submitPage.usedMoney = @"";
                    submitPage.privateUserInfo = _privateUserInfo;
                    [self.navigationController pushViewController:submitPage animated:YES];
                }
            }
            else
            {
                [[UIEngine sharedInstance] showAlertWithTitle:msg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (_isRenZheng) {
                        //返回到个人资料
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[PersionInfoViewController class]]) {
                                    NSLog(@"==nobanckCarc:%@",_privateUserInfo);
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"attention_status" object:_privateUserInfo];
                                [self.navigationController popToViewController:controller animated:YES];
                            }
                        
                        }

                    }else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }

                };
                
            }
            
        }
        else
        {
            if (msg.length>0) {
                [UIEngine showShadowPrompt:msg];
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
        
        [[UIEngine sharedInstance] hideProgress];
        [self textFieldEdit];
    }];
}



#pragma mark 绑定完银行卡重新加载页面
-(void)loadAgain
{
    [_scrollView removeFromSuperview];
    _scrollView=nil;
    
    [self loadUI];
}

#pragma mark 根据卡号获取银行名
-(void)getBankName
{
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToGetBankNameWithBankCard:_bankCardTF.text Complete:^(BOOL SUCCESS, NSString *bankName) {
        if (SUCCESS) {
            _bankNameBtn.titleLabel.text=bankName;
            [self.view.window endEditing:YES];
            _addButton.enabled=YES;
            _addButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        }
        [[UIEngine sharedInstance] hideProgress];
    }];
}

-(void)textFieldEdit
{
    if (_bankCardTF.text.length>0) {
        _addButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        
    }
    else
    {
        _addButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    }
    
    if(_bankCardTF.text.length>0)
    {
        if (_proTF==nil) {
            _proTF=[[UITextField alloc]initWithFrame:CGRectMake(0, 167, ScreenWidth, 50)];
            _proTF.enabled=NO;
            _proTF.backgroundColor=RGBACOLOR(220, 220, 220, 1);
            _proTF.textAlignment=NSTextAlignmentCenter;
            _proTF.font=[UIFont systemFontOfSize:25];
            _proTF.textColor=[UIColor redColor];
            [_scrollView addSubview:_proTF];
        }
        
        
        NSString *proStr=_bankCardTF.text;
        NSMutableArray *proArray=[NSMutableArray array];
        for (int i =0; i<proStr.length; i++) {
            NSString *str=@"";
            if (i==0) {
                str=[NSString stringWithFormat:@"%@",[proStr substringToIndex:1]];
            }
            
            else if (i==proStr.length-1) {
                str = [NSString stringWithFormat:@"%@",[[proStr substringFromIndex:i] substringToIndex:1]];
            }
            
            else
            {
                str = [NSString stringWithFormat:@"%@",[[proStr substringFromIndex:i] substringToIndex:1]];
            }
            
            [proArray addObject:str];
        }

        NSMutableArray *temArray=[NSMutableArray arrayWithArray:proArray];
        if (proStr.length>4) {
            for (int i =0; i<proArray.count/4; i++) {
                if(i==0)
                {
                    [temArray insertObject:@" " atIndex:4];
                }
                else
                {
                    [temArray insertObject:@" " atIndex:4+i*4+i];
                }
            }
        }
        
        proStr=@"";
        for (int i = 0; i<temArray.count; i++) {
            proStr=[proStr stringByAppendingString:temArray[i]];
        }
        
        
        _proTF.text=proStr;
        
        _addBtnCoverView.frame=CGRectMake(0, 180+40, ScreenWidth, 100);
        
    }
    else
    {
        _addBtnCoverView.frame=CGRectMake(0, 180, ScreenWidth, 100);
        [_proTF removeFromSuperview];
        _proTF=nil;
    }
    
    if(_bankCardTF.text.length>21)
    {
        _bankCardTF.text = [_bankCardTF.text substringToIndex:21];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

#pragma mark 表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text=_privateUserInfo.bankName;
    
    for (int i = 0; i<_bankNameArray.count; i++) {
        if ([_privateUserInfo.bankName isEqualToString:_bankNameArray[i]]) {
            cell.imageView.image = [UIImage imageNamed:_bankIconArray[i]];
        }
    }
    
    
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"尾号为%@",[_privateUserInfo.bankCard substringFromIndex:_privateUserInfo.bankCard.length-4]];
    cell.detailTextLabel.textColor=RGBACOLOR(188, 188, 188, 1);
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
