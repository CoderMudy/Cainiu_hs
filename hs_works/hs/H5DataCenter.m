//
//  H5DataCenter.m
//  QuoteWidget&H5SDKDemo
//
//  Created by lihao on 15-3-3.
//  Copyright (c) 2015年 lihao. All rights reserved.
//

#import "H5DataCenter.h"

#import "hscomm_message_interface.h"
#import "h5_protocol_tag.h"
#import "HsStockRealtime.h"
#import "HsIndexRealtime.h"
#import "HsStockKlineItem.h"
#import "HsStockKline.h"
#import "HsStockTrendItem.h"
#import "HsStockTrendData.h"
#import "hsQuoteFormatUtils.h"
#import "HsQuoteUtils.h"
#import "HsDealDetails.h"


static const int *FieldsIDArray[] = {
    &H5SDK_TAG_PROD_CODE,             //证券代码
    &H5SDK_TAG_PROD_NAME,                  //证券名称
    &H5SDK_TAG_HQ_TYPE_CODE,               //类型代码
    &H5SDK_TAG_DATA_TIMESTAMP,          //时间戳
    &H5SDK_TAG_TRADE_STATUS,            //交易状态
    &H5SDK_TAG_PRECLOSE_PX,             //昨收价
    &H5SDK_TAG_OPEN_PX,                 //今开盘
    &H5SDK_TAG_LAST_PX,                 //最新成交价
    &H5SDK_TAG_HIGH_PX,                 //最高价
    &H5SDK_TAG_LOW_PX,                  //最低价
    &H5SDK_TAG_CLOSE_PX,                //收盘价
    &H5SDK_TAG_BID_GRP,               //委买档位 --sequence
    &H5SDK_TAG_OFFER_GRP,             //委卖档位 --sequence
    &H5SDK_TAG_BUSINESS_AMOUNT,                  //总成交量
    &H5SDK_TAG_BUSINESS_BALANCE,                //总成交额
    &H5SDK_TAG_UP_PRICE,                //涨停价格
    &H5SDK_TAG_DOWN_PRICE,              //跌停价格
    &H5SDK_TAG_CURRENT_AMOUNT,             //最近成交量(现手)
    &H5SDK_TAG_BUSINESS_AMOUNT_IN,           //内盘成交量
    &H5SDK_TAG_BUSINESS_AMOUNT_OUT,          //外盘成交量
    &H5SDK_TAG_WEEK52_LOW_PX,            //52周最低价
    &H5SDK_TAG_WEEK52_HIGH_PX,           //52周最高价
    &H5SDK_TAG_PX_CHANGE,                  //涨跌额
    &H5SDK_TAG_PX_CHANGE_RATE,          //涨跌幅
    &H5SDK_TAG_POPC_PX,    //盘前盘后价
    &H5SDK_TAG_PE_RATE,                          //当前交易节成交量
    &HSSDK_TAG_EPS,                     //每股收益
    &HSSDK_TAG_MARKET_VALUE,            //总市值
    &HSSDK_TAG_CIRCULATION_VALUE,       //流通市值
    &HSSDK_TAG_SHARES_PER_HAND,         //每手股数
    &H5SDK_TAG_TURNOVER_RATIO,          //换手率
    &HSSDK_TAG_RISE_COUNT,              //涨家数
    &HSSDK_TAG_FALL_COUNT,              //跌家数
    &HSSDK_TAG_MEMBER_COUNT,            //总家数
    &H5SDK_TAG_RISE_FIRST_GRP,              //领涨股 --sequence
    &H5SDK_TAG_FALL_FIRST_GRP,              //领跌股 --sequence
    NULL
};


@interface H5DataCenter ()<INetworkResponse>
{
    NSMutableDictionary *_handleBlocks;
}
@end

@implementation H5DataCenter

-(instancetype)init
{
    self = [super init];
    if (self) {
        _handleBlocks = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(NSDictionary*)createUserInfo:(NSString*)handleKey ForStock:(HsStock*)stock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([handleKey length] > 0) {
        [dic setObject:handleKey forKey:@"handleKey"];
    }
    if (stock) {
        [dic setObject:stock forKey:@"stock"];
    }
    return dic;
}



-(NSString*)getHandlerKey
{
    static unsigned int handlerKey = 1000;
    return [NSString stringWithFormat:@"%d", handlerKey++];
}

-(int)requestMaxRecord
{
    return 12;
}

-(void)queryStocks:(NSString*)stock type:(int)type withHandleBlock:(HandleBlock)block
{
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_KEYBOARD_WIZARD andPackageType:REQUEST];
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_MAX_VALUE] setInt32:[self requestMaxRecord] atIndex:0];
    IGroup *types = [body setGroup:H5SDK_TAG_TYPE_GRP];
    //沪深
       if (type == 0) {
    [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XSHG.ESA" atIndex:0];
    //[[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XSHG.MRI" atIndex:0];
    [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XSHE.ESA" atIndex:0];
    //[[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XSHE.MRI" atIndex:0];
    
        }
    //美股
    //    else if (type == 1){
//    [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XNAS.ES" atIndex:0];
//    [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XASE.ES" atIndex:0];
//    [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:"XNYS.ES" atIndex:0];
    //    }
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:nil];
    //    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo timeout:2 resendTimes:0];
}

-(void)loadBlocks4StockCode:(HsStock*)stock withHandleBlock:(HandleBlock)block
{
    CMLog(@"-------loadBock  start");
    //创建一条新消息
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_STOCK_BLOCKS andPackageType:REQUEST];
    //在消息体中设置正确的请求参数
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    
    //保存回调处理函数
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:stock];
    //发送消息给服务器
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
    
    CMLog(@"-------loadBock  end");
}
-(void)loadTrends:(HsStock*)stock withHandleBlock:(HandleBlock)block
{
    //创建一条新消息
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_TREND  andPackageType:REQUEST];
    //在消息体中设置正确的请求参数
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_DATE] setInt32:0 atIndex:0];
    
    //保存回调处理函数
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:stock];
    //发送消息给服务器
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
    
}

-(void)loadStockTick:(HsStock *)stock Begin:(int)begin andCount:(int)count withHandleBlock:(HandleBlock)block
{
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_TICK_DIRECTION andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_DATE] setInt32:0 atIndex:0];
    [[body getItem:H5SDK_TAG_START_POS] setInt32:0 atIndex:0];
    [[body getItem:H5SDK_TAG_DIRECTION] setInt32:H5SDK_ENUM_FORWARD atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:stock];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
}

