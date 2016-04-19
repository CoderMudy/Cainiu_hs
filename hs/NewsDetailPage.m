//
//  NewsDetailPage.m
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define inputVHeight 165
#define contentFont 17
#define titleFont 20
#define lineSpace 6
#define textLengthSpace @0.2f
#import "NewsDetailPage.h"
#import "News.h"
#import "InputView.h"
#import "InfoDetailHeaderView.h"
#import "InfoSectionHeaderView.h"
#import "NewsDetailCell.h"
#import "PShowImageV.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NewsDataModels.h"
#import "EmojiClass.h"
#import "MJRefresh.h"


@interface NewsDetailPage ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,InputViewDelegate>
{
    NavView * _nav;
    NSMutableArray * _totalCmtArray;
    NSMutableArray * _contentArray;
    NSMutableArray * _contentImgArray;
    NSMutableDictionary * _contentImgDic;
    
    int _cmtPageNo;
    int _cmtPageSize;
    int _superCmtNum;
    
    NSString * _cmtContent;
    NSString * _replyContent;
    int  _cmtId;
    int _replyId;
    
    
}
@property (nonatomic,strong)PShowImageV * pShowImgV;
@property (nonatomic,strong)UIView * inputView;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UIButton  * sendBtn;
@property (nonatomic,strong)InputView * inputV;
@property (nonatomic,strong) UIView * inputBackV;
@end

@implementation NewsDetailPage

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self loadData];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initTableView];
    
    
    [self initCommentView];
    [self initNav];
    
    // Do any additional setup after loading the view.
}
- (void)initData
{
    _contentArray = [[NSMutableArray alloc] init];
    _contentImgArray = [[NSMutableArray alloc] init];
}
- (void)loadData
{
    _superCmtNum = [_news.cmtCount intValue];
    _cmtPageNo = 1;
    _cmtPageSize = 10;
//    [ManagerHUD showHUD:self.view animated:YES];

    [self requestContentData];
    [self requestTotalComentData];
}

