//
//  RGZActionStyleMoreButton.m
//  ActionSheet
//
//  Created by 茹高震 on 15/3/19.
//  Copyright (c) 2015年 茹高震. All rights reserved.
//

#import "RGZActionStyleMoreButton.h"
#define HeaderDividers if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {[cell setSeparatorInset:UIEdgeInsetsZero];}if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {[cell setLayoutMargins:UIEdgeInsetsZero];}if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){[cell setPreservesSuperviewLayoutMargins:NO];}

#define rowHeight 54

#define Spacing 2
@implementation RGZActionStyleMoreButton
{
    UITableView *_tableView;
    
    NSMutableArray *_infoArray;
    
    NSString       *_title;
    
    NSString       *_cancelTitle;
    
    NSMutableArray *_chooseButtonIndexArray;
    
    UIButton       *_selectButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithData:(NSMutableArray *)aInfoArray Frame:(CGRect)aFrame  Title:(NSString *)aTitle CancelButtonTitle:(NSString *)aCancelTitle choosedButtonIndex:(NSMutableArray *)aChooseArray
{
    self=[super initWithFrame:aFrame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _infoArray=aInfoArray;
        _title=aTitle;
        _cancelTitle=aCancelTitle;
        _chooseButtonIndexArray=aChooseArray;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:view];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(willHideView)];
        [view addGestureRecognizer:tap];
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, (1+_infoArray.count/3)*rowHeight+rowHeight+Spacing*2) style:UITableViewStyleGrouped];
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
        _tableView.frame=CGRectMake(0, self.frame.size.height-(_infoArray.count/3+1)*rowHeight-rowHeight-Spacing*2, self.frame.size.width, (1+_infoArray.count/3)*rowHeight+rowHeight+Spacing*2);
        
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
        return (_infoArray.count/3)+1;
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
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
            titleLabel.font=[UIFont systemFontOfSize:17];
            titleLabel.textColor=[UIColor lightGrayColor];
//            titleLabel.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            [cell addSubview:titleLabel];
        }
        else
        {
            for (int i=0; i<_infoArray.count; i++) {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"choose_select_on"] forState:UIControlStateSelected];
//                [button setBackgroundImage:[UIImage imageNamed:@"choose_select_off"] forState:UIControlStateNormal];
                button.frame=CGRectMake(self.frame.size.width/3*i+10, 10, self.frame.size.width/3-20, 54-20);
                button.tag=((indexPath.row-1)*3)+(i);
                button.layer.cornerRadius=18;
                button.clipsToBounds=YES;
                for (NSString *indexStr in _chooseButtonIndexArray) {
                    if ([indexStr integerValue]==button.tag) {
                        button.selected=YES;
                        _selectButton=button;
                    }
                }
                
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:_infoArray[(indexPath.row-1)*3+(i) ] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
            
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

-(void)buttonClick:(UIButton *)button
{
    for (int i = 0; i<button.superview.subviews.count; i++) {
        if ([button.superview.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = button.superview.subviews[i];
            btn.selected = NO;
        }
    }
    
    button.selected = YES;
    
    _selectButton=button;
    
//    if (button.selected==YES) {
//        button.selected=NO;
//    }
//    else
//    {
//        _selectButton.selected=NO;
//        
//        button.selected=YES;
//
//        _selectButton=button;
//    }
    
    if ([self.delegate respondsToSelector:@selector(clickWithIndex:)]) {
        [self.delegate clickWithIndex:button.tag];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
            return;
    }
    if (indexPath.section==1) {
        [self.delegate cancelClick];
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

-(void)willHideView
{
    if ([self.delegate respondsToSelector:@selector(otherPlaceClick)]) {
        [self.delegate otherPlaceClick];
    }
    
    [self hideView];
}

@end
