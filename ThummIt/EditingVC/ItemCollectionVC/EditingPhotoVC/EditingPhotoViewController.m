//
//  EditingPhotoViewController.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "EditingPhotoViewController.h"
#import "EditingViewController.h"
#import "EditingViewController+Buttons.h"
#import "UIView+Additions.h"
@interface EditingPhotoViewController ()

@end

@implementation EditingPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated{
    [UndoManager.sharedInstance initUndoRedoForEditingPhoto];
}


-(void)dismissSelf{
        
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.photoLoaded = false;
        [self.photoImageView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}

-(void)viewDidLayoutSubviews{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    UIImage *photoImage = self.photoImageView.image;
    if (photoImage && !self.photoLoaded) {
        self.photoLoaded = true;
        float ratio = photoImage.size.height/photoImage.size.width;
        float photoImageViewWidth = self.contentView.frameWidth * 0.9;
        float photoImageViewHeight = self.contentView.frameHeight * 0.9;
        if (ratio < 1) {
            self.photoImageView.frameSize = CGSizeMake (photoImageViewWidth, photoImageViewWidth*ratio);
        } else {
            self.photoImageView.frameSize = CGSizeMake (photoImageViewHeight * 1/ratio, photoImageViewHeight);
        }
        self.photoImageView.center = CGPointMake( self.contentView.centerX,  self.contentView.centerY - editingVC.editingPhotoButtonVC.view.frameHeight);
        self.originalCenter = self.photoImageView.center;
        [UndoManager.sharedInstance addCurrentPhotoToStack:photoImage];
        
    }
    
}

-(void)addGestureRecognizers{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewPanned:)];
    pan.delegate = self;
    [self.gestureView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewPinched:)];
    pinch.delegate = self;
    [self.gestureView addGestureRecognizer:pinch];
    
}

-(void)gestureViewPanned:(UIGestureRecognizer *)sender {
    
    UIImageView *photoImageView = self.photoImageView;
    if (self.includeButton.selected || self.eraseButton.selected) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            CGAffineTransform t = photoImageView.transform;
            float scale = sqrt(t.a * t.a + t.c * t.c);
            CGPoint convertedPoint = [self.gestureView convertPoint:[sender locationInView:self.gestureView] toView:self.photoImageView];
            float widthRatio = photoImageView.image.size.width/photoImageView.frameWidth;
            float heightRatio = photoImageView.image.size.height/photoImageView.frameHeight;
            self.lastPoint = CGPointMake(convertedPoint.x * widthRatio * scale, convertedPoint.y * heightRatio * scale);
            
        } else if (sender.state == UIGestureRecognizerStateChanged){
            
            CGPoint convertedPoint = [self.gestureView convertPoint:[sender locationInView:self.gestureView] toView:self.photoImageView];
            CGAffineTransform t = photoImageView.transform;
            float scale = sqrt(t.a * t.a + t.c * t.c);
            
            float widthRatio = photoImageView.image.size.width/photoImageView.frameWidth;
            float heightRatio = photoImageView.image.size.height/photoImageView.frameHeight;
            CGPoint currentPoint = CGPointMake(convertedPoint.x * widthRatio * scale, convertedPoint.y * heightRatio * scale);
            UIGraphicsBeginImageContext(photoImageView.image.size);
            [photoImageView.image drawInRect:CGRectMake(0, 0, photoImageView.image.size.width, photoImageView.image.size.height)];
            
            // I add this
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.lastPoint = currentPoint;
            
        } else if (sender.state == UIGestureRecognizerStateEnded){
            
            [UndoManager.sharedInstance addCurrentPhotoToStack:photoImageView.image];
            
        }
        
        
    } else {
        // 아이템 편집 상태
        if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches == 1) {
            
            self.originalPoint = [sender locationInView:self.gestureView];
            self.originalCenter = photoImageView.center;
            
        } else if (sender.state == UIGestureRecognizerStateChanged  && sender.numberOfTouches == 1){
            
            CGPoint fingerPoint = [sender locationInView:self.gestureView];
            
            CGPoint newCenter  = CGPointMake(fingerPoint.x - (self.originalPoint.x - self.originalCenter.x), fingerPoint.y - (self.originalPoint.y - self.originalCenter.y));
            photoImageView.centerX = newCenter.x;
            photoImageView.centerY = newCenter.y;
            
            } else if (sender.state == UIGestureRecognizerStateEnded){
                
            }
    }
    
}

