//
//  H5DataCenter.h
//  QuoteWidget&H5SDKDemo
//
//  Created by lihao on 15-3-3.
//  Copyright (c) 2015年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IH5Session.h"
#import "HsStock.h"

typedef void (^HandleBlock) (id);

@interface H5DataCenter : NSObject

@property(nonatomic, weak)IH5Session *h5Session;

/**
 * 查询股票基本信息
 * @param stock 需要查询的股票代码
 * @param type  0-> 沪深, 1－> 美股
 * @param block 回调函数, 回传一个HsStock的数组
 */
-(void)queryStocks:(NSString*)stock type:(int)type withHandleBlock:(HandleBlock)block;

/**
 * 股票分时数据获取
 * @param stock 需要查询的股票
 * @param block 回调函数，回传一个HsStockTrendData对象
 */
-(void)loadTrends:(HsStock*)stock withHandleBlock:(HandleBlock)block;

/**
 * 股票K线数据获取
 * @param stock 需要查询的股票
 * @param dt 日期
 * @param count 条数
 * @param peroid K线周期
 * @param block 回调函数，回传一个HsStockKline对象
 */
-(void)loadKline:(HsStock*)stock
          AtDate:(int64_t)dt
           Count:(int)count
          Peroid:(int)peroid
 withHandleBlock:(HandleBlock)block;

/**
 * 股票快照信息查询
 * @param stock 需要查询的股票信息
 * @param block 回调函数，回传一个HsRealtime对象
 */
-(void)loadRealtime:(HsStock*)stock withHandleBlock:(HandleBlock)block;

/**
 * 市场信息获取
 */
-(void)loadMarketData:(NSArray *)market withHandleBlock:(HandleBlock)block;


/**
 * 一组股票快照信息查询
 * @param stocks 需要查询的股票信息的数组（元素类型为HsStock）
 * @param block 回调函数，回传一个HsRealtime对象
 */
-(void)loadRealtimeList:(NSMutableArray*)stocks withHandleBlock:(HandleBlock)block;


/**
 * 成交明细获取(只支持沪深)
 */
-(void)loadStockTick:(HsStock *)stock
               Begin:(int)begin
            andCount:(int)count
     withHandleBlock:(HandleBlock)block;

/**
 * 请求排名数据
 * @param marketType 市场类型（数组）
 * @param begin      开始标记
 * @param count      最大请求条数
 * @param colId      排序基准列
 * @param ascending  升降序
 * @param handler
 */
-(void)loadRankingStocksData:(NSArray*)marketType
                        From:(int)begin
                       Count:(int)count
                andSortColId:(int)colId
                   orderType:(int)orderType
             withHandleBlock:(HandleBlock)block;


/**
 * 请求排名数据(指定股票列表)
 * @param stocks     指定股票列表
 * @param marketType 市场类型（数组）
 * @param begin      开始标记
 * @param count      最大请求条数
 * @param colId      排序基准列
 * @param ascending  升降序
 * @param handler
 */
-(void)loadRankingStocksData:(NSArray*)stocks
                       types:(NSArray*)marketType
                        From:(int)begin
                       Count:(int)count
                andSortColId:(int)colId
                   orderType:(int)orderType
             withHandleBlock:(HandleBlock)block;

//得到某个股票的板块信息
-(void)loadBlocks4StockCode:(HsStock*)stock
            withHandleBlock:(HandleBlock)block;
//
/**
 * 请求得到板块数据
 * @param blocks     指定板块XBHS.HY
 * @param begin      开始标记
 * @param count      最大请求条数
 * @param handler
 */
-(void)loadBlocks:(NSString *)blocks
             From:(int)begin
            Count:(int)count
  withHandleBlock:(HandleBlock)block;

//
/**
 * 请求得到某个板块下的股票数据
 * @param stock      指定板块里的具体某个板块
 * @param begin      开始标记
 * @param count      最大请求条数
 * @param orderType  升降序-即涨跌幅
 * @param handler
 */
-(void)loadBlocksStocks4Sort:(HsStock*)stock
                        From:(int)begin
                       Count:(int)count
                   orderType:(int)orderType
            withHandleBlock:(HandleBlock)block;
//市场代码表
-(void)loadMarketReference:(NSString*)hqTypeCode
           withHandleBlock:(HandleBlock)block;

@end
