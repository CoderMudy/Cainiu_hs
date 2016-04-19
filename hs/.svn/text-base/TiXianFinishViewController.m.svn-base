//
//  TiXianFinishViewController.m
//  hs
//
//  Created by Xse on 15/10/23.
//  Copyright © 2015年 luckin. All rights reserved.
// ====提现完成页面

#import "TiXianFinishViewController.h"
#import "CollectFeetStanderViewController.h"
#import "TiXianDeatialCell.h"
#import "NetRequest.h"
#import "AccountPage.h"

@interface TiXianFinishViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *downView;
    NSString *doneData;
    NSString *titleMsg;
}
@property(nonatomic,strong) NSMutableArray *finishArray;
@property(nonatomic,strong) UITableView *finishTableView;
@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation TiXianFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [self setNavibarBackGroundColor:K_color_red];
    
    [self setNaviTitle:@"提现"];
    [self setNavibarBackGroundColor:K_color_red];
    
    [self initWithTableView];
    [self requestMoneyTime];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 初始化表格视图
- (void)initWithTableView
{
    //addSign
//    _accountMoney=[[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[infoArray[2] doubleValue]]] stringByAppendingString:@" 元"];
    _finishArray = [@[
                    @{@"name":@"提现金额",@"detail":[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[_finishDic[@"inOutAmt"] doubleValue]]]},
                    @{@"name":@"实际到账",@"detail":[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[_finishDic[@"factAmt"] doubleValue]]]},
                    @{@"name":@"手续费",@"detail":[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[_finishDic[@"factTax"] doubleValue]]]},
                    @{@"name":@"姓名",@"detail":_finishDic[@"userName"]},
                    @{@"name":@"银行卡",@"detail":_finishDic[@"bank"]},
                    ]mutableCopy];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = RGBCOLOR(244, 244, 244);
    _scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth);
    [self.view addSubview:_scrollView];
    
    _finishTableView = [[UITableView alloc]init];
    _finishTableView.frame = CGRectMake(0, 0, ScreenWidth, 35*5 + [self drawHeadView].frame.size.height);
    _finishTableView.delegate = self;
    _finishTableView.dataSource = self;
    _finishTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _finishTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_scrollView addSubview:_finishTableView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [_finishTableView setTableFooterView:va];
    
    _finishTableView.tableHeaderView = [self drawHeadView];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.backgroundColor = RGBACOLOR(255, 62, 27, 1);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(15, CGRectGetMaxY(_finishTableView.frame) + 20, ScreenWidth - 15*2, 45*ScreenWidth/320);
    [finishBtn addTarget:self action:@selector(clickFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn.layer setCornerRadius:5];
    [finishBtn.layer setMasksToBounds:YES];
    [_scrollView addSubview:finishBtn];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80*ScreenWidth/320, CGRectGetMaxY(finishBtn.frame) + 13, 12*ScreenWidth/320, 12*ScreenWidth/320)];
    iconImageView.image = [UIImage imageNamed:@"tixian_finish_icon"];
    [_scrollView addSubview:iconImageView];
    
    UILabel *textLab = [[UILabel alloc]init];
    textLab.text = @"账户资金安全由人保财险承保";
    textLab.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame), CGRectGetMaxY(finishBtn.frame) + 10, ScreenWidth - CGRectGetMaxX(iconImageView.frame), 21);
    textLab.font = [UIFont systemFontOfSize:12.0];
    textLab.textColor = [UIColor colorWithRed:223/255.0 green:43/255.0 blue:33/255.0 alpha:1];
    [_scrollView addSubview:textLab];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(textLab.frame) + 80);
}

#pragma mark - 完成按钮点击事件
- (void)clickFinishAction:(UIButton *)sender
{
    [self tishiView];
}

#pragma mark - 提示视图
- (void)tishiView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }

    UIView *pView = [[UIView alloc]init];
    pView.tag = 20000;
    pView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    pView.backgroundColor = [UIColor blackColor];
    pView.alpha = 0.5;
    [window addSubview:pView];
    
    downView = [[UIView alloc]init];
    downView.frame = CGRectMake(20, ScreenHeigth/2 - (45*ScreenWidth/320 + 52 + 195)/2,  ScreenWidth - 20*2, (52 + 195 +40 + 45)*ScreenWidth/320);
    downView.backgroundColor = K_color_red;
    downView.layer.cornerRadius = 5;
    downView.layer.masksToBounds = YES;
    [window addSubview:downView];
    
    UIView *addView = [[UIView alloc]init];
    if ([UIScreen mainScreen].bounds.size.height <=568)
    {
        addView.frame = CGRectMake(0, 0, ScreenWidth - 20*2,(52 + 195 +60)*ScreenWidth/320);
        
    }else
    {
       addView.frame = CGRectMake(0, 0, ScreenWidth - 20*2,52 + 195 +45);
    }
    
    addView.backgroundColor = [UIColor whiteColor];
    addView.layer.cornerRadius = 5;
    addView.layer.masksToBounds = YES;
    [downView addSubview:addView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = titleMsg;
    titleLab.frame = CGRectMake(0, 40, ScreenWidth - 20*2, 21);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17.0];
    [addView addSubview:titleLab];
    
    UILabel *timeLab = [[UILabel alloc]init];
