//
//  TokenObj.m
//  hs
//
//  Created by RGZ on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "TokenObj.h"

@implementation TokenObj

- (id)getToken{
    return [[CMStoreManager sharedInstance] getUserToken];
}

@end
