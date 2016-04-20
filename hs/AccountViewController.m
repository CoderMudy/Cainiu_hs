//
//  AccountViewController.m
//  hs
//
//  Created by RGZ on 16/4/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingViewController.h"
#import "AccountViewCell.h"

@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSMutableArray  *_detailArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountViewController

#define Color_drawmoney  [UIColor colorWithRed:235/255.0 green:200/255.0 blue:144/255.0 alpha:1]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDefaultData];
    [self loadTableViewConfiger];
    [self loadTableHeaderView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)loadTableViewConfiger{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = K_color_line;
}

-(void)loadDefaultData{
    _titleArray = @[@"总积分",@"抵用券",@"收支明细"];
    _imageArray = @[@"Account_totalintegral",@"Account_coupon",@"Account_detail"];
    _detailArray = [NSMutableArray arrayWithObjects:@"5345.34",@"可用5张",@"", nil];
}

#pragma mark Header

-(void)loadTableHeaderView{
    if ([CMStoreManager sharedInstance].isLogin) {
        self.tableView.tableHeaderView = [self logInHeaderView];
    }
    else{
        self.tableView.tableHeaderView = [self logOutHeaderView];
    }
}


//显示登录UI
-(UIView *)logOutHeaderView{
    UIView *bgView = [[UIView    alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120.0/667.0*ScreenHeigth)];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 20/667.0*ScreenHeigth, bgView.frame.size.width - 40, (bgView.frame.size.height - 40/667.0*ScreenHeigth)/2 )];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text =  @"金融社交平台，只为更简单";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor redColor];
    [bgView addSubview:titleLabel];
    
    UIButton    *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 5, (bgView.frame.size.width)/2 - 7 - 20, titleLabel.frame.size.height - 5);
    loginButton.backgroundColor = Color_drawmoney;
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:loginButton];
    
    UIButton    *registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registeButton.frame = CGRectMake(CGRectGetMaxX(loginButton.frame) + 14, loginButton.frame.origin.y, loginButton.frame.size.width, loginButton.frame.size.height);
    registeButton.backgroundColor = [UIColor redColor];
    registeButton.clipsToBounds = YES;
    registeButton.layer.cornerRadius = 3;
    [registeButton setTitle:@"注册" forState:UIControlStateNormal];
    registeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:registeButton];
    
    return bgView;
}

//登录成功UI
-(UIView *)logInHeaderView{
    UIView *bgView = [[UIView    alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 20, bgView.frame.size.width - 40, (bgView.frame.size.height - 40)/2 )];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text =  @"金融社交平台，只为更简单";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor redColor];
    [bgView addSubview:titleLabel];
    
    UIButton    *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 5, (bgView.frame.size.width)/2 - 7 - 20, titleLabel.frame.size.height - 5);
    loginButton.backgroundColor = [UIColor redColor];
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton setImage:[UIImage imageNamed:@"Account_recharge"] forState:UIControlStateNormal];
    [loginButton setTitle:@" 充值" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:loginButton];
    
    UIButton    *registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registeButton.frame = CGRectMake(CGRectGetMaxX(loginButton.frame) + 14, loginButton.frame.origin.y, loginButton.frame.size.width, loginButton.frame.size.height);
    registeButton.backgroundColor = [UIColor whiteColor];
    registeButton.clipsToBounds = YES;
    registeButton.layer.cornerRadius = 3;
    registeButton.layer.borderWidth = 1;
    registeButton.layer.borderColor = Color_drawmoney.CGColor;
    [registeButton setImage:[UIImage imageNamed:@"Account_drawmoney"] forState:UIControlStateNormal];
    [registeButton setTitle:@" 提现" forState:UIControlStateNormal];
    registeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registeButton setTitleColor:Color_drawmoney forState:UIControlStateNormal];
    [bgView addSubview:registeButton];
    
    return bgView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountViewCell *cell = [[AccountViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArray[indexPath.row]]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.detailLabel.text = _detailArray[indexPath.row];
    
    HeaderDividers;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)settingClick:(UIButton *)sender {
    SettingViewController   *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
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