//    timeLab = [[UILabel alloc]init];
    timeLab.text = doneData;
    timeLab.textColor = [UIColor colorWithRed:213/255.0 green:68/255.0 blue:34/255.0 alpha:1];
    timeLab.font = [UIFont systemFontOfSize:14.0];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.frame = CGRectMake(0, CGRectGetMaxY(titleLab.frame) + 10, ScreenWidth - 20*2, 21);
    [addView addSubview:timeLab];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(timeLab.frame) + 20, ScreenWidth - 20*2, 0.5);
    [addView addSubview:lineView];
    
    UILabel *tishiLab = [[UILabel alloc]init];
    tishiLab.text = @"温馨提示:";
    tishiLab.frame = CGRectMake(15, CGRectGetMaxY(lineView.frame) + 20, ScreenWidth, 20);
    tishiLab.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    tishiLab.font = [UIFont systemFontOfSize:15.0];
    [addView addSubview:tishiLab];
    
    UILabel *proLabel = [[UILabel alloc]init];
//     NSString *attString = @"• 工作日(09:00——17:00)申请提现，最快2小时到账； \n• 双休日及节假日申请提现，顺延至下一工作日处理； \n• 具体到账时间请依据各银行时间为准。";
     NSString *attString = @"• 周一至周五09:00-17:00的提款申请当天处理，17:00以后的提款申请延至第二天处理；\n • 周五17:00后提款，延至下个工作日处理。提现到账时间最快2小时，最晚1个工作日； \n• 双休日及节假日申请提现，顺延至下一工作日处理； \n• 具体到账时间请依据各银行到账时间为准。";
    CGSize labeSize = [Helper sizeWithText:attString font:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(ScreenWidth -15*2 - 20*2, 2000)];
    proLabel.frame = CGRectMake(15, CGRectGetMaxY(tishiLab.frame) + 2, ScreenWidth  -15*2 - 20*2, labeSize.height + 40);

    proLabel.textAlignment = NSTextAlignmentLeft;
    proLabel.font = [UIFont systemFontOfSize:12];
    proLabel.numberOfLines = 0;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:attString];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:5.0f];

    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.mutableString.length)];
    proLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
//    proLabel.attributedText = [Helper mutableFontAndColorText:proLabel.text from:0 to:8 font:15 from:0 to:8 color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8]];
    proLabel.attributedText = attStr;
    [addView addSubview:proLabel];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = RGBACOLOR(255, 62, 27, 1);
    [sureBtn addTarget:self action:@selector(clickSureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(0, CGRectGetMaxY(addView.frame), ScreenWidth - 20*2, 45*ScreenWidth/320);
    [downView addSubview:sureBtn];

    downView.frame = CGRectMake(20, ScreenHeigth/2 - (45*ScreenWidth/320 + 52 + 195)/2, ScreenWidth - 20*2, CGRectGetMaxY(sureBtn.frame));
}

- (void)clickSureAction
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    UIView *sureView = [window viewWithTag:20000];
    [sureView removeFromSuperview];
    [downView removeFromSuperview];
    
//    [self setNavLeftBut:NSPushRootMode];
    //返回到账户中心
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AccountPageName class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
    }

}

#pragma mark - 初始化表格头视图
- (UIView *)drawHeadView
{
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 48*ScreenWidth/320 + 30*3 +(ScreenWidth - 15*2)*38/274 + 20);
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"tixian_finish_headImgOne"];
    headImage.frame = CGRectMake(ScreenWidth/2 - 48*ScreenWidth/320/2, 25, 48*ScreenWidth/320, 48*ScreenWidth/320);
    [headView addSubview:headImage];
    
    UILabel *finshLab = [[UILabel alloc]init];
    finshLab.textAlignment = NSTextAlignmentCenter;
    finshLab.font = [UIFont systemFontOfSize:20];
    finshLab.text = @"申请成功，等待审核";
    finshLab.frame = CGRectMake(0, CGRectGetMaxY(headImage.frame) + 15, ScreenWidth, 30);
    [headView addSubview:finshLab];
    
    UIImageView *headimageTwo = [[UIImageView alloc]init];
//    headimageTwo.backgroundColor = [UIColor redColor];
    headimageTwo.image = [UIImage imageNamed:@"tixian_finish_headImgTwo"];
    headimageTwo.frame = CGRectMake(15, CGRectGetMaxY(finshLab.frame) + 17, ScreenWidth - 15*2, (ScreenWidth - 15*2)*38/274);
    [headView addSubview:headimageTwo];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.backgroundColor = RGBCOLOR(244, 244, 244);
    grayView.frame = CGRectMake(0, CGRectGetMaxY(headimageTwo.frame) + 5, ScreenWidth, 15);
    [headView addSubview:grayView];
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _finishArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    TiXianDeatialCell *cell = (TiXianDeatialCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[TiXianDeatialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置自定义单元格不能点击
    
    NSDictionary *dic = _finishArray[indexPath.row];
    cell.nameTextlab.text = [dic objectForKey:@"name"];
    cell.deatailLab.text = [dic objectForKey:@"detail"];
    
    if (indexPath.row == 2) {
        cell.downBtn.hidden = NO;
        [cell.downBtn addTarget:self action:@selector(clickDownBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}

#pragma mark - 预计到账时间
- (void)requestMoneyTime
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"ioId":_finishDic[@"id"]};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_TixianDoneData successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSDictionary *dic = dictionary[@"data"];
            doneData = [Helper judgeStr:dic[@"subTitle"]];
            titleMsg = [Helper judgeStr:dic[@"mainTitle"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];

}

#pragma mark - 点击免手续费进入手续费介绍页面
- (void)clickDownBtn:(UIButton *)sender
{
    CollectFeetStanderViewController *conllecTrl = [[CollectFeetStanderViewController alloc]init];
    [self.navigationController pushViewController:conllecTrl animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