#pragma  mark 获取正文内容
- (void)requestContentData
{
    [RequestDataModel requestInfoDetailWithNewsArticleId:_news.newsID successBlock:^(BOOL success, NSDictionary * Info)
     {
         if (success)
         {
             _contentImgArray = [[NSMutableArray alloc] init];
             News    *news = [[News alloc]init];
             news.title          = [DataUsedEngine nullTrimString:Info[@"title"]];
             news.sectionName    = [DataUsedEngine nullTrimString:Info[@"sectionName"]];
             news.summary        = [DataUsedEngine nullTrimString:Info[@"summary"]];
             news.permitComment  = [DataUsedEngine nullTrimString:Info[@"permitComment"]];
             news.bannerUrl      = [DataUsedEngine nullTrimString:Info[@"bannerUrl"]];
             news.readCount      = [DataUsedEngine nullTrimString:Info[@"readCount"]];
             news.plateName      = [DataUsedEngine nullTrimString:Info[@"plateName"]];
             news.createDate     = [DataUsedEngine nullTrimString:Info[@"createDate"]];
             news.newsID         = [DataUsedEngine nullTrimString:Info[@"id"]];
             news.content        = [DataUsedEngine nullTrimString:Info[@"content"]];
             news.subTitle       = [DataUsedEngine nullTrimString:Info[@"subTitle"]];
             news.modifyDate     = [DataUsedEngine nullTrimString:Info[@"modifyDate"]];
             news.status         = [DataUsedEngine nullTrimString:Info[@"status"]];
             news.keyword        = [DataUsedEngine nullTrimString:Info[@"keyword"]];
             news.createStaffName     = [DataUsedEngine nullTrimString:Info[@"createStaffName"]];
             news.cmtCount       = [DataUsedEngine nullTrimString:Info[@"cmtCount"]];
             news.orderWeight    = [DataUsedEngine nullTrimString:Info[@"orderWeight"]];
             news.sourceType     = [DataUsedEngine nullTrimString:Info[@"sourceType"]];
             news.newsPlateIdList     = [DataUsedEngine nullTrimString:Info[@"newsPlateIdList"]];
             news.targetType     = [DataUsedEngine nullTrimString:Info[@"targetType"]];
             news.outSourceName  = [DataUsedEngine nullTrimString:Info[@"outSourceName"]];
             news.section        = [DataUsedEngine nullTrimString:Info[@"section"]];
             news.outSourceUrl   = [DataUsedEngine nullTrimString:Info[@"outSourceUrl"]];
             news.picFlag        = [DataUsedEngine nullTrimString:Info[@"picFlag"]];
             news.hotEndTime     = [DataUsedEngine nullTrimString:Info[@"hotEndTime"]];
             news.hot            = [DataUsedEngine nullTrimString:Info[@"hot"]];
             news.top            = [DataUsedEngine nullTrimString:Info[@"top"]];
             _news = news;
             if(_news.bannerUrl.length >4)
             {
                 [_contentImgArray addObject:_news.bannerUrl];
             }
             [self dealContentData:_news.content];
         }
     }];
}
- (void)requestTotalComentData
{
    
    [RequestDataModel requestInfoTotalComentDataNewArticleId:_news.newsID pageNo:_cmtPageNo pageSize:_cmtPageSize successBlock:^(BOOL success, id Info)
     {
//         [ManagerHUD hidenHUD];
         [self endLoading];
         if (success)
         {
             NewsBaseClass * newsBaseModel = [NewsBaseClass modelObjectWithDictionary:Info];
             if (newsBaseModel.totalCmt>0) {
                 _superCmtNum = newsBaseModel.totalCmt;
             }
             [self loadRemindCmtView];
             if (_cmtPageNo ==1)
             {
                 if ([DataUsedEngine nullTrim:Info[@"cmtReplyList"]])
                 {
                     _totalCmtArray = [NSMutableArray arrayWithArray:newsBaseModel.cmtReplyList];
                 }
             }else
             {
                 [_totalCmtArray addObjectsFromArray:newsBaseModel.cmtReplyList];
             }
             [_tableView reloadData];
         }
     }];
}
- (void)contentArrayAddObject:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    if (string.length >0) {
        [_contentArray addObject:string];
    }
    if ([string rangeOfString:@".png"].location !=NSNotFound ||[string rangeOfString:@".jpg"].location !=NSNotFound)
    {
        [_contentImgArray addObject:string];
    }
}
#pragma mark 资讯详情正文内容处理
- (void)dealContentData:(NSString *)content
{
    _contentArray = [[NSMutableArray alloc] init];
    if ([content rangeOfString:@"<img"].location !=NSNotFound)
    {
        NSArray * array = [content componentsSeparatedByString:@"<img"];
        for (int i= 0; i<array.count;i++)
        {
            NSString * string = array[i];
            if (i!=0) {
                string = [NSString stringWithFormat:@"<img%@",string];
            }
            if ([string rangeOfString:@"/>"].location !=NSNotFound)
            {
                NSArray * subArray = [string componentsSeparatedByString:@"/>"];
                [self contentArrayAddObject:[self dealString:subArray[0]]];
                if (subArray.count>1)
                {
                    for (int i=1; i<subArray.count; i++)
                    {
                        NSString * subString = subArray[i];
                        [self contentArrayAddObject:subString];
                    }
                }
            }else
            {
                string = [self dealString:string];
                [self contentArrayAddObject:[self dealString:string]];
            }
        }
    }else{
        [self contentArrayAddObject:[self dealString:content]];
    }
    [self cacheContentImage];
    [_tableView reloadData];
    _pShowImgV = [[PShowImageV alloc] initWithImgArray:_contentImgArray];
    _pShowImgV.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2);
    _pShowImgV.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    _pShowImgV.hidden = YES;
    [self.navigationController.view addSubview:_pShowImgV];
}
- (void)cacheContentImage
{
    [self performSelector:@selector(updateImage) withObject:nil afterDelay:0];
    
}
- (void)updateImage
{
    for (int i=0; i<_contentImgArray.count; i++) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_contentImgArray[i]]];
        UIImage * img = [UIImage imageWithData:data];
        if (![DataUsedEngine nullTrim:[_contentImgDic objectForKey:_contentImgArray[i]]]) {
            [_contentImgDic setObject:img forKey:_contentImgArray[i]];
        }
    }
    [CacheEngine setNewInfoDetailImageDetail:_contentImgDic];
}
- (NSString * )dealString:(NSString*)string
{
    if ([string rangeOfString:@"<img"].location!=NSNotFound)
    {
        NSArray * array = [string componentsSeparatedByString:@"\""];
        for (int i=0; i<array.count; i++)
        {
            if ([array[i] rangeOfString:@"http"].location !=NSNotFound)
            {
                string = [NSString stringWithFormat:@"%@",array[i]];
                break;
            }
        }
    }
    return string;
}