-(void)loadKline:(HsStock*)stock AtDate:(int64_t)dt Count:(int)count Peroid:(int)peroid withHandleBlock:(HandleBlock)block
{
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_CANDLE_BY_OFFSET andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    //周期转化
    [[body getItem:H5SDK_TAG_CANDLE_PEROID] setInt32:peroid atIndex:0];
    uint8 klineCandleMode = H5SDK_ENUM_CANDLE_ORIGINAL;
    
    klineCandleMode = H5SDK_ENUM_CANDLE_FORWARD;
    
    [[body getItem:H5SDK_TAG_CANDLE_MODE] setInt8:klineCandleMode atIndex:0];
    if (dt != 0) {
        [[body getItem:H5SDK_TAG_DATE] setInt32:(uint32)dt/10000 atIndex:0];
        [[body getItem:H5SDK_TAG_MIN_TIME] setInt32:dt%10000 atIndex:0];
    }
    
    [[body getItem:H5SDK_TAG_DIRECTION] setInt8:H5SDK_ENUM_FORWARD atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:stock];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
}
//市场代码表
-(void)loadMarketReference:(NSString*)hqTypeCode
           withHandleBlock:(HandleBlock)block
{
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_MARKET_REFERENCE andPackageType:REQUEST];
    IRecord *body = [msg getBody];
    
    if (hqTypeCode != nil) {
        [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:hqTypeCode.UTF8String atIndex:0];
        
    }
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:nil];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
}
//得到某个板块下的股票数据
-(void)loadBlocksStocks4Sort:(HsStock*)stock
                        From:(int)begin
                       Count:(int)count
                   orderType:(int)orderType
             withHandleBlock:(HandleBlock)block
{
    if( block == nil)
        return;
    // static int sorttype = 0;
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_BLOCK_SORT andPackageType:REQUEST];
    IRecord *body = [msg getBody];
    
    [[body getItem:H5SDK_TAG_START_POS] setInt32:begin atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    
    [[body getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    [[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:H5SDK_TAG_PX_CHANGE_RATE atIndex:0];
    //[[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:H5SDK_TAG_DATE atIndex:0];
    
    //[[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:100 atIndex:0];
    
    [[body getItem:H5SDK_TAG_SORT_TYPE] setInt8:orderType atIndex:0];
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:nil];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
    // sorttype = (sorttype == 0 ? 1:0);
}

//请求板块数据

-(void)loadBlocks:(NSString *)blocks
             From:(int)begin
            Count:(int)count
  withHandleBlock:(HandleBlock)block
{
    if( block == nil)
        return;
    //blocks = @"XBHS"
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_SORT andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    
    [[body getItem:H5SDK_TAG_START_POS] setInt32:begin atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    
    
    IGroup *stocks = [body setGroup:H5SDK_TAG_SORT_TYPE_GRP];
    IRecord *a_record = [stocks addRecord];
    [[a_record getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:blocks.UTF8String atIndex:0];
    
    [[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:H5SDK_TAG_PX_CHANGE_RATE atIndex:0];
    //[[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:H5SDK_TAG_PX_CHANGE atIndex:0];
    IGroup *fieldsbody = [body setGroup:H5SDK_TAG_FIELD_GRP];
    @try {
        int i = 0;
        int *fieldsid = (int *)FieldsIDArray[i];
        while (fieldsid!=NULL) {
            [[[fieldsbody addRecord] getItem:H5SDK_TAG_FIELD_ID] setInt32:*fieldsid atIndex:0];
            fieldsid = (int *)FieldsIDArray[++i];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: %@", exception.description);
    }
    
    // int nf = H5SDK_TAG_RISE_FIRST_GRP;
    IGroup *fields = [body setGroup:H5SDK_TAG_FIELD_GRP];
    NSString * str = @"rise_first_grp";
    //[[[fields addRecord] getItem:H5SDK_TAG_FIELD_NAME] setString:str.UTF8String atIndex:0];
    //[[[fields addRecord] getItem:H5SDK_TAG_FIELD_ID] setInt32:H5SDK_TAG_RISE_FIRST_GRP atIndex:0];
    //20058 1009
    @try {
        int i = 0;
        int *fieldsid = (int *)FieldsIDArray[i];
        
        while (fieldsid!=NULL)
        {
            [[[fields addRecord] getItem:H5SDK_TAG_FIELD_ID] setInt32:*fieldsid atIndex:0];
            fieldsid = (int *)FieldsIDArray[++i];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: %@", exception.description);
    }
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:nil];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
}

-(void)loadRealtime:(HsStock*)stock withHandleBlock:(HandleBlock)block
{
    if (stock == nil || block == nil) {
        return;
    }
    NSLog(@"(开始)请求股票信息 %@ %@",stock.stockName,stock.stockCode);
    
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_SNAPSHOT andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_HQ_LEVEL] setInt8:H5SDK_ENUM_LEVEL_2 atIndex:0];
    IGroup *stocks = [body setGroup:H5SDK_TAG_PROD_GRP];
    IRecord *a_record = [stocks addRecord];
    [[a_record getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
    [[a_record getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    IGroup *fields = [body setGroup:H5SDK_TAG_FIELD_GRP];
    @try {
        int i = 0;
        int *fieldsid = (int *)FieldsIDArray[i];
        while (fieldsid!=NULL) {
            [[[fields addRecord] getItem:H5SDK_TAG_FIELD_ID] setInt32:*fieldsid atIndex:0];
            fieldsid = (int *)FieldsIDArray[++i];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: %@", exception.description);
    }
    //20069=H5SDK_TAG_FIELD_ID
    //[[[fields addRecord] getItem:20069] setInt32:20069 atIndex:0];
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSDictionary *userInfo = [self createUserInfo:handlerKey ForStock:stock];
    [self.h5Session sendMessage:msg delegate:self andUserInfo:userInfo];
    
    NSLog(@"(结束)请求股票信息 %@ %@",stock.stockName,stock.stockCode);
}

-(void)loadRealtimeList:(NSMutableArray *)stocks withHandleBlock:(HandleBlock)block
{
    //NSLog(@"loadRealtimeList start");
    if ([stocks count] == 0 || block == nil) {
        return;
    }
    
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_SNAPSHOT andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_HQ_LEVEL] setInt8:H5SDK_ENUM_LEVEL_2 atIndex:0];
    IGroup *stockGroup = [body setGroup:H5SDK_TAG_PROD_GRP];
    for (HsStock *stock in stocks) {
        IRecord *a_record = [stockGroup addRecord];
        [[a_record getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
        [[a_record getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    }
    
    IGroup *fields = [body setGroup:H5SDK_TAG_FIELD_GRP];
    @try {
        int i = 0;
        int *fieldsid = (int *)FieldsIDArray[i];
        while (fieldsid!=NULL) {
            [[[fields addRecord] getItem:H5SDK_TAG_FIELD_ID] setInt32:*fieldsid atIndex:0];
            fieldsid = (int *)FieldsIDArray[++i];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: %@", exception.description);
    }
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([handlerKey length] > 0) {
        [dic setObject:handlerKey forKey:@"handleKey"];
    }
    if ([stocks count] > 0) {
        [dic setObject:stocks forKey:@"stocks"];
    }
    [self.h5Session sendMessage:msg delegate:self andUserInfo:dic];
    
    
}


-(void)loadMarketData:(NSArray *)market withHandleBlock:(HandleBlock)block
{
    if ([market count] == 0) {
        return;
    }
    IHsCommMessage *msg = [_h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_MARKET_TYPES andPackageType:REQUEST];
    IRecord *body = [msg getBody];
    IGroup *group = [body setGroup:H5SDK_FINANCE_MIC_GRP];
    for (NSString *marketName in market) {
        if ([marketName length] > 0) {
            [[[group addRecord] getItem:H5SDK_TAG_FINANCE_MIC] setString:marketName.UTF8String atIndex:0];
        }
    }
    
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([handlerKey length] > 0) {
        [dic setObject:handlerKey forKey:@"handleKey"];
    }
    [self.h5Session sendMessage:msg delegate:self andUserInfo:dic];
}

-(void)loadRankingStocksData:(NSArray*)marketType
                        From:(int)begin
                       Count:(int)count
                andSortColId:(int)colId
                   orderType:(int)orderType
             withHandleBlock:(HandleBlock)block
{
    if (block == nil) {
        return;
    }
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_SORT andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_START_POS] setInt32:begin atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    [[body getItem:H5SDK_TAG_SORT_TYPE] setInt8:orderType atIndex:0];
    
    //    NSString *fieldName = [HsH5DataCenter hsQuoteTypeToH5Type:colId];
    [[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:colId  atIndex:0];
    
    IGroup *types = [body setGroup:H5SDK_TAG_SORT_TYPE_GRP];
    for (NSString * mType in marketType) {
        if ([mType length] > 0) {
            [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:mType.UTF8String atIndex:0];
        }
    }
    
    /*
     IGroup *fields = [body setGroup:H5SDK_TAG_FIELDS];
     @try {
     int i = 0;
     char *fieldsName = FieldsArray[i];
     while (strlen(fieldsName)>1) {
     [[[fields addRecord] getItem:H5SDK_TAG_FIELD_NAME] setString:fieldsName atIndex:0];
     fieldsName = FieldsArray[++i];
     }
     }
     @catch (NSException *exception) {
     NSLog(@"ERROR: %@", exception.description);
     }
     */
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block  forKey:handlerKey];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([handlerKey length] > 0) {
        [dic setObject:handlerKey forKey:@"handleKey"];
    }
    [self.h5Session sendMessage:msg delegate:self andUserInfo:dic];
    
}

-(void)loadRankingStocksData:(NSArray*)stocks
                       types:(NSArray*)marketType
                        From:(int)begin
                       Count:(int)count
                andSortColId:(int)colId
                   orderType:(int)orderType
             withHandleBlock:(HandleBlock)block
{
    if (block == nil) {
        return;
    }
    IHsCommMessage *msg = [self.h5Session createMessageWithBizID:BIZ_H5PROTO andFuncId:H5SDK_MSG_SORT andPackageType:REQUEST];
    
    IRecord *body = [msg getBody];
    [[body getItem:H5SDK_TAG_START_POS] setInt32:begin atIndex:0];
    [[body getItem:H5SDK_TAG_DATA_COUNT] setInt32:count atIndex:0];
    [[body getItem:H5SDK_TAG_SORT_TYPE] setInt8:orderType atIndex:0];
    
    //    NSString *fieldName = [HsH5DataCenter hsQuoteTypeToH5Type:colId];
    [[body getItem:H5SDK_TAG_SORT_FIELD_ID] setInt32:colId atIndex:0];
    
    IGroup *stockGroup = [body setGroup:H5SDK_TAG_SORT_PROD_GRP];
    for (HsStock *stock in stocks) {
        IRecord *a_record = [stockGroup addRecord];
        [[a_record getItem:H5SDK_TAG_PROD_CODE] setString:stock.stockCode.UTF8String atIndex:0];
        [[a_record getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:stock.codeType.UTF8String atIndex:0];
    }
    
    IGroup *types = [body setGroup:H5SDK_TAG_SORT_TYPE_GRP];
    for (NSString * mType in marketType) {
        if ([mType length] > 0) {
            [[[types addRecord] getItem:H5SDK_TAG_HQ_TYPE_CODE] setString:mType.UTF8String atIndex:0];
        }
    }
    /*
     IGroup *fields = [body setGroup:H5SDK_TAG_FIELDS];
     @try {
     int i = 0;
     char *fieldsName = FieldsArray[i];
     while (strlen(fieldsName)>1) {
     [[[fields addRecord] getItem:H5SDK_TAG_FIELD_NAME] setString:fieldsName atIndex:0];
     fieldsName = FieldsArray[++i];
     }
     }
     @catch (NSException *exception) {
     NSLog(@"ERROR: %@", exception.description);
     }
     */
    NSString *handlerKey = [self getHandlerKey];
    if (block) {
        [_handleBlocks setObject:block forKey:handlerKey];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([handlerKey length] > 0) {
        [dic setObject:handlerKey forKey:@"handleKey"];
    }
    [self.h5Session sendMessage:msg delegate:self andUserInfo:dic];
    
}


#pragma mark - handle H5Message
-(void)handleMessage:(IHsCommMessage *)msg Error:(Errors)error UserInfo:(id)userInfo
{
    if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *handlerKey = [(NSDictionary*)userInfo objectForKey:@"handleKey"];
    HsStock *stock = [(NSDictionary*)userInfo objectForKey:@"stock"];
    NSArray *stockList = [(NSDictionary*)userInfo objectForKey:@"stocks"];
    HandleBlock block = [_handleBlocks objectForKey:handlerKey];
    if (!block) {
        NSLog(@"No handleBlock...");
        return;
    }
    if (error != SUCCESS) {
        block(nil);
        [_handleBlocks removeObjectForKey:handlerKey];
        return;
    }
    id result = nil;
    int functionID = [msg getFunction];
    //键盘精灵
    if (functionID == H5SDK_KEYBOARD_WIZARD) {
        result = [self msgToStocks:msg];
    }
    //行情快照
    else if (functionID == H5SDK_MSG_SNAPSHOT)
    {
        if (stock) {
            result = [self msgToRealtime:msg withStock:stock];
        }
        else if ([stockList count] > 0)
        {
            result = [self msgToRealtimeList:msg withStock:stockList];
        }
//        if(stock)
//        {
//            ;
//        }
//        else
//        {
//            NSLog(@"H5SDK_MSG_SNAPSHOT 回复");
//        }
        
    }
    //分时
    else if (functionID == H5SDK_MSG_TREND)
    {
        result = [self msgToTrendData:msg withStock:stock];
    }
    //K线
    else if (functionID == H5SDK_MSG_CANDLE_BY_OFFSET || functionID == H5SDK_MSG_CANDLE_BY_RANGE)
    {
        result = [self msgToKline:msg withStock:stock];
    }
    else if (functionID == H5SDK_MSG_MARKET_TYPES){
        result = [self getMarketInfo:msg];
    }
    else if(functionID == H5SDK_MSG_SORT){
        //result = [self msgToRealtimeList:msg withStock:nil];
        result  = [self getBlocks4H5SDK_TAG_PX_CHANGE_RATE:msg];
    }
    else if(functionID == H5SDK_MSG_TICK_DIRECTION){
        result = [self msgToTick:msg withStock:stock];
    }
    else if(functionID == H5SDK_MSG_STOCK_BLOCKS)
    {
        result  = [self msgToStockBlocks:msg withStock:stock];
    }
    else if (functionID == H5SDK_MSG_BLOCK_SORT)
    {
        result  = [self msgToStockBlocksSort:msg withStock:stock];//某板块下的数据
    }
    else if (functionID == H5SDK_MSG_MARKET_REFERENCE)
    {
        result = [self msgToMarketReference:msg];
    }
    block(result);
    //NSLog(@"_handleBlocks=%@",_handleBlocks);
    
    [_handleBlocks removeObjectForKey:handlerKey];
}

#pragma mark - H5Message parse
-(id)msgToMarketReference:(IHsCommMessage*)msg
{
    IRecord *body = [msg getBody];
    
    NSString * strProdName1 = [NSString stringWithUTF8String:[[body getItem:H5SDK_TAG_FINANCE_NAME] getString:0]];
    
    IGroup *sequence = [msg getGroup:H5SDK_TAG_PROD_GRP];
    int size = [sequence getRecordCount];
    for (int i=0; i<size; i++)
    {
        IRecord *record = [sequence  getRecord:i];
        NSString * strProdName = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_NAME] getString:0]];
        NSString * strProdCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        NSString * strTypeCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]];
        
        int nRATE = [[record getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0];
        
        NSLog(@"%@ 板块＝%@ 代码 ＝%@ type =%@ 涨跌幅＝%d",strProdName1,strProdName,strProdCode,strTypeCode,nRATE);
        
    }
    return nil;
}

//某板块下的数据

-(id)msgToStockBlocksSort:(IHsCommMessage*)msg withStock:(HsStock*)stock
{
    IGroup *sequence = [msg getGroup:H5SDK_TAG_SORT_PROD_GRP];
    int size = [sequence getRecordCount];
    NSMutableArray *trendArray = [NSMutableArray array];
    
    for (int i=0; i<size; i++) {
        IRecord *record = [sequence  getRecord:i];
        NSString * strProdName = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_NAME] getString:0]];
        NSString * strProdCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        NSString * strTypeCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]];
       
//        // 过滤掉创业版
//        NSRange range = [strTypeCode rangeOfString:@"GEM"];//判断字符串是否包含
//        if (range.location == NSNotFound)//不包含
//            ;
//        else
//        {
//            NSLog(@"板块＝%@ 代码 ＝%@ type =%@ ",strProdName,strProdCode,strTypeCode);
//            continue;
//        }
        
        NSRange range = [strProdName rangeOfString:@"ST"];//判断字符串是否包含
        if (range.location == NSNotFound)//不包含
            ;
        else
        {
            NSLog(@"板块＝%@ 代码 ＝%@ type =%@ ",strProdName,strProdCode,strTypeCode);
            continue;
        }

        
        int newPrice = [[record getItem:H5SDK_TAG_LAST_PX] getInt32:0];
        int nRATE = [[record getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0];
        
        double newprice = newPrice/LARGE_NUM;
        double nrate = nRATE/LARGE_NRATE;
        
        
        
        NSLog(@"板块＝%@ 代码 ＝%@ type =%@ 涨跌幅＝%d ,最新价 ＝ %d",strProdName,strProdCode,strTypeCode,nRATE,newPrice);
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        NSString * tmp2 = strProdName==nil ?@"":strProdName;
        dictionary[@"strProdName"]=tmp2;
        [dictionary setValue:tmp2 forKey:@"strProdName"];
        [dictionary setValue:strProdCode forKey:@"strProdCode"];
        [dictionary setValue:strTypeCode forKey:@"strTypeCode"];
        [dictionary setValue:[NSString stringWithFormat:@"%f",nrate] forKey:@"nRATE"];
        [dictionary setValue:[NSString stringWithFormat:@"%f",newprice]  forKey:@"newPrice"];
        
        IGroup * riseFirst_grp = [record getGroup:H5SDK_TAG_RISE_FIRST_GRP];
        
        int gn = [riseFirst_grp getRecordCount];
        
        for (int j=0; j<gn; j++)
        {
            IRecord *record1 = [riseFirst_grp  getRecord:j];
            NSString * firstStockProdName = [NSString stringWithUTF8String:[[record1 getItem:H5SDK_TAG_PROD_NAME] getString:0]];
            NSString * firstStockProdCode = [NSString stringWithUTF8String:[[record1 getItem:H5SDK_TAG_PROD_CODE] getString:0]];
            
            [dictionary setValue:firstStockProdName forKey:@"upFirstStockName"];
            [dictionary setValue:firstStockProdCode forKey:@"upFirstStockCode"];
            
            break;
            // NSLog(@"first = %@",strProdName);
        }
        [trendArray  addObject:dictionary];
        
    }
    
    return  trendArray;
}

//板块数据
-(id)getBlocks4H5SDK_TAG_PX_CHANGE_RATE:(IHsCommMessage*)msg
{
    NSMutableArray *trendArray = [NSMutableArray array];
    
    //    IGroup *sequence = [msg getGroup:H5SDK_TAG_PROD_GRP];
    
    
    IGroup *sequence = [msg getGroup:H5SDK_TAG_SORT_PROD_GRP];
    int size = [sequence getRecordCount];
    for (int i=0; i<size; i++) {
        IRecord *record = [sequence  getRecord:i];
        NSString * strProdName = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_NAME] getString:0]];
        NSString * strProdCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        NSString * strTypeCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]];
        /*HSSDK_TAG_RISE_COUNT
         HSSDK_TAG_FALL_COUNT
         HSSDK_TAG_MEMBER_COUNT*/
        //领涨股数
        int riseCount = [[record getItem:HSSDK_TAG_RISE_COUNT] getInt32:0];
        //领跌股数
        int fallCount = [[record getItem:HSSDK_TAG_FALL_COUNT] getInt32:0];
        //总股数
        int memberCount = [[record getItem:HSSDK_TAG_MEMBER_COUNT] getInt32:0];
        //平盘股
        int flatCount = memberCount - fallCount - riseCount;
        //涨跌额
        int changePrice = [[record getItem:H5SDK_TAG_PX_CHANGE] getInt32:0];
        
        //最新价
        int64 newPrice = [[record getItem:H5SDK_TAG_LAST_PX] getInt64:0];
        //涨跌幅
        int32 nRATE = [[record getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0];
        
        double changeprice = changePrice/LARGE_NUM;
        double newprice = newPrice/LARGE_NUM;
        double nrate = nRATE/LARGE_NRATE;
        
        
        
        //        NSString * upFirstStock =[NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_RISE_FIRST_GRP]getString:0]];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        NSString * tmp2 = strProdName==nil ?@"":strProdName;
        dictionary[@"strProdName"]=tmp2;
        [dictionary setValue:tmp2 forKey:@"strProdName"];
        [dictionary setValue:strProdCode forKey:@"strProdCode"];
        [dictionary setValue:strTypeCode forKey:@"strTypeCode"];
        [dictionary setValue:[NSNumber numberWithDouble:nrate] forKey:@"nRATE"];
        [dictionary setValue:[NSNumber numberWithDouble:changeprice] forKey:@"changePrice"];
        [dictionary setValue:[NSNumber numberWithDouble:newprice] forKey:@"newPrice"];
        [dictionary setValue:[NSNumber numberWithInt:riseCount] forKey:@"riseCount"];
        [dictionary setValue:[NSNumber numberWithInt:fallCount] forKey:@"fallCount"];
        [dictionary setValue:[NSNumber numberWithInt:flatCount] forKey:@"flatCount"];
        
        
        
        
        
        
        
        NSLog(@"板块＝%@ 代码 ＝%@ type =%@ 涨跌幅＝%d ",strProdName,strProdCode,strTypeCode,nRATE);
        [trendArray  addObject:dictionary];
        IGroup * riseFirst_grp = [record getGroup:H5SDK_TAG_RISE_FIRST_GRP];
        
        int gn = [riseFirst_grp getRecordCount];
        
        for (int j=0; j<gn; j++)
        {
            IRecord *record1 = [riseFirst_grp  getRecord:j];
            NSString * firstStockProdName = [NSString stringWithUTF8String:[[record1 getItem:H5SDK_TAG_PROD_NAME] getString:0]];
            NSString * firstStockProdCode = [NSString stringWithUTF8String:[[record1 getItem:H5SDK_TAG_PROD_CODE] getString:0]];
            
            [dictionary setValue:firstStockProdName forKey:@"upFirstStockName"];
            [dictionary setValue:firstStockProdCode forKey:@"upFirstStockCode"];
            
            
            NSLog(@"first = %@",firstStockProdName);
            break;
            
        }
    }
    
    return  trendArray;
}
-(id)getMarketInfo:(IHsCommMessage*)msg
{
    IRecord *body = [msg getBody];
    NSMutableDictionary *marketInfo = [NSMutableDictionary dictionary];
    @try {
        IGroup *group = [body getGroup:H5SDK_FINANCE_MIC_GRP];
        if (group) {
            
            int count = [group getRecordCount];
            for (int i = 0; i < count; i++) {
                IRecord *rec = [group getRecord:i];
                HsMarket *market = [[HsMarket alloc] init];
                market.marketCode = [[NSString stringWithUTF8String:[[rec getItem:H5SDK_TAG_FINANCE_MIC] getString:0]] uppercaseString];
                market.marketName = [NSString stringWithUTF8String:[[rec getItem:H5SDK_TAG_FINANCE_NAME] getString:0]];
                market.marketDate = [[rec getItem:H5SDK_TAG_MARKET_DATE] getInt32:0];
                market.tradeDate = [[rec getItem:H5SDK_TAG_INIT_DATE] getInt32:0];
                market.summerTimeFlag = [[rec getItem:H5SDK_TAG_DST_FLAG] getInt8:0];
                market.timezone = [NSString stringWithUTF8String:[[rec getItem:H5SDK_TAG_TIMEZONE_CODE] getString:0]];
                
                IGroup *types = [rec getGroup:H5SDK_TAG_TYPE_GRP];
                if (types) {
                    int typeCount = [types getRecordCount];
                    for (int j = 0; j < typeCount; j++) {
                        IRecord *typeRec = [types getRecord:j];
                        HsTypeItem *typeItem = [[HsTypeItem alloc] init];
                        typeItem.marketCode = market.marketCode;
                        typeItem.marketTypeCode = [[NSString stringWithUTF8String:[[typeRec getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]] uppercaseString];
                        typeItem.marketTypeName = [NSString stringWithUTF8String:[[typeRec getItem:H5SDK_TAG_HQ_TYPE_NAME] getString:0]];
                        typeItem.priceDecimal = [[typeRec getItem:HSSDK_TAG_PX_PRECISION] getInt32:0];
                        typeItem.priceScale = [[typeRec getItem:H5SDK_TAG_PRICE_SCALE] getInt32:0];
                        typeItem.tradeDate = [[typeRec getItem:H5SDK_TAG_INIT_DATE] getInt32:0];
                        
                        IGroup *hours = [typeRec getGroup:H5SDK_TAG_TRADE_SECTION_GRP];
                        if (hours) {
                            int hourCount = [hours getRecordCount];
                            for (int k = 0; k < hourCount; k++) {
                                IRecord *hourRec = [hours getRecord:k];
                                HsTradeTime *tradeTime = [[HsTradeTime alloc] init];
                                tradeTime.openTime = [[hourRec getItem:H5SDK_TAG_OPEN_TIME] getInt32:0];
                                tradeTime.closeTime = [[hourRec getItem:H5SDK_TAG_CLOSE_TIME] getInt32:0];
                                [typeItem.tradeTimes addObject:tradeTime];
                            }
                        }
                        [market.typeItems addObject:typeItem];
                    }
                }
                [marketInfo setObject:market forKey:market.marketCode];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Message parse Error: %@",exception.description);
    }
    @finally {
        return marketInfo;
    }
}

//分时
-(id)msgToTrendData:(IHsCommMessage*)msg withStock:(HsStock*)stock
{
    NSMutableArray *trendArray = [NSMutableArray array];
    IGroup *sequence = [msg getGroup:H5SDK_TAG_TREND_GRP];
    int size = [sequence getRecordCount];
    for (int i = 0; i < size; i++) {
        IRecord *record = [sequence getRecord:i];
        HsStockTrendItem *item = [[HsStockTrendItem alloc] init];
        //价格需要进行缩放处理
        unsigned int price = [[record getItem:H5SDK_TAG_HQ_PRICE] getInt32:0];
        item.price = [HsQuoteFormatUtils formatPrice:price withStock:stock]/LARGE_NUM;
        unsigned int avg = [[record getItem:H5SDK_TAG_AVG_PX] getInt32:0];
        item.avg = [HsQuoteFormatUtils formatPrice:avg withStock:stock];
        unsigned int wavg = [[record getItem:H5SDK_TAG_WAVG_PX] getInt32:0];
        item.wavg = [HsQuoteFormatUtils formatPrice:wavg withStock:stock]/LARGE_NUM;
        item.time = [[record getItem:H5SDK_TAG_MIN_TIME] getInt32:0];
        
        item.vol = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT] getInt64:0];
        if (i>0) {//每个时点的量为累积，因此需要减去上个时点的量
            item.vol = item.vol - [[[sequence getRecord:i-1] getItem:H5SDK_TAG_BUSINESS_AMOUNT] getInt64:0];
        }
        item.money = [[record getItem:H5SDK_TAG_BUSINESS_BALANCE] getInt64:0];
        [trendArray addObject:item];
    }
    HsStockTrendData *trendData = [[HsStockTrendData alloc] init];
    trendData.items = trendArray;
    
    return trendData;
    
}

-(id)msgToStockBlocks:(IHsCommMessage *)msg withStock:(HsStock *)stock
{
    
    IGroup *sequence = [msg getGroup:H5SDK_TAG_PROD_GRP];
    int size = [sequence getRecordCount];
    NSDictionary * dictionary = [[NSDictionary alloc] init];
    for (int i=0; i<size; i++) {
        IRecord *record = [sequence getRecord:i];
        
        NSString * strProdName = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_NAME] getString:0]];
        NSString * strProdCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        NSString * strTypeCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]];
        
        
        NSLog(@"板块＝%@ 代码 ＝%@ type =%@ ",strProdName,strProdCode,strTypeCode);
        
        
        strProdName = (strProdName==nil?@"":strProdName);
        dictionary = @{@"strProdName":strProdName,
                       @"strTypeCode":strTypeCode,
                       @"strProdCode":strProdCode};
        
    }
    
    return  dictionary;
}
-(id)msgToTick:(IHsCommMessage *)msg withStock:(HsStock *)stock
{
    IGroup *sequence = [msg getGroup:H5SDK_TAG_TICK_GRP];
    int size = [sequence getRecordCount];
    NSMutableArray *dealItems = [NSMutableArray arrayWithCapacity:size];
    for (int i=0; i<size; i++) {
        IRecord *record = [sequence getRecord:i];
        HsStockTickItem *item = [[HsStockTickItem alloc] init];
        item.price = [HsQuoteFormatUtils formatPrice:[[record getItem:H5SDK_TAG_HQ_PRICE] getInt32:0] withStock:stock];
        //        NSLog(@"%d/%d = %f",[[record getItem:H5SDK_TAG_PRICE] getInt32:0],[HsQuoteUtils getPriceScale:stock],item.price);
        item.volume = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT] getInt64:0];
        item.time = [[record getItem:H5SDK_TAG_BUSINESS_TIME] getInt32:0];
        item.tradeFlag = [[record getItem:HSSDK_TAG_BUSINESS_DIRECTION] getInt8:0];
        [dealItems addObject:item];
    }
    HsDealDetails *dealDetails = [[HsDealDetails alloc] init];
    dealDetails.dealItems = dealItems;
    
    return dealDetails;
}

