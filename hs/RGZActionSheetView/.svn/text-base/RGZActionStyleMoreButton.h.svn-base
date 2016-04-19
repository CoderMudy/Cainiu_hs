//
//  RGZActionStyleMoreButton.h
//  ActionSheet
//
//  Created by 茹高震 on 15/3/19.
//  Copyright (c) 2015年 茹高震. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGZActionStyleMoreButton : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)id  delegate;

-(id)initWithData:(NSMutableArray *)aInfoArray Frame:(CGRect)aFrame  Title:(NSString *)aTitle CancelButtonTitle:(NSString *)aCancelTitle choosedButtonIndex:(NSMutableArray *)aChooseArray;

@end

@protocol RGZActionStyleDelegate <NSObject>

-(void)clickWithIndex:(NSInteger)aIndex;

@optional

-(void)cancelClick;

-(void)otherPlaceClick;

@end
