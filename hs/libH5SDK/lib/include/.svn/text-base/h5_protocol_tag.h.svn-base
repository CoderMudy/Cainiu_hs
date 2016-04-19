/**
 *源程序名称:sdk_tag.h
 *软件著作权:恒生电子股份有限公司
 *系统名称:H5行情协议
 *模块名称:H5行情协议
 *功能说明:定义H5行情协议中的字段TAG
 *作    者: 彭小豪
 *开发日期: 2014/11/28 10:58:58
 *版 本 号: 1.0.0.1
 *备    注: 根据文档《H5行情服务协议(修订版).xls》生成
 */

#ifndef __H5_SDK_TAG_H__
#define __H5_SDK_TAG_H__

#include "hscomm_message_interface.h"

#define MESSAGE_TEMPLATE_VERSION	"1.0.0.1"
/*****************功能消息域定义*******************/
extern const int H5PROTO_HEAD_INFO ; //
extern const int H5SDK_MSG_LOGIN ; // 登入请求
extern const int H5SDK_MSG_LOGOUT ; // 登出信息
extern const int H5SDK_MSG_HEARTBEAT ; // 心跳
extern const int H5SDK_SERVER_INFO ; // 请求服务器信息
extern const int H5SDK_MSG_BATCH ; // 批处理
extern const int H5SDK_MSG_FILE ; // 请求静态文件
extern const int H5SDK_MSG_MARKET_TYPES ; // 市场分类信息
extern const int H5SDK_MSG_MARKET_REFERENCE ; // 市场代码表
extern const int H5SDK_MSG_SNAPSHOT ; // 行情快照
extern const int H5SDK_KEYBOARD_WIZARD ; // 键盘精灵消息
extern const int H5SDK_MSG_SUBSCRIBE ; // 行情快照订阅
extern const int H5SDK_MSG_SORT ; // 排序请求
extern const int H5SDK_MSG_TREND ; // 按指定的日期或偏移取分时数据
extern const int H5SDK_MSG_CANDLE_BY_OFFSET ; // 按偏移取K线
extern const int H5SDK_MSG_CANDLE_BY_RANGE ; // 按日期时间范围取K线
extern const int H5SDK_MSG_TICK_MIN ; // 指定分钟的分笔
extern const int H5SDK_MSG_TICK_DIRECTION ; // 按偏移取分笔


/*****************系统域定义*******************/

/// 数据类型：uint32(枚举); 域名：业务prod_code,用以找合适的模板
extern const int H5PROTO_TAG_BUSINESS_ID ;
extern const uint32 BIZ_SYSTEM ; // 系统模板
extern const uint32 BIZ_H5HQ ; // 行情模板
extern const uint32 BIZ_UFX ; // UFX模板
extern const uint32 BIZ_H5PROTO ; // H5行情服务协议

/// 数据类型：uint32(枚举); 域名：报文类型
extern const int H5PROTO_TAG_PACKET_TYPE ;
extern const uint32 REQUEST ; // 请求
extern const uint32 ANSWER ; // 应答
extern const uint32 PUSH ; // 主推报文

/// 数据类型：uint32; 域名：功能号
extern const int H5PROTO_TAG_FUNCTION_ID ;

/// 数据类型：rawdata; 域名：客户端KEY
extern const int H5PROTO_TAG_USER_KEY ;

/// 数据类型：rawdata; 域名：会话号
extern const int H5PROTO_TAG_SESSION_ID ;

/// 数据类型：uint32; 域名：错误号
extern const int H5PROTO_TAG_ERROR_NO ;

/// 数据类型：bytevector; 域名：错误信息
extern const int H5PROTO_TAG_ERROR_INFO ;

/// 数据类型：array; 数组项缺省类型：uint32; 域名：发送者的标识信息,表示信息从哪个适配器的哪个通道的哪个连接获得,一般通信适配器在接收到消息后,负责IDX_CONNECTID和IDX_CHANNEL_INDEX这两个成员的
extern const int H5PROTO_TAG_SEND_INFO_ARRAY ;

/// 数据类型：array; 数组项缺省类型：uint32; 域名：处理时间，计算异步返回时间
extern const int H5PROTO_TAG_TIME_STAMP_ARRAY ;

/// 数据类型：uint32; 域名：批处理号
extern const int H5PROTO_TAG_BATCH_NO ;

