//
//  MacroURL.h
//  hs
//
//  Created by PXJ on 15/4/24.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#ifndef hs_Macro_h
#define hs_Macro_h



#define AccountPageName AccountViewController

/**获取域名格式 www.cainiu.com*/
#define K_URL [[CMStoreManager sharedInstance] getEnvironment]//获取到域名 www.cainiu.com
/**获取域名格式 http://www.cainiu.com*/
#define K_MGLASS_URL   [NSString stringWithFormat:@"http://%@",K_URL]
/**设置Font*/
#define FontSize(a) [UIFont systemFontOfSize:a]

/**现货闪电平仓是否弹窗的缓存标记*/
#define K_CashKeySaleCacheMark @"cashKeySale"


#define K_COLOR_CUSTEM(a,b,c,d) ([[UIColor alloc] initWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:(d)])
//设置背景图片

#define K_setImage(NAME) [UIImage imageWithData:[[CMStoreManager sharedInstance] getbackgroundImage:(NAME)]]
//查询模拟盘总盈利
#define K_Order_monProfit [NSString stringWithFormat:@"%@/order/order/moniTotalProfit",K_MGLASS_URL]
//查询是否为假期
#define  K_market_isHoliday [NSString stringWithFormat:@"%@/market/market/isHoliday",K_MGLASS_URL]
/**现货 ————入金回调*/
#define K_Cash_CyberPayBlock [NSString stringWithFormat:@"%@/cots/pay/yiDuPayConfirm",K_MGLASS_URL]

/**现货 ————查询单个品种详细*/
#define K_Cash_SingelInfo [NSString stringWithFormat:@"%@/cots/cots/querySingleInfo",K_MGLASS_URL]

/**现货 ————查询用户持仓风险率*/
#define K_Cash_RiskTrader [NSString stringWithFormat:@"%@/cots/cots/queryRiskTrader",K_MGLASS_URL]
 
 /**现货————查询委托订单详情*/
#define K_Cash_EntrustDetail [NSString stringWithFormat:@"%@/cots/cots/entrustCashOrder",K_MGLASS_URL]

/**现货————闪电平仓*/
#define K_Cash_KeySale [NSString stringWithFormat:@"%@/cots/sale/saleOrder",K_MGLASS_URL]

/**现货————委托撤单*/
#define K_Cash_revokeEntrust [NSString stringWithFormat:@"%@/cots/cots/entrustRevoke",K_MGLASS_URL]

/**现货————止盈止损撤单*/
#define K_Cash_revokeSet [NSString stringWithFormat:@"%@/cots/cots/bullishBearishRevoke",K_MGLASS_URL]

/**现货————获取订单列表___成功单*/
#define K_Cash_queryOrderList [NSString stringWithFormat:@"%@/cots/cots/bargainList",K_MGLASS_URL]

/**现货————获取订单列表___委托单*/
#define K_Cash_queryEntrustList [NSString stringWithFormat:@"%@/cots/cots/entrustList",K_MGLASS_URL]

/**现货————获取订单列表___止盈止损单*/
#define K_Cash_querySetOrderList [NSString stringWithFormat:@"%@/cots/cots/upDownList",K_MGLASS_URL]

/**现货————获取订单列表___结算单*/
#define K_Cash_queryEndOrderList [NSString stringWithFormat:@"%@/cots/cots/endOrderList",K_MGLASS_URL]

/**现货————获取用户持仓数据*/
#define K_Cash_queryPosition [NSString stringWithFormat:@"%@/cots/cots/querySinglePosition",K_MGLASS_URL]

/**现货————获取持仓列表（未成交委托单）*/
#define K_Cash_queryNewEntrustList [NSString stringWithFormat:@"%@/cots/cots/newEntrustList",K_MGLASS_URL]

/**现货————获取用户资金*/
#define k_Cash_QueryFund [NSString stringWithFormat:@"%@/cots/cots/queryFund",K_MGLASS_URL]

/**获取抵用券数量*/
#define K_coupons_couponNum [NSString stringWithFormat:@"%@/user/coupon/usefulCouponCount",K_MGLASS_URL]