#pragma mark - 初始化UI

- (void)initNav
{
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = @"详情";
    [_nav.leftControl addTarget:self action:@selector(leftBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[NewsDetailCell class] forCellReuseIdentifier:@"newsContentCell"];
    [_tableView registerClass:[NewsDetailCell class] forCellReuseIdentifier:@"newsConmentCell"];
    [self.view addSubview:_tableView];
    [self loadRefresh];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_news.bannerUrl]];
    UIImage * img = [UIImage imageWithData:data];
    
    if (![DataUsedEngine nullTrim:[_contentImgDic objectForKey:_news.bannerUrl]]) {
        [_contentImgDic setObject:img forKey:_news.bannerUrl];
    }
    [CacheEngine setNewInfoDetailImageDetail:_contentImgDic];
    
    CGSize  imgSize = img.size;
    CGFloat headerImgHeight ;
    if (imgSize.height==0||imgSize.width==0) {
        headerImgHeight = 0;
    }else{
        headerImgHeight = imgSize.height*(ScreenWidth-40)/imgSize.width +20;
    }
    
    CGSize titleSize = [Helper sizeWithText:_news.title font:FontSize(titleFont) maxSize:CGSizeMake(ScreenWidth-40, 0)];
    
    
    InfoDetailHeaderView * tabHeaderV = [[InfoDetailHeaderView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth,50+headerImgHeight+titleSize.height+20) news:_news];
    _tableView.tableHeaderView = tabHeaderV;
    __weak typeof(self) weakSelf = self;
    tabHeaderV.showImageBlock = ^(NSString * showImgUrlStr)
    {
        [weakSelf showImageViewWithImage:showImgUrlStr];
    };
}

