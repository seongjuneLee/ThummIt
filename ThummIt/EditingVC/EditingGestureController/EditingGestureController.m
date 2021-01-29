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
#import "GuideLineManager.h"
#import "UIView+Additions.h"
#import "GuideLine.h"
#import "GuideTarget.h"
@implementation EditingGestureController

-(id)init{
    self = [super init];
    if(self){
        self.top = [[GuideLineView alloc] init];

        self.bottom = [[GuideLineView alloc] init];

        self.leading = [[GuideLineView alloc] init];

        self.trailing = [[GuideLineView alloc] init];
        self.itemDegreeGuides = [NSMutableArray array];
        for (int i = -20; i<20; i++) {
            float criteriaDegrees = i*45;
            [self.itemDegreeGuides addObject:@(criteriaDegrees)];
            
        }


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
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
        }
        [editingVC.layerController bringCurrentItemToFront:editingVC.currentItem];
        [self.delegate readyUIForPanning];
        self.guideLines = [GuideLineManager.sharedInstance criteriasForFrameWithBGView:editingVC.bgView];
        self.itemGuideLines = [GuideLineManager.sharedInstance criteriasForItemFrameWithCurrentItem:editingVC.currentItem withBGView:editingVC.bgView];

    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        if (!editingVC.currentItem) {
            return;
        }
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
        }

        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x,currentPoint.y - self.originalPoint.y);
        
        editingVC.currentItem.baseView.centerX += deltaPoint.x;
        editingVC.currentItem.baseView.centerY += deltaPoint.y;
        [self.delegate deleteImageRespondToCurrentPointY:currentPoint.y];
        self.originalPoint = [sender locationInView:editingVC.gestureView];
        editingVC.currentItem.center = editingVC.currentItem.baseView.center;
        
        [self guideWithDeltaPoint:deltaPoint];
        [self showGuideLineForSituation];

        self.isMagneting = false;


    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (!editingVC.currentItem) {
            return;
        }
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
        }

        [self.delegate panGestureEndedForItem:editingVC.currentItem withFingerPoint:currentPoint];
        if (editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }
        if (!self.isPinching) {
            [SaveManager.sharedInstance save];
        }
        
        for (GuideLine *guideLine in self.guideLines) {
            [guideLine removeFromSuperView];
        }
        for (GuideLine *guideLine in self.itemGuideLines) {
            [guideLine removeFromSuperView];
        }
        self.isMagneting = false;

    }

}

