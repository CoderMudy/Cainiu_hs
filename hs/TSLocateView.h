//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "TSLocation.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray *provinces;
    NSArray	*cities;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic)  UIPickerView *locatePicker;
@property (strong, nonatomic) UIButton *cancelBut;
@property (strong, nonatomic) UIButton *locateBut;
@property (strong, nonatomic) TSLocation *locate;

- (id)initWithTitle:(NSString *)title frame:(CGRect)frame delegate:(id)delegate;

- (void)showInView:(UIView *)view;

@end
