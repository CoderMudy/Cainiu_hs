//
//  SecondCell.m
//  EGOTableViewPullRefreshDemo
//
//  Created by gg on 15/5/8.
//
//

#import "SecondCell.h"

@implementation SecondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clickBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.clickBut setBackgroundColor:[UIColor blueColor]];
        [self.clickBut setFrame:CGRectMake(0, 0, 80, 80)];
        [self.clickBut addTarget:self action:@selector(clickCellBut) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.clickBut];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self getIndexPath];
}

- (void)setDelegate:(id<SecondCellDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setDict:(NSDictionary *)dict
{
    NSString *textString = (NSString *)dict;
    [self.clickBut setTitle:textString forState:UIControlStateNormal];
}

- (void)clickCellBut
{
    [self.delegate clickCellBut:self.clickBut indexPath:[self getIndexPath]];
}


@end
