

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Additions)

#pragma mark - 그림자

-(void)makeShadow{
    
    self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.7].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 1.0;
    self.clipsToBounds = NO;
    
}


#pragma mark - 트랜스폼 디스크립션

- (NSString *)affineTransformDescription {
    
    // check if it's simply the identity matrix
    if (CGAffineTransformIsIdentity(self.transform)) {
        return @"Is the identity transform";
    }
    // the above does't catch things like a 720° rotation so also check it manually
    if (fabs(self.transform.a  - 1.0) < FLT_EPSILON &&
        fabs(self.transform.b  - 0.0) < FLT_EPSILON &&
        fabs(self.transform.c  - 0.0) < FLT_EPSILON &&
        fabs(self.transform.d  - 1.0) < FLT_EPSILON &&
        fabs(self.transform.tx - 0.0) < FLT_EPSILON &&
        fabs(self.transform.ty - 0.0) < FLT_EPSILON) {
        return @"Is the identity transform";
    }
    
    // The affine transforms is built up like this:
    
    // a b tx
    // c d ty
    // 0 0 1
    
    // An array to hold all the different descirptions, charasteristics of the transform.
    NSMutableArray *descriptions = [NSMutableArray array];
    
    // Checking for a translation
    if (fabs(self.transform.tx) > FLT_EPSILON) { // translation along X
        [descriptions addObject:[NSString stringWithFormat:@"Will move %.2f along the X axis",
                                 self.transform.tx]];
    }
    if (fabs(self.transform.ty) > FLT_EPSILON) { // translation along Y
        [descriptions addObject:[NSString stringWithFormat:@"Will move %.2f along the Y axis",
                                 self.transform.ty]];
    }
    
    
    // Checking for a rotation
    CGFloat angle = atan2(self.transform.b, self.transform.a); // get the angle of the rotation. Note this assumes no shearing!
    if (fabs(angle) < FLT_EPSILON || fabs(angle - M_PI) < FLT_EPSILON) {
        // there is a change that there is a 180° rotation, in that case, A and D will and be negative.
        BOOL bothAreNegative  = self.transform.a < 0.0 && self.transform.d < 0.0;
        
        if (bothAreNegative) {
            angle = M_PI;
        } else {
            angle = 0.0; // this is not considered a rotation, but a negative scale along one axis.
        }
    }
    
    // add the rotation description if there was an angle
    if (fabs(angle) > FLT_EPSILON) {
        [descriptions addObject:[NSString stringWithFormat:@"Will rotate %.1f° degrees",
                                 angle*180.0/M_PI]];
    }
    
    
    // Checking for a scale (and account for the possible rotation as well)
    CGFloat scaleX = self.transform.a/cos(angle);
    CGFloat scaleY = self.transform.d/cos(angle);
    
    
    if (fabs(scaleX - scaleY) < FLT_EPSILON && fabs(scaleX - 1.0) > FLT_EPSILON) {
        // if both are the same then we can format things a little bit nicer
        [descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along both X and Y",
                                 scaleX]];
    } else {
        // otherwise we look at X and Y scale separately
        if (fabs(scaleX - 1.0) > FLT_EPSILON) { // scale along X
            [descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along the X axis",
                                     scaleX]];
        }
        
        if (fabs(scaleY - 1.0) > FLT_EPSILON) { // scale along Y
            [descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along the Y axis",
                                     scaleY]];
        }
    }
    
    if (descriptions.count == 0) {
        return @"Can't easilly be described.";
    }
    
    // join all the descriptions on their own line
    return [descriptions componentsJoinedByString:@",\n"];
}

- (float)transformScaleY{
    
    CGFloat angle = atan2(self.transform.b, self.transform.a);
    if (fabs(angle) < FLT_EPSILON || fabs(angle - M_PI) < FLT_EPSILON) {
        BOOL bothAreNegative  = self.transform.a < 0.0 && self.transform.d < 0.0;
        
        if (bothAreNegative) {
            angle = M_PI;
        } else {
            angle = 0.0;
        }
    }
//    CGFloat scaleX = self.transform.a/cos(angle);
    CGFloat scaleY = self.transform.d/cos(angle);
    
    return scaleY;

}

- (float)transformAngle{
    
    // Checking for a rotation
    CGFloat angle = atan2(self.transform.b, self.transform.a); // get the angle of the rotation. Note this assumes no shearing!
    if (fabs(angle) < FLT_EPSILON || fabs(angle - M_PI) < FLT_EPSILON) {
        // there is a change that there is a 180° rotation, in that case, A and D will and be negative.
        BOOL bothAreNegative  = self.transform.a < 0.0 && self.transform.d < 0.0;
        
        if (bothAreNegative) {
            angle = M_PI;
        } else {
            angle = 0.0; // this is not considered a rotation, but a negative scale along one axis.
        }
    }
    
    return angle;
    
}


#pragma mark - 색 가져오기

- (UIColor *) colorOfPoint:(CGPoint)point{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

#pragma mark - 스크린샷

- (UIImage *)pb_takeSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Geometry Methods

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(newX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(self.frame.origin.x, newY, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}

- (CGPoint)frameOrigin {
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    [self.layer removeAllAnimations];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize.width, newSize.height);
}

- (CGFloat)boundsX {
	return self.bounds.origin.x;
}

- (void)setBoundsX:(CGFloat)newX {
	self.bounds = CGRectMake(newX, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)boundsY {
	return self.bounds.origin.y;
}

- (void)setBoundsY:(CGFloat)newY {
	self.bounds = CGRectMake(self.bounds.origin.x, newY, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)boundsWidth {
	return self.bounds.size.width;
}

- (void)setBoundsWidth:(CGFloat)newWidth {
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, newWidth, self.bounds.size.height);
}

- (CGFloat)boundsHeight {
	return self.bounds.size.height;
}

- (void)setBoundsHeight:(CGFloat)newHeight {
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newHeight);
}

- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterX:(CGFloat)newX {
	self.center = CGPointMake(newX, self.center.y);
}

- (CGFloat)centerY {
	return self.center.y;
}

- (void)setCenterY:(CGFloat)newY {
	self.center = CGPointMake(self.center.x, newY);
}

#pragma mark - Screen Shotting Methods

- (UIImage *)toImage {
	return [self toImageWithSize:self.bounds.size];
}

- (UIImage *)toImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (UIImageView *)toImageView {
	return [self toImageViewWithSize:self.bounds.size];
}


- (UIImageView *)toImageViewWithSize:(CGSize)size {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[self toImageWithSize:size]];
	imageView.frame = CGRectMake(self.frameX, self.frameY, size.width, size.height);
	return imageView;
}


-(void)transformTo:(CGFloat)radians with:(CATransform3D)transform{
    self.layer.transform = CATransform3DRotate(transform, radians, 0, 1, 0);
}

-(void)setAnchorPoint:(CGPoint)point{
    
    CGPoint newPoint = CGPointMake(self.bounds.size.width * point.x, self.bounds.size.height*point.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = point;
}

- (BOOL)isLandscape {
    
    if (self.frame.size.width > self.frame.size.height) {
        return true;
    } else {
        return false;
    }
}

- (CGFloat)widthHeightRatio {
    
    CGFloat ratio = self.bounds.size.height / self.bounds.size.width;
    return ratio;
}

@end