-(void)itemGuideWithDelta:(CGPoint)deltaPoint{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    float padding = 5;
    
    if ((fabs(deltaPoint.x) < 0.4  && fabs(deltaPoint.y) < 0.4)) {
        GuideTarget *target;
        
        for (GuideLine *guideLine in self.itemGuideLines) {
            
            if ([self findClosestTargetWithTargets:guideLine]) {
                target = [self findClosestTargetWithTargets:guideLine];
                if (target.guideTargetType == GuideTargetCenter) {
                    if (fabs(guideLine.dashedGuideLineView.centerX - target.targetPoint.x)<= padding) {
                        editingVC.currentItem.baseView.centerX = guideLine.dashedGuideLineView.centerX;
                        self.isMagneting = true;
                    }
                    if (fabs(guideLine.dashedGuideLineView.centerY - target.targetPoint.y)<= padding) {
                        editingVC.currentItem.baseView.centerY = guideLine.dashedGuideLineView.centerY;
                        self.isMagneting = true;
                    }
                } else if (target.guideTargetType == GuideTargetTopLeft) {
                    
                    if (fabs(guideLine.dashedGuideLineView.centerX - target.targetPoint.x)<= padding) {
                        editingVC.currentItem.baseView.centerX = guideLine.dashedGuideLineView.centerX - 1 + editingVC.currentItem.baseView.frameWidth/2;
                        self.isMagneting = true;
                    }
                    if (fabs(guideLine.dashedGuideLineView.centerY - target.targetPoint.y)<= padding) {
                        editingVC.currentItem.baseView.centerY = guideLine.dashedGuideLineView.centerY - 1 + editingVC.currentItem.baseView.frameHeight/2;
                        self.isMagneting = true;
                    }
                    
                } else if (target.guideTargetType == GuideTargetTopRight){
                    if (fabs(guideLine.dashedGuideLineView.centerX - target.targetPoint.x)<= padding) {
                        editingVC.currentItem.baseView.centerX = guideLine.dashedGuideLineView.centerX - 1 - editingVC.currentItem.baseView.frameWidth/2;
                        self.isMagneting = true;
                    }
                    if (fabs(guideLine.dashedGuideLineView.centerY - target.targetPoint.y)<= padding) {
                        editingVC.currentItem.baseView.centerY = guideLine.dashedGuideLineView.centerY - 1 + editingVC.currentItem.baseView.frameHeight/2;
                        self.isMagneting = true;
                    }
                } else if (target.guideTargetType == GuideTargetBottomLeft){
                    if (fabs(guideLine.dashedGuideLineView.centerX - target.targetPoint.x)<= padding) {
                        editingVC.currentItem.baseView.centerX = guideLine.dashedGuideLineView.centerX - 1 + editingVC.currentItem.baseView.frameWidth/2;
                        self.isMagneting = true;
                    }
                    if (fabs(guideLine.dashedGuideLineView.centerY - target.targetPoint.y)<= padding) {
                        editingVC.currentItem.baseView.centerY = guideLine.dashedGuideLineView.centerY - 1 - editingVC.currentItem.baseView.frameHeight/2;
                        self.isMagneting = true;
                    }
                }
            }
        }
    }
}

-(void)guideWithDeltaPoint:(CGPoint)deltaPoint{
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    float padding = 5;
    CGRect centerXRect = CGRectMake(editingVC.bgView.centerX - padding, editingVC.bgView.frameY, padding*2, editingVC.bgView.frameHeight);
    CGRect leadingRect = CGRectMake(editingVC.bgView.frameX - padding, editingVC.bgView.frameY, padding*2, editingVC.bgView.frameHeight);
    CGRect trailingRect = CGRectMake(editingVC.bgView.frameX + editingVC.bgView.frameWidth - padding, editingVC.bgView.frameY, padding*2, editingVC.bgView.frameHeight);
    
    CGRect centerYRect = CGRectMake(0, editingVC.bgView.centerY -padding, editingVC.bgView.frameWidth, padding*2);
    CGRect bottomYRect = CGRectMake(0, editingVC.bgView.frameY +editingVC.bgView.frameHeight -padding, editingVC.bgView.frameWidth, padding*2);
    CGRect topYRect = CGRectMake(0, editingVC.bgView.frameY -padding, editingVC.bgView.frameWidth, padding*2);
    
    CGPoint center = editingVC.currentItem.baseView.center;
    
    if (!self.isMagneting && (fabs(deltaPoint.x) < 0.4  && fabs(deltaPoint.y) < 0.4)) {
        
        // 센터
        if (CGRectContainsPoint(centerXRect, center)) {
            editingVC.currentItem.baseView.centerX = editingVC.bgView.centerX;
        }
        if (CGRectContainsPoint(centerYRect, center)) {
            editingVC.currentItem.baseView.centerY = editingVC.bgView.centerY;
        }
        CGPoint topRight = CGPointMake(editingVC.currentItem.baseView.frameX + editingVC.currentItem.baseView.frameWidth, editingVC.currentItem.baseView.frameY);
        
        // 탑 오른쪽
        if (CGRectContainsPoint(centerXRect, topRight)) {
            editingVC.currentItem.baseView.centerX = editingVC.bgView.centerX - editingVC.currentItem.baseView.frameWidth/2;
        } else if (CGRectContainsPoint(trailingRect, topRight)) {
            editingVC.currentItem.baseView.centerX = editingVC.bgView.frameX + editingVC.bgView.frameWidth - editingVC.currentItem.baseView.frameWidth/2;
        }
        
        if (CGRectContainsPoint(topYRect, topRight)) {
            editingVC.currentItem.baseView.centerY = editingVC.bgView.frameY + editingVC.currentItem.baseView.frameHeight/2;
        } else if (CGRectContainsPoint(centerYRect, topRight)) {
            editingVC.currentItem.baseView.centerY = editingVC.bgView.centerY + editingVC.currentItem.baseView.frameHeight/2;
        }
        
        // 왼쪽 바텀
        CGPoint leftBottom = CGPointMake(editingVC.currentItem.baseView.frameX, editingVC.currentItem.baseView.frameY + editingVC.currentItem.baseView.frameHeight);
        
        if (CGRectContainsPoint(centerXRect, leftBottom)) {
            //1 중앙
            editingVC.currentItem.baseView.centerX = editingVC.bgView.centerX + editingVC.currentItem.baseView.frameWidth/2;
        } else if (CGRectContainsPoint(leadingRect, leftBottom)) {
            //2 leading
            editingVC.currentItem.baseView.centerX = editingVC.bgView.frameX + editingVC.currentItem.baseView.frameWidth/2;
        }
        // bottom
        if (CGRectContainsPoint(centerYRect, leftBottom)) {
            //1 중앙
            editingVC.currentItem.baseView.centerY = editingVC.bgView.centerY - editingVC.currentItem.baseView.frameHeight/2;
        } else if (CGRectContainsPoint(bottomYRect, leftBottom)) {
            //2 바텀
            editingVC.currentItem.baseView.centerY = editingVC.bgView.frameY +editingVC.bgView.frameHeight - editingVC.currentItem.baseView.frameHeight/2;
        }
        self.isMagneting = true;
    }

}

