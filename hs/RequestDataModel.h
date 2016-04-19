//
//  RequestDataModel.h
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestDataModel : NSObject
//现货————————入金结果————通知服务端
+ (void)feedbackServiceWithDic:(NSDictionary *)dic successBlock:(void(^)(BOOL success))successBlock;
//现货————————查询单个品种信息
+ (void)requestCashSingleInfoWithWareId:(NSString*)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
//现货————————用户风险率查询
+ (void)requestCashUserRistTraderSuccessBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;

//现货————————委托订单详情
+ (void)requestCashEntrustDetailOrderId:(NSString*)orderId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;

//现货————————订单列表
+ (void)requestCashOrderListWithWareId:(NSString *)wareId url:(NSString *)urlStr pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize successBlock:(void(^)(BOOL success,NSArray *dataArray))successBlock;
//现货————————闪电平仓
+ (void)requestCashKeySaleWareId:(NSString *)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
/**现货————————部分平仓*/
+ (void)requestCashPartSaleWareId:(NSString *)wareId buyOrSal:(NSString *)buyOrSal price:(NSString *)price saleNum:(NSString*)saleNum successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;

//现货————————撤销订单
+ (void)requestCashRevokeOrderUrl:(NSString *)urlStr seriaNo:(NSString *)seriaNo wareId:(NSString*)wareId orderId:(NSString*)orderId fDate:(NSString*   )fDate successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
//现货————————获取用户持仓数据
+ (void)requestCashPositionDataWareId:(NSString*)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
//现货————————获取现活持仓列表（未成交委托单）
+ (void)requestCashUnSuccessSignList:(NSString*)wareId successBlock:(void(^)(BOOL success,NSArray *dictionary))successBlock;

//现货————————获取用户资金
+ (void)requestCashUserFundSuccessBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
//大厅————————获取大厅是否清仓
+(void)requestMarkerIsClearSuccessBlock:(void(^)(BOOL success,NSString * data))successBlock;


//大厅————————获取单个种类的行情信息
+(void)requestFoyerCacheData:(NSString * )futuresType successBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
//大厅————————假日盘——获取用户盈利
+(void)requestFoyerHolidayProfitSuccessBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
//大厅————————请求产品列表(区分积分，现金，假日盘)
+(void)requestProductDataWithType:(NSString*)lobby SuccessBlock:(void(^)(BOOL success,NSMutableArray * mutableArray))successBlock;

//大厅————————请求大厅产品列表
+(void)requestFoyerProductDataSuccessBlock:(void(^)(BOOL success,NSMutableArray* mutableArray))successBlock;
/***
市场——————请求是否为假期
 */
+(void)requestMarkerIsHolidaySuccessBlock:(void(^)(BOOL success,BOOL isHoliDay,NSString* holiDay))successBlock;

/**请求期货持仓列表*/
+(void)requestFuturesListWithFuturesTypeWithFuturesType:(NSString *)futuresType fundType:(NSString *)fundType successBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
//甩单请求
+(void)requestSaleOrderWithOrderID:(NSString *)orderId salePrice:(NSString * )salePrice saleDate:(NSString *)saleDate shouldCheckPrice:(NSString*)shouldCheckPrice SuccessBlock:(void(^)(BOOL success,NSMutableArray* mutableArray,NSDictionary * errorDic))successBlock;
//甩单轮询结果
+(void)requestSearchSaleOrderStatusWith:(NSString*)orderId SuccessBlock:(void(^)(BOOL success,NSMutableArray* mutableArray,NSString * errorMessage))successBlock;
/*
 * 期货
 * 撤单
 */
+ (void)requestFuturesRevokeOrderFundType:(NSString *)fundType conditionId:(NSString*)conditionId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;

//查询产品是否可点击
+(void)requestPruductClickEnable:(NSString *)productId successBlock:(void(^)(BOOL success,BOOL enable,NSString * errorMessage))successBlock;

//获取用户持仓数量
+(void)requestPosiOrderNum:(BOOL)isXH successBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;

//获取banner信息
+(void)requestBanerDataSuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;

//获取播报信息
+(void)requestReportDataSuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;

//查询期货订单状态
+(void)requestOrderStateWithfundType:(NSString *)fundtype orderId:(NSString *)orderID SuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;

//查询用户管理权限
+(void)requestUserPowerSuccessBlock:(void(^)(BOOL success,int userPower))successBlock;

//校验用户环境切换密码
+(void)requestEnviromentPassWord:(NSString *)passWord SuccessBlock:(void(^)(BOOL success,int clickStatus,NSString * msg))successBlock;
//发现————————获取用户任务中心是否有红包可领取
+(void)requestUserIsEnableRedBag:(void(^)(BOOL success,BOOL enable))successBlock;

//判断用户是否是推广员
+(void)requestUserIsSpreadSuccess:(void(^)(BOOL success,int isSpreadUser))successBlock;

//请求个人分享推广链接
+(void)requestUserQRSuccessBlock:(void(^)(BOOL success,BOOL clickStatus,NSString * msg))successBlock;

//请求大厅广告图链接
+(void)requestAdvertSuccessBlock:(void(^)(BOOL success,id data))successBlock;

//申请成为推广员请求
+(void)requestApplyPromote:(NSString *)applyReason SuccessBlock:(void(^)(BOOL success ,NSString * msg))successBlock;

//获取推广用户推广信息
+(void)requestPromoteUserMessageSuccessBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;

//获取推广员用户下线信息
+(void)requestPromoteSubUserPageNo:(int)pageNo PageSize:(int)pageSize successBlock:(void(^)(BOOL success,id sender))successBlock;

//获取推广元佣金明细
+(void)requestPromoteComissionPageNo:(int)pageNo pageSize:(int)pageSize successBlock:(void(^)(BOOL success,id sender))successBlock;
//推广佣金转现
+(void)requestPromoteComissionCashMoney:(CGFloat)cashMoney successBlock:(void(^)(BOOL success,NSString * msg,int errorCode))successBlock;
//获取用户优惠券数量
+(void)requestCouponsNumSuccessBlock:(void(^)(BOOL success,int couponsNum))successBlock;

+(void)requestMarketIsStatus:(NSString *)futureType futureCode:(NSString *)fcode successBlock:(void(^)(BOOL success,NSInteger status))successBlock;
#pragma mark 上传用户头像
+(void)updateUserHeaderImageWithImage:(NSData*)image imageDetail:(NSDictionary*)detailDic successBlock:(void(^)(BOOL success,id Info))successBlock;
/**查询用户账户*/
+ (void)requestUserAccountsInfoSuccessBlock:(void(^)(BOOL success,id Info))successBlock;

/**激活积分账户*/
+ (void)requestOpenScoreAccountSuccessBlock:(void(^)(BOOL success,id Info))successBlock;

/**
 *资讯————获取资讯详情
 */
+ (void)requestInfoDetailWithNewsArticleId:(NSString *)newsSrticleId successBlock:(void(^)(BOOL success,id Info))successBlock;
/*
*资讯————资讯详情评论列表
*/
+ (void)requestInfoTotalComentDataNewArticleId:(NSString *)newsArticleId pageNo:(int)pageNo pageSize:(int)pageSize successBlock:(void(^)(BOOL success,id Info))successBlock;
/*
 *资讯————新增评论回复
 */
+ (void)requestInfoAddNewCommentNewsId:(NSString *)newsId
                           contentText:(NSString * )cmtContent
                          replyContent:(NSString *)replyContent
                                 cmtId:(int)cmtId
                               replyId:(int)replyId
                          successBlock:(void(^)(BOOL success,id Info))successBlock;


@end