//k线

-(id)msgToKline:(IHsCommMessage*)msg withStock:(HsStock*)stock
{
    IGroup *sequence = [msg getGroup:H5SDK_TAG_CANDLE_GRP];
    int size = [sequence getRecordCount];
    NSMutableArray *klineDatas = [NSMutableArray arrayWithCapacity:size];
    for(int i = 0; i < size; i++)
    {
        IRecord *record = [sequence getRecord:i];
        HsStockKlineItem *item = [[HsStockKlineItem alloc] init];
        
        int closePrice = [[record getItem:H5SDK_TAG_CLOSE_PX] getInt32:0];
        item.closePrice = [HsQuoteFormatUtils formatPrice:closePrice withStock:stock]/LARGE_NUM;
        int openPrice = [[record getItem:H5SDK_TAG_OPEN_PX] getInt32:0];
        item.openPrice = [HsQuoteFormatUtils formatPrice:openPrice withStock:stock]/LARGE_NUM;
        int lowPrice = [[record getItem:H5SDK_TAG_LOW_PX] getInt32:0];
        item.lowPrice = [HsQuoteFormatUtils formatPrice:lowPrice withStock:stock]/LARGE_NUM;
        int highPrice = [[record getItem:H5SDK_TAG_HIGH_PX] getInt32:0];
        item.highPrice = [HsQuoteFormatUtils formatPrice:highPrice withStock:stock]/LARGE_NUM;
        
        item.money = [[record getItem:H5SDK_TAG_BUSINESS_BALANCE] getInt64:0];
        item.volume = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT] getInt64:0];
        item.date = [[record getItem:H5SDK_TAG_DATE] getInt32:0];
        item.time = [[record getItem:H5SDK_TAG_MIN_TIME] getInt32:0];
        
        [klineDatas addObject:item];
    }
    HsStockKline *stockKline = [[HsStockKline alloc] init];
    stockKline.klineDatas = klineDatas;
    stockKline.period = [[msg getItem:H5SDK_TAG_CANDLE_PEROID] getInt32:0];
    return stockKline;
}