-(void)showGuideLineForSituation{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    for (GuideLine *guideLine in self.guideLines) {
        if ([self findClosestTargetWithTargets:guideLine]) {
            if (![editingVC.view.subviews containsObject:guideLine.guideLineView]) {
                [editingVC.view addSubview:guideLine.guideLineView];
            }
        } else {
            [guideLine.guideLineView removeFromSuperview];
        }
    }
    
    for (GuideLine *guideLine in self.itemGuideLines) {
        if ([self findClosestTargetWithTargets:guideLine]) {
            if (![editingVC.view.subviews containsObject:guideLine.dashedGuideLineView]) {
                [editingVC.view addSubview:guideLine.dashedGuideLineView];
            }
        } else {
            [guideLine.dashedGuideLineView removeFromSuperview];
        }
    }

}


-(GuideTarget *)findClosestTargetWithTargets:(GuideLine *)guideLine{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    self.shortestDistance = 100000;
    NSMutableArray *targets = [GuideLineManager.sharedInstance frameTargetsWithCurrentItem:editingVC.currentItem];
    GuideTarget *foundGuideTarget;
    for (GuideTarget *guideTarget in targets) {
        if (CGRectContainsPoint(guideLine.guideArea, guideTarget.targetPoint) ) {
            if ([GuideLineManager.sharedInstance distanceBetweenRect:guideLine.guideLineView.frame andPoint:guideTarget.targetPoint] < self.shortestDistance) {
                foundGuideTarget = guideTarget;
                self.shortestDistance = [GuideLineManager.sharedInstance distanceBetweenRect:guideLine.guideLineView.frame andPoint:guideTarget.targetPoint];
            }
        }
    }
    
    
    return foundGuideTarget;
}