/**个人持仓*/
#define K_ORDER_STOCKPOSI   [NSString stringWithFormat:@"%@/order/order/currentOrderList",K_MGLASS_URL]

/**获取操盘配置信息*/
#define K_FINANCY_STOCKTRADER [NSString stringWithFormat:@"%@/financy/financy/getStockTraderList",K_MGLASS_URL]

/**股票可售状态查询*/
#define K_MARKET_STOCKSTATUS [NSString stringWithFormat:@"%@/market/market/stockStatus",K_MGLASS_URL]

/**积分持仓市值*/
#define K_TASK_SCOREMARKETV [NSString stringWithFormat:@"%@/order/order/scoreMarketValue",K_MGLASS_URL]

/**冻结积分*/
#define K_ORDER_FROZENSCORE [NSString stringWithFormat:@"%@/order/order/frozenScore",K_MGLASS_URL]

/**积分流水列表*/
#define K_FINANCY_SCOREFINANCYFLOWLIST [NSString stringWithFormat:@"%@/financy/financy/apiScoreFinancyFlowList",K_MGLASS_URL]

/**积分交易记录－持有中*/
#define K_ORDER_CUR_SCORELIST [NSString stringWithFormat:@"%@/order/order/curScoreOrderList",K_MGLASS_URL]

/**积分交易记录－已结算*/
#define K_ORDER_FINISH_SCORELIST [NSString stringWithFormat:@"%@/order/order/finishScoreOrderList",K_MGLASS_URL]

/**现金交易记录－持有中*/
#define K_ORDER_CUR_CASHLIST [NSString stringWithFormat:@"%@/order/order/curCashOrderList",K_MGLASS_URL]

/**现金交易记录－已结算*/
#define K_ORDER_FINISH_CASHLIST [NSString stringWithFormat:@"%@/order/order/finishCashOrderList",K_MGLASS_URL]

/**他人持仓列表*/
#define k_ORDER_OTHERPOSI   [NSString stringWithFormat:@"%@/order/order/otherPosi",K_MGLASS_URL]

/**获取系统时间*/
#define K_systemTime [NSString stringWithFormat:@"%@/user/sysTime",K_MGLASS_URL]

/**获取公告图片列表*/
#define K_ImageURL  [NSString stringWithFormat:@"%@/user/newsNotice/newsList",K_MGLASS_URL]

/**大厅页面播报*/
#define K_FINANCY_ROLL [NSString stringWithFormat:@"%@/financy/fs/profitStatisticsList",K_MGLASS_URL]

/**平台累计持仓、盈利*/
#define K_FINANCY_STATISTICS [NSString stringWithFormat:@"%@/financy/fs/financyStatistics",K_MGLASS_URL]

/**获取自选股列表*/
#define K_FAVORITESLIST [NSString stringWithFormat:@"%@/user/favorites/favoritesList",K_MGLASS_URL]

/**添加自选股*/
#define K_ADD_FAVORITES [NSString stringWithFormat:@"%@/user/favorites/addFavorites",K_MGLASS_URL]

/**删除自选股*/
#define K_DELETE_FAVORITES [NSString stringWithFormat:@"%@/user/favorites/deleteFavorites",K_MGLASS_URL]

//----------------------------------------------

/**大厅－－－－－－是否清仓*/
#define K_Foyerpage_isClear [NSString stringWithFormat:@"%@/market/market/isClear",K_MGLASS_URL]

/**大厅————————获取单个种类的行情信息*/
#define K_Foyerpage_getCachedata [NSString stringWithFormat:@"%@/futuresquota/getCacheData",K_MGLASS_URL]

/**点击大厅产品查询是否可进入内页*/
#define K_FoyerPage_productClickEnable [NSString stringWithFormat:@"%@/market/futureCommodity/checkVendibility",K_MGLASS_URL]

/**获取广告图片*/
#define K_FoyerPage_advert [NSString stringWithFormat:@"%@/user/newsNotice/newsList",K_MGLASS_URL]

/**大厅商品数据接口－区分 实盘 积分 模拟*/
#define K_FoyerPage_productDataByType [NSString stringWithFormat:@"%@/market/futureCommodity/selectByType",K_MGLASS_URL]


