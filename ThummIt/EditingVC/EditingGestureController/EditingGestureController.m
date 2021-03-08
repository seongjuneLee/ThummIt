//
//  EditingGestureController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import "EditingGestureController.h"
#import "EditingViewController.h"
#import "EditingViewController+GestureControllerDelegate.h"
#import "ItemCollectionViewController+Button.h"
#import "PhotoFrame.h"
#import "ItemManager.h"
#import "SaveManager.h"
#import "GuideLineManager.h"
#import "GuideLine.h"
#import "UIImage+Additions.h"
#import "GuideTarget.h"
#import "EditingViewController+Buttons.h"
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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5; //seconds
    [editingVC.gestureView addGestureRecognizer:longPress];

}

#pragma mark - 탭

-(void)gestureViewTapped:(UITapGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    if (editingVC.modeController.editingMode == MainFrameOrBGColorMode) {
        return;
    }
    if (editingVC.currentItem) { // 애딩 또는 에디팅 모드일 때 컨텐트 모드 진입
        
        BOOL didTappedCurrentItem = [self didTappedCurrentItem:sender];
        
        if (didTappedCurrentItem) { // 현재 아이템을 탭함
            if ([editingVC.currentItem isKindOfClass:Text.class]) {
                [editingVC.itemCollectionVC textButtonTapped:editingVC.itemCollectionVC.textButton];
            } else if ([editingVC.currentItem isKindOfClass:PhotoFrame.class]){
                [editingVC.itemCollectionVC photoFramePhotoButtonTapped:editingVC.itemCollectionVC.photoFramePhotoButton];
            } else if ([editingVC.currentItem isKindOfClass:Sticker.class]){
               // 해줄 것 없음.
            }
        } else { // 다른 아이템 탭 함.
            if ([editingVC.currentItem isKindOfClass:Text.class]) {
                
            } else if ([editingVC.currentItem isKindOfClass:Sticker.class]){
                
            } else if ([editingVC.currentItem isKindOfClass:PhotoFrame.class]){
                
            }
        }
        
    } else { // 에디팅 모드 진입
        if ([self getCurrentItem:sender]) {
            [editingVC didSelectItem:[self getCurrentItem:sender]];
        }
    }
    
}

#pragma mark - 팬

-(void)gestureViewPanned:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (editingVC.modeController.editingMode == MainFrameOrBGColorMode) {
        return;
    }
    if ([editingVC.currentItem isKindOfClass:PhotoFrame.class] && (editingVC.modeController.editingMode != NormalMode) && editingVC.itemCollectionVC.photoFramePhotoButton.selected) { // 포토 프레임의 이미지뷰 제스쳐
        [self gestureViewPannedForEditingPhotoModeWithSender:sender];
    } else {
        [self gestureViewPannedWithSender:sender];
    }

}