-(HsRealtime*)realtimeFromRecord:(IRecord *)record withStock:(HsStock *)stock
{
    if (stock == nil) {
        stock = [[HsStock alloc] init];
    }
   // NSLog(@"(开始)得到一个股票的数据 %@ %@",stock.stockName,stock.stockCode);
    
    char *tempStr = (char*)[[record getItem:H5SDK_TAG_PROD_NAME] getString:0];
    if (tempStr != NULL && strlen(tempStr) > 0) {
        stock.stockName = [NSString stringWithUTF8String: tempStr];
    }
    tempStr = (char*)[[record getItem:H5SDK_TAG_PROD_CODE] getString:0];
    if (tempStr != NULL) {
        stock.stockCode = [NSString stringWithUTF8String:tempStr];
    }
    tempStr = (char*)[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0];
    if (tempStr) {
        stock.codeType = [[NSString stringWithUTF8String:tempStr] uppercaseString];
    }
    
    HsRealtime *realtime;
    if ([HsQuoteUtils isIndex:stock]) {//指数
        realtime = [[HsIndexRealtime alloc] init];
    }
    else{//个股
        realtime = [[HsStockRealtime alloc] init];
    }
    
    realtime.name = stock.stockName;
    realtime.code = stock.stockCode;
    realtime.codeType = stock.codeType;
    
    realtime.timestamp = [[record getItem:H5SDK_TAG_DATA_TIMESTAMP] getInt32:0];
    realtime.tradeMinutes = [[record getItem:H5SDK_TAG_TRADE_MINS] getInt32:0];
    char* tradeStatus = (char*)[[record getItem:H5SDK_TAG_TRADE_STATUS] getString:0];
    if (tradeStatus != NULL) {
        realtime.tradeStatus = [H5DataCenter getTradeStatus:[NSString stringWithUTF8String:tradeStatus]];
    }
    
    //    realtime.currency = [[record getItem:H5SDK_TAG_CURRENCY] getString:0];
    //    NSLog(@"%s", [[record getItem:H5SDK_TAG_CURRENCY] getString:0]);
    unsigned int openPrice = [[record getItem:H5SDK_TAG_OPEN_PX] getInt32:0];
    realtime.openPrice = [HsQuoteFormatUtils formatPrice:openPrice withStock:stock]/LARGE_NUM;
    unsigned int highPrice = [[record getItem:H5SDK_TAG_HIGH_PX] getInt32:0];
    realtime.highPrice = [HsQuoteFormatUtils formatPrice:highPrice withStock:stock]/LARGE_NUM;
    unsigned int lowPrice = [[record getItem:H5SDK_TAG_LOW_PX] getInt32:0];
    realtime.lowPrice = [HsQuoteFormatUtils formatPrice:lowPrice withStock:stock]/LARGE_NUM;
    unsigned int newPrice = [[record getItem:H5SDK_TAG_LAST_PX] getInt32:0];
    realtime.newPrice = [HsQuoteFormatUtils formatPrice:newPrice withStock:stock]/LARGE_NUM;
    unsigned int closePrice = [[record getItem:H5SDK_TAG_CLOSE_PX] getInt32:0];
    realtime.closePrice = [HsQuoteFormatUtils formatPrice:closePrice withStock:stock]/LARGE_NUM;
    unsigned int preClosePrice = [[record getItem:H5SDK_TAG_PRECLOSE_PX] getInt32:0];
    realtime.preClosePrice = [HsQuoteFormatUtils formatPrice:preClosePrice withStock:stock]/LARGE_NUM;
    
    realtime.volume = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT] getInt64:0];
    realtime.totalMoney = [[record getItem:H5SDK_TAG_BUSINESS_BALANCE] getInt64:0];
    realtime.current = [[record getItem:H5SDK_TAG_CURRENT_AMOUNT] getInt32:0];
    realtime.totalBuy = [[record getItem:H5SDK_TAG_TOTAL_BUY_AMOUNT] getInt64:0];
    realtime.totalSell = [[record getItem:H5SDK_TAG_TOTAL_SELL_AMOUNT] getInt64:0];
    
    realtime.hand = [[record getItem:HSSDK_TAG_SHARES_PER_HAND] getInt32:0];
    int priceChange = [[record getItem:H5SDK_TAG_PX_CHANGE] getInt32:0];
    double priceUnit = [[HsQuoteUtils shareInstance] getPriceScale:stock];
    realtime.priceChange = priceChange/priceUnit/LARGE_NUM;
    //服务器给的是放大10000倍的数据、客户端做还原处理
    realtime.priceChangePercent = ((int)[[record getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0]) / 10000.0f;
    realtime.turnoverRation = [[record getItem:H5SDK_TAG_TURNOVER_RATIO] getInt32:0] / 10000.0f;
//    float npriceCharge = realtime.priceChangePercent;
//    NSLog(@"%@ %f",stock.stockName,npriceCharge);
    
    unsigned int w52High = [[record getItem:H5SDK_TAG_WEEK52_HIGH_PX] getInt32:0];
    realtime.w52High = [HsQuoteFormatUtils formatPrice:w52High withStock:stock];
    unsigned int w52Low = [[record getItem:H5SDK_TAG_WEEK52_LOW_PX] getInt32:0];
    realtime.w52Low = [HsQuoteFormatUtils formatPrice:w52Low withStock:stock];
    unsigned int popc = [[record getItem:H5SDK_TAG_POPC_PX] getInt32:0];
    realtime.popc = [HsQuoteFormatUtils formatPrice:popc withStock:stock];
    
    
    if ([HsQuoteUtils isIndex:stock]) {
        HsIndexRealtime *indexRealTime = (HsIndexRealtime *)realtime;
        
        indexRealTime.fallCount = [[record getItem:HSSDK_TAG_FALL_COUNT] getInt32:0];
        indexRealTime.riseCount = [[record getItem:HSSDK_TAG_RISE_COUNT] getInt32:0];
        indexRealTime.totalStocks = [[record getItem:HSSDK_TAG_MEMBER_COUNT] getInt32:0];
        
        //领涨领跌股
        IGroup *rise_first = [record getGroup:H5SDK_TAG_RISE_FIRST_GRP];
        int groupsize = [rise_first getRecordCount];
        if (groupsize>0) {
            indexRealTime.riseLeading = [NSMutableArray arrayWithCapacity:groupsize];
            for (int i = 0; i<groupsize; i++) {
                IRecord *riseR = [rise_first getRecord:i];
                HsStockRealtime *item = [[HsStockRealtime alloc] init];
                HsStock *riseStock = [[HsStock alloc] init];
                char *tempStr = (char*)[[riseR getItem:H5SDK_TAG_PROD_NAME] getString:0];
                if (tempStr != NULL && strlen(tempStr) > 0) {
                    riseStock.stockName = [NSString stringWithUTF8String: tempStr];
                }
                tempStr = (char*)[[riseR getItem:H5SDK_TAG_PROD_CODE] getString:0];
                if (tempStr != NULL) {
                    riseStock.stockCode = [NSString stringWithUTF8String:tempStr];
                }
                tempStr = (char*)[[riseR getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0];
                if (tempStr) {
                    riseStock.codeType = [NSString stringWithUTF8String:tempStr];
                }
                
                item.name = riseStock.stockName;
                item.code = riseStock.stockCode;
                item.codeType = riseStock.codeType;
                
                unsigned int newPrice = [[riseR getItem:H5SDK_TAG_LAST_PX] getInt32:0];
                item.newPrice = [HsQuoteFormatUtils formatPrice:newPrice withStock:riseStock];
                
                item.priceChangePercent = ((int)[[riseR getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0]) / 10000.0f;
                [indexRealTime.riseLeading addObject:item];
            }
        }
        
        IGroup *fall_first = [record getGroup:H5SDK_TAG_FALL_FIRST_GRP];
        groupsize = [fall_first getRecordCount];
        if (groupsize>0) {
            indexRealTime.fallLeading = [NSMutableArray arrayWithCapacity:groupsize];
            for (int i = 0; i<groupsize; i++) {
                IRecord *fallR = [fall_first getRecord:i];
                HsStockRealtime *item = [[HsStockRealtime alloc] init];
                HsStock *fallStock = [[HsStock alloc] init];
                char *tempStr = (char*)[[fallR getItem:H5SDK_TAG_PROD_NAME] getString:0];
                if (tempStr != NULL && strlen(tempStr) > 0) {
                    fallStock.stockName = [NSString stringWithUTF8String: tempStr];
                }
                tempStr = (char*)[[fallR getItem:H5SDK_TAG_PROD_CODE] getString:0];
                if (tempStr != NULL) {
                    fallStock.stockCode = [NSString stringWithUTF8String:tempStr];
                }
                tempStr = (char*)[[fallR getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0];
                if (tempStr) {
                    fallStock.codeType = [NSString stringWithUTF8String:tempStr];
                }
                
                item.name = fallStock.stockName;
                item.code = fallStock.stockCode;
                item.codeType = fallStock.codeType;
                
                unsigned int newPrice = [[fallR getItem:H5SDK_TAG_LAST_PX] getInt32:0];
                item.newPrice = [HsQuoteFormatUtils formatPrice:newPrice withStock:fallStock];
                
                item.priceChangePercent = ((int)[[fallR getItem:H5SDK_TAG_PX_CHANGE_RATE] getInt32:0]) / 10000.0f;
                [indexRealTime.fallLeading addObject:item];
            }
        }
        
        
    }
    else{
        HsStockRealtime *stockRealTime = (HsStockRealtime *)realtime;
        
        stockRealTime.outside = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT_OUT] getInt64:0];
        stockRealTime.inside = [[record getItem:H5SDK_TAG_BUSINESS_AMOUNT_IN] getInt64:0];
        unsigned int uppx = [[record getItem:H5SDK_TAG_UP_PRICE] getInt32:0];
        stockRealTime.highLimitPrice = [HsQuoteFormatUtils formatPrice:uppx withStock:stock];
        unsigned int downpx = [[record getItem:H5SDK_TAG_DOWN_PRICE] getInt32:0];
        stockRealTime.lowLimitPrice = [HsQuoteFormatUtils formatPrice:downpx withStock:stock];
        
        HsFinancialItem *financial = [[HsFinancialItem alloc] init];
        financial.totalShares = [NSString stringWithFormat:@"%lld",[[record getItem:H5SDK_TAG_TOTAL_SHARES] getInt64:0]];
        financial.circulationShares = [NSString stringWithFormat:@"%lld",[[record getItem:HSSDK_TAG_CIRCULATION_AMOUNT] getInt64:0]];
        financial.totalValue = [HsQuoteFormatUtils amountToString:[[record getItem:HSSDK_TAG_MARKET_VALUE] getInt64:0] withMutiple:0];
        financial.circulationValue = [HsQuoteFormatUtils amountToString:[[record getItem:HSSDK_TAG_CIRCULATION_VALUE] getInt64:0] withMutiple:0];
        
        //市盈率
        int PE = (int)[[record getItem:H5SDK_TAG_PE_RATE] getInt32:0];
        if (PE>0) {//根据正负进行四舍五入
            PE = (PE+5)/priceUnit*100;
        }
        else{
            PE = (PE-5)/priceUnit*100;
        }
        financial.PE = [HsQuoteFormatUtils formatDouble:PE/100.f withPoint:2];//固定两位小数
        //每股收益
        double EPS = (int)[[record getItem:HSSDK_TAG_EPS] getInt32:0]/priceUnit;
        financial.EPS = [HsQuoteFormatUtils priceToString:EPS withStock:stock];
        
        stockRealTime.financial = financial;
        
        //买卖盘口
        IGroup *bidGroup = [record getGroup:H5SDK_TAG_BID_GRP];
        for (int i = 0; i < [bidGroup getRecordCount]; i++) {
            
            IRecord *bidR = [bidGroup getRecord:i];
            PriceVolumeItem *item = [[PriceVolumeItem alloc] init];
            int price = [[bidR getItem:H5SDK_TAG_ENTRUST_PX] getInt32:0];
            item.price = [HsQuoteFormatUtils formatPrice:price withStock:stock];
            item.volume = (int)[[bidR getItem:H5SDK_TAG_TOTAL_ENTRUST_AMOUNT] getInt64:0];
            [stockRealTime.buyPriceList addObject:item];
        }
        IGroup *offerGroup = [record getGroup:H5SDK_TAG_OFFER_GRP];
        for (int i = 0; i < [offerGroup getRecordCount]; i++) {
            IRecord *offerR = [offerGroup getRecord:i];
            PriceVolumeItem *item = [[PriceVolumeItem alloc] init];
            int price = [[offerR getItem:H5SDK_TAG_ENTRUST_PX] getInt32:0];
            item.price = [HsQuoteFormatUtils formatPrice:price withStock:stock];
            item.volume = (int)[[offerR getItem:H5SDK_TAG_TOTAL_ENTRUST_AMOUNT] getInt64:0];
            [stockRealTime.sellPriceList addObject:item];
        }
        
    }
    //将昨收价保存到股票基本信息中
    if (stock) {
        stock.preClosePrice = realtime.preClosePrice;
    }
    
   // NSLog(@"(结束)得到一个股票的数据 %@ %@",stock.stockName,stock.stockCode);
    
    
    return realtime;
}
//单只股票行情快照
-(id)msgToRealtime:(IHsCommMessage*)msg withStock:(HsStock*)stock
{
    IGroup *group = [[msg getBody] getGroup:H5SDK_TAG_PROD_GRP];
    IRecord *record = [group getRecord:0];
    return [self realtimeFromRecord:record withStock:stock];
}
//一组股票行情快照
-(id)msgToRealtimeList:(IHsCommMessage*)msg withStock:(NSArray*)stocks
{
    //NSLog(@"msgToRealtimeList start");
    NSMutableArray *realtimeList = [NSMutableArray array];
    //服务器返回的顺序可能和客户端请求的不一致，所以需要重新匹配
    NSMutableDictionary *stockMap = [NSMutableDictionary dictionary];
    for (HsStock *item in stocks) {
        NSString *key = [[NSString stringWithFormat:@"%@-%@", item.stockCode, item.marketType] uppercaseString];
        [stockMap setObject:item forKey:key];
    }
    IGroup *group = [[msg getBody] getGroup:H5SDK_TAG_PROD_GRP];
    if (!group) {//取不到说明是排序返回的，通过排序列表取
        group = [[msg getBody] getGroup:H5SDK_TAG_SORT_PROD_GRP];
    }
    int count = [group getRecordCount];
    for (int i = 0; i < count; i++) {
        IRecord *record = [group getRecord:i];
        NSString *stockCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        NSString *codeType = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]];
        NSString *marketType = [[codeType componentsSeparatedByString:@"."] firstObject];
        if (stockCode && codeType) {
            NSString *key = [[NSString stringWithFormat:@"%@-%@", stockCode, marketType] uppercaseString];
            HsStock *stock = [stockMap objectForKey:key];
            HsRealtime *realtime = [self realtimeFromRecord:record withStock:stock];
            if (realtime) {
                [realtimeList addObject:realtime];
            }
        }
    }
    // NSLog(@"msgToRealtimeList end");
    return realtimeList;
}