/**大厅商品数据接口*/
#define K_FoyerPage_productData [NSString stringWithFormat:@"%@/market/futureCommodity/select",K_MGLASS_URL]

/**大厅中获取各种订单笔数*/
#define K_FoyerPage_posiOrderCount [NSString stringWithFormat:@"%@/order/posiOrderCount",K_MGLASS_URL]
/**大厅中获取现货订单笔数*/
#define K_FoyerPage_Cash_posiOrderCount [NSString stringWithFormat:@"%@/cots/cots/cotsPositionCount",K_MGLASS_URL]
/**首页期货状态列表*/
#define K_FoyerPage_FuturesStatus [NSString stringWithFormat:@"%@/market/market/getFuturesStatus",K_MGLASS_URL]
/**获取期货持仓列表*/
#define K_Index_posiList [NSString stringWithFormat:@"%@/order/futures/posiList",K_MGLASS_URL]

/**获取期货委托记录列表*/
#define K_Index_futuresOrderEntrustList [NSString stringWithFormat:@"%@/order/futures/futuresOrderEntrustList",K_MGLASS_URL]

/**获取期货条件单列表*/
#define K_Index_conditionOrderList [NSString stringWithFormat:@"%@/order/condition/conditionOrderList",K_MGLASS_URL]

/**获取期货结算列表*/
#define K_Index_balanceList [NSString stringWithFormat:@"%@/order/futures/balancedList",K_MGLASS_URL]

/**出售期货列表*/
#define K_Index_sale [NSString stringWithFormat:@"%@/order/futures/sale",K_MGLASS_URL]

/**出售期货交易结果轮询查询*/
#define K_Index_saleSearch [NSString stringWithFormat:@"%@/order/futures/result",K_MGLASS_URL]
/*期货撤单*/
#define k_Index_futuresOrderRevoke [NSString stringWithFormat:@"%@/order/condition/userRepeal",K_MGLASS_URL]
/**交易提醒消息*/
#define K_sms_TraderMsg [NSString stringWithFormat:@"%@/sms/message/traderMassages",K_MGLASS_URL]

/**系统消息列表*/
#define K_sms_sysMsg [NSString stringWithFormat:@"%@/sms/message/systemMessages",K_MGLASS_URL]

/**系统消息详情*/
#define K_sms_sysMsgDetail [NSString stringWithFormat:@"%@/sms/message/systemMessageInfo",K_MGLASS_URL]

/**消息中心，各种消息的未读数量*/
#define K_sms_MsgCount [NSString stringWithFormat:@"%@/sms/message/messageCount",K_MGLASS_URL]

/**提现验证密码*/
#define K_user_checkPassWord [NSString stringWithFormat:@"%@/user/user/checkPwd",K_MGLASS_URL]

/**查询用户管理权限*/
#define K_user_getIsStaffStatus [NSString stringWithFormat:@"%@/user/user/getIsStaffStatus",K_MGLASS_URL]

/**校验用户切换环境密码*/
#define K_user_checkEnviroPassWord [NSString stringWithFormat:@"%@/user/user/check",K_MGLASS_URL]

/**更新用户头像*/
#define K_user_updateHeader [NSString stringWithFormat:@"%@/user/user/updPhoto",K_MGLASS_URL]

/**查询用户账户*/
#define K_user_accountsInfo [NSString stringWithFormat:@"%@/user/account/getAccountsInfo",K_MGLASS_URL]

/**开启模拟账户*/
#define K_user_openScoreAccount [NSString stringWithFormat:@"%@/user/account/openScoreAcc",K_MGLASS_URL]

/**查看期货订单状态*/
#define K_order_orderState [NSString stringWithFormat:@"%@/order/futures/orderStatus",K_MGLASS_URL]

/**发现- 获取用户任务中心是否有红包可领取*/
#define K_activity_diplay [NSString stringWithFormat:@"%@/activity/taskManage/display",K_MGLASS_URL]
/**推广- 判断是否是推广员*/
#define K_promotion_getPromotionStatus [NSString stringWithFormat:@"%@/promotion/getPromoteStatus",K_MGLASS_URL]

/**推广- 获取个人邀请码*/
#define K_promotion_getPromoteId [NSString stringWithFormat:@"%@/promotion/getPromoteIdByToken",K_MGLASS_URL]

