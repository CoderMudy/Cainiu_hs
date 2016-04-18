//
//  CommissionExplain.m
//  hs
//
//  Created by PXJ on 15/10/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CommissionExplain.h"
#define textFont [UIFont systemFontOfSize:12*ScreenWidth/375]
#define colorText K_color_black

#define  Nav_Title(titleName,leftBtnClick)  \
NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];\
nav.titleLab.text = titleName;\
[nav.leftControl addTarget:self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];\
[self.view addSubview:nav];



@interface CommissionExplain ()<UITableViewDataSource,UITableViewDelegate>
{

    NSArray * _textArray;
}

@end

@implementation CommissionExplain


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
    
}
- (void)initNav
{
    Nav_Title(@"赚钱说明", leftbuttonClick);
    
}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    NSArray * array = @[@"1、合伙人具有不同等级，等级越高则佣金比例越大。", @"2、合伙人等级由邀请好友的交易总手数决定，交易手数越多则等级越高。",@"3、好友交易总手数达到系统要求，则自动提升推广等级。",@"4、累计交易总手数只计算一级下线交易手数，二级下线不计入在内。",@"5、合伙人等级指标:"];
    
    CGFloat startHeight = 30*ScreenWidth/375+64;
    for (int i=0; i<array.count; i++) {
        
        NSString * labText = array[i];
        
        CGFloat labHeight = [Helper sizeWithText:labText font:textFont maxSize:CGSizeMake(ScreenWidth-40, 0)].height;
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, startHeight, ScreenWidth-40, labHeight)];
        lab.text = labText;
        lab.numberOfLines = 0;
        lab.textColor = colorText;
        lab.font = textFont;
        [self.view addSubview:lab];
        startHeight  = startHeight+labHeight +10*ScreenWidth/375;
    }
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, startHeight+2, ScreenWidth-40, ScreenHeigth-startHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"explainCell"];
    [self.view addSubview: tableView];
    
   _textArray = @[@"2000手以下",@"累计达到2000手自动提升",@"累计达到5000手自动提升",@"累计达到10000手自动提升",@"累计达到30000手自动提升"];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54*ScreenWidth/375;


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _textArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"explainCell" forIndexPath:indexPath];
    
    for (UIView * subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView * imgV = [[UIImageView alloc] init ];
    imgV.center = CGPointMake(60*ScreenWidth/375, 27*ScreenWidth/375);
    imgV.bounds = CGRectMake(0, 0, 48*ScreenWidth/375, 48*ScreenWidth/375);
    imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"sLevel8-%d",(int)indexPath.row+1]];
    [cell.contentView addSubview:imgV];
    
    UILabel * lab = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(imgV.frame)+50*ScreenWidth/375, 0, ScreenWidth-40-120*ScreenWidth/375 , 54*ScreenWidth/375)];
    lab.text = _textArray[indexPath.row];
    lab.textColor = colorText;
    lab.font = textFont;
    [cell.contentView addSubview:lab];
    
    return cell;

}
- (void)leftbuttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
