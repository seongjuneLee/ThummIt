//
//  EditingGestureController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import "EditingGestureController.h"
#import "EditingViewController.h"
#import "PhotoFrame.h"
#import "ItemManager.h"
#import "SaveManager.h"
@implementation EditingGestureController

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
    
}

-(id)initWithView:(UIView *)view{
    
    self = [super init];
    if(self){
    }
    return self;

}


-(void)addGestureRecognizers{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewTapped:)];
    [editingVC.gestureView addGestureRecognizer:tap];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewPanned:)];
    [editingVC.gestureView addGestureRecognizer:pan];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewPinched:)];
    [editingVC.gestureView addGestureRecognizer:pinch];
    pinch.delegate = self;

    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewRotated:)];
    rotation.delegate = self;
    [editingVC.gestureView addGestureRecognizer:rotation];
    
}

-(void)gestureViewTapped:(UITapGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if ([self getCurrentItem:sender]) {
        if (editingVC.editingModeController.editingMode == NormalMode) {
            [self.delegate didSelectItem:[self getCurrentItem:sender]];
        } else if (editingVC.editingModeController.editingMode == EditingPhotoFrameMode) {
            [self.delegate changeSelectedItem:[self getCurrentItem:sender]];
        }
    }
        
}

-(void)gestureViewPanned:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (editingVC.editingModeController.editingMode == NormalMode) {
            
        [self gestureViewPannedForNormalMode:sender];
        
    } else if (editingVC.editingModeController.editingMode == AddPhotoFrameMode){
        
        [self gestureViewPannedForNormalMode:sender];
        
    } else if(editingVC.editingModeController.editingMode == EditingPhotoFrameMode){
        
        [self gestureViewPannedForEditingPhotoFrameMode:sender];
        
    }
    
}

-(void)gestureViewPannedForNormalMode:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    // 일반 상태
    CGPoint currentPoint = [sender locationInView:editingVC.gestureView];
    CGPoint deltaPoint = CGPointZero;

    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if ([self getCurrentItem:sender]) {
            self.currentItem = [self getCurrentItem:sender];
            self.originalPoint = [sender locationInView:editingVC.gestureView];
            [self.delegate readyUIForPanning];
        } else {
            return;
        }
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x,currentPoint.y - self.originalPoint.y);
        
        if ([self.currentItem isKindOfClass:PhotoFrame.class]) {
            self.currentItem.baseView.centerX += deltaPoint.x;
            self.currentItem.baseView.centerY += deltaPoint.y;
            [self.delegate deleteImageRespondToCurrentPointY:currentPoint.y];
        }
        self.originalPoint = [sender locationInView:editingVC.gestureView];
    } else if (sender.state == UIGestureRecognizerStateEnded){
        [self.delegate panGestureEndedForNoramlMode:self.currentItem withFingerPoint:currentPoint];
        self.currentItem = nil;
    }

}

-(void)gestureViewPannedForEditingPhotoFrameMode:(UIPanGestureRecognizer *)sender{
    
    CGPoint currentPoint = [sender locationInView:self.currentItem.baseView];
    CGPoint deltaPoint = CGPointZero;

    // 아이템 편집 상태
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self getCurrentItem:sender]) {
            self.currentItem = [self getCurrentItem:sender];
            self.originalPoint = [sender locationInView:self.currentItem.baseView];
        } else {
            return;
        }
    } else if (sender.state == UIGestureRecognizerStateChanged){
        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x, currentPoint.y - self.originalPoint.y);

        if ([self.currentItem isKindOfClass:PhotoFrame.class]) {
            self.currentItem.photoImageView.centerX += deltaPoint.x;
            self.currentItem.photoImageView.centerY += deltaPoint.y;
        }
        
        self.originalPoint = [sender locationInView:self.currentItem.baseView];
    } else if (sender.state == UIGestureRecognizerStateEnded){
        self.currentItem = nil;
    }

}

-(void)gestureViewPinched:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (editingVC.editingModeController.editingMode == NormalMode) {
        
        [self gestureViewPinchedInNormalMode:sender];
        
    } else if (editingVC.editingModeController.editingMode == EditingPhotoFrameMode){
        
        [self gestureViewPinchedInEditingPhotoFrameMode:sender];
        
    }
    
}

