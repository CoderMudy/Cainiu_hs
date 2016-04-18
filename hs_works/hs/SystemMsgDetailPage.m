//
//  SystemMsgDetailPage.m
//  hs
//
//  Created by PXJ on 15/8/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SystemMsgDetailPage.h"
#import "SysMsgData.h"
#import "NetRequest.h"

@interface SystemMsgDetailPage ()<UIScrollViewDelegate>
{
//    SysMsgData * sysMsgModel;


}


@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UITextView * detailTextView;
@property (nonatomic,strong)UIScrollView * scroView;
@end

@implementation SystemMsgDetailPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"系统详情"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    [self requestDetailData];

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"系统详情"];
    self.navigationController.navigationBarHidden = NO;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initView];
    [self loadNav];
}

- (void)requestDetailData
{
    NSString * url = K_sms_sysMsgDetail;
    
//    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
//    token = token==nil?@"":token;
    NSDictionary * dic = @{@"messageId":_messageId==nil?@"":_messageId};

    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        
//        NSLog(@"%@",dictionary);
        if ([dictionary[@"code"]intValue]==200) {
            _sysMsgModel = [SysMsgData modelObjectWithDictionary:dictionary[@"data"]];
            [self loadViewData];
        }
    } failureBlock:^(NSError *error) {
        
//        NSLog(@"%@",error.localizedDescription);
    }];



}
- (void)initData
{
    _sysMsgModel = [[SysMsgData alloc] init];

}
-(void)loadNav{
    
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"系统详情";
    [nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
//    self.title = @"系统详情";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView
{
//
//    _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeigth)];
//    [self.view addSubview:_scroView];
    

    _titleLab = [[UILabel alloc] init];
    _titleLab.center = CGPointMake(ScreenWidth/2, 104);
    _titleLab.bounds = CGRectMake(0, 0, ScreenWidth, 20);
    _titleLab.textAlignment = NSTextAlignmentCenter;

    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
    [self.view addSubview:_titleLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(30, _titleLab.frame.size.height+_titleLab.frame.origin.y+10, ScreenWidth-60, 15)];
    _timeLab.font = [UIFont systemFontOfSize:12];

    _timeLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_timeLab];


    
    
    
    
    _detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_timeLab.frame)+10, ScreenWidth-60, ScreenHeigth- CGRectGetMaxY(_timeLab.frame)-20)];
    _detailTextView.editable = NO;
    _detailTextView.delegate = self;
    _detailTextView.showsVerticalScrollIndicator = NO;
    _detailTextView.showsHorizontalScrollIndicator = NO;
    _detailTextView.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    _detailTextView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_detailTextView];
    
    

    
    
    

}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{

    return NO;
}
- (void)loadViewData{


    _titleLab.text= _sysMsgModel.title;
    _timeLab.text = [self chageTimeFormatter:_sysMsgModel.updateDate] ;
    NSString *detailText = [NSString stringWithFormat:@"%@",_sysMsgModel.content];
  
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailText];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailText.length)];
    
    
    CGRect rect = [detailText boundingRectWithSize:CGSizeMake(ScreenWidth-60, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//
//    _detailTextView.frame =CGRectMake(30, _timeLab.frame.size.height+_timeLab.frame.origin.y+20, ScreenWidth-60, rect.size.height*5/4 +30);
    _detailTextView.attributedText = attributedString;
    _scroView.contentSize = CGSizeMake(ScreenWidth, rect.size.height*5/4+_timeLab.frame.size.height+_timeLab.frame.origin.y+40);

}
- (NSString *)chageTimeFormatter:(NSString*)timeStr
{
    
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [dm dateFromString:timeStr];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString * string = [dm stringFromDate:date];
    return string;
    
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