/// 数据类型：uint32; 域名：同步调用编号
extern const int H5PROTO_TAG_SYNC_NO ;

/// 数据类型：rawdata; 域名：流水信息
extern const int H5PROTO_TAG_SERIAL_INFO ;


/*****************消息域定义*******************/

/// 数据类型：string; 域名：用户名
extern const int H5SDK_TAG_USER_NAME ;

/// 数据类型：string; 域名：密码
extern const int H5SDK_TAG_PASSWORD ;

/// 数据类型：string; 域名：动态密码
extern const int H5SDK_TAG_DYNMIC_PASSWORD ;

/// 数据类型：bytevector; 域名：原始数据
extern const int H5SDK_TAG_ORGINAL_DATA ;

/// 数据类型：uint32; 域名：心跳间隔
extern const int H5SDK_TAG_HEARTBEAT_INTERVAL ;

/// 数据类型：uint32; 域名：SDK版本
extern const int H5SDK_TAG_SDK_VERSION ;

/// 数据类型：bytevector; 域名：操作系统版本
extern const int H5SDK_TAG_OS_VERSION ;

/// 数据类型：bytevector; 域名：服务器名称
extern const int H5SDK_TAG_SERVER_NAME ;

/// 数据类型：uint64; 域名：服务器时间。Unix时间戳
extern const int H5SDK_TAG_SERVER_TIME ;

/// 数据类型：uint32; 域名：当前在线
extern const int H5SDK_TAG_CURR_ONLINE_COUNT ;

/// 数据类型：uint32; 域名：最大在线
extern const int H5SDK_TAG_MAX_ONLINE_COUNT ;

/// 数据类型：uint32(枚举); 域名：文件类型
extern const int H5SDK_TAG_HQ_FILE_TYPE ;
extern const uint32 H5SDK_ENUM_FT_COMMON_FILE ; // 普通文件。需要使用文件名、相对路径信息进行访问
extern const uint32 H5SDK_ENUM_FT_FINDATA_FILE ; // 财务数据文件
extern const uint32 H5SDK_ENUM_FT_EXRIGHT_FILE ; // 除权数据文件
extern const uint32 H5SDK_ENUM_FT_INFO_CONFIG_FILE ; // 资讯配置文件
extern const uint32 H5SDK_ENUM_FT_WELCOME_FILE ; // 欢迎文件
extern const uint32 H5SDK_ENUM_FT_DYNAMIC_NEWS_FILE ; // 流动条信息文件
extern const uint32 H5SDK_ENUM_FT_SYS_BLOCK_FILE ; // 系统板块文件
extern const uint32 H5SDK_ENUM_FT_USR_BLOCK_FILE ; // 自定义板块文件
extern const uint32 H5SDK_ENUM_FT_BLOCK_CODE_FILE ; // 板块组织关系文件
extern const uint32 H5SDK_ENUM_FT_MARKET_MONITOR_CONFIG_FILE ; // 短线精灵配置文件
extern const uint32 H5SDK_ENUM_FT_CALL_AUCTION_TIME_FILE ; // 集合竞价时段配置文件

/// 数据类型：bytevector; 域名：文件名称
extern const int H5SDK_TAG_HQ_FILE_NAME ;

/// 数据类型：uint64; 域名：文件偏移
extern const int H5SDK_TAG_FILE_OFFSET ;

/// 数据类型：uint32; 域名：文件长度
extern const int H5SDK_TAG_FILE_LENGTH ;

/// 数据类型：uint32; 域名：成交时间
extern const int H5SDK_TAG_BUSINESS_TIME ;

/// 数据类型：uint32; 域名：数据CRC
extern const int H5SDK_TAG_CRC ;

/// 数据类型：uint32; 域名：错误号
extern const int H5SDK_TAG_ERROR_NO ;

/// 数据类型：bytevector; 域名：错误描述字符串
extern const int H5SDK_TAG_ERROR_INFO ;

/// 数据类型：bytevector; 域名：交易所代码
extern const int H5SDK_TAG_FINANCE_MIC ;

/// 数据类型：bytevector; 域名：交易所名称
extern const int H5SDK_TAG_FINANCE_NAME ;

/// 数据类型：uint32; 域名：市场日期
extern const int H5SDK_TAG_MARKET_DATE ;

