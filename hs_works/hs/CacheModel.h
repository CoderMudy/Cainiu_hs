//
//  CacheModel.h
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageAccountModel.h"
#import "PagePositionModel.h"
#import "PageOtherPositionModel.h"
#import "PositionDetailModel.h"
#import "OtherPositionDetialModel.h"
#import "PageHotLIstModel.h"
#import "PageOrderBuyModel.h"
#import "PageFinanceModel.h"
#import "PagePayModel.h"
#import "HolidayCacheModel.h"

@interface CacheModel : NSObject<NSCoding>

/*
 使用方法：
 获取：
 CacheModel *cacheModel = [CacheEngine getCacheInfo];
 
 存储：
 //获取缓存信息
 CacheModel *cacheModel = [CacheEngine getCacheInfo];
 //设置属性
 cacheModel.accountModel.accountIndexModel.privateUserInfo.statusRealName = _privateUserInfo.statusRealName;
 // 存入缓存
 [CacheEngine setCacheInfo:cacheModel];
 */
#pragma mark holiday 假期场相关缓存
@property (nonatomic,strong)HolidayCacheModel * holidayCacheModel;

#pragma mark page--账户

@property (nonatomic,strong)PageAccountModel *accountModel;

@property (nonatomic,strong)PagePayModel    *payModel;

//******************************************************

#pragma mark page--持仓首页

@property (nonatomic,strong)PagePositionModel * positionPrivateIndex;

#pragma mark page--个人持仓内页

@property (nonatomic,strong)NSMutableArray * stockDetailArray;

#pragma mark page--融资购买首页

@property (nonatomic,strong)PageFinanceModel * financeIndex;

#pragma mark page--热门行业

@property (nonatomic,strong)PageHotLIstModel * tradeHot;

#pragma mark page--他人持仓首页

@property (nonatomic,strong)PageOtherPositionModel * positionPublicIndex;

#pragma mark page--他人持仓内页

@property (nonatomic,strong)OtherPositionDetialModel * positionPublic;

#pragma mark page--下单

@property (nonatomic,strong)PageOrderBuyModel * orderIndex;

#pragma mark 沪金下单
@property (nonatomic,strong)NSMutableDictionary *tradeDic;
//NSMutableDictionary *agTradeDic; NSMutableDictionary *ifTradeDic; NSMutableDictionary *cnTradeDic;


#pragma mark 用户是否签署过协议

@property (nonatomic,strong)NSString * isAgree;
@property (nonatomic,strong)NSString * isAgreeOfAu;

#pragma mark 用户习惯选择额度

@property (nonatomic,assign)int userAmt;

#pragma mark 历史搜索记录
@property (nonatomic,strong)NSMutableArray * searchArray;

#pragma mark 行情数据

@property (nonatomic,strong)NSMutableDictionary *socketInfoDic;
//NSMutableArray *ifInfoArray; NSMutableArray *agInfoArray;
#pragma mark  大厅产品列表

@property (nonatomic,strong)NSMutableArray *productListArray;
@property (nonatomic,strong)NSMutableArray *reportArray;
@property (nonatomic,strong)NSMutableArray *bannerArray;

@property (nonatomic,strong) NSString *isOrLogin;//判断是否登录了
@property (nonatomic,strong) NSString *isOrderOrLogin;//判断是否登录了(下单页面)用来判断是否显示新手引导页
@property (nonatomic,strong) NSString *isQuickOrderOrLogin;//（快速下单页面）用来判断是否显示新手引导页

#pragma mark 记录用户是否在大厅页点击了解财牛
@property (nonatomic,strong) NSString *isClickLJCN;

#pragma mark  身份认证页面图片的缓存
@property (nonatomic,strong)NSMutableArray *imageRenzhengArray;

#pragma mark 是否第一次进入现货下单页面
@property (nonatomic,strong) NSString *isFirstSpotIndex;

#pragma mark 南交所信息(现货)存储
@property (nonatomic,strong) NSMutableDictionary *spotgoodsInfo;

#pragma mark 现货闪电下单存储
@property (nonatomic,strong) NSMutableDictionary * cashSaleDic;
@end
