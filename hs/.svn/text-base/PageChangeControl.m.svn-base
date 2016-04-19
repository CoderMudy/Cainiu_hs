//
//  PageChangeControl.m
//  hs
//
//  Created by PXJ on 16/1/25.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "PageChangeControl.h"
#import "FindKeFuController.h"
#import <ShareSDK/ShareSDK.h>//分享
@interface PageChangeControl ()

@end

@implementation PageChangeControl

#pragma mark /**跳转客服*/
+ (void)goKeFuWithSource:(UIViewController*)sourcePage
{
    FindKeFuController  * vc = [[FindKeFuController alloc] init];
    [sourcePage.navigationController pushViewController:vc animated:YES];
}
#pragma mark /**调用分享*/
+ (void)goShareWithTitle:(NSString*)title content:(NSString*)content urlStr:(NSString *)url imagePath:(NSString * )imagePath;
{
    if (imagePath ==nil)
    {
        imagePath = [[NSBundle mainBundle] pathForResource:App_shareIconName ofType:@"png"];
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@\n%@",content,url]
                                       defaultContent:[NSString stringWithFormat:@"%@？\n%@",content,url]
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:[NSString stringWithFormat:@"%@",title]
                                                  url:url
                                          description:[NSString stringWithFormat:@"%@\n%@",content,url]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             NSLog(NSLocalizedString(@"恭喜您，分享成功！", @"分享成功"));
         }
         else if (state == SSResponseStateFail)
         {
//             [UIEngine showShadowPrompt:@"尚未安装此应用，请下载后重试!"];
             NSString * errorCode = [NSString stringWithFormat:@"%ld",(long)[error errorCode]];
             NSString * errorDesc = [NSString stringWithFormat:@"%@",[error errorDescription]];
             NSLog(@"错误码:%@  错误描述:%@",errorCode,errorDesc);
             NSLog(NSLocalizedString(@"分享失败", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
         }
     }];
}
+(void)callWithTel:(NSString *)tel{
    NSString * telUrl = [NSString stringWithFormat:@"tel://%@",tel];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telUrl]];
}



@end
