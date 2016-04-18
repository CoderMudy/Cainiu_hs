//
//  FoyerDrawView.m
//  hs
//
//  Created by PXJ on 15/12/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FoyerDrawView.h"

@implementation FoyerDrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
-(id)initWithFrame:(CGRect)frame
{
    if (self ==[super initWithFrame:frame]) {
    }
    return self;
}
-(void)foyerDraw:(id)sender;
{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    NSArray * drawArray = @[@"12",@"13",@"16",@"11",@"18",@"9",@"17",@"10",@"35",@"30",@"26",@"30",@"18",@"22",@"17",@"16"];
    CGFloat height =0;
    CGFloat low = 0;
    CGFloat length = self.frame.size.width/drawArray.count;
    
    CGRect rectBounds  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rectBounds);
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, 0.8f);
    CGContextSetStrokeColorWithColor(context, RGBACOLOR(250, 66, 0, 1).CGColor);
    
    for (int i=0; i<drawArray.count-1; i++) {
        CGContextMoveToPoint(context, i*length,self.frame.size.height-([drawArray[i] floatValue]-10)*self.frame.size.height/25);
        CGContextAddLineToPoint(context, (i+1)*length, self.frame.size.height-([drawArray[i+1] floatValue]-10)*self.frame.size.height/25);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
