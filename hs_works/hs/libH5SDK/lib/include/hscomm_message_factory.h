#import <Foundation/Foundation.h>
#import "MyObjectList.h"
#import "hscomm_message_interface.h"

@class IHsCommMessage;


@protocol IHsComMessageFactory <NSObject>

@optional
//动态加载“明文”模板接口
-(int)loadPlaintextTemplate:(IHSKnown*)lpCfg withDate:(NSData*)templateData;

//根据功能号来创建消息，不同功能有不同的消息模板
-(IHsCommMessage*)createMessageWithbizId:(int)bizId
                              FunctionId:(int)iFunc
                           andPacketTyep:(int)iPacketType;

// 申请消息
-(IHsCommMessage*)createMessage;

-(int)initFactory;
-(int)initFactoryWithTemplate:(NSData*)templateData;

@end

@interface  IHsComMessageFactory:  NSObject<IHsComMessageFactory>

@end

//typedef map<int, string> BusinessId2TemplateBuffer;

@interface  CHsComMessageFactory:  IHsComMessageFactory
{
    // 为支持接口GetTemplateByBusinessId而增加内部数据结构
//    BusinessId2TemplateBuffer m_businessId2TemplateBuffer;
    int m_iDefaultBizID;
    int m_iMangerFunctionCount;
    BOOL _ready;
}

//@property(nonatomic, assign) BusinessId2TemplateBuffer      m_businessId2TemplateBuffer;
@property(nonatomic, retain) MyObjectList*   m_lpMsgPool;
@property(nonatomic, readonly)BOOL isReady;

@end


