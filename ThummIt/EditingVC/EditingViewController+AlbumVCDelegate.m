//
//  EditingViewController+AlbumVCDelegate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "EditingViewController+AlbumVCDelegate.h"

@implementation EditingViewController (AlbumVCDelegate)

-(void)didSelectPhoto{
    
    PhotoFrame *photoFrame = (PhotoFrame *)self.currentItem;
    PHAsset *selectedPHAsset = self.albumVC.phAssets[self.albumVC.selectedIndexPath.item];
    if (!self.originalPhotoFrameImage) {
        self.currentItem.phAsset = selectedPHAsset;
    }
    
    photoFrame.photoImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
    photoFrame.photoImageView.frameOrigin = CGPointMake(0,0);
    photoFrame.photoImageView.frameSize = photoFrame.baseView.frameSize;

    [PhotoManager.sharedInstance getImageFromPHAsset:selectedPHAsset withPHImageContentMode:PHImageContentModeAspectFill withSize:CGSizeMake(1280, 720) WithCompletionBlock:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            photoFrame.photoImageView.image = image;
        });
    }];
    
}

@end
