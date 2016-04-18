

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface CMStoreManager : NSObject
AS_SINGLETON(CMStoreManager)

//本地plist文件操作
-(NSString *)get_filename:(NSString *)name;
-(BOOL)is_file_exist:(NSString *)name;

//设置大厅股票期货的可售状态
- (void)setFoyerPageStatus:(id)sender;

//获取大厅股票期货的可售状态
- (id)getFoyerPageStatus;

//获取友盟设备号
- (NSString * )getUmCode;

//设置友盟设备号
- (void)setUmengCode:(NSString*)UmengCode;

//设置环境
- (void)setEnvironment:(NSString*)environmentURL;

//获取环境
- (NSString *)getEnvironment;

//设置UUID
- (void)setUUID;

//获得UUID
- (NSString *)getUUID;


// 是否已经登录
- (BOOL)isLogin;

// 是否自动登录
- (BOOL)isAutoLogin;

// 获取账户余额
- (NSString *)getAccountBalance;

// 设置账户余额
- (void)setAccountBalance:(NSString *)balance;

// 获取账户冻结金额
- (NSString *)getAccountFreeze;

// 设置账户冻结金额
- (void)setAccountFreeze:(NSString *)freeze;

// 获取账户积分
- (int)getAccountScore;

// 设置账户积分
- (void)setAccountScore:(int)score;

// 设置是否自动登录
- (void)setIsAutoLogin:(BOOL)isAutoLogin;


// 登录成功，保存用户名及密码
- (void)storeUserName:(NSString*)userName;

// 保存userSession
- (void)storeUserSession:(NSString*)userSession;

// 获取用户名
- (NSString*)getUserName;

// 获取登录密码
- (NSString*)getPassWord;

// 获取userSession
- (NSString*)getUserSession;

// 保存deviceToken
- (void)storeDeviceToken:(NSString *)deviceToken;

// 获取deviceToken
- (NSString*)getDeviceToken;

// 保存userToken
- (void)storeUserToken:(NSString *)userToken;

// 获取userToken
- (NSString*)getUserToken;

// 保存userTokenSecret
- (void)storeUserTokenSecret:(NSString *)userTokenSecret;

// 获取userTokenSecret
- (NSString*)getUserTokenSecret;

//保存用户昵称
-(void)setUserNick:(NSString *)aNick;

//获取昵称
-(NSString *)getUserNick;

//保存用户头像地址
-(void)setUSerHeaderAddress:(NSString*)headerAddress;

//获取头像
-(UIImage*)getUserHeader;

//保存用户个性签名
-(void)setUserSign:(NSString *)aSign;

//获取用户个性签名
-(NSString *)getUserSign;
/**存储用户积分账户状态*/
-(void)setAccountScoreStatus:(NSString*)status;
/**获取用户积分账户状态*/
-(BOOL)getAccountScoreStatus;
/**存储用户财牛账户状态*/
-(void)setAccountCainiuStatus:(NSString*)status;
/**获取用户财牛账户状态*/
-(BOOL)getAccountCainiuStatus;
/**存储用户南交所账户状态*/
-(void)setAccountNanJSStatus:(NSString*)status;
/**获取用户南交所账户状态*/
-(BOOL)getAccountNanJSStatus;

/**存储用户积分账户detailDic*/
-(void)setAccountScoreDetailDic:(NSDictionary*)detailDic;
/**获取用户积分账户detailDic*/
-(NSDictionary *)getAccountScoreDetailDic;
/**存储用户财牛账户detailDic*/
-(void)setAccountCainiuDetailDic:(NSDictionary*)detailDic;
/**获取用户财牛账户detailDic*/
-(NSDictionary *)getAccountCainiuDetailDic;
/**存储用户南交所账户detailDic*/
-(void)setAccountNanJSDetailDic:(NSDictionary*)detailDic;
/**获取用户南交所账户detailDic*/
-(NSDictionary *)getAccountNanJSDetailDic;
//清除用户名密码
- (void)deleteUserName;

//保存用户管理权限
-(void)setuseIsStaff:(int)isStaff;

//获取用户管理权限
-(NSString*)getUserIsStaff;

//获取背景图片
-(NSData*)getbackgroundImage:(NSString*)imageName;

//设置背景图片
-(void)setbackgroundimage;

//用户注销清空用户信息
- (void)exitLoginClearUserData;

-(AccountModel *)getAccountScoreModel;

@end