-(void)gestureViewPannedWithSender:(UIPanGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    // 일반 상태
    CGPoint currentPoint = [sender locationInView:editingVC.gestureView];
    CGPoint deltaPoint = CGPointZero;
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalPoint = [sender locationInView:editingVC.gestureView];
        
        if (!editingVC.currentItem && [self getCurrentItem:sender]) {
            editingVC.currentItem = [self getCurrentItem:sender];
        }
        if (!editingVC.currentItem || editingVC.currentItem.isBasePhotoFrame) {
            editingVC.currentItem = nil;
            return;
        }

        [editingVC readyUIForPanning];
        self.guideLines = [GuideLineManager.sharedInstance criteriasForFrameWithBGView:editingVC.bgView];
        self.itemGuideLines = [GuideLineManager.sharedInstance criteriasForItemFrameWithCurrentItem:editingVC.currentItem withBGView:editingVC.bgView];

    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        if (!editingVC.currentItem || editingVC.currentItem.isBasePhotoFrame) {
            return;
        }

        deltaPoint = CGPointMake(currentPoint.x - self.originalPoint.x,currentPoint.y - self.originalPoint.y);
        
        editingVC.currentItem.baseView.centerX += deltaPoint.x;
        editingVC.currentItem.baseView.centerY += deltaPoint.y;
        [editingVC deleteImageRespondToCurrentPointY:currentPoint.y];
        self.originalPoint = [sender locationInView:editingVC.gestureView];
        
        editingVC.currentItem.relativeCenter = CGPointMake( editingVC.currentItem.baseView.centerX/editingVC.bgView.frameWidth, (editingVC.currentItem.baseView.centerY - editingVC.bgView.frameY)/(editingVC.bgView.frameHeight));
        [self guideWithDeltaPoint:deltaPoint];
        [self showGuideLineForSituation];

        self.isMagneting = false;

    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (!editingVC.currentItem || editingVC.currentItem.isBasePhotoFrame) {
            return;
        }
        self.isMagneting = false;
        
        [editingVC panGestureEndedForItem:editingVC.currentItem withFingerPoint:currentPoint];

        for (GuideLine *guideLine in self.guideLines) {
            [guideLine removeFromSuperView];
        }
        [self deleteHueSliderRespondToCurrentPointY:currentPoint.y];
        
        if([editingVC.currentItem isKindOfClass:Text.class]){
            [self deleteKeyBoardRespondToCurrentPointY:currentPoint.y];
        }
        
        if (!self.isPinching) {
            [SaveManager.sharedInstance saveAndAddToStack];
        }

        if (editingVC.modeController.editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }
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
    
    float padding = editingVC.bgView.frameWidth * 5/375;

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
    
//    for (GuideLine *guideLine in self.itemGuideLines) {
//        if ([self findClosestTargetWithTargets:guideLine]) {
//            if (![editingVC.view.subviews containsObject:guideLine.dashedGuideLineView]) {
//                [editingVC.view addSubview:guideLine.dashedGuideLineView];
//            }
//        } else {
//            [guideLine.dashedGuideLineView removeFromSuperview];
//        }
//    }

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


-(void)gestureViewPannedForEditingPhotoModeWithSender:(UIPanGestureRecognizer *)sender{
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
        if (!self.isPinching) {
            photoFrame.photoImageView.centerX = newCenter.x;
            photoFrame.photoImageView.centerY = newCenter.y;
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
    }
    
}

#pragma mark - 핀치

-(void)gestureViewPinched:(UIPinchGestureRecognizer *)sender{
    
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (editingVC.modeController.editingMode == MainFrameOrBGColorMode) {
        return;
    }

    if ([editingVC.currentItem isKindOfClass:PhotoFrame.class] && (editingVC.modeController.editingMode != NormalMode) && editingVC.itemCollectionVC.photoFramePhotoButton.selected) { // 포토 프레임의 이미지뷰 제스쳐
        [self gestureViewPinchedForEditingPhotoModeWithSender:sender];
    } else {
        [self gestureViewPinchedWithSender:sender];
    }
    
}

-(void)gestureViewPinchedWithSender:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        
        if (!editingVC.currentItem && [self getCurrentItem:sender]) {
            editingVC.currentItem = [self getCurrentItem:sender];
        }
        if (!editingVC.currentItem || editingVC.currentItem.isBasePhotoFrame) {
            editingVC.currentItem = nil;
            return;
        }
        self.isPinching = true;
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
        if (editingVC.currentItem.isBasePhotoFrame) {
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

        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:editingVC.view];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        editingVC.currentItem.baseView.center = changedPoint;
        editingVC.currentItem.relativeCenter = CGPointMake(editingVC.currentItem.baseView.centerX/editingVC.bgView.frameWidth, editingVC.currentItem.baseView.centerY/editingVC.bgView.frameHeight);

        [self showDegreeGuideLineWithMagnetWithDeltaDegree:self.currentRotation withScaleTransform:scaleTransform];
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if (editingVC.currentItem.isBasePhotoFrame) {
            return;
        }

        self.isPinching = false;
        [self removeItemSizeGuideLinesFromSuperView];
        [self.rotationDashedLine removeFromSuperview];
        
        [SaveManager.sharedInstance saveAndAddToStack];
        if (editingVC.modeController.editingMode == NormalMode) {
            editingVC.currentItem = nil;
        }

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


-(void)gestureViewPinchedForEditingPhotoModeWithSender:(UIPinchGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    PhotoFrame *photoFrame = (PhotoFrame *)editingVC.currentItem;
    
    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        if (!editingVC.currentItem) {
            return;
        }
        self.isPinching = true;

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
                
        photoFrame.photoImageView.transform = scaleTransform;

        
        photoFrame.photoScale = self.originalScaleRatio*changeScale;
        
        // 중심값 이동
        CGPoint newPinchCenter = [sender locationInView:photoFrame.baseView];
        float translationX = newPinchCenter.x - self.originalPinchCenter.x;
        float translationY = newPinchCenter.y - self.originalPinchCenter.y;
        
        // 센터가이드 적용
        CGPoint changedPoint = CGPointMake(self.originalItemViewCenter.x + translationX, self.originalItemViewCenter.y + translationY);
        photoFrame.photoImageView.center = changedPoint;
        photoFrame.photoCenter = changedPoint;


    } else if (sender.state == UIGestureRecognizerStateEnded) {
        self.isPinching = false;
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

#pragma mark - 롱탭

-(void)handleLongPress:(UILongPressGestureRecognizer*)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.editingItemLayerVC handleLongPress:sender];
    
}



#pragma mark - Helper

-(void)deleteHueSliderRespondToCurrentPointY:(float)currentPointY{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    float imageViewBottomY = editingVC.bgView.frameY + editingVC.bgView.frameHeight;
    if (currentPointY > imageViewBottomY && editingVC.currentItem.canChangeColor) {
        [UIView animateWithDuration:0.2 animations:^{
            editingVC.hueSlider.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [editingVC hideAndInitSlider];
        }];
    }
}

-(void)deleteKeyBoardRespondToCurrentPointY:(float)currentPointY{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    if ([editingVC.currentItem isKindOfClass:Text.class] && editingVC.itemCollectionVC.textButton.selected) {
        [editingVC.currentText.textView becomeFirstResponder];
    }
    
}



-(BOOL)didTappedCurrentItem:(UIGestureRecognizer *)sender{
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    CGPoint tappedLocation = [sender locationInView:self.gestureView];
    if (CGRectContainsPoint(editingVC.currentItem.baseView.frame, tappedLocation)) {
        return true;
    }
    
    return false;
}

-(Item *)getCurrentItem:(UIGestureRecognizer*)sender{
    
    CGPoint tappedLocation = [sender locationInView:self.gestureView];
    NSMutableArray *foundItems = [NSMutableArray new];
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        if (CGRectContainsPoint(item.baseView.frame, tappedLocation)) {
            [foundItems addObject:item];
        }
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSArray *sortedArray = [foundItems sortedArrayUsingComparator:^NSComparisonResult(Item *a, Item *b) {
        NSNumber *first = [formatter numberFromString:a.indexInLayer];
        NSNumber *second = [formatter numberFromString:b.indexInLayer];
        return [first compare:second];
    }];

    
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

