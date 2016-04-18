//
//  Realtime.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

//货币类型
typedef enum Currency{
    RMB,
    USD,
    HKD
}Currency;

//交易状态定义
/*!
 *  @brief  新产品
 */
extern const short TRADE_STATUS_ADD;       //新产品
/*!
 *  @brief  交易间，禁止任何交易活动
 */
extern const short TRADE_STATUS_BETW;      //交易间，禁止任何交易活动
/*!
 *  @brief  休市，如：午休，无撮合和市场内部信息披露
 */
extern const short TRADE_STATUS_BREAK;     //休市，如：午休，无撮合和市场内部信息披露
/*!
 *  @brief  闭市，自动计算闭市价格
 */
extern const short TRADE_STATUS_CLOSE;     //闭市，自动计算闭市价格
/*!
 *  @brief  产品待删除
 */
extern const short TRADE_STATUS_DEL;       //产品待删除
/*!
 *  @brief  交易结束
 */
extern const short TRADE_STATUS_ENDTR;     //交易结束
/*!
 *  @brief  固定价格集合竞价
 */
extern const short TRADE_STATUS_FCALL;     //固定价格集合竞价
/*!
 *  @brief  暂停，除了自有订单和交易查询之外，任何交易活动都被禁止
 */
extern const short TRADE_STATUS_HALT;      //暂停，除了自有订单和交易查询之外，任何交易活动都被禁止
/*!
 *  @brief  停盘，与HALT的区别在与SUSP时可以撤单
 */
extern const short TRADE_STATUS_SUSP;      //停盘，与HALT的区别在与SUSP时可以撤单
/*!
 *  @brief  盘中集合竞价
 */
extern const short TRADE_STATUS_ICALL;     //盘中集合竞价
/*!
 *  @brief  盘中集合竞价订单薄平衡
 */
extern const short TRADE_STATUS_IOBB;      //盘中集合竞价订单薄平衡
/*!
 *  @brief  盘中集合竞价
 */
extern const short TRADE_STATUS_IPOBB;     //盘中集合竞价
/*!
 *  @brief  开市集合竞价
 */
extern const short TRADE_STATUS_OCALL;     //开市集合竞价
/*!
 *  @brief  开市集合竞价OBB
 */
extern const short TRADE_STATUS_OOBB;      //开市集合竞价OBB
/*!
 *  @brief  开市集合竞价订单薄平衡前期阶段
 */
extern const short TRADE_STATUS_OPOBB;     //开市集合竞价订单薄平衡前期阶段
/*!
 *  @brief  非交易支持非交易服务
 */
extern const short TRADE_STATUS_NOTRD;     //非交易支持非交易服务
/*!
 *  @brief  盘后处理
 */
extern const short TRADE_STATUS_POSTR;     //盘后处理
/*!
 *  @brief  盘前处理
 */
extern const short TRADE_STATUS_PRETR;     //盘前处理
/*!
 *  @brief  启动
 */
extern const short TRADE_STATUS_START;     //启动
/*!
 *  @brief  连续自动撮合
 */
extern const short TRADE_STATUS_TRADE;     //连续自动撮合
/*!
 *  @brief  连续交易和集合竞价交易的波动性中断VOLA
 */
extern const short TRADE_STATUS_VOLA;      //连续交易和集合竞价交易的波动性中断VOLA
/*!
 *  @brief  长期停盘，停盘n天，n>=1
 */
extern const short TRADE_STATUS_STOP;      //长期停盘，停盘n天，n>=1



/*!
 *  @brief  个股快照数据模型
 */
@interface HsRealtime : NSObject
/*!
 *  @brief  个股代码
 */
@property(nonatomic, retain)NSString *code;
/*!
 *  @brief  个股市场分类代码
 */
@property(nonatomic, retain)NSString *codeType;
/*!
 *  @brief  个股名称
 */
@property(nonatomic, retain)NSString *name;
/*!
 *  @brief  快照时间戳HMMSSsss格式
 */
@property(nonatomic, assign)int64_t timestamp;
/*!
 *  @brief  交易分钟数
 */
@property(nonatomic, assign)int tradeMinutes;//交易分钟数
@property(nonatomic, assign)Currency currency;//货币 (类型与服务器不一致、待确认)
/*!
 *  @brief  交易状态
 */
@property(nonatomic, assign)int tradeStatus;//交易状态
/*!
 *  @brief  开盘价
 */
@property(nonatomic, assign)double openPrice;
/*!
 *  @brief  最高价
 */
@property(nonatomic, assign)double highPrice;
/*!
 *  @brief  最低价
 */
@property(nonatomic, assign)double lowPrice;
/*!
 *  @brief  最新价
 */
@property(nonatomic, assign)double newPrice;
/*!
 *  @brief  收盘价
 */
@property(nonatomic, assign)double closePrice;
/*!
 *  @brief  昨收价
 */
@property(nonatomic, assign)double preClosePrice;

/*!
 *  @brief  总成交量
 */
@property(nonatomic, assign)int64_t volume;//总成交量
/*!
 *  @brief  总成交额
 */
@property(nonatomic, assign)int64_t totalMoney;//总成交额
/*!
 *  @brief  现手
 */
@property(nonatomic, assign)int64_t current;//现手
/*!
 *  @brief  换手率
 */
@property(nonatomic, assign)double  turnoverRation;//换手率

/*!
 *  @brief  总买
 */
@property(nonatomic, assign)int64_t totalBuy;//总买
/*!
 *  @brief  总卖
 */
@property(nonatomic, assign)int64_t totalSell;//总卖

/*!
 *  @brief  每手股数
 */
@property(nonatomic, assign)int hand;//每手股数
/*!
 *  @brief  涨跌额
 */
@property(nonatomic, assign)float priceChange;//涨跌
/*!
 *  @brief  涨跌幅
 */
@property(nonatomic, assign)float priceChangePercent;//涨跌幅
/*!
 *  @brief  涨速
 */
@property(nonatomic, assign)int riseSpeed;//涨速

/*!
 *  @brief  52周最高价
 */
@property(nonatomic, assign)double w52High;//52周最高价
/*!
 *  @brief  52周最低价
 */
@property(nonatomic, assign)double w52Low;//52周最低价
/*!
 *  @brief  盘前盘后价
 */
@property(nonatomic, assign)double popc;//盘前盘后价

@end
