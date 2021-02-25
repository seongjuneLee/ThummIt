//
//  UIImage+Additions.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Additions) <NSCopying>

+ (UIImage *)imageWithView:(UIView *)view;
- (UIImage *)crop:(CGRect)rect;
+ (UIImage *)trimImage:(UIImage *)originalImage;

@end

NS_ASSUME_NONNULL_END
