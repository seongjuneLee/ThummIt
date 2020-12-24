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
        [self.editingModeController setUpEditingMode:EditingItemMode];
        self.originalPhotoFrameImage = self.selectedItem.imageView.image;
        self.originalImageViewCenter = self.selectedItem.imageView.center;
        
        [self showAlbumVC];
        [self setCurrentPhotoSelectedOnAlbumVC];
        
    }
    
    [self.editingLayerController setUpWithSelectedItem:item];
    
}

-(void)changeSelectedItem:(Item *)item{
    
    if (self.selectedItem != item) {
        self.selectedItem.imageView.image = self.originalPhotoFrameImage;
        self.selectedItem.imageView.center = self.originalImageViewCenter;
        [self.editingLayerController recoverOriginalLayer];
        [self.editingLayerController setUpWithSelectedItem:item];
        
        self.selectedItem = item;
        self.originalPhotoFrameImage = self.selectedItem.imageView.image;
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
        self.selectedItem.imageView.image = image;
    }];
        
}

-(void)showAlbumVC{
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    if (!self.albumVC) {
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
-(void)pangestureBeganForNoramlMode{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.textButtonContainerView.alpha = 0.0;
        self.deleteButtonContainerView.alpha = 1.0;
    }];
    
}

-(void)pangestureChangedInNormalMode:(Item *)item withDelta:(CGPoint)delta withFingerPoint:(CGPoint)fingerPoint{
    
    CGPoint convertedPoint = [self.imageView convertPoint:item.baseView.center fromView:self.view];
    CGPoint center = CGPointMake(convertedPoint.x/self.imageView.frameWidth, convertedPoint.y/self.imageView.frameHeight);
    if ([item isKindOfClass:PhotoFrame.class]) {
        self.selectedItem = item;
        self.selectedItem.baseView.centerX += delta.x;
        self.selectedItem.baseView.centerY += delta.y;
        self.selectedItem.center = center;
        
        float iamgeViewBottomY = self.imageView.frameY + self.imageView.frameHeight;
        if (fingerPoint.y >= iamgeViewBottomY) {
            [UIView animateWithDuration:0.2 animations:^{
                self.deleteButtonContainerView.alpha = 0.4;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.deleteButtonContainerView.alpha = 1.0;
            }];
        }
    }

}

-(void)pangestureEndedForNoramlMode:(Item *)item withFingerPoint:(CGPoint)fingerPoint{
    
    float iamgeViewBottomY = self.imageView.frameY + self.imageView.frameHeight;
    if (fingerPoint.y >= iamgeViewBottomY) {
        [self deleteItem:item];
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.textButtonContainerView.alpha = 1.0;
        self.deleteButtonContainerView.alpha = 0.0;
    }];
    [SaveManager.sharedInstance save];

}

-(void)deleteItem:(Item *)item{
    
    [item.baseView removeFromSuperview];
    [SaveManager.sharedInstance.currentProject.items removeObject:item];
    [SaveManager.sharedInstance save];
    
}

// 팬 제스쳐 아이템 편집 모드

-(void)pangestureChangedInEditingItemMode:(Item *)item withDelta:(CGPoint)delta{
    
    CGPoint center = CGPointMake(item.imageView.center.x/item.baseView.frameWidth, item.imageView.center.y/item.baseView.frameHeight);

    if ([item isKindOfClass:PhotoFrame.class]) {
        self.selectedItem = item;
        self.selectedItem.imageView.centerX += delta.x;
        self.selectedItem.imageView.centerY += delta.y;
        self.selectedItem.imageViewCenter = center;
    }
    
}

@end
