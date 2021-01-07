//
//  EditingViewController+GestureControllerDelegate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import "EditingViewController+GestureControllerDelegate.h"
#import "EditingViewController+AlbumVCDelegate.h"

@implementation EditingViewController (GestureControllerDelegate)

#pragma mark - 탭
-(void)didSelectItem:(Item *)item{
    
    if ([item isKindOfClass:PhotoFrame.class]) {
        
        self.selectedItem = (PhotoFrame *)item;
        [self.editingModeController setUpEditingMode:EditingPhotoFrameMode];
        self.originalPhotoFrameImage = self.selectedItem.photoImageView.image;
        self.originalImageViewCenter = self.selectedItem.photoImageView.center;
        self.originalTransform = self.selectedItem.photoImageView.transform;
        [self showAlbumVC];
        [self setCurrentPhotoSelectedOnAlbumVC];
        
    }
    
    [self.editingLayerController bringSelectedItemToFront:item];
    
}

-(void)changeSelectedItem:(Item *)item{
    
    if (self.selectedItem != item) {
        self.selectedItem.photoImageView.image = self.originalPhotoFrameImage;
        self.selectedItem.photoImageView.center = self.originalImageViewCenter;
        [self.editingLayerController recoverOriginalLayer];
        [self.editingLayerController bringSelectedItemToFront:item];
        
        self.selectedItem = item;
        self.originalPhotoFrameImage = self.selectedItem.photoImageView.image;
        [self setCurrentPhotoSelectedOnAlbumVC];
    }
    
}


-(void)setCurrentPhotoSelectedOnAlbumVC{
    
    NSUInteger index = 0;
    NSArray *phassets = PhotoManager.sharedInstance.phassets;
    for (int i = 0; i < phassets.count; i++) {
        PHAsset *phAsset = phassets[i];
        if ([self.selectedItem.phAsset.localIdentifier isEqualToString:phAsset.localIdentifier]) {
            index = i;
        }
    }
    
    self.albumVC.selectedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.albumVC.collectionView reloadData];
    PHAsset *selectedPHAsset = phassets[index];
    [PhotoManager.sharedInstance getImageFromPHAsset:selectedPHAsset withPHImageContentMode:PHImageContentModeAspectFill withSize:CGSizeMake(1920, 1080) WithCompletionBlock:^(UIImage * _Nonnull image) {
        self.selectedItem.photoImageView.image = image;
    }];
        
}

-(void)showAlbumVC{
    
    if (!self.albumVC) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        self.albumVC = (AlbumViewController *)[main instantiateViewControllerWithIdentifier:@"AlbumViewController"];

        [self addChildViewController:self.albumVC];
        [self.view addSubview:self.albumVC.view];
        
        self.albumVC.delegate = self;
        self.albumVC.collectionView.frameY = self.view.frameHeight;
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.albumVC.collectionView.frameY = self.albumVC.view.frameY;
            
        } completion:nil];
    }
    
}


#pragma mark - 팬

// 팬 제스쳐 노멀 모드
-(void)readyUIForPanning{
    self.underAreaView.hidden = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.textButtonContainerView.alpha = 0.0;
        self.deleteButtonContainerView.alpha = 1.0;
    }];
}

-(void)deleteImageRespondToCurrentPointY:(float)currentPointY{
    float iamgeViewBottomY = self.imageView.frameY + self.imageView.frameHeight;
    if (currentPointY >= iamgeViewBottomY) {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteButtonContainerView.alpha = 0.4;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteButtonContainerView.alpha = 1.0;
        }];
    }
}

-(void)panGestureEndedForNoramlMode:(Item *)item withFingerPoint:(CGPoint)fingerPoint{
    
    self.underAreaView.hidden = false;
    float iamgeViewBottomY = self.imageView.frameY + self.imageView.frameHeight;
    if (fingerPoint.y >= iamgeViewBottomY) {
        [ItemManager.sharedInstance deleteItem:item];
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.textButtonContainerView.alpha = 1.0;
        self.deleteButtonContainerView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [SaveManager.sharedInstance save];
    }];

}


#pragma mark - 핀치제스쳐

-(void)pinchGestureInNormalModeBeganWithItem:(Item *)item withSender:(UIGestureRecognizer *)sender{
    self.underAreaView.hidden = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.textButtonContainerView.alpha = 0.0;
        self.deleteButtonContainerView.alpha = 1.0;
    }];
}

@end