-(void)gestureViewPinchedInNormalMode:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        
        if ([self getCurrentItemForPinch:sender]) {
            self.currentItem = [self getCurrentItemForPinch:sender];
            self.originalFirstFinger = [sender locationOfTouch:0 inView:self.editingVC.view];
            self.originalSecondFinger = [sender locationOfTouch:1 inView:self.editingVC.view];
            
            self.originalPinchCenter = CGPointMake((self.originalFirstFinger.x+self.originalSecondFinger.x)/2.0, (self.originalFirstFinger.y+self.originalSecondFinger.y)/2.0);
            self.originalItemViewCenter = self.currentItem.baseView.center;
            
            CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
            CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
            
            CGAffineTransform t = self.currentItem.baseView.transform;
            self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
            self.originalPinchDistance = [self distanceFrom:finger1Point to:finger2Point];
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);
        
        // 각도 변경
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(self.currentRotation);
        
        // 최종 적용
        self.currentItem.baseView.transform = CGAffineTransformConcat(scaleTransform, rotationTransform);
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:editingVC.view];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        self.currentItem.baseView.center = changedPoint;
    }
    
}

-(void)gestureViewPinchedInEditingPhotoFrameMode:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        
        if ([self getCurrentItemForPinch:sender]) {
            self.currentItem = [self getCurrentItemForPinch:sender];
            self.originalFirstFinger = [sender locationOfTouch:0 inView:self.currentItem.baseView];
            self.originalSecondFinger = [sender locationOfTouch:1 inView:self.currentItem.baseView];
            
            self.originalPinchCenter = CGPointMake((self.originalFirstFinger.x+self.originalSecondFinger.x)/2.0, (self.originalFirstFinger.y+self.originalSecondFinger.y)/2.0);
            self.originalItemViewCenter = self.currentItem.photoImageView.center;
            
            CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
            CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
            
            CGAffineTransform t = self.currentItem.photoImageView.transform;
            self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
            self.originalPinchDistance = [self distanceFrom:finger1Point to:finger2Point];
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);
        
        // 각도 변경
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(self.currentRotation);
        
        // 최종 적용
        self.currentItem.photoImageView.transform = CGAffineTransformConcat(scaleTransform, rotationTransform);
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:self.currentItem.baseView];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        self.currentItem.photoImageView.center = changedPoint;
    }

}

#pragma mark - 로테이션

-(void)gestureViewRotated:(UIRotationGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2) {
        
        float newRotation = self.lastRotation + sender.rotation;
        self.currentRotation = newRotation;
    } else if(sender.state == UIGestureRecognizerStateEnded){
        
        self.lastRotation = self.currentRotation;
        self.currentItem.rotationDegree = self.lastRotation;
    }
}



#pragma mark - Helper

-(Item *)getCurrentItem:(UIGestureRecognizer*)sender{
    

    CGPoint tappedLocation = [sender locationInView:self.gestureView];
    
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        
        if ([item isKindOfClass:PhotoFrame.class]) {
            PhotoFrame *photoFrame = (PhotoFrame *)item;
            NSLog(@"photoFrame.baseView.frame %@",NSStringFromCGRect(photoFrame.baseView.frame));
            NSLog(@"tappedLocation %@",NSStringFromCGPoint(tappedLocation));
            if (CGRectContainsPoint(photoFrame.baseView.frame, tappedLocation)) {
                return item;
            }
        } else {
            if (CGRectContainsPoint(item.baseView.frame, tappedLocation)) {
                return item;
            }
        }
    }
    return nil;
}

-(Item *)getCurrentItemForPinch:(UIGestureRecognizer *)sender{

    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
    CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];

    CGPoint centerOfFinger = CGPointMake((finger2Point.x + finger1Point.x)/2, (finger1Point.y +finger2Point.y)/2);
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        if ([item isKindOfClass:PhotoFrame.class]) {
            if (CGRectContainsPoint(item.baseView.frame, centerOfFinger)) {
                return item;
            }
        } else {
            if (CGRectContainsPoint(item.baseView.frame, centerOfFinger)) {
                return item;
            }
        }
    }
    return nil;
}

-(BOOL)isImageViewOutOfBounds:(PhotoFrame *)photoFrame{
    
    CGPoint baseViewCenter = photoFrame.baseView.center;
    CGPoint imageViewOrigin = photoFrame.photoImageView.bounds.origin;
    CGSize imageViewSize =photoFrame.photoImageView.frameSize;
    
    
    if (baseViewCenter.x < imageViewOrigin.x // 오른쪽
        || baseViewCenter.y < imageViewOrigin.y // 아래
        || imageViewOrigin.x + imageViewSize.width < baseViewCenter.x // 왼쪽
        || imageViewOrigin.y + imageViewSize.height < baseViewCenter.y) { // 위
        return true;
    }
    return false;
}

-(float)distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}


#pragma mark - 제스쳐 델리게이트

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

@end
