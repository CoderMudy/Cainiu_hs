//
//  AccountPageCell.h
//  hs
//
//  Created by PXJ on 16/2/23.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountPageCell : UITableViewCell

@property (nonatomic,strong)UIImageView * accountImgView;
@property (nonatomic,strong)UILabel * accountNameLab;
@property (nonatomic,strong)UIImageView * arrowImgV;
@property (nonatomic,strong)UIImageView * posiImgV;
@property (nonatomic,strong)UILabel * showLab;
@property (nonatomic,strong)UILabel * showDetailLab;
@property (nonatomic,strong)UIView * separateLine;
@property (nonatomic,strong)UILabel * loginLab;

- (void)setCellWithStyle:(NSInteger )Style cellDetail:(id)detailInfo;
@end
