//
//  FoyerProductModel.h
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoyerProductModel : NSObject

@property (nonatomic,strong)NSString * loddyType; //产品类型 1:现金实盘 2:积分模拟 3:假日模拟盘
@property (nonatomic,strong)NSString * productID;//产品ID
@property (nonatomic,strong)NSString * commodityName;//产品名字
@property (nonatomic,strong)NSString * vendibility;//1:红色／0:灰色（是否可点击）
@property (nonatomic,strong)NSString * createDate;
@property (nonatomic,strong)NSString * creater;
@property (nonatomic,strong)NSString * weight;
@property (nonatomic,strong)NSString * advertisement;//产品描述
@property (nonatomic,strong)NSString * tag;//0:没有标签 1:热门标签 2:new标签
@property (nonatomic,strong)NSString * timeTag; // 0:日盘 1:夜盘
@property (nonatomic,strong)NSString * commodityDesc;// 交易描述
@property (nonatomic,strong)NSString * marketId; // marketID
@property (nonatomic,strong)NSString * marketCode; // marketCode
@property (nonatomic,strong)NSString * marketName; //交易所
@property (nonatomic,strong)NSString * marketStatus; //开市1，休市0
@property (nonatomic,strong)NSString * imgs;// 图标地址
@property (nonatomic,strong)NSString * status;// 0:隐藏 1:显示 2:全盘
@property (nonatomic,strong)NSString * instrumentID; // 产品标示符 (au1512)
@property (nonatomic,strong)NSString * instrumentCode;//产品代码 (au)
@property (nonatomic,strong)NSString * currency;//币种 CNY  USD   HKD港币
@property (nonatomic,strong)NSString * currencyName;//币种名称 eg:人民币
@property (nonatomic,strong)NSString * currencySign;//币种符号 eg:¥
@property (nonatomic,strong)NSString * currencyUnit;//币种单位 eg:元
@property (nonatomic,strong)NSString * multiple;//价格倍数，完整一个点的价格差；
@property (nonatomic,strong)NSString * decimalPlaces;//价格小数位数
@property (nonatomic,strong)NSString * baseline;//基线数目
@property (nonatomic,strong)NSString * timeline;//时间轴
@property (nonatomic,strong)NSString * interval;// 闪动图波动区间-
@property (nonatomic,strong)NSString * isDoule;// 是否双线-
@property (nonatomic,strong)NSString * nightTimeAndNum;//夜间时间条数-
@property (nonatomic,strong)NSString * scale;//分时图区间比例：分时图区间值=昨收价*比例，比例必须是整数，前端拿到这个比例乘以昨收价即可。-
@property (nonatomic,strong)NSString * timeAndNum;//白天时间条数：用于区分白天和晚上的开市时间所展示的时间点以及该时间范围内的条数；（举例：沪铜09:00/76表示09:00-10:15共75分钟，那么总条数就是76条；-
@property (nonatomic,strong)NSString * accountCode;//激活 (cainiu;score;njsuo)

@property (nonatomic,strong)NSString * tradeSubDicName;
@property (nonatomic,strong)NSString * tradeDicName;//配置缓存路径
@property (nonatomic,assign)int         isXH;
@property (nonatomic,strong)NSString * minPrice; //
+(id)productModelWithDictionary:(NSDictionary*)dictionary;

-(id)initWithDictionary:(NSDictionary*)dictionary;

//- (instancetype)fillData:(NSDictionary *)dic;

@end
