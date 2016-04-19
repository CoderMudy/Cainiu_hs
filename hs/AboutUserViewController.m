//
//  AboutUserViewController.m
//  hs
//
//  Created by Xse on 15/10/26.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AboutUserViewController.h"
#import "AboutUserCell.h"
#import "KnowAboutCainiuController.h"
#import "FindKeFuController.h"

#define APPStoreVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@interface AboutUserViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong) UITableView *aboutTableView;
@property(nonatomic,strong) NSMutableArray *aboutArray;
@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation AboutUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviTitle:@"关于我们"];
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_NavColor];
    
    [self initWithTableView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initWithTableView
{
#if defined (YQB)
    _aboutArray = [@[

                     @{@"icon":@"about_icon_4",@"name":@"客服QQ",
                       @"detailTitle":@"4008915690"},
                     @{@"icon":@"about_icon_5",@"name":@"客服电话",
                       @"detailTitle":@"工作日9:00-22:00"},

                     
                     ]mutableCopy];
#else
    _aboutArray = [@[
                     @{@"icon":@"account_icon_08",@"name":[NSString stringWithFormat:@"了解我们"],
                       @"detailTitle":@""},
                     @{@"icon":@"about_icon_1",@"name":[NSString stringWithFormat:@"%@官网",App_appShortName],
                       @"detailTitle":@"www.cainiu.com"},
                     @{@"icon":@"about_icon_2",@"name":[NSString stringWithFormat:@"%@微博",App_appShortName],
                       @"detailTitle":[NSString stringWithFormat:@"@%@官方微博",App_appShortName]},
                     @{@"icon":@"about_icon_3",@"name":[NSString stringWithFormat:@"%@微信",App_appShortName],
                       @"detailTitle":[NSString stringWithFormat:@"%@小伙伴",App_appShortName]},
                     @{@"icon":@"about_icon_4",@"name":@"客服QQ",
                       @"detailTitle":@"4006666801"},
                     @{@"icon":@"about_icon_4",@"name":@"商务QQ",
                       @"detailTitle":@"1361224263"},
                     @{@"icon":@"about_icon_5",@"name":@"客服电话",
                       @"detailTitle":@"工作日9:00-22:00"},
                     @{@"icon":@"about_icon_6",@"name":@"给我评分"
                       ,@"detailTitle":@""}
                     
                     ]mutableCopy];
#endif

    
    
//    _scrollView = [[UIScrollView alloc]init];
//    _scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64 - 19*ScreenWidth/320 - 20);
//    [self.view addSubview:_scrollView];
    
    _aboutTableView = [[UITableView alloc]init];
    _aboutTableView.frame = CGRectMake(0, 64, ScreenWidth,ScreenHeigth - 64 - 19*ScreenWidth/320 - 20);//50*6 + [self drawHeadView].frame.size.height
    _aboutTableView.delegate = self;
    _aboutTableView.dataSource = self;
    _aboutTableView.backgroundColor =[UIColor whiteColor];
    _aboutTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_aboutTableView];
    
    _aboutTableView.tableHeaderView = [self drawHeadView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [_aboutTableView setTableFooterView:va];
    
#if defined (YQB)
 
    

#else
    UIImageView *downImg = [[UIImageView alloc]init];
    
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        downImg.frame = CGRectMake(ScreenWidth/2 - 162*ScreenWidth/320/2, ScreenHeigth - 19*ScreenWidth/320 - 10,162*ScreenWidth/320, 19*ScreenWidth/320);
    }else
    {
        downImg.frame = CGRectMake(ScreenWidth/2 - 162*ScreenWidth/320/2, ScreenHeigth - 19*ScreenWidth/320 - 20,162*ScreenWidth/320, 19*ScreenWidth/320);
    }
    
    downImg.image = [UIImage imageNamed:@"about_down_img"];
    [self.view addSubview:downImg];
    
#endif
    

//    _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(downImg.frame) + 100);
    

}

