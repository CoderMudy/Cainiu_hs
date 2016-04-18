//
//  HSBaseViewController.h
//  hs
//
//  Created by 杨永刚 on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, NSPushType) {
    NSPushMode           = 1,
    NSPresentMode      = 2,
    NSPushRootMode  = 3,
};

typedef void(^HSBlock)(void);

@interface HSBaseViewController : UIViewController

@property (nonatomic,assign)BOOL    customLeft;

@property (nonatomic,strong)HSBlock leftClick;


- (void)setNavTitle:(NSString *)title;
- (void)setNavLeftBut:(NSPushType)pushType;
- (void)setTitleViewImage:(NSString *)imageName;

- (void)setNavRigthBut:(NSString *)titleStr butImage:(UIImage *)butImage butHeigthImage:(UIImage *)heigtLigthImage select:(SEL)selector;

@end