-(id)msgToStocks:(IHsCommMessage*)msg
{
    NSMutableArray *stockArray = [NSMutableArray array];
    IGroup *sequence = [msg getGroup:H5SDK_TAG_PROD_GRP];
    int size = [sequence getRecordCount];
    for (int i = 0; i < size; i++) {
        IRecord *record = [sequence getRecord:i];
        HsStock *stock = [[HsStock alloc] init];
        stock.stockName = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_NAME] getString:0]];
        stock.stockCode = [NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_PROD_CODE] getString:0]];
        stock.codeType = [[NSString stringWithUTF8String:[[record getItem:H5SDK_TAG_HQ_TYPE_CODE] getString:0]] uppercaseString];
        
        NSLog(@"%@ %@ %@",stock.stockName ,stock.stockCode,stock.codeType);
        
        // 过滤掉创业版或ST
//        NSRange range = [stock.codeType rangeOfString:@"GEM"];//判断字符串是否包含
        NSRange range1 = [stock.stockName rangeOfString:@"ST"];//判断字符串是否包含
//        if (range.location == NSNotFound && range1.location == NSNotFound )//不包含
//            [stockArray addObject:stock];
        if (range1.location == NSNotFound )//不包含
            [stockArray addObject:stock];

    }
    
     //NSLog(@"%@",stockArray);
    
    return stockArray;
}


