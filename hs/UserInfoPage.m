//
//  UserInfoPage.m
//  hs
//
//  Created by PXJ on 16/2/25.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "UserInfoPage.h"

@interface UserInfoPage ()
{
    NSMutableArray * _ListArray;
}
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation UserInfoPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"个人资料";
    [nav.leftControl addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
}
- (void)initData
{
   _ListArray = [NSMutableArray arrayWithArray:@[@"头像",@"昵称",@"个性签名",@"用户ID",@"设置手势密码"]];
}
- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

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