-(void)gestureViewPinched:(UIPinchGestureRecognizer *)sender {
    UIImageView *photoImageView = self.photoImageView;
    if (sender.state == UIGestureRecognizerStateBegan && sender.numberOfTouches ==2) {
        CGPoint finger1Point = [sender locationOfTouch:0 inView:self.gestureView];
        CGPoint finger2Point = [sender locationOfTouch:1 inView:self.gestureView];
        
        CGAffineTransform t = photoImageView.transform;
        self.originalScaleRatio = sqrt(t.a * t.a + t.c * t.c);
        CGPoint originalPinchCenter = CGPointMake((finger1Point.x+finger2Point.x)/2.0, (finger1Point.y+finger2Point.y)/2.0);
        self.originalItemViewCenter = photoImageView.center;
        CGPoint convertedPinchCenter = CGPointMake([self.gestureView convertPoint:originalPinchCenter toView:self.photoImageView].x*self.originalScaleRatio, [self.gestureView convertPoint:originalPinchCenter toView:self.photoImageView].y*self.originalScaleRatio) ;
        CGPoint anchorPoint = CGPointMake(convertedPinchCenter.x/self.photoImageView.frameWidth, convertedPinchCenter.y/self.photoImageView.frameHeight);
        [self.photoImageView setAnchorPoint:anchorPoint];
        
    } else if (sender.state == UIGestureRecognizerStateChanged && sender.numberOfTouches == 2){
        float scale = self.originalScaleRatio *sender.scale;

        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale,scale);
        photoImageView.transform = scaleTransform;
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
    }
}

-(float)distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}


#pragma mark - buttons

- (IBAction)editButtonTapped:(id)sender {
}

- (IBAction)photoButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [self dismissSelf];
    [editingVC.editingPhotoButtonVC dismissSelf];
    
    [editingVC.albumVC showWithAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        [editingVC.view layoutIfNeeded];
    }];
    
}

- (IBAction)closeButtonTapped:(id)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.editingPhotoButtonVC dismissSelf];
    [editingVC.albumVC dismissSelf];
    [self dismissSelf];
    [editingVC.layerController hideTransparentView];
    
    [editingVC.currentItem.baseView removeFromSuperview];
    editingVC.modeController.editingMode = NormalMode;
    [editingVC hideAndInitSlider];
    [editingVC showItemsForNormalMode];
    [editingVC.editingItemLayerVC.tableView reloadData];

    editingVC.currentItem = nil;
    editingVC.currentSticker = nil;
    editingVC.currentText = nil;
    editingVC.currentPhotoFrame = nil;
    editingVC.currentPhoto = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        editingVC.buttonScrollView.alpha = 1.0;
    }];

}

- (IBAction)doneButtonTapped:(id)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.editingPhotoButtonVC dismissSelf];
    [editingVC.layerController hideTransparentView];
    [editingVC.albumVC dismissSelf];
    [self dismissSelf];
    [editingVC.albumVC dismissSelf];
    [SaveManager.sharedInstance addItem:editingVC.currentPhoto];
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        item.indexInLayer = [NSString stringWithFormat:@"%ld",[editingVC.view.subviews indexOfObject:item.baseView]];
    }
    [SaveManager.sharedInstance saveAndAddToStack];
    editingVC.modeController.editingMode = NormalMode;
    
    [editingVC hideAndInitSlider];
    [editingVC showItemsForNormalMode];
    [editingVC.editingItemLayerVC.tableView reloadData];

    editingVC.currentItem = nil;
    editingVC.currentSticker = nil;
    editingVC.currentText = nil;
    editingVC.currentPhotoFrame = nil;
    editingVC.currentPhoto = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        editingVC.buttonScrollView.alpha = 1.0;
    }];

}


@end
