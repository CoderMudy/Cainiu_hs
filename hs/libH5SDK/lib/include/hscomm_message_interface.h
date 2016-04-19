#ifndef ___HS___COMMONMSG___
#define ___HS___COMMONMSG___

#import <Foundation/Foundation.h>

//基本数据类型
typedef int8_t				int8;
typedef short				int16;
typedef int					int32;
typedef __int64_t			int64;
typedef unsigned char		uint8;
typedef unsigned short		uint16;
typedef unsigned int		uint32;
typedef __uint64_t          uint64;


//数据类型定义
static const uint8 TypeInt8=0;
static const uint8 TypeuInt8=1;
static const uint8 TypeInt16=2;
static const uint8 TypeuInt16=3;
static const uint8 TypeInt32=4;
static const uint8 TypeuInt32=5;
static const uint8 TypeInt64=6;
static const uint8 TypeuInt64=7;
static const uint8 TypeDouble=8;
static const uint8 TypeString=9;
static const uint8 TypeVector=10;
static const uint8 TypeRaw=11;
static const uint8 TypeIPV4=12;
static const uint8 TypeIPV6=13;
static const uint8 TypeMac=14;
static const uint8 TypeArray=15;
static const uint8 TypeSequence=16;
static const uint8 TypeUnKnown=255;


@class IHSKnown;

@protocol IHSKnown <NSObject>
@optional

/**
 *@brief 查询与当前接口相关的其他接口，例如可以查到 IIoC, IManager 等
 *@param HS_SID  iid  接口全局唯一标识
 *@param IKnown **ppv 返回iid对应的接口指针
 *@return I_OK 成功，I_NONE 未查到iid 相应接口
 */
-(unsigned long) QueryInterface:(const char*)iid PPV:(IHSKnown**) ppv;
///引用接口，引用计数加一(多线程引用时，方法实现代码里要对计数值加锁后修改)
-(unsigned long) AddRef;
///释放接口，引用计数减一，计数为0时释放接口的实现对象(多线程引用时，方法实现代码里要对计数值加锁加锁后修改)
-(unsigned long)Release;
@end

@interface IHSKnown : NSObject<IHSKnown>
@end


/*!
 * tagItem抽象接口类，构成记录（Record）的基本单元
 */
@protocol IHsCommTagItem <NSObject>
@optional

/*!
 * @brief 获取16位整形值
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 16位无符号整形值
 */
-(uint16)getInt16:(uint32)dwIndex;

/*!
 * @brief 获取132位整形值
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 32位无符号整形值
 */
-(uint32)getInt32:(uint32)dwIndex;

/*!
 * @brief 获取64位整形值
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 64位无符号整形值
 */
-(uint64)getInt64:(uint32)dwIndex;

/*!
 * @brief 获取8位整形值
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 8位无符号整形值
 */
-(uint8)getInt8:(uint32)dwIndex;

/*!
 * @brief 获取双精度浮点型数值
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 双精度浮点型数值
 */
-(double)getDouble:(uint32)dwIndex;

/*!
 * @brief 获取字符串
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 字符串常量
 */
-(const char*)getString:(uint32)dwIndex;

/*!
 * @brief 获取原始数据
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @param ilpRawDataLen 传出参数，数据长度
 * @return 原始数据指针
 */
-(const void*)getRawData:(uint32)dwIndex andLen:(int*)ilpRawDataLen;

/*!
 * @brief 获取原始数据长度
 * @param dwIndex 如果是序列则传入下标，否则传0
 * @return 原始数据长度
 */
-(int)getRawDataLen:(uint32)dwIndex;

/*!
 * @brief 设置8位无符号整型值
 * @param iValue  8位无符号整型值
 * @param iIndex 如果是序列则传入下标，否则传0
 */
-(void)setInt8:(uint8)iValue atIndex:(int)iIndex;

/*!
 * @brief 设置16位无符号整型值
 * @param iValue 16位无符号整型值
 * @param iIndex 如果是序列则传入下标，否则传0
 */
-(void)setInt16:(uint16)iValue atIndex:(int)iIndex;

/*!
 * @brief 设置32位无符号整型值
 * @param iValue  32位无符号整型值
 * @param iIndex 如果是序列则传入下标，否则传0
 */
-(void)setInt32:(uint32)iValue atIndex:(int)iIndex;

/*!
 * @brief 设置64位无符号整型值
 * @param iValue  64位无符号整型值
 * @param iIndex  如果是序列则传入下标，否则传0
 */
-(void)setInt64:(uint64)iValue atIndex:(int)iIndex;

/*!
 * @brief 设置双精度浮点值
 * @param iValue 双精度浮点值
 * @param iIndex 如果是序列则传入下标，否则传0
 */
-(void)setDouble:(double)iValue atIndex:(int)iIndex;

/*!
 * @brief 设置字符串
 * @param lpValue 字符串指针
 * @param iIndex 如果是序列则传入下标，否则传0
 */
-(void)setString:(const char*)lpValue atIndex:(int)iIndex;

/*!
 * @brief 设置字符串
 * @param lpValue 字符串指针
 * @param iIndex 如果是序列则传入下标，否则传0
 * @param len 指定字符串的长度
 */
-(void)setString:(const char*)lpValue atIndex:(int)iIndex withLen:(int)len;

/*!
 * @brief 设置原始数据
 * @param lpRawData 原始数据指针
 * @param iIndex 如果是序列则传入下标，否则传0
 * @param iRawDataLen 指定数据的长度
 */
-(void)setRawData:(const void*)lpRawData atIndex:(int)iIndex withLen:(int)iRawDataLen;

/*!
 * @brief 重置并清空数据
 */
-(void)reset;

/*!
 * @brief 获取内部数据类型
 * @param dwIndex 如果是序列则传入下标，否则传0
 */
-(int)getValueType:(uint32)dwIndex;

/*!
 * @brief 获取序列内的元素个数
 */
-(int)getCount;

/*!
 * @brief 判断是否存在值
 * @param dwIndex 如果是序列则传入下标，否则传0
 */
-(BOOL)isExist:(uint32)dwIndex;

/*!
 * @brief 判断G是不是double类型
 */
-(BOOL)isDouble;


@end

@interface IHsCommTagItem : IHSKnown <IHsCommTagItem, NSCopying>

@end

@class IGroup;

/*!
 * 消息内部记录，由一个或多个TagItem、Sequence组成
 */
@interface IRecord : IHSKnown <NSCopying>

/*!
 * @brief 获取指定tag的TagItem
 * @param iFieldTag 需要获取的item对应的tag
 */
-(IHsCommTagItem*)getItem:(int)iFieldTag;

/*!
 * @brief 删除指定tag的TagItem
 */
-(int)removeTag:(int)iFieldTag;

/*!
 * @brief 添加一个序列
 * @param iSequenceTag 指定序列的Tag
 * @return 新添加的序列
 */
-(IGroup *)setGroup:(int)iSequenceTag;

/*!
 * @brief 获取指定序列
 * @param iSequenceTag 序列的Tag
 * @return 对应Tag的序列
 */
-(IGroup *)getGroup:(int)iSequenceTag;

/*!
 * @brief 删除指定tag的序列
 * @param iSequenceTag 需要删除的序列对应的tag
 */
-(void)removeGroup:(int)iSequenceTag;

/*!
 * @brief 判断指定的tagItem是否存在
 * @param dwIndex 如果是序列则传入下标，否则传0
 */
-(BOOL)isExist:(int)iFieldTag;

/*!
 * @brief 遍历普通字段(非序列字段)
 * @param wTagID 传出参数，字段对应的Tag值
 */
-(IHsCommTagItem*)getPureTag:(uint16*)wTagID;

/*!
 * @brief 判断是否存在普通Item（非重复组）
 */
-(BOOL)isExistPure:(int)iFieldTag;


/*!
 * @brief 判断是否存在重复组
 */
-(BOOL)isExistSequence:(int)iSequenceTag;

/*!
 * @brief 判断本记录里的某个TAG是不是double类型
 */
-(BOOL)isDouble:(int)iFieldTag;

@end

/*!
 * IRecord组成的序列（数组）
 */
@interface IGroup : IHSKnown <NSCopying>

/*!
 * @brief 添加一条新记录 
 * @return 添加的新记录
 */
-(IRecord*)addRecord;

/*!
 * @brief 一次添加多条新记录
 * @param  count 需要添加的记录条数
 * @return 返回操作完成后序列内的记录总数
 */
-(int)addRecords:(int)count;

/*!
 * @brief 获取指定下标的记录
 * @param index 下标
 * @return 对应下标的记录 
 */
-(IRecord*)getRecord:(int)index;

/*!
 * @brief 获取序列内记录总数
 */
-(int)getRecordCount;

@end


/*!
 * 消息结构，HsMessage消息由一个包头Record和一个包体Record组成（包体Record可以没有）
 */
@interface IHsCommMessage : IHSKnown

/*!
 * @brief 获取业务号
 */
-(int)getBizID;

/*!
 * @brief 获取功能号
 */
-(int)getFunction;

/*!
 * @brief 获取包类型
 */
-(int)getPacketType;

/*!
 * @brief 获取会话号
 * @param len 传出参数，会话号长度
 */
-(const void*)getSessionID:(int*)len;

/*!
 * @brief 获取用户附加信息
 * @param len 传出参数，信息长度
 */
-(const void*)getUsrKey:(int*)len;

/*!
 * @brief 获取头部错误号
 */
-(int)getHeadErrorNo;

/*!
 * @brief 获取头部错误信息
 * @param len 传出参数，错误信息长度
 */
-(const void*)getHeadErrorInfo:(int*)len;

/*!
 * @brief 设置业务号
 * @param dwBizID 需要设置的业务号
 */
-(int)setBizID:(uint32)dwBizID;

/*!
 * @brief 设置功能号
 * @param dwFuncID 需要设置的功能号
 */
-(int)setFunction:(uint32)dwFuncID;

/*!
 * @brief 设置包类型
 * @param dwPacketType 需要设置的包类型
 */
-(int)setPacketType:(uint32)dwPacketType;

/*!
 * @brief 设置会话号
 * @param sessionID 需要设置的会话号
 * @param len 会话好的长度
 */
-(int)setSessionID:(const void*)sessionID andLen:(int)len;

/*!
 * @brief 设置用户附加信息
 * @param usrKey 用户附加信息
 * @param len 信息长度
 */
-(int)setUsrKey:(const void*)usrKey andLen:(int)len;

/*!
 * @brief 返回消息最后的错误信息
 */
-(NSString*)getLastErrInfo;

/*!
 * @brief 清空消息
 */
-(void)clear;

/*!
 * @brief 根据业务号、功能号、包类型选择正确的包体记录
 */
-(void)setCorrectBody;

/*!
 * @brief 获取包体（消息体）内指定tag的TagItem
 * @param iFieldTag 需要获取的item对应的tag
 */
-(IHsCommTagItem*)getItem:(int)iFieldTag;


/*!
 * @brief 获得包头(消息头)记录
 */
-(IRecord*)getHead;

/*!
 * @brief 获得包体（消息体）记录
 */
-(IRecord*)getBody;

/*!
 * @brief 将消息转化成二进制流
 * @param  ilpMsgLen 传出参数，二进制流长度
 * @return  成功转化返回二进制流，否则返回NULL
 */
-(void*)getBuffer:(int*)ilpMsgLen;

/*!
 * @brief 将二进制流转化成消息
 * @param iMsgLen 二进制流长度
 * @param  成功转化返回0，否则返回值小于0
 */
-(int)setBuffer:(const char*)lpMessage Len:(int)iMsgLen;

/*!
 * @brief 获取指定tag的序列
 * @param iSequenceTag 指定tag
 * @return 返回与指定tag对应的序列，不存在则返回nil
 */
-(IGroup*)getGroup:(int)iSequenceTag;

/*!
 * @brief 添加指定tag的序列
 * @param iSequenceTag 指定tag
 * @return 返回新添加的序列，添加失败则返回nil
 */
-(IGroup*)setGroup:(int)iSequenceTag;

/*!
 * @brief 检查包体（消息体）中是否包含某个tagItem
 */
-(int)isExist:(int)iFieldTag;

/*!
 * @brief 删除指定的tagItem
 */
-(int)removeTag:(int)iFieldTag;


@end


#endif

