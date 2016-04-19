//
//  InfomationIndexPage.m
//  hs
//
//  Created by RGZ on 15/12/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "InfomationIndexPage.h"
#import "TacticPageCell.h"
#import "MJRefresh.h"
#import "News.h"

#import "NewsPage.h"
#import "TacticPage.h"

@interface InfomationIndexPage ()
{
}
@property (nonatomic,strong)UISegmentedControl * seg;
@property (nonatomic,strong)UIScrollView * backScrollView;
@property (nonatomic,strong)NewsPage * newsPage;//新闻
@property (nonatomic,strong)TacticPage * tacticPage;//策略

@end

@implementation InfomationIndexPage

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    [self loadBackScroll];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)loadNav{
    Self_AddNavBGGround;
    _seg = [[UISegmentedControl alloc] initWithItems:@[@"新闻",@"策略"]];
    _seg.center = CGPointMake(ScreenWidth/2, 42);
    _seg.bounds = CGRectMake(0, 0, 215*ScreenWidth/375, 27);
    _seg.selectedSegmentIndex = 0;
    _seg.tintColor = [UIColor whiteColor];
    [_seg addTarget:self action:@selector(segChangeClick:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:_seg];


}
-(void)loadBackScroll
{
    
    __weak typeof(self) weakSelf = self;
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64-49)];
    _backScrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeigth-64);
    _backScrollView.scrollEnabled = NO;
    _backScrollView.backgroundColor = K_color_line;
    [self.view addSubview:_backScrollView];
    
    _newsPage = [[NewsPage alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_backScrollView.frame))];
    _newsPage.backgroundColor = K_color_line;
    _newsPage.pushBlock= ^(UIViewController * vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_backScrollView addSubview:_newsPage];
    
    _tacticPage = [[TacticPage alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(_backScrollView.frame))];
    _tacticPage.backgroundColor = K_color_line;
    _tacticPage.pushBlock= ^(UIViewController * vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_backScrollView addSubview:_tacticPage];
}

-(void)segChangeClick:(UISegmentedControl*)seg
{

    if (seg.selectedSegmentIndex==1) {
        _backScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }else{
        _backScrollView.contentOffset = CGPointMake(0, 0);
    }
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
