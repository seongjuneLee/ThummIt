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
    if (editingVC.modeController.editingMode == NormalMode) {
        if ([self getCurrentItem:sender]) {
            [self.delegate didSelectItem:[self getCurrentItem:sender]];
        }
    } else if (editingVC.modeController.editingMode == AddingPhotoFrameMode) {
        [self.delegate didTapPhotoFrameWhileAdding];
    } else if (editingVC.modeController.editingMode == EditingPhotoFrameMode) {
        if ([self getCurrentItem:sender]) {
            [self.delegate changeCurrentItem:[self getCurrentItem:sender]];
        }
    } else if (editingVC.modeController.editingMode == AddingTextMode){
        [self.delegate didTapTextWhileAdding];
    }
    
}

-(void)gestureViewPanned:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (editingVC.modeController.editingMode == NormalMode) {
            
        [self gestureViewPannedForMode:NormalMode withSender:sender];
        
    } else if (editingVC.modeController.editingMode == AddingPhotoFrameMode){
        
        [self gestureViewPannedForMode:AddingPhotoFrameMode withSender:sender];
        
    } else if(editingVC.modeController.editingMode == AddingTextMode){
        
        [self gestureViewPannedForMode:AddingTextMode withSender:sender];
        
    } else if(editingVC.modeController.editingMode == AddingStickerMode){
        
        [self gestureViewPannedForMode:AddingStickerMode withSender:sender];
        
    } else if(editingVC.modeController.editingMode == EditingPhotoFrameModeWhileAddingPhotoFrameMode){
        
        [self gestureViewPannedForEditingPhotoMode:EditingPhotoFrameModeWhileAddingPhotoFrameMode withSender:sender];

    } else if(editingVC.modeController.editingMode == EditingPhotoFrameMode){
        
        [self gestureViewPannedForEditingPhotoMode:EditingPhotoFrameMode withSender:sender];
        
    }
    
}

-(void)gestureViewPannedForMode:(EditingMode)editingMode withSender:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    // 일반 상태
    CGPoint currentPoint = [sender locationInView:editingVC.gestureView];
    CGPoint deltaPoint = CGPointZero;

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalPoint = [sender locationInView:editingVC.gestureView];

        if (editingMode == NormalMode) {
            if ([self getCurrentItem:sender]) {
                editingVC.currentItem =[self getCurrentItem:sender];
            } else {
                return;
            }
        } else {
            if (!editingVC.currentItem) {
                return;
            }
        }
        [editingVC.layerController bringCurrentItemToFront:editingVC.currentItem];
        [self.delegate readyUIForPanning];

        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        if (!editingVC.currentItem) {
            return;
        }
        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x,currentPoint.y - self.originalPoint.y);
        
        editingVC.currentItem.baseView.centerX += deltaPoint.x;
        editingVC.currentItem.baseView.centerY += deltaPoint.y;
        [self.delegate deleteImageRespondToCurrentPointY:currentPoint.y];
        self.originalPoint = [sender locationInView:editingVC.gestureView];
        editingVC.currentItem.center = editingVC.currentItem.baseView.center;
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (!editingVC.currentItem) {
            return;
        }
        [self.delegate panGestureEndedForItem:editingVC.currentItem withFingerPoint:currentPoint];
        if (editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }
        if (!self.isPinching) {
            [SaveManager.sharedInstance save];
        }

    }

}

-(void)gestureViewPannedForEditingPhotoMode:(EditingMode)editingMode withSender:(UIPanGestureRecognizer *)sender{
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    CGPoint currentPoint = [sender locationInView:editingVC.currentItem.baseView];
    CGPoint deltaPoint = CGPointZero;

    // 아이템 편집 상태
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (!editingVC.currentItem) {
            return;
        }
        self.originalPoint = [sender locationInView:editingVC.currentItem.baseView];

    } else if (sender.state == UIGestureRecognizerStateChanged){
        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x, currentPoint.y - self.originalPoint.y);

        if ([editingVC.currentItem isKindOfClass:PhotoFrame.class]) {
            PhotoFrame *photoFrame = (PhotoFrame *)editingVC.currentItem;
            photoFrame.photoImageView.centerX += deltaPoint.x;
            photoFrame.photoImageView.centerY += deltaPoint.y;
            photoFrame.photoCenter = photoFrame.photoImageView.center;
        }
        self.originalPoint = [sender locationInView:editingVC.currentItem.baseView];
    } else if (sender.state == UIGestureRecognizerStateEnded){

    }

}

