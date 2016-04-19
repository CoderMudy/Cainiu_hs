//
//  IndexOrderChooseButton.m
//  hs
//
//  Created by RGZ on 16/4/11.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexOrderChooseButton.h"

@implementation IndexOrderChooseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundColor = Color_Gold;
        self.bgButton.clipsToBounds = YES;
        self.bgButton.layer.cornerRadius = 3;
        self.bgButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bgButton setTitle:@"请设置委托条件" forState:UIControlStateNormal];
        [self.bgButton addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
        UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 10, self.frame.size.height - 12, 5, 5)];
        signLabel.text = @"◢";
        signLabel.textColor = [UIColor blackColor];
        signLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:signLabel];
    }
    
    return self;
}

-(void)chooseBtnClick{
    self.indexOrderChooseButtonBlock();
}

@end
