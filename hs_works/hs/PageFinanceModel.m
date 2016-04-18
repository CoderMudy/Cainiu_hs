//
//  PageFinanceModel.m
//  hs
//
//  Created by PXJ on 15/6/26.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PageFinanceModel.h"

@implementation PageFinanceModel
@synthesize hotArray,earnListArray;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:hotArray forKey:@"hotArray"];
    [aCoder encodeObject:earnListArray forKey:@"earnListArray"];

    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.hotArray=[aDecoder decodeObjectForKey:@"hotArray"];
        self.earnListArray=[aDecoder decodeObjectForKey:@"earnListArray"];
    
    }
    
    return self;
}

@end
/*hotArray;
 @property (nonatomic,strong)NSMutableArray * earnListArray;
*/