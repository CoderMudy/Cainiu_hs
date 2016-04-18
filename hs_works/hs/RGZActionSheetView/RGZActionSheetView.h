//
//  RGZActionSheetView.h
//  ActionSheet
//
//  Created by 茹高震 on 15/3/17.
//  Copyright (c) 2015年 茹高震. All rights reserved.
//

#import <UIKit/UIKit.h>


/* 简单的自定义ActionSheet
 
 */
@interface RGZActionSheetView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)id  delegate;

-(id)initWithData:(NSMutableArray *)aInfoArray Frame:(CGRect)aFrame  Title:(NSString *)aTitle CancelButtonTitle:(NSString *)aCancelTitle;

@end

@protocol RGZActionSheetDelegate <NSObject>

-(void)clickWithIndex:(NSInteger)aIndex;

@optional

-(void)cancelClick;

@end