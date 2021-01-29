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
        photoFrame.phAsset = selectedPHAsset;
    }
    
    photoFrame.photoImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
    photoFrame.photoImageView.center = CGPointMake(photoFrame.baseView.frameWidth/2,photoFrame.baseView.frameHeight/2);
    photoFrame.photoCenter = photoFrame.photoImageView.center;
    photoFrame.photoImageView.frameSize = photoFrame.baseView.frameSize;

    [PhotoManager.sharedInstance getImageFromPHAsset:selectedPHAsset withPHImageContentMode:PHImageContentModeAspectFill withSize:CGSizeMake(1920,1080) WithCompletionBlock:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            photoFrame.photoImageView.image = image;
            float ratio = image.size.height/image.size.width;
            float width = self.bgView.frameWidth;
            float height = self.bgView.frameWidth * ratio;
            photoFrame.photoImageView.frameSize = CGSizeMake(width, height);
        });
    }];
    
}

@end
