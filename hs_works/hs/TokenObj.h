//
//  TokenObj.h
//  hs
//
//  Created by RGZ on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TokenObjProtocol <JSExport>

- (id)getToken;

@end


@interface TokenObj : NSObject<TokenObjProtocol>

@end