#pragma mark - 绘制表格头视图
- (UIView *)drawHeadView
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = K_color_red;
//    headView.backgroundColor = [UIColor colorWithRed:223/255.0 green:46/255.0 blue:34/255.0 alpha:1];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 80*ScreenWidth/320 + 70);
    
    //Logo
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 80*ScreenWidth/320/2, 5, 80*ScreenWidth/320, 80*ScreenWidth/320)];
    logoImageView.image = [UIImage imageNamed:@"about_center_icon"];
    [headView addSubview:logoImageView];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text = App_appName;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:20.0];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.frame = CGRectMake(0, CGRectGetMaxY(logoImageView.frame), ScreenWidth, 21);
    [headView addSubview:nameLab];
    
    //版本
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame) + 5, ScreenWidth, 22)];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.text = [NSString stringWithFormat:@"V%@",APPStoreVersion];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:versionLabel];

    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aboutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    AboutUserCell *cell = (AboutUserCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[AboutUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    [cell fillWithData:_aboutArray[indexPath.row]];
    
    if (indexPath.row == _aboutArray.count -1) {
        cell.grayLineView.hidden = YES;
    }else
    {
        cell.grayLineView.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
#if defined (YQB)

    switch ( indexPath.row) {

        case 0:
        {
            [self goKeFuQQ];

        }break;
        case 1:
        {
            [self call];

        }break;

            
        default:
            break;
    }
#else
    if (indexPath.row == 0){
        KnowAboutCainiuController *knowVC = [[KnowAboutCainiuController alloc]init];
        [self.navigationController pushViewController:knowVC animated:YES];
    }
    else if (indexPath.row == 1) {
        //财牛官网
        NSString * URLString = @"http://www.cainiu.com";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        
    }else if (indexPath.row == 2)
    {
        //财牛微博
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string =[_aboutArray[1] objectForKey:@"detailTitle"];
        
        NSString * URLString = @"sinaweibo://";
        if ([self APCheckIfAppInstalled2:URLString]) {
            [UIEngine showShadowPrompt:[NSString stringWithFormat:@"%@微博已复制成功",App_appShortName]];
            [self weiboMakerRan];
            //            weiboTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(weiboMakerRan) userInfo:nil repeats:YES];
        }else
        {
            [UIEngine showShadowPrompt:@"请先安装微博"];
        }
        
    }else if (indexPath.row == 3)
    {
        //财牛微信
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string =[_aboutArray[2] objectForKey:@"detailTitle"];
        
        NSString * URLString = @"weixin://";
        if ([self APCheckIfAppInstalled2:URLString])
        {
            [UIEngine showShadowPrompt:[NSString stringWithFormat:@"%@微信号已复制成功",App_appShortName]];
            [self makerRan];
        }else
        {
            [UIEngine showShadowPrompt:@"请先安装微信"];
        }
    }
    else if (indexPath.row == 4){
        [self goKeFuQQ];
    }
    else if (indexPath.row == 5)
    {
        //商务QQ
        [self goBusinessQQ];
    }
    else if (indexPath.row == 6)
    {
        //客服电话
        [self call];
    }else if (indexPath.row == 7) {
        [self goAppStore];
    }
    
#endif
    
 
}

- (void)makerRan
{
    NSString * URLString = @"weixin://";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
}

- (void)weiboMakerRan
{
    NSString * URLString = @"weibo://";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
}

-(void)goKeFuQQ{
    FindKeFuController *kefuVC = [[FindKeFuController alloc]init];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
- (void)goBusinessQQ
{
    NSString * urlStr = @"mqqwpa://im/chat?chat_type=wpa&uin=1361224263&version=1&src_type=web";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
-(void)goAppStore
{
    
    NSString *appleID = @"999750777";
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(BOOL) APCheckIfAppInstalled2:(NSString *)urlSchemes
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        NSLog(@" installed");
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)call{
#if defined (YQB)
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您是否要拨打客服电话 400-8915-690 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
#else
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您是否要拨打客服电话 400-6666-801 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
#endif
    
  
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
#if defined (YQB)
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://400-8915-690"]]];

#else
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://400-6666-801"]]];
   
#endif
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height || scrollView.contentOffset.y < 0) {
        scrollView.scrollEnabled = NO;
    }
    else{
        scrollView.scrollEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
