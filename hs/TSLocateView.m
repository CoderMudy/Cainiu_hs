//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locatePicker;
@synthesize locate;

- (id)initWithTitle:(NSString *)title frame:(CGRect)frame delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:RGBACOLOR(235, 235, 241, 1)];
        self.delegate = delegate;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
//        [self.titleLabel setBackgroundColor:RGBACOLOR(235, 235, 241, 1)];
        self.titleLabel.text = title;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"bg_023.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]]];
        [self addSubview:self.titleLabel];
        
//        UIImage *cancelImage = [UIImage imageNamed:@"btn_021.png"];
//        self.cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.cancelBut setFrame:CGRectMake(0, 0, cancelImage.size.width, cancelImage.size.height)];
//        [self.cancelBut setImage:cancelImage forState:UIControlStateNormal];
//        [self.cancelBut addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.cancelBut];
        
        UIImage *locateImage = [UIImage imageNamed:@"btn_020.png"];
        self.locateBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locateBut setFrame:CGRectMake(self.frame.size.width-locateImage.size.width-15, 0, locateImage.size.width, locateImage.size.height)];
//        [self.locateBut setImage:locateImage forState:UIControlStateNormal];
        [self.locateBut setTitle:@"确定" forState:UIControlStateNormal];
        self.locateBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.locateBut addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.locateBut];
        
        
        self.locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, self.frame.size.height-40)];
        [self addSubview:self.locatePicker];
        self.locatePicker.backgroundColor = RGBACOLOR(235, 235, 241, 1);
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
        
        //初始化默认数据
        self.locate = [[TSLocation alloc] init];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"State"];
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    self.tag = 10000;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            
            self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"State"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (void)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