- (void)initCommentView
{
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-49, ScreenWidth, 49)];
    _inputView.backgroundColor = K_color_infoBack;
    [self.view addSubview:_inputView];
    
    UIView * whiteBack = [[UIView alloc] initWithFrame:CGRectMake(10, 6, ScreenWidth*0.7, 35)];
    whiteBack.backgroundColor = [UIColor whiteColor];
    whiteBack.layer.cornerRadius = 5;
    [_inputView addSubview:whiteBack];
    
    UIImageView * writeImgV = [[UIImageView alloc] init ];
    writeImgV.center = CGPointMake(15, CGRectGetHeight(whiteBack.frame)/2);
    writeImgV.bounds = CGRectMake(0, 0, 15, 15);
    writeImgV.image = [UIImage imageNamed:@"conmentEdit"];
    [whiteBack addSubview:writeImgV];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 4, CGRectGetWidth(whiteBack.frame)-40, 35-8)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.tag = 12345;
    _textField.backgroundColor = [UIColor whiteColor];
    [whiteBack addSubview:_textField];
    
    _textField.enablesReturnKeyAutomatically = YES;
    _textField.delegate = self;
    _textField.placeholder = @"说点什么吧...";
    _textField.font = FontSize(14);
    //设置returm键的样式
    _textField.returnKeyType = UIReturnKeySend;
    
    UIButton * comentRemindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comentRemindBtn.center = CGPointMake(CGRectGetMaxX(whiteBack.frame) + (ScreenWidth-CGRectGetMaxX(whiteBack.frame))/4, whiteBack.center.y);
    comentRemindBtn.bounds = CGRectMake(0, 0, 30, 30);
    [comentRemindBtn setImage:[UIImage imageNamed:@"conmentRemind"] forState:UIControlStateNormal];
    [comentRemindBtn addTarget:self action:@selector(scrollToConment) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:comentRemindBtn];
    
    UILabel * remindCmtLab = [[UILabel alloc] init];
    remindCmtLab.center = CGPointMake(CGRectGetMaxX(comentRemindBtn.frame)-3, CGRectGetMinY(comentRemindBtn.frame)+3);
    remindCmtLab.bounds = CGRectMake(0, 0, 20, 12);
    remindCmtLab.layer.cornerRadius = 6;
    remindCmtLab.layer.masksToBounds = YES;
    remindCmtLab.backgroundColor = K_COLOR_CUSTEM(216, 41, 50, 1);
    remindCmtLab.hidden = YES;
    remindCmtLab.textColor = [UIColor whiteColor];
    remindCmtLab.textAlignment = NSTextAlignmentCenter;
    remindCmtLab.font = FontSize(9);
    remindCmtLab.tag = 120000;
    [_inputView addSubview:remindCmtLab];
    
    UIButton * newsShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newsShareBtn.center = CGPointMake(CGRectGetMaxX(whiteBack.frame) + (ScreenWidth-CGRectGetMaxX(whiteBack.frame))*3/4, whiteBack.center.y);
    newsShareBtn.bounds = CGRectMake(0, 0, 30, 30);
    [newsShareBtn setImage:[UIImage imageNamed:@"newsShare"] forState:UIControlStateNormal];
    [newsShareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:newsShareBtn];
    
    
    
    //注册键盘弹出状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _inputBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _inputBackV.alpha = 0.7;
    _inputBackV.hidden = YES;
    _inputBackV.backgroundColor = [UIColor blackColor];
    [self.navigationController.view addSubview:_inputBackV];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
    [_inputBackV addGestureRecognizer:gesture];
    
    _inputV = [[InputView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-inputVHeight, ScreenWidth, inputVHeight)];
    _inputV.hidden = YES;
    _inputV.delegate = self;
    [self.navigationController.view addSubview:_inputV];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击键盘上德return键之后，手动调用发送按钮的方法，就相当于点击了发送
    [self sendButtonClick:nil];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField.tag ==12345) {
        if(![[CMStoreManager sharedInstance] isLogin]){
            [self goLogin];
            return NO;
        }
        
        if ([_news.permitComment isEqualToString:@"0"]) {
            [UIEngine showShadowPrompt:@"该文章暂不支持评论"];
            return NO;
        }
        
        self.conmentStyle = ConmentNews;
        _inputV.titleLab.text = @"评论";
        _cmtId = 0;
        _replyId = 0;
        _inputV.placeholderLab.text = [NSString stringWithFormat:@"说点什么吧..."];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    
}
#pragma mark- scroll
//将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark- notiMetho监听键盘打开和收起
- (void)keyboardChangeFrame:(NSNotification *)noti
{
    NSLog(@"%@",noti.userInfo);
    
    //从通知中取出动画速率
    int curve = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    //取出动画时间
    float duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取出键盘动画结束后键盘的frame
    CGRect endFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        if (endFrame.origin.y<ScreenHeigth)
        {
            _inputBackV.hidden = NO;
            [_inputV.textView becomeFirstResponder];
            _inputV.hidden = NO;
            _inputView.hidden = YES;
            
            
            _inputV.frame = CGRectMake(0, endFrame.origin.y-inputVHeight, ScreenWidth, inputVHeight);
            _inputView.frame = CGRectMake(0, endFrame.origin.y-49, self.view.bounds.size.width, 49);
            _tableView.frame = CGRectMake(0, 64, ScreenWidth,CGRectGetMinY(_inputV.frame)-64);
        }else
        {
            _inputBackV.hidden = YES;
            _inputV.hidden = YES;
            _inputView.hidden = NO;
            
            _inputV.frame = CGRectMake(0, endFrame.origin.y-inputVHeight, ScreenWidth, inputVHeight);
            _inputView.frame = CGRectMake(0, endFrame.origin.y-49, self.view.bounds.size.width, 49);
            _tableView.frame = CGRectMake(0, 64, ScreenWidth,CGRectGetMinY(_inputView.frame)-64);
        }
        
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _totalCmtArray.count +1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNums = 0;
    if (section==0)
    {
        rowNums = _contentArray.count;
    }else
    {
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[section-1];
        
        if (cmtReplyModel.reply.count>0)
        {
            if (cmtReplyModel.isOpen||cmtReplyModel.reply.count<=5) {
                rowNums = cmtReplyModel.reply.count;
                
            }else{
                rowNums = 5;
            }
        }else
        {
            rowNums = 1;
        }
    }
    
    return rowNums;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeight = 0.5;
    
    if (section!=0)
    {
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[section-1];
        NewsCmt * cmtModel = cmtReplyModel.cmt;
        NSString * replyContent = [EmojiClass decodeFromPercentEscapeString:cmtModel.content];
        
        CGFloat rowCellHeight = [Helper getSpaceLabelHeight:replyContent withFont:FontSize(14) withLineSpace:3 size:CGSizeMake(ScreenWidth-80, 100000) textlengthSpace:@0.0 paragraphSpacing:3];
        sectionHeight = 62+ rowCellHeight;
        
        if (section ==1) {
            sectionHeight = sectionHeight +36;
        }
    }
    return sectionHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section!=0)
    {
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[section-1];
        if (cmtReplyModel.reply.count>0)
        {
            return 15;
        }else{
            return 0.5;
        }
    }else{
        return 0.5;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    if (indexPath.section==0)
    {
        NSString * str = _contentArray[indexPath.row];
        if ([str rangeOfString:@".png"].location !=NSNotFound ||[str rangeOfString:@".jpg"].location !=NSNotFound)
        {
            
            
            UIImage * img ;
            if ([DataUsedEngine nullTrim:[_contentImgDic objectForKey:str]]) {
                img = [_contentImgDic objectForKey:_news.bannerUrl];
            }else{
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
                img = [UIImage imageWithData:data];
            }
            
            CGSize  imgSize = img.size;
            if (imgSize.width==0 || imgSize.height==0) {
                cellHeight = 0.5;
            }else
            {
                cellHeight = imgSize.height*(ScreenWidth-40-contentFont*2)/imgSize.width;
            }
        }else
        {
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            paraStyle.lineSpacing = lineSpace;
            paraStyle.paragraphSpacing = 10;
            paraStyle.hyphenationFactor = 1.0;
            paraStyle.firstLineHeadIndent = 0.0;
            paraStyle.paragraphSpacingBefore = 0.0;
            paraStyle.headIndent = 0;
            paraStyle.tailIndent = 0;
            NSDictionary *dic = @{NSFontAttributeName:FontSize(contentFont),
                                  NSParagraphStyleAttributeName:paraStyle,
                                  NSKernAttributeName:@1.0f
                                  };
            [attrStr addAttributes:dic range:NSMakeRange(0, attrStr.length)];
            
            CGFloat attrStrHeight = [Helper getSpaceLabelHeight:(NSString *)attrStr.mutableString withFont:FontSize(contentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 100000) textlengthSpace:textLengthSpace paragraphSpacing:10];
            cellHeight = attrStrHeight;
        }
    }else
    {
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[indexPath.section-1];
        if (cmtReplyModel.reply.count>0)
        {
            NSArray * cmtScetionArray = cmtReplyModel.reply;
            if (indexPath.row<cmtScetionArray.count)
            {
                NewsReply * replyModel = cmtScetionArray[indexPath.row];
                
                NSString * replyContent = [EmojiClass decodeFromPercentEscapeString:replyModel.replyContent];
                NSString * replyUserNick = [DataUsedEngine nullTrimString:replyModel.replyUserNick expectString:@""];
                NSString * upUserNick = [DataUsedEngine nullTrimString:replyModel.upUserNick expectString:@""];
                
            
                NSString * cmtText = [NSString stringWithFormat:@"%@ 回复 %@: %@",replyUserNick,upUserNick,replyContent];
                CGFloat rowCellHeight = [Helper getSpaceLabelHeight:cmtText withFont:FontSize(12) withLineSpace:3 size:CGSizeMake(ScreenWidth-70, 100000) textlengthSpace:@0.0 paragraphSpacing:3];
//                CGSize rowCellHeight = [Helper sizeWithText:cmtText font:FontSize(12) maxSize:CGSizeMake(ScreenWidth-90, 0)];
                cellHeight = rowCellHeight+10;
            }
            if (indexPath.row ==0) {
                if ( cmtReplyModel.reply.count>5) {
                    cellHeight += 30;

                }else{
                    cellHeight +=10;
                }
            }
        }else
        {
            cellHeight = 0.5;
        }
    }
    return cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * identifier = @"cmtHeaderV";
    CGFloat sectionHeight = 0.5;
    if (section!=0)
    {
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[section-1];
        NewsCmt * cmtModel = cmtReplyModel.cmt;
        NSString * replyContent = [EmojiClass decodeFromPercentEscapeString:cmtModel.content];
        
        CGFloat rowCellHeight = [Helper getSpaceLabelHeight:replyContent withFont:FontSize(14) withLineSpace:3 size:CGSizeMake(ScreenWidth-80, 100000) textlengthSpace:@0.0 paragraphSpacing:3];
        sectionHeight = 62+ rowCellHeight;
        if (section ==1)
        {
            sectionHeight = sectionHeight +36;
        }
    }
    __weak typeof(self) weakSelf = self;
    
    if (section!=0)
    {
        InfoSectionHeaderView * tabHeaderV = [[InfoSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, sectionHeight) reuseIdentifier:identifier];
        tabHeaderV.backgroundColor = [UIColor whiteColor];
        tabHeaderV.sectionHeaderClickBlock = ^(double cmtId,NSString * cmtUserNick){
            
            
            [weakSelf clickSectionHeaderWithCmtId:cmtId replyId:0 conmentUserNick:cmtUserNick];
        };
        [tabHeaderV setSectionHeaderWithDetailCmtReply:_totalCmtArray[section-1] section:(int)section];
        return tabHeaderV;
    }else{
        return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"newsContentCell";
    if (indexPath.section !=0)
    {
        identifier = @"newsConmentCell";
    }
    __weak typeof(self) weakSelf = self;
    
    NewsDetailCell * cell =  [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.showImageBlock = ^(NSString * showImgUrlStr)
    {
        [weakSelf showImageViewWithImage:showImgUrlStr];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0)
    {
        NSString * str = _contentArray[indexPath.row];
        [cell setContentCellWithContentString:str];
    }else
    {
        
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[indexPath.section-1];
        if (cmtReplyModel.reply.count>0)
        {
            NSArray * cmtScetionArray = cmtReplyModel.reply;
            if (indexPath.row<cmtScetionArray.count)
            {
                NewsReply * replyModel = cmtScetionArray[indexPath.row];
                
                [cell setConmentCellWithInfo:replyModel indexPath:indexPath allrowNums:cmtReplyModel.reply.count isOpen:cmtReplyModel.isOpen];
            }
        }
        cell.openReplyListBlock  = ^(BOOL isOpen,NSIndexPath * indexPath)
        {
            cmtReplyModel.isOpen = isOpen;
            [_totalCmtArray replaceObjectAtIndex:indexPath.section-1 withObject:cmtReplyModel];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
       __block NewsDetailCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString * userNick = [[CMStoreManager sharedInstance] getUserNick];
        NewsCmtReplyList  * cmtReplyModel = _totalCmtArray[indexPath.section-1];
        
       
        if (cmtReplyModel.reply.count>0)
        {
            NSArray * cmtScetionArray = cmtReplyModel.reply;
            if (indexPath.row<cmtScetionArray.count)
            {
                NewsReply * replyModel = cmtScetionArray[indexPath.row];
                if ([replyModel.replyUserNick isEqualToString:userNick]) {
                    [UIEngine showShadowPrompt:@"暂不支持回复自己的评论"];
                    return;
                }
                [UIView animateWithDuration:0.5 animations:^{
                    cell.cmtLab.backgroundColor = K_COLOR_CUSTEM(193, 200, 215, 1);
                } completion:^(BOOL finished)
                {
                    cell.cmtLab.backgroundColor = K_color_infoBack;
                    self.conmentStyle = ConmentReplyUser;
                    _inputV.titleLab.text = @"回复";
                    _cmtId = replyModel.cmtId;
                    _replyId = replyModel.replyIdentifier;
                    _inputV.placeholderLab.text = [NSString stringWithFormat:@"回复%@",replyModel.replyUserNick];
                    [_inputV.textView becomeFirstResponder];
                }];
               
            }
        }
    }
}

#pragma mark 发送回复／评论
- (void)conmentWithContentText;//:(NSString * )cmtContent replyContent:(NSString *)replyContent cmtId:(int)cmtId replyId:(int)replyId
{
    
    [RequestDataModel requestInfoAddNewCommentNewsId:_news.newsID
                                         contentText:_cmtContent
                                        replyContent:_replyContent
                                               cmtId:_cmtId
                                             replyId:_replyId
                                        successBlock:^(BOOL success, id info)
     {
         if (!success)
         {
             if (info)
             {
                 NSString * str = [NSString stringWithFormat:@"%@",info];
                 [UIEngine showShadowPrompt:str];
             }
         }else
         {
             [_inputV.textView resignFirstResponder];
             _inputV.textView.text = @"";
             _inputV.inputViewText  =@"";
             _inputV.placeholderLab.hidden = NO;
             [self.view endEditing:YES];
             _textField.placeholder = @"说点什么吧...";

             [self  refreshTableView];
         }
     }];
}

#pragma mark 刷新评论提醒数目
- (void)loadRemindCmtView
{
    UILabel * remindCmtLab = [_inputView viewWithTag:120000];
    if (_superCmtNum>0)
    {
        remindCmtLab.text = [NSString stringWithFormat:@"%d",_superCmtNum];
        remindCmtLab.hidden = NO;
    }else
    {
        remindCmtLab.hidden = YES;
    }
    
}

- (void)refreshTableView
{
    [self requestTotalComentData];
}


#pragma mark - 点击事件

#pragma mark －偏移量至评论
- (void)scrollToConment
{
    if (_totalCmtArray.count>0)
    {
        NSIndexPath * indexpath = [NSIndexPath  indexPathForRow:nil inSection:1];
        [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - tableView点击区头 回复一级评论
- (void)clickSectionHeaderWithCmtId:(int )cmtId replyId:(int)replyId conmentUserNick:(NSString *)conmentUserNick
{
    NSString * userNick = [[CMStoreManager sharedInstance] getUserNick];
    if ([conmentUserNick isEqualToString:userNick]) {
        [UIEngine showShadowPrompt:@"暂不支持回复自己的评论"];
        return;
    }
    
    _cmtId = cmtId;
    _replyId = replyId;
    self.conmentStyle = ConmentUser;
    _inputV.titleLab.text = @"回复";
    _inputV.placeholderLab.text = [NSString stringWithFormat:@"回复%@",conmentUserNick];
    [_inputV.textView becomeFirstResponder];
    
    
}
#pragma mark - InputViewDelegate 点击确定发送
- (void)sendInfo:(NSString *)infoStr
{
    [self.view endEditing:YES];
    [self sendButtonClick:nil];
}
#pragma mark 取消发送
- (void)cancelSendInfo
{
    [_inputV.textView resignFirstResponder];
    [self.view endEditing:YES];
    _inputV.textView.text = @"";
    _inputV.inputViewText = @"";
    _inputV.placeholderLab.text = @"说点什么吧...";
    _inputV.placeholderLab.hidden = NO;
}
#pragma mark 评论／回复事件
- (void)sendButtonClick:(UIButton *)sender
{
    if (_inputV.inputViewText.length<=0)
    {
        [UIEngine showShadowPrompt:@"发送内容为空"];
        return;
    }
    
    switch (self.conmentStyle)
    {
        case ConmentNews:
        {
            _cmtContent = _inputV.inputViewText;
            _replyContent = @"";
            _inputV.titleLab.text = @"评论";
        }
            break;
        case ConmentUser: case ConmentReplyUser:
        {
            _replyContent = _inputV.inputViewText;
            _cmtContent = @"";

        }
            break;
        default:
            break;
    }
    [self conmentWithContentText];//:_cmtContent replyContent:_replyContent cmtId:_cmtId replyId:_replyId];
//    [_inputV.textView resignFirstResponder];
//    _inputV.textView.text = @"";
//    _inputV.inputViewText  =@"";
//    _inputV.placeholderLab.hidden = NO;
//    [self.view endEditing:YES];
//    _textField.placeholder = @"说点什么吧...";
}
#pragma mark 取消编辑
- (void)cancelEdit
{
    [_inputV.textView resignFirstResponder];
    [self.view endEditing:YES];
    _textField.text = _inputV.textView.text;
}
#pragma mark 返回上一页

- (void)leftBackClick
{
    //注册键盘弹出状态的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 分享

- (void)shareClick
{
    NSString *url = [NSString stringWithFormat:@"%@/activity/newsDtl.html?id=%@",K_MGLASS_URL,self.news.newsID];
    NSString * title = self.news.title;
    NSString * content = [NSString stringWithFormat:@"%@ %@",self.news.summary,url];
    [PageChangeControl goShareWithTitle:title content:content urlStr:url imagePath:nil];
}
#pragma mark 去登录
- (void)goLogin
{
    
    PopUpView * loginAlertView = [[PopUpView alloc] initShowAlertWithShowText:@"请先登录" setBtnTitleArray:@[@"返回",@"登录"]];
    [self.navigationController.view addSubview:loginAlertView];
    loginAlertView.confirmClick = ^(UIButton * button){
        switch (button.tag) {
            case 66666:
            {
            }
                break;
            case 66667:
            {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
    
}
#pragma mark 显示照片浏览器
- (void)showImageViewWithImage:(NSString *)imageUrlStr
{
    [_pShowImgV showImageVWithImage:imageUrlStr];
    
}


-(void)loadRefresh{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [_tableView.header setAutoChangeAlpha:YES];
    [_tableView.footer setAutoChangeAlpha:YES];
}

-(void)endLoading{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}

-(void)loadMore{
    if ([_tableView.footer isRefreshing]) {
        if (_totalCmtArray.count >=_superCmtNum) {
        
            if (_totalCmtArray.count==0) {
                [self endLoading];
            }else{
                [_tableView.footer noticeNoMoreData];
            }
            return;
        }else{
            _cmtPageNo++;
            _cmtPageSize = 10;
            
            [self requestGo];
        }
    }
}

-(void)refresh{
    if ([_tableView.header isRefreshing]) {
        _cmtPageNo = 1;
        _cmtPageSize = 10;
        [self requestGo];
    }
}
-(void)requestGo{
    [self requestTotalComentData];
}


- (void)didReceiveMemoryWarning
{
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