/// 数据类型：uint32; 域名：交易日期
extern const int H5SDK_TAG_INIT_DATE ;

/// 数据类型：int32; 域名：时区
extern const int H5SDK_TAG_TIMEZONE ;

/// 数据类型：uint8; 域名：夏令时标志
extern const int H5SDK_TAG_DST_FLAG ;

/// 数据类型：sequence; 域名：类型重复组
extern const int H5SDK_TAG_TYPE_GRP ;

/// 数据类型：sequence; 域名：排序类型重复组
extern const int H5SDK_TAG_SORT_TYPE_GRP ;

/// 数据类型：bytevector; 域名：类型代码
extern const int H5SDK_TAG_HQ_TYPE_CODE ;

/// 数据类型：bytevector; 域名：类型名称
extern const int H5SDK_TAG_HQ_TYPE_NAME ;

/// 数据类型：uint32; 域名：价格放大倍数
extern const int H5SDK_TAG_PRICE_SCALE ;

/// 数据类型：sequence; 域名：交易时间段
extern const int H5SDK_TAG_TRADE_SECTION_GRP ;

/// 数据类型：uint32; 域名：开市时间
extern const int H5SDK_TAG_OPEN_TIME ;

/// 数据类型：uint32; 域名：闭市时间
extern const int H5SDK_TAG_CLOSE_TIME ;

/// 数据类型：uint32; 域名：昨收价
extern const int H5SDK_TAG_PRECLOSE_PX ;

/// 数据类型：uint32; 域名：涨停价格
extern const int H5SDK_TAG_UP_PRICE ;

/// 数据类型：uint32; 域名：跌停价格
extern const int H5SDK_TAG_DOWN_PRICE ;

/// 数据类型：uint8(枚举); 域名：行情等级
extern const int H5SDK_TAG_HQ_LEVEL ;
extern const uint8 H5SDK_ENUM_LEVEL_1 ; // 基础行情
extern const uint8 H5SDK_ENUM_LEVEL_2 ; // 2级行情

/// 数据类型：sequence; 域名：股票集重复组
extern const int H5SDK_TAG_PROD_GRP ;

/// 数据类型：sequence; 域名：排序股票集重复组
extern const int H5SDK_TAG_SORT_PROD_GRP ;

/// 数据类型：bytevector; 域名：股票代码
extern const int H5SDK_TAG_PROD_CODE ;

/// 数据类型：string; 域名：行业代码
extern const int H5SDK_TAG_INDUSTRY_CODE ;

/// 数据类型：string; 域名：货币
extern const int H5SDK_TAG_MONEY_TYPE ;

/// 数据类型：uint32; 域名：时间戳
extern const int H5SDK_TAG_DATA_TIMESTAMP ;

/// 数据类型：string; 域名：交易状态
extern const int H5SDK_TAG_TRADE_STATUS ;

/// 数据类型：uint32; 域名：开盘价
extern const int H5SDK_TAG_OPEN_PX ;

/// 数据类型：uint32; 域名：最新价
extern const int H5SDK_TAG_LAST_PX ;

/// 数据类型：uint32; 域名：最高价
extern const int H5SDK_TAG_HIGH_PX ;

/// 数据类型：uint32; 域名：最低价
extern const int H5SDK_TAG_LOW_PX ;

/// 数据类型：uint32; 域名：收盘价
extern const int H5SDK_TAG_CLOSE_PX ;

/// 数据类型：uint32; 域名：平均价
extern const int H5SDK_TAG_AVG_PX ;

/// 数据类型：uint32; 域名：加权平均价
extern const int H5SDK_TAG_WAVG_PX ;

/// 数据类型：uint32; 域名：成交笔数
extern const int H5SDK_TAG_BUSINESS_COUNT ;

/// 数据类型：uint64; 域名：成交量
extern const int H5SDK_TAG_BUSINESS_AMOUNT ;

/// 数据类型：uint64; 域名：成交额
extern const int H5SDK_TAG_BUSINESS_BALANCE ;

/// 数据类型：uint64; 域名：现手
extern const int H5SDK_TAG_CURRENT_AMOUNT ;

/// 数据类型：uint64; 域名：内盘成交量
extern const int H5SDK_TAG_BUSINESS_AMOUNT_IN ;

/// 数据类型：uint64; 域名：外盘成交量
extern const int H5SDK_TAG_BUSINESS_AMOUNT_OUT ;