+(int)getTradeStatus:(NSString*)tradeStatus
{
    //TRADE:交易状态:
    //PRETR: 盘前
    //OCALL: 开市集合竞价
    //TRADE: 交易（连续撮合)
    //HALT: 暂停交易
    //BREAK: 休市
    //POSTR: 盘后
    //ENDTR: 结束交易(闭市)
    //START: 未开盘（初始化）
    if ([tradeStatus isEqualToString:@"PRETR"]) {
        return TRADE_STATUS_PRETR;
    }
    else if ([tradeStatus isEqualToString:@"START"]){
        return TRADE_STATUS_START;
    }
    else if ([tradeStatus isEqualToString:@"OCALL"]){
        return TRADE_STATUS_OCALL;
    }
    else if ([tradeStatus isEqualToString:@"TRADE"]){
        return TRADE_STATUS_TRADE;
    }
    else if ([tradeStatus isEqualToString:@"HALT"]){
        return TRADE_STATUS_HALT;
    }
    else if ([tradeStatus isEqualToString:@"BREAK"]){
        return TRADE_STATUS_BREAK;
    }
    else if ([tradeStatus isEqualToString:@"POSTR"]){
        return TRADE_STATUS_POSTR;
    }
    else if ([tradeStatus isEqualToString:@"ENDTR"]){
        return TRADE_STATUS_ENDTR;
    }
    else{
        return -1;
    }
}


@end
