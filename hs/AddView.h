//
//  AddView.h
//  TheOne
//
//  Created by PXJ on 15/10/20.
//  Copyright © 2015年 PXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddView : UIView
{
}
@property (nonatomic,strong)UIImageView * imageV;
@property (nonatomic,strong)UILabel * dscLab;
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName dsc:(NSString * )dsc;
@end