-(void)gestureViewPannedForEditingPhotoMode:(EditingMode)editingMode withSender:(UIPanGestureRecognizer *)sender{
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    PhotoFrame *photoFrame = (PhotoFrame *)editingVC.currentItem;
    
    // 아이템 편집 상태
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (!editingVC.currentItem) {
            return;
        }
        
        self.originalPoint = [sender locationInView:photoFrame.baseView];
        self.originalCenter = photoFrame.photoImageView.center;
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        CGPoint fingerPoint = [sender locationInView:photoFrame.baseView];
        
        CGPoint newCenter  = CGPointMake(fingerPoint.x - (self.originalPoint.x - self.originalCenter.x), fingerPoint.y - (self.originalPoint.y - self.originalCenter.y));
        CGPoint photoImageViewOrigin = CGPointMake(newCenter.x - photoFrame.photoImageView.frameWidth/2, newCenter.y - photoFrame.photoImageView.frameHeight/2);
        if (photoImageViewOrigin.x <= 0 && photoFrame.baseView.frameWidth <= newCenter.x + photoFrame.photoImageView.frameWidth/2 ) {
            photoFrame.photoImageView.centerX = newCenter.x;
        }

        if (photoImageViewOrigin.y <= 0 && photoFrame.baseView.frameHeight <= newCenter.y + photoFrame.photoImageView.frameHeight/2 ) {
            photoFrame.photoImageView.centerY = newCenter.y;
        }
        photoFrame.photoCenter = photoFrame.photoImageView.center;
        
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
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
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
        
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
        }

        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);

        // 각도 변경
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(self.currentRotation);
        // 최종 적용
        editingVC.currentItem.baseView.transform = CGAffineTransformConcat(scaleTransform, rotationTransform);
        editingVC.currentItem.rotationDegree = self.currentRotation;
        editingVC.currentItem.scale = self.originalScaleRatio*changeScale;

        [self showDegreeGuideLineWithMagnetWithDeltaDegree:self.currentRotation withScaleTransform:scaleTransform];
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (editingVC.currentItem.isFixedPhotoFrame) {
            return;
        }

        if (editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }
        [SaveManager.sharedInstance save];
        [self removeItemSizeGuideLinesFromSuperView];
        [self.rotationDashedLine removeFromSuperview];
    }
    
}

-(void)showSizeGuideLine{
    
    self.itemSizeGuideLines = [NSMutableArray array];
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    UIView *targetView = editingVC.currentItem.baseView;
    
    self.top.frame = CGRectMake(targetView.frameX, editingVC.currentItem.baseView.frameY, targetView.frameWidth, 2);
    self.bottom.frame = CGRectMake(targetView.frameX, targetView.frameY + targetView.frameHeight, targetView.frameWidth, 2);
    self.leading.frame = CGRectMake(targetView.frameX, targetView.frameY, 2, targetView.frameHeight);
    self.trailing.frame = CGRectMake(targetView.frameX + targetView.frameWidth, targetView.frameY, 2, targetView.frameHeight);
    
    [editingVC.view addSubview:self.top];
    [editingVC.view addSubview:self.bottom];
    [editingVC.view addSubview:self.leading];
    [editingVC.view addSubview:self.trailing];
    if (![self.itemSizeGuideLines containsObject:self.top]) {
        [self.itemSizeGuideLines addObject:self.top];
    }
    if (![self.itemSizeGuideLines containsObject:self.bottom]) {
        [self.itemSizeGuideLines addObject:self.bottom];
    }

    if (![self.itemSizeGuideLines containsObject:self.leading]) {
        [self.itemSizeGuideLines addObject:self.leading];
    }

    if (![self.itemSizeGuideLines containsObject:self.trailing]) {
        [self.itemSizeGuideLines addObject:self.trailing];
    }
    
}

-(void)removeItemSizeGuideLinesFromSuperView{
    
    for (GuideLineView *view in self.itemSizeGuideLines) {
        [view removeFromSuperview];
    }
}

