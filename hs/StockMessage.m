//
//  StockMessage.m
//  hs
//
//  Created by PXJ on 15/7/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockMessage.h"
#import "StockMessageCell.h"

@interface StockMessage ()

@end

@implementation StockMessage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    UIView * titleView = [[UIView alloc] init];
    
    titleView.center = CGPointMake(ScreenWidth/2, 32);
    titleView.bounds = CGRectMake(0, 0, 200, 64);
    
    UILabel * namelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,200, 20)];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:16];
    namelab.text = _realtime.name;
    namelab.textColor = [UIColor whiteColor];
    [titleView addSubview:namelab];
    
    UILabel * codeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40,200 , 10)];
    codeLab.font = [UIFont systemFontOfSize:10];
    codeLab.textAlignment = NSTextAlignmentCenter;
    codeLab.text = _realtime.code;
    codeLab.textColor = [UIColor whiteColor];
    [titleView addSubview:codeLab];
    
    self.navigationItem.titleView = titleView;
    
    [self setNavLeftBut];
    [self initUI];


}

- (void)setNavLeftBut
{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, leftButtonImage.size.width, leftButtonImage.size.height)];
    [leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

- (void)back
{

    [self.navigationController popViewControllerAnimated:YES];


}
- (void)initUI
{


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = K_COLOR_CUSTEM(248,248,248,1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[StockMessageCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];



}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 30;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    StockMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"今开";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.openPrice];
            break;
        case 1:
        {
        
            cell.nameLabel.text = @"昨收";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.preClosePrice];

        }
            break;

        case 2:
        {
            
            cell.nameLabel.text = @"最高";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.highPrice];

        }
            break;

        case 3:
        {
            
            cell.nameLabel.text = @"最低";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.lowPrice];

        }
            break;

        case 4:
        {
            
            cell.nameLabel.text = @"市盈率(％)";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;

        case 5:
        {
            
            cell.nameLabel.text = @"每股收益";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;

        case 6:
        {
            
            cell.nameLabel.text = @"量比";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;

        case 7:
        {
            
            cell.nameLabel.text = @"换手率（％）";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.turnoverRation*100];

        }
            break;

        case 8:
        {
            
            cell.nameLabel.text = @"每股净资产";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;

        case 9:
        {
            
            cell.nameLabel.text = @"总成交量";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2lld",_realtime.volume/100000000];

        }
            break;

        case 10:
        {
            
            cell.nameLabel.text = @"52周最高";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.w52High/1000];

        }
            break;
        case 11:
        {
            
            cell.nameLabel.text = @"52周最低";
            cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",_realtime.w52Low/1000];

        }
            break;

        case 12:
        {
            
            cell.nameLabel.text = @"流通股本";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;

        case 13:
        {
            
            cell.nameLabel.text = @"总股本";
            cell.valueLabel.text = [NSString stringWithFormat:@"--"];

        }
            break;



            
        default:
            break;
    }

    return cell;

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
