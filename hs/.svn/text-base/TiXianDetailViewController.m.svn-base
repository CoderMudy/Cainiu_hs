//
//  TiXianDetailViewController.m
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//  ====提现详情

#import "TiXianDetailViewController.h"
#import "TiXianDeatialCell.h"
#import "NetRequest.h"

@interface TiXianDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *cancelTixianBtn;
    UILabel *statusLab ;
    NSString *string;
}
@property(nonatomic,strong) UITableView *detailTableView;
@property(nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *detailArray;

@end

@implementation TiXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _detailArray = [[NSMutableArray alloc]init];
    _dataArray = [@[@{@"name":@"实际到账"},
                    @{@"name":@"交易手续费"},
                    @{@"name":@"流水号"},
                    @{@"name":@"提现银行"},
                    @{@"name":@"提现时间"},
                    @{@"name":@"到账时间"},
                    @{@"name":@"备注"},
                    ] mutableCopy];
    
    //导航栏
    [self setNaviTitle:@"提现详情"];
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_red];

    [self requestDetailData];
    
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

- (void)requestDetailData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"ioId":_tiXianId};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_TixianDetail successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            _dataDic = dictionary[@"data"];
            [_detailArray addObject:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"factInAmt"]]];
            [_detailArray addObject:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"factTax"]]];
            [_detailArray addObject:[_dataDic objectForKey:@"payId"]];
            [_detailArray addObject:[_dataDic objectForKey:@"bankInfo"]];
            [_detailArray addObject:[_dataDic objectForKey:@"createDate"]];
            [_detailArray addObject:[_dataDic objectForKey:@"doneDate"]];
            [_detailArray addObject:[_dataDic objectForKey:@"remark"]];
            
            [self initWithTableView];
        }else
        {
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }

        

//        [_detailTableView reloadData];
        

        
    } failureBlock:^(NSError *error) {
        
    }];

}

#pragma mark - 初始化表格
- (void)initWithTableView
{
    _detailTableView = [[UITableView alloc]init];
    _detailTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    [self.view addSubview:_detailTableView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [_detailTableView setTableFooterView:va];

    
    _detailTableView.tableHeaderView = [self drawHeadView];
}

#pragma mark - 绘制表格头视图
- (UIView *)drawHeadView
{
    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor redColor];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 0, ScreenWidth, 105);
    [headView addSubview:backView];
    
    UILabel *moneyLab = [[UILabel alloc]init];
    moneyLab.text = [NSString stringWithFormat:@"%@元",_dataDic[@"inOutAmt"]];
    moneyLab.font = [UIFont systemFontOfSize:30.0];
    moneyLab.textColor = [UIColor blackColor];
    moneyLab.frame = CGRectMake(10, backView.frame.size.height/2 - 30/2, ScreenWidth - 40, 30);
//    moneyLab.center = CGPointMake(10, headView.center.y);
    [backView addSubview:moneyLab];
    
    statusLab = [[UILabel alloc]init];
    statusLab.font = [UIFont systemFontOfSize:13.0];
    statusLab.textAlignment = NSTextAlignmentRight;
    statusLab.textColor = [UIColor lightGrayColor];
    statusLab.frame = CGRectMake(ScreenWidth - 130, backView.frame.size.height/2 - 21/2, 40 , 21);
    //    statusLab.center = CGPointMake(10, headView.center.y);
    [backView addSubview:statusLab];

    string = [NSString stringWithFormat:@"%d", [_dataDic[@"status"] intValue]];
    if ([string isEqualToString:@"0"]) {
        statusLab.text = @"未审核";
    }else if ([string isEqualToString:@"1"]|| [string isEqualToString:@"8"])
    {
        statusLab.text = @"已审核";
    }else if ([string isEqualToString:@"21"])
    {
        statusLab.text = @"已撤回";
    }else if ([string isEqualToString:@"9"] || [string isEqualToString:@"2"])
    {
        statusLab.text = @"失败";
    }else  if([string isEqualToString:@"10"])
    {
        statusLab.text = @"成功";
    }

    NSLog(@"statulabl%@",statusLab.text);
//    if ([_dataDic[@"status"] intValue] == 0) {
//        statusLab.text = @"未审核";
//    }else if ([_dataDic[@"status"] intValue] == 1 || [_dataDic[@"status"] intValue] == 8)
//    {
//        statusLab.text = @"已审核";
//    }else if ([_dataDic[@"status"] intValue] == 21)
//    {
//        statusLab.text = @"已撤回";
//    }else if ([_dataDic[@"status"] intValue] == 9 || [_dataDic[@"status"] intValue] == 2)
//    {
//        statusLab.text = @"失败";
//    }else  //([_dataDic[@"status"] intValue] == 10)
//    {
//        statusLab.text = @"成功";
//    }
    
    //提现撤回按钮
    cancelTixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelTixianBtn setImage:[UIImage imageNamed:@"tixian_list_cancel"] forState:UIControlStateNormal];
    [cancelTixianBtn addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelTixianBtn.frame = CGRectMake(ScreenWidth - 70 - 10, CGRectGetMinY(statusLab.frame) - 10, 70, 40);
//    cancelTixianBtn.center = CGPointMake(ScreenWidth - 50, headView.center.y);
    [backView addSubview:cancelTixianBtn];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.frame = CGRectMake(0, CGRectGetMaxY(backView.frame), ScreenWidth, 15);
    grayView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:238/255.0 alpha:1];
    [headView addSubview:grayView];

    if ([statusLab.text isEqualToString:@"未审核"]) {
        cancelTixianBtn.hidden = NO;
    }else
    {
        cancelTixianBtn.hidden = YES;
        statusLab.frame = CGRectMake(ScreenWidth - 50, backView.frame.size.height/2 - 21/2, 40 , 21);
    }
    
    return headView;
}

#pragma mark - 提现撤销按钮
- (void)clickCancelAction:(UIButton *)sender
{
    [self requestTixianCancel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    TiXianDeatialCell *cell = (TiXianDeatialCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[TiXianDeatialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置自定义单元格不能点击
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    cell.nameTextlab.text = [dic objectForKey:@"name"];
    NSLog(@"==:%@",_detailArray);
    cell.deatailLab.text = [_detailArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

#pragma mark - 提现撤回的接口调用
- (void)requestTixianCancel
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"ioId":_tiXianId};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_TixianCancel successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if ([dictionary[@"msg"]isEqualToString:@"撤销成功"])
            {
                cancelTixianBtn.hidden = YES;
                statusLab.text = @"已撤回";
//                string = [NSString stringWithFormat:@"%d", 21];
                statusLab.frame = CGRectMake(ScreenWidth - 50, 105/2 - 21/2, 40 , 21);
                [_detailTableView reloadData];
            }else
            {
                [UIEngine showShadowPrompt:@"已审核，不能撤销"];
            }

        }
    
//        [_detailTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