-(void)guideItemSizeWithRotationTransform:(CGAffineTransform)rotation{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    float targetWidth = editingVC.currentItem.baseView.frameWidth;
    float targetHeight = editingVC.currentItem.baseView.frameHeight;
    float padding = 5;
    
    for (GuideLine *guideLine in [GuideLineManager.sharedInstance criteriaseForItemSizeWithBGView:editingVC.bgView]) {
        if ((guideLine.guideSize.width - padding <= targetWidth &&  targetWidth <= guideLine.guideSize.width  + padding) && (guideLine.guideSize.height  - padding <= targetHeight &&  targetHeight <= guideLine.guideSize.height  + padding) ) {
            
            editingVC.currentItem.baseView.transform = CGAffineTransformConcat(rotation, CGAffineTransformMakeScale(guideLine.guideSize.width/targetWidth, guideLine.guideSize.height/targetHeight));
            [self showSizeGuideLine];

        } else {
            [self removeItemSizeGuideLinesFromSuperView];
        }
    }
    
}



-(void)showDegreeGuideLineWithMagnetWithDeltaDegree:(float)currentRadians withScaleTransform:(CGAffineTransform)scaleTransform{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    float padding = 0.1;
    BOOL foundGuide = false;
    for (NSNumber *guideDegree in [self degreesForGuideLine]) {
        float rotationDegree = guideDegree.floatValue;
        float guideRadians = degreesToRadians(rotationDegree);
        if (guideRadians - padding <= currentRadians && currentRadians <= guideRadians + padding) {
            
            if (!self.rotationDashedLine) {
                self.rotationDashedLine = [[DashedGuideLineView alloc] initWithFrame:CGRectMake(0, 0, editingVC.currentItem.baseView.frameWidth, 2)];
                [self.rotationDashedLine makeViewDashed];
                [editingVC.view addSubview:self.rotationDashedLine];
            }
            self.rotationDashedLine.center = editingVC.currentItem.baseView.center;
            self.rotationDashedLine.transform = CGAffineTransformMakeRotation(guideRadians);
            editingVC.currentItem.baseView.transform = CGAffineTransformConcat(scaleTransform, CGAffineTransformMakeRotation(guideRadians));
            foundGuide = true;
            break;
        } else {
            foundGuide = false;
        }
        
    }
    if (!foundGuide) {
        [self.rotationDashedLine removeFromSuperview];
        self.rotationDashedLine = nil;
    }
    
}

-(NSMutableArray *)degreesForGuideLine{
    
    NSMutableArray *degrees = [NSMutableArray array];
    
    for (int i = -20; i < 20; i ++) {
        [degrees addObject:@(i*45)];
    }

    return degrees;
    
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
        self.convertedOriginalPinchCenter = [editingVC.view convertPoint:self.originalPinchCenter toView:photoFrame.photoImageView];

        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        CGAffineTransform t = photoFrame.photoImageView.transform;
        self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
        self.originalPinchDistance = [self distanceFrom:finger1Point to:finger2Point];
        
        self.originalPhotoImageViewRect = photoFrame.photoImageView.frame;

    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        CGPoint finger1Point = [sender locationOfTouch:0 inView:editingVC.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:editingVC.gestureView];
        
        float changedDistance = [self distanceFrom:finger1Point to:finger2Point];
        float changeScale = changedDistance/self.originalPinchDistance;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.originalScaleRatio*changeScale, self.originalScaleRatio*changeScale);
        
        photoFrame.photoImageView.layer.anchorPoint = CGPointMake(self.convertedOriginalPinchCenter.x/self.originalPhotoImageViewRect.size.width, self.convertedOriginalPinchCenter.y/self.originalPhotoImageViewRect.size.height);
        photoFrame.photoImageView.transform = scaleTransform;
        
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:editingVC.view];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        photoFrame.photoImageView.center = changedPoint;


    } else if (sender.state == UIGestureRecognizerStateEnded && sender.numberOfTouches ==2) {
        photoFrame.photoImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
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
