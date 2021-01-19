//
//  UIImage+Additions.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (id) copyWithZone: (NSZone *) zone
{
    return [[UIImage allocWithZone: zone] initWithCGImage: self.CGImage];
}

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}


@end
