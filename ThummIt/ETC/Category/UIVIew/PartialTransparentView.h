//
//  PartialTransparentView.h
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartialTransparentView : UIView


@property (strong, nonatomic) NSArray *rectsArray;
@property (strong, nonatomic) UIColor *backgroundColor;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects;

@end

NS_ASSUME_NONNULL_END
