//
//  InfoDetailHeaderView.h
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^ShowImageBlock)(NSString * showImgUrlStr);

#import <UIKit/UIKit.h>
@class News;
@interface InfoDetailHeaderView : UIView
{
}
@property (copy) ShowImageBlock showImageBlock;
@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * souceLab;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UILabel * readNumLab;
@property (nonatomic,strong)UIImageView * bannerImageV;
- (id)initWithFrame:(CGRect)frame news:(News*)news;

@end
