
#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;

@property (nonatomic, assign) CGFloat boundsX;
@property (nonatomic, assign) CGFloat boundsY;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (NSString *)affineTransformDescription;
- (float)transformScaleY;
- (float)transformAngle;

- (UIImage *)toImage;
- (UIImage *)pb_takeSnapshot;

- (UIImageView *)toImageView;

-(void)transformTo:(CGFloat)radians with:(CATransform3D)transform;
-(void)setAnchorPoint:(CGPoint)point;
-(void)makeShadow;
-(UIColor *) colorOfPoint:(CGPoint)point;
- (BOOL)isLandscape;
- (CGFloat)widthHeightRatio;
@end
