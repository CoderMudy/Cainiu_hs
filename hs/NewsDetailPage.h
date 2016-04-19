//
//  NewsDetailPage.h
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef enum{
    ConmentNews,
    ConmentUser,
    ConmentReplyUser

}ConmentStyle;
#import <UIKit/UIKit.h>

@class News;

@interface NewsDetailPage : UIViewController

@property (nonatomic,assign)ConmentStyle conmentStyle;
@property (nonatomic,strong)News    *news;

@end
