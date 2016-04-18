//
//  AccountOpenPage.h
//  hs
//
//  Created by PXJ on 16/2/25.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountH5Page : UIViewController
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong) NSString   *usedMoney;
@property (nonatomic,assign)BOOL isHaveToken;
@property (nonatomic,assign)BOOL isNeedNav;
@end
