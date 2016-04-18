//
//  UploadDocuMentsViewController.h
//  study自定义裁剪Two
//
//  Created by Xse on 15/10/17.
//  Copyright © 2015年 杭州市向淑娥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadDocuMentsViewController;

@protocol UpLoadDocumentsDelegate <NSObject>

- (void)imageCropper:(UploadDocuMentsViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(UploadDocuMentsViewController *)cropperViewController;

@end

@interface UploadDocuMentsViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<UpLoadDocumentsDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
