//
//  RGZActionSheetView.m
//  ActionSheet
//
//  Created by 茹高震 on 15/3/17.
//  Copyright (c) 2015年 茹高震. All rights reserved.
//

#import "RGZActionSheetView.h"
#define HeaderDividers if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {[cell setSeparatorInset:UIEdgeInsetsZero];}if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {[cell setLayoutMargins:UIEdgeInsetsZero];}if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){[cell setPreservesSuperviewLayoutMargins:NO];}

#define rowHeight 54

#define Spacing 2
@implementation RGZActionSheetView
{
    UITableView *_tableView;
    
    NSMutableArray *_infoArray;
    
    NSString       *_title;
    
    NSString       *_cancelTitle;
}
-(id)initWithData:(NSMutableArray *)aInfoArray Frame:(CGRect)aFrame  Title:(NSString *)aTitle CancelButtonTitle:(NSString *)aCancelTitle
{
    self=[super initWithFrame:aFrame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _infoArray=aInfoArray;
        _title=aTitle;
        _cancelTitle=aCancelTitle;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:view];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
        [view addGestureRecognizer:tap];
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, (1+_infoArray.count)*rowHeight+rowHeight+Spacing*2) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
        [self addSubview:_tableView];
        
        
        
        [self showTable];
    }
    
    return self;
}



-(void)showTable
{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _tableView.frame=CGRectMake(0, self.frame.size.height-(_infoArray.count+1)*rowHeight-rowHeight-Spacing*2, self.frame.size.width, (1+_infoArray.count)*rowHeight+rowHeight+Spacing*2);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return _infoArray.count+1;
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.5;
    }
    return Spacing;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Spacing;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    HeaderDividers
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, rowHeight)];
            titleLabel.text=_title;
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont boldSystemFontOfSize:17];
            titleLabel.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            [cell addSubview:titleLabel];
        }
        else
        {
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, rowHeight)];
            titleLabel.text=_infoArray[indexPath.row-1];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:20];
            titleLabel.textColor=[UIColor colorWithRed:0/255.0 green:121/255.0 blue:252/255.0 alpha:1];
            [cell addSubview:titleLabel];
        }
    }
    else
    {
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, rowHeight)];
        titleLabel.text=_cancelTitle;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=[UIColor redColor];
        titleLabel.font=[UIFont systemFontOfSize:20];
        [cell addSubview:titleLabel];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return;
        }
        else
        {
            [self.delegate clickWithIndex:indexPath.row-1];
        }
    }
    if (indexPath.section==1) {
        if ([self.delegate respondsToSelector:@selector(cancelClick)]) {
            [self.delegate cancelClick];
        }
    }
    [self hideView];
}



-(void)hideView
{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tableView.frame= CGRectMake(0, self.frame.size.height, self.frame.size.width, (1+_infoArray.count)*rowHeight+rowHeight+Spacing*2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