/// 数据类型：uint64; 域名：总委买量
extern const int H5SDK_TAG_TOTAL_BUY_AMOUNT ;

/// 数据类型：uint64; 域名：总委卖量
extern const int H5SDK_TAG_TOTAL_SELL_AMOUNT ;

/// 数据类型：uint32; 域名：加权平均委买价
extern const int H5SDK_TAG_WAVG_BID_PX ;

/// 数据类型：uint32; 域名：加权平均委卖价
extern const int H5SDK_TAG_WAVG_OFFER_PX ;

/// 数据类型：sequence; 域名：委买档位
extern const int H5SDK_TAG_BID_GRP ;

/// 数据类型：sequence; 域名：委卖档位
extern const int H5SDK_TAG_OFFER_GRP ;

/// 数据类型：uint32; 域名：价格
extern const int H5SDK_TAG_HQ_PRICE ;

/// 数据类型：uint64; 域名：委托量
extern const int H5SDK_TAG_TOTAL_ENTRUST_AMOUNT ;

/// 数据类型：sequence; 域名：委托单重复组
extern const int H5SDK_TAG_ENTRUST_GRP ;

/// 数据类型：uint32; 域名：委托价格
extern const int H5SDK_TAG_ENTRUST_PX ;

/// 数据类型：uint32; 域名：委托单量
extern const int H5SDK_TAG_ENTRUST_AMOUNT ;

/// 数据类型：uint32; 域名：52周最低价
extern const int H5SDK_TAG_WEEK52_LOW_PX ;

/// 数据类型：uint32; 域名：52周最高价
extern const int H5SDK_TAG_WEEK52_HIGH_PX ;

/// 数据类型：int32; 域名：价格涨跌
extern const int H5SDK_TAG_PX_CHANGE ;

/// 数据类型：int32; 域名：涨跌幅
extern const int H5SDK_TAG_PX_CHANGE_RATE ;

/// 数据类型：uint32; 域名：盘前/盘后价格
extern const int H5SDK_TAG_POPC_PX ;

/// 数据类型：uint64; 域名：当前阶段的成交量
extern const int H5SDK_TAG_SESSION_VOLUMUE ;

/// 数据类型：uint32; 域名：日期: YYYYMMDD，0：表示当前日期
extern const int H5SDK_TAG_DATE ;

/// 数据类型：int32; 域名：日期偏移天数
extern const int H5SDK_TAG_DATE_OFFSET ;

/// 数据类型：sequence; 域名：分时数据重复组
extern const int H5SDK_TAG_TREND_GRP ;

/// 数据类型：uint32(枚举); 域名：K线周期
extern const int H5SDK_TAG_CANDLE_PEROID ;
extern const uint32 H5SDK_ENUM_PEROID_1MIN ; // 一分钟
extern const uint32 H5SDK_ENUM_PEROID_5MIN ; // 5分钟
extern const uint32 H5SDK_ENUM_PEROID_15MIN ; // 15分钟
extern const uint32 H5SDK_ENUM_PEROID_30MIN ; // 30分钟
extern const uint32 H5SDK_ENUM_PEROID_60MIN ; // 60分钟
extern const uint32 H5SDK_ENUM_PEROID_DAY ; // 日线
extern const uint32 H5SDK_ENUM_PEROID_WEEK ; // 周线
extern const uint32 H5SDK_ENUM_PEROID_MONTH ; // 月线
extern const uint32 H5SDK_ENUM_PEROID_YEAR ; // 年线

/// 数据类型：uint8(枚举); 域名：K线搜索方向
extern const int H5SDK_TAG_DIRECTION ;
extern const uint8 H5SDK_ENUM_FORWARD ; // 向前
extern const uint8 H5SDK_ENUM_BACKWARD ; // 向后

/// 数据类型：uint32; 域名：数据个数
extern const int H5SDK_TAG_DATA_COUNT ;

/// 数据类型：uint32; 域名：起始日期,YYYYMMDD
extern const int H5SDK_TAG_START_DATE ;

/// 数据类型：uint32; 域名：结束日期,YYYYMMDD
extern const int H5SDK_TAG_END_DATE ;

/// 数据类型：sequence; 域名：K线重复组
extern const int H5SDK_TAG_CANDLE_GRP ;

/// 数据类型：bytevector; 域名：访问TOKEN
extern const int H5SDK_TAG_HQ_TOKEN ;

/// 数据类型：sequence; 域名：交易所重复组
extern const int H5SDK_TAG_FINANCE_GRP ;

/// 数据类型：bytevector; 域名：退出原因
extern const int H5SDK_TAG_QUIT_REASON ;

/// 数据类型：sequence; 域名：批
extern const int H5SDK_TAG_BATCH_GRP ;

/// 数据类型：rawdata; 域名：子包
extern const int H5SDK_TAG_SUB_PACKET ;

/// 数据类型：sequence; 域名：字段集重复组
extern const int H5SDK_TAG_FIELD_GRP ;

/// 数据类型：bytevector; 域名：字段名称
extern const int H5SDK_TAG_FIELD_NAME ;

/// 数据类型：bytevector; 域名：证券名称
extern const int H5SDK_TAG_PROD_NAME ;

/// 数据类型：uint32; 域名：委托单数
extern const int H5SDK_TAG_ENTRUST_COUNT ;

/// 数据类型：uint32; 域名：交易分钟数
extern const int H5SDK_TAG_TRADE_MINS ;

/// 数据类型：int32; 域名：交易阶段
extern const int H5SDK_TAG_TRADE_SECTION ;

/// 数据类型：uint8(枚举); 域名：K线模式
extern const int H5SDK_TAG_CANDLE_MODE ;
extern const uint8 H5SDK_ENUM_CANDLE_ORIGINAL ; // 原始K线
extern const uint8 H5SDK_ENUM_CANDLE_FORWARD ; // 前复权K线
extern const uint8 H5SDK_ENUM_CANDLE_BACKWARD ; // 后复权K线

/// 数据类型：uint32; 域名：最大值
extern const int H5SDK_TAG_MAX_VALUE ;

/// 数据类型：uint64; 域名：总股本
extern const int H5SDK_TAG_TOTAL_SHARES ;

/// 数据类型：int32; 域名：市盈率
extern const int H5SDK_TAG_PE_RATE ;

/// 数据类型：sequence; 域名：市场重复组
extern const int H5SDK_FINANCE_MIC_GRP ;

/// 数据类型：uint32(枚举); 域名：订阅还是退订, 如果是退订,允许SubscriberKey为空,表示该连接的所有已订阅信息都取消
extern const int H5SDK_TAG_SUB_TYPE ;
extern const uint32 HSUB_ENUM_SUB_OVER ; // 覆盖订阅(当前客户端的订阅模式)
extern const uint32 HSUB_ENUM_SUB ; // 追加订阅
extern const uint32 HSUB_ENUM_UNSUB ; // 退订

/// 数据类型：uint32; 域名：起始位置
extern const int H5SDK_TAG_START_POS ;

/// 数据类型：bytevector; 域名：字段名称
extern const int H5SDK_TAG_SORT_FIELD_NAME ;

/// 数据类型：int32; 域名：量比
extern const int H5SDK_TAG_VOL_RATIO ;

/// 数据类型：int32; 域名：振幅
extern const int H5SDK_TAG_AMPLITUDE ;

/// 数据类型：int64; 域名：持仓量
extern const int H5SDK_TAG_AMOUNT ;

/// 数据类型：int32; 域名：换手率
extern const int H5SDK_TAG_TURNOVER_RATIO ;

/// 数据类型：int32; 域名：委比
extern const int H5SDK_TAG_ENTRUST_RATE ;

/// 数据类型：int64; 域名：委差
extern const int H5SDK_TAG_ENTRUST_DIFF ;

/// 数据类型：int8(枚举); 域名：排序方式
extern const int H5SDK_TAG_SORT_TYPE ;
extern const int8 HSUB_ENUM_SORT_ASC ; // 升序
extern const int8 HSUB_ENUM_SORT_DESC ; // 降序

/// 数据类型：bytevector; 域名：MIC_ABBR
extern const int H5SDK_TAG_MIC_ABBR ;

/// 数据类型：uint32; 域名：起始分钟数
extern const int H5SDK_TAG_START_MIN ;

/// 数据类型：uint32; 域名：介绍分钟数
extern const int H5SDK_TAG_END_MIN ;

/// 数据类型：sequence; 域名：分笔数据重复组
extern const int H5SDK_TAG_TICK_GRP ;

/// 数据类型：uint32; 域名：分笔序号
extern const int H5SDK_TAG_BUSINESS_NO ;

/// 数据类型：int32; 域名：成交方向
extern const int HSSDK_TAG_BUSINESS_DIRECTION ;

/// 数据类型：int32; 域名：每手股数
extern const int HSSDK_TAG_SHARES_PER_HAND ;

/// 数据类型：int32; 域名：价格精度
extern const int HSSDK_TAG_PX_PRECISION ;

/// 数据类型：int64; 域名：流通股本
extern const int HSSDK_TAG_CIRCULATION_AMOUNT ;

/// 数据类型：int64; 域名：市值
extern const int HSSDK_TAG_MARKET_VALUE ;

/// 数据类型：int64; 域名：流通市值
extern const int HSSDK_TAG_CIRCULATION_VALUE ;

/// 数据类型：int32; 域名：每股股收益
extern const int HSSDK_TAG_EPS ;

/// 数据类型：int32; 域名：每股净资产
extern const int HSSDK_TAG_BPS ;

/// 数据类型：int32; 域名：市净率
extern const int HSSDK_TAG_DYN_PB_RATE ;

/// 数据类型：int32; 域名：财务季度
extern const int HSSDK_TAG_FIN_QUARTER ;

/// 数据类型：int32; 域名：财务截至日期
extern const int HSSDK_TAG_FIN_END_DATE ;

/// 数据类型：int8; 域名：数据是否获取完全
extern const int HSSDK_TAG_ALL_DATA_FLAG ;

/// 数据类型：int32; 域名：上涨家数
extern const int HSSDK_TAG_RISE_COUNT ;

/// 数据类型：int32; 域名：下跌家数
extern const int HSSDK_TAG_FALL_COUNT ;

/// 数据类型：int32; 域名：成员个数
extern const int HSSDK_TAG_MEMBER_COUNT ;

/// 数据类型：sequence; 域名：领涨股
extern const int H5SDK_TAG_RISE_FIRST_GRP ;

/// 数据类型：sequence; 域名：领跌股
extern const int H5SDK_TAG_FALL_FIRST_GRP ;

/// 数据类型：string; 域名：时区码
extern const int H5SDK_TAG_TIMEZONE_CODE ;

/// 数据类型：uint32; 域名：分钟时间
extern const int H5SDK_TAG_MIN_TIME ;

/// 数据类型：uint32; 域名：排序字段ID
extern const int H5SDK_TAG_SORT_FIELD_ID ;

/// 数据类型：uint32; 域名：字段id
extern const int H5SDK_TAG_FIELD_ID ;


/// 数据类型：uint32(枚举); 域名：错误号
//extern const int H5PROTO_TAG_ERROR_NO ;
extern const uint32 H5PROTO_ENUM_EN_SUCCESS ; // 成功
extern const uint32 H5PROTO_ENUM_EN_CUSTOM ; // 使用自定义错误号
extern const uint32 H5PROTO_ENUM_EN_FAILED ; // 失败
extern const uint32 H5PROTO_ENUM_EN_CRC_MATCH ; // CRC匹配
extern const uint32 H5PROTO_ENUM_EN_FILE_NOT_EXIST ; // 文件不存在

/// 数据类型：int64; 域名：特殊标记,///Special Marker宏定义
#define SM_DELIST_WARNING           0x01  ///< 退市警示标的
#define SM_RISK_WARNING             0x02  ///< 风险警示标的
#define SM_CRD_BUY                  0x04  ///< 融资标的
#define SM_CRD_SELL                 0x08  ///< 融券标的
#define SM_SH2HK                    0x10  ///< 沪股通标的(可买可卖)
#define SM_HK2SH                    0x20  ///< 港股通标的(可买可卖)
#define SM_SH2HK_ONLY_SELL          0x40  ///< 沪股通标的(只可卖)
#define SM_HK2SH_ONLY_SELL          0x80  ///< 港股通标的(只可卖)

extern const int H5SDK_TAG_SPECIAL_MARKER;

extern const int H5SDK_MSG_BLOCK_SORT; // 板块成分股排序
extern const int H5SDK_MSG_STOCK_BLOCKS; // 通过代码查找所属板块集

#endif /* __H5_SDK_TAG_H__ */