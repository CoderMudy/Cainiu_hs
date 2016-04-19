
#ifndef CaiMoo_CMGlobalDefinition_h
#define CaiMoo_CMGlobalDefinition_h

#pragma mark - 日志输出

#define DEBUG_LOG                            // 是否开启日志输出

#ifdef DEBUG_LOG                            // 普通日志
#define CMLog(...) NSLog(__VA_ARGS__)
#else
#define CMLog(...) do { } while (0)
#endif

#pragma mark - 客户端运行时配置宏
#define IMNetwork_Need_Sign         // 网络请求是否附带签名

//预发布
//#define ROOT_URL        @"http://client.caimoo.net"

//新生产环境
#define ROOT_URL        @"http://www.cainiu.com"

#pragma mark - rgb color

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeigth [UIScreen mainScreen].bounds.size.height

#define NavigationTitleFont 17
//#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 消除ARC环境下PerformSelector的警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define X(v) (v).frame.origin.x
#define Y(v) (v).frame.origin.y
#define  WIDTH(v) (v).frame.size.width
#define HEIGHT(v)  (v).frame.size.height


#define UnSelectButBackColor [UIColor colorWithHexString:@"6e6e6e"]
#define CanSelectButBackColor [UIColor colorWithHexString:@"fa4300"]

#define MAINTEXTCOLOR [UIColor colorWithHexString:@"373635"]
#define SUBTEXTCOLOR [UIColor colorWithHexString:@"999999"]

#pragma mark - singleton macro

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#endif