/**推广- 获取用户推广信息*/
#define K_promotion_getPromoteSt [NSString stringWithFormat:@"%@/promotion/getPromoteSt",K_MGLASS_URL]

/**推广- 获取推广员用户推广信息*/
#define K_promotion_gerPromote  [NSString stringWithFormat:@"%@/promotion/getPromoteDetail",K_MGLASS_URL]

/**推广－ 申请成为推广员*/
#define K_promote_apply [NSString stringWithFormat:@"%@/promotion/app/promote/apply",K_MGLASS_URL]

/**推广－ 推广员下线信息*/
#define K_promote_subUsers [NSString stringWithFormat:@"%@/promotion/getPromoteSubUsers",K_MGLASS_URL]

/**推广－ 佣金流水*/
#define K_promote_commissionDetail [NSString stringWithFormat:@"%@/financy/commissions/getCommissionsToCashHistory",K_MGLASS_URL];

/**推广－ 佣金提现*/
#define K_promote_commissionCash [NSString stringWithFormat:@"%@/financy/commissions/transferCommissionsToCash",K_MGLASS_URL];

/**推广－ 获取用户返利领取状态*/
#define K_financy_TaskStatus [NSString stringWithFormat:@"%@/financy/financy/getUserTaskStatus",K_MGLASS_URL]

/**推广－ 领取返利金额*/

#define K_financy_FriendTotalConsume [NSString stringWithFormat:@"%@/financy/financy/friendTotalConsume",K_MGLASS_URL]

//回复记录
#define K_Answer_AnswerRecord [NSString stringWithFormat:@"%@/user/feedback/readFeedback",K_MGLASS_URL]

//更新回复已读状态
#define K_AnsRefresh_AnswerRefresh [NSString stringWithFormat:@"%@/user/feedback/updateIsRead",K_MGLASS_URL]

//回复信息是否已读
#define K_Answer_AnswerIsRead [NSString stringWithFormat:@"%@/user/feedback/isRead",K_MGLASS_URL]

//上传图片接口
#define K_Upload_UploadIMg  [NSString stringWithFormat:@"%@/user/audit/updateImg",K_MGLASS_URL]

//审核状态
#define K_ShenHe_Satus     [NSString stringWithFormat:@"%@/user/user/checkIdCardPic",K_MGLASS_URL]


//用户第几次提现
#define K_Tixian_Num        [NSString stringWithFormat:@"%@/financy/financy/getWithdrawCount",K_MGLASS_URL]

//判断用户当日第几次提现
#define K_Today_TixianNum        [NSString stringWithFormat:@"%@/financy/financy/getTodayWithdrawCount",K_MGLASS_URL]

//用户提现记录列表
#define K_User_TixianRecord       [NSString stringWithFormat:@"%@/financy/financy/getWithdrawHistory",K_MGLASS_URL]

//用户提现详情
#define K_User_TixianDetail     [NSString stringWithFormat:@"%@/financy/financy/getWithdrawHistoryDetail",K_MGLASS_URL]

//用户提现撤回
#define K_User_TixianCancel     [NSString stringWithFormat:@"%@/financy/financy/cancleWithdraw",K_MGLASS_URL]

//获取用户提现到账时间
#define K_User_TixianDoneData     [NSString stringWithFormat:@"%@/financy/financy/getWithdrawDoneDate",K_MGLASS_URL]

//判断用户是否有交易的行为
#define K_User_IsTradeOrNot     [NSString stringWithFormat:@"%@/financy/financy/isTraderOrNot",K_MGLASS_URL]

//银行卡
#define K_User_Banktransfer         [NSString stringWithFormat:@"%@/financy/financy/bankTransfer",K_MGLASS_URL]

//支付宝转账
#define K_User_ZfbNumber            [NSString stringWithFormat:@"%@/financy/financy/zfbTransfer",K_MGLASS_URL]

//获取用户银行卡和支付宝信息
#define K_User_ZfbAndBanckNumber    [NSString stringWithFormat:@"%@/financy/financy/getZfbBankNumberInfo",K_MGLASS_URL]

//获取抵用券列表(不分页)
#define K_User_CouponList           [NSString stringWithFormat:@"%@/user/coupon/availableCouponList",K_MGLASS_URL]

//获取抵用券列表(分页)
#define K_User_CouponPageList       [NSString stringWithFormat:@"%@/user/coupon/userCouponList",K_MGLASS_URL]

//获取已使用和已过期的抵用券列表
#define K_User_CouponHistoryList      [NSString stringWithFormat:@"%@/user/coupon/usedAndExpiredCouponList",K_MGLASS_URL]

//根据兑换码绑定抵用券
#define K_User_BindCouPon      [NSString stringWithFormat:@"%@/user/coupon/bindCoupon",K_MGLASS_URL]

//现货————市价下单
#define K_Cash_MarketOrder      [NSString stringWithFormat:@"%@/cots/cots/queryMarketEntrust",K_MGLASS_URL]

//现货————限价下单
#define K_Cash_LimitedOrder      [NSString stringWithFormat:@"%@/cots/cots/queryLimitEntrust",K_MGLASS_URL]

//现货————止盈止损下单
#define K_Cash_StopOrGetOrder      [NSString stringWithFormat:@"%@/cots/cots/bullishBearishEntrust",K_MGLASS_URL]

//现货————五档行情
#define K_Cash_FiveIndexList      [NSString stringWithFormat:@"%@/futuresquota/getNewCotsData",K_MGLASS_URL]

//现货————获取涨停价和跌停价e
#define K_Cash_LowsOrHighPrice      [NSString stringWithFormat:@"%@/cots/cots/querySingleInfo",K_MGLASS_URL]

//现货————获取止盈止损可下单数量
#define K_Cash_StopProfitNum      [NSString stringWithFormat:@"%@/cots/cots/getEntrustAvailble",K_MGLASS_URL]

//现货————获取交易系统已闭市
#define K_Cash_MarketIsStatus      [NSString stringWithFormat:@"%@/market/market/futuresStatus",K_MGLASS_URL]

//资讯————获取资讯详情
#define K_Info_detail [NSString stringWithFormat:@"%@/user/newsArticle/detail",K_MGLASS_URL]

//资讯————资讯详情评论列表
#define K_Info_detailComment  [NSString stringWithFormat:@"%@/user/newsArticle/newsArticleCmt",K_MGLASS_URL]

//资讯————新增评论回复
#define K_Info_addNewComment  [NSString stringWithFormat:@"%@/user/newsArticle/addNewsArticleCmt",K_MGLASS_URL]


//价格倍数
#define LARGE_NUM  1000.0
#define LARGE_NRATE  10000.0

#define ADScale 96/270



#define K_color_backView  K_COLOR_CUSTEM(246, 246, 246, 1)

#define K_color_line  K_COLOR_CUSTEM(230, 230, 230, 1)
#define K_color_lightGray  K_COLOR_CUSTEM(193, 193, 193, 1)
#define K_color_gray  K_COLOR_CUSTEM(163, 163, 163, 1)
#define K_color_grayLine  K_COLOR_CUSTEM(163, 163, 163, 0.5)

#define K_color_grayBlack  K_COLOR_CUSTEM(110, 110, 110, 1)
#define K_color_black  K_COLOR_CUSTEM(55, 54, 53, 1)

#define K_color_Purple K_COLOR_CUSTEM(105, 27, 79, 1)

#define K_color_orangeLine K_COLOR_CUSTEM(255, 155, 49, 1)
#define K_color_orangeBack K_COLOR_CUSTEM(255, 211, 141, 1)

#define K_color_infoBlue K_COLOR_CUSTEM(87, 107, 149, 1)
#define K_color_infoBack K_COLOR_CUSTEM(243,243,245,1)
//销售包导航黑色
#define K_color_NavColor K_COLOR_CUSTEM(22, 22, 24, 1)
//销售包蓝色
#define k_color_blueColor K_COLOR_CUSTEM(8, 129, 198, 1)
//销售包白色背景
#define k_color_whiteBack [UIColor whiteColor]
//系统绿色
#define K_color_green  K_COLOR_CUSTEM(0, 166, 120, 1)
//系统红色
#define K_color_red  K_COLOR_CUSTEM(200, 50, 30, 1)
#endif