-(void)gestureViewPinched:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (editingVC.modeController.editingMode == NormalMode) {
        
        [self gestureViewPinchedForMode:NormalMode withSender:sender];
        
    } else if (editingVC.modeController.editingMode == AddingPhotoFrameMode){
        
        [self gestureViewPinchedForMode:AddingPhotoFrameMode withSender:sender];

    } else if (editingVC.modeController.editingMode == AddingTextMode){
        
        [self gestureViewPinchedForMode:AddingTextMode withSender:sender];

    } else if (editingVC.modeController.editingMode == AddingStickerMode){
        
        [self gestureViewPinchedForMode:AddingStickerMode withSender:sender];

    } else if (editingVC.modeController.editingMode == EditingPhotoFrameModeWhileAddingPhotoFrameMode){
        
        [self gestureViewPinchedForEditingPhotoMode:EditingPhotoFrameModeWhileAddingPhotoFrameMode withSender:sender];
        
    }
    else if (editingVC.modeController.editingMode == EditingPhotoFrameMode){
        
        [self gestureViewPinchedForEditingPhotoMode:EditingPhotoFrameMode withSender:sender];

    }
    
}

-(void)gestureViewPinchedForMode:(EditingMode)editingMode withSender:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        if (editingMode == NormalMode) {
            if ([self getCurrentItem:sender]) {
                editingVC.currentItem =[self getCurrentItem:sender];
            } else {
                return;
            }
        } else {
            if (!editingVC.currentItem) {
                return;
            }
        }
        self.isPinching = true;
        [editingVC.layerController bringCurrentItemToFront:editingVC.currentItem];
        self.originalFirstFinger = [sender locationOfTouch:0 inView:self.editingVC.view];
        self.originalSecondFinger = [sender locationOfTouch:1 inView:self.editingVC.view];
        
        self.originalPinchCenter = CGPointMake((self.originalFirstFinger.x+self.originalSecondFinger.x)/2.0, (self.originalFirstFinger.y+self.originalSecondFinger.y)/2.0);
        self.originalItemViewCenter = editingVC.currentItem.baseView.center;
        
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        CGAffineTransform t = editingVC.currentItem.baseView.transform;
        self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
        self.originalPinchDistance = [self distanceFrom:finger1Point to:finger2Point];
        
        
    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);
        editingVC.currentItem.scale = self.originalScaleRatio*changeScale;

        // 각도 변경
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(self.currentRotation);
        editingVC.currentItem.rotationDegree = self.currentRotation;
        // 최종 적용
        editingVC.currentItem.baseView.transform = CGAffineTransformConcat(scaleTransform, rotationTransform);
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:editingVC.view];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        editingVC.currentItem.baseView.center = changedPoint;
        editingVC.currentItem.center = changedPoint;
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }
        [SaveManager.sharedInstance save];

    }
    
}

-(void)gestureViewPinchedForEditingPhotoMode:(EditingMode)editingMode withSender:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    PhotoFrame *photoFrame = (PhotoFrame *)editingVC.currentItem;

    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        if (!editingVC.currentItem) {
            return;
        }
        self.originalFirstFinger = [sender locationOfTouch:0 inView:editingVC.currentItem.baseView];
        self.originalSecondFinger = [sender locationOfTouch:1 inView:editingVC.currentItem.baseView];
        
        self.originalPinchCenter = CGPointMake((self.originalFirstFinger.x+self.originalSecondFinger.x)/2.0, (self.originalFirstFinger.y+self.originalSecondFinger.y)/2.0);
        self.originalItemViewCenter = photoFrame.photoImageView.center;
        
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        CGAffineTransform t = photoFrame.photoImageView.transform;
        self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
        self.originalPinchDistance = [self distanceFrom:finger1Point to:finger2Point];
        
        
    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);
        
        // 각도 변경
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(self.currentRotation);
        
        // 최종 적용
        photoFrame.photoImageView.transform = CGAffineTransformConcat(scaleTransform, rotationTransform);
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:editingVC.currentItem.baseView];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        photoFrame.photoImageView.center = changedPoint;
        photoFrame.photoCenter = changedPoint;
        photoFrame.photoScale = self.originalScaleRatio*changeScale;
        photoFrame.photoRotationDegree = self.currentRotation;
    }

}

#pragma mark - 로테이션

-(void)gestureViewRotated:(UIRotationGestureRecognizer*)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2) {
        
        float newRotation = self.lastRotation + sender.rotation;
        self.currentRotation = newRotation;
    } else if(sender.state == UIGestureRecognizerStateEnded){
        
        self.lastRotation = self.currentRotation;
        editingVC.currentItem.rotationDegree = self.lastRotation;
    }
}



#pragma mark - Helper

-(Item *)getCurrentItem:(UIGestureRecognizer*)sender{
    
    
    CGPoint tappedLocation = [sender locationInView:self.gestureView];
    NSMutableArray *foundItems = [NSMutableArray new];
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        if (CGRectContainsPoint(item.baseView.frame, tappedLocation)) {
            [foundItems addObject:item];
        }
    }
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexInLayer" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [foundItems sortedArrayUsingDescriptors:descriptors];
    return sortedArray.lastObject;
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
