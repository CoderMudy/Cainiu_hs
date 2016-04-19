//
//  SecondCell.h
//  EGOTableViewPullRefreshDemo
//
//  Created by gg on 15/5/8.
//
//

#import <UIKit/UIKit.h>
#import "HSTableViewCell.h"

@protocol SecondCellDelegate <NSObject>

- (void)clickCellBut:(UIButton *)but indexPath:(NSIndexPath *)indexPath;

@end

@interface SecondCell : HSTableViewCell

@property (nonatomic, assign)id<SecondCellDelegate>delegate;

@property (nonatomic, strong)UIButton *clickBut;

@end
