//
//  EditingPhotoViewController+ButtonDelegate.m
//  ThummIt
//
//  Created by 이성준 on 2021/03/01.
//

#import "EditingPhotoViewController+ButtonDelegate.h"
#import "EditingViewController.h"
#import "ThummIt-Swift.h"
#import "UIImage+Additions.h"
@implementation EditingPhotoViewController (ButtonDelegate)

-(void)removeBGButtonTapped{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    CGPoint originalCenter = editingVC.currentPhoto.baseView.center;
    
    UIImageView *photoImageView = self.photoImageView;

    UIImage *sourceImage = photoImageView.image;
    struct CGImage *cgImg = sourceImage.segmentation;
    if (cgImg) {
        SegmentFilter *filter = [[SegmentFilter alloc] init];
        filter.inputImage = [[CIImage alloc] initWithCGImage:sourceImage.CGImage];
        filter.maskImage = [[CIImage alloc] initWithCGImage:cgImg];

        CIImage *output = [filter valueForKey:kCIOutputImageKey];
        CIContext *ciContext = [[CIContext alloc] initWithOptions:nil];
        struct CGImage *cgImage = [ciContext createCGImage:output fromRect:output.extent];

        UIImage *originalImage = photoImageView.image;
        CGSize originalSize = CGSizeMake(originalImage.size.width * originalImage.scale, originalImage.size.height * originalImage.scale);
        UIImage *finalImage = [UIImage trimImage:[[UIImage alloc] initWithCGImage:cgImage]];
        CGSize finalImageSize = CGSizeMake(finalImage.size.width * finalImage.scale, finalImage.size.height * finalImage.scale);
        float widthDeltaRatio = finalImageSize.width/originalSize.width;
        float heightDeltaRatio = finalImageSize.height/originalSize.height;
        photoImageView.image = finalImage;
        photoImageView.frameWidth *= widthDeltaRatio;
        photoImageView.frameHeight *= heightDeltaRatio;
        photoImageView.center = self.originalCenter;
        editingVC.currentPhoto.photoImageView.frameSize = photoImageView.frameSize;
        editingVC.currentPhoto.photoImageView.image = finalImage;
        editingVC.currentPhoto.imageData = UIImagePNGRepresentation(finalImage);
        editingVC.currentPhoto.baseView.bounds = editingVC.currentPhoto.photoImageView.bounds;
        editingVC.currentPhoto.baseView.center = originalCenter;
        [UndoManager.sharedInstance addCurrentPhotoToStack:finalImage];
    }
    
}

-(void)undoButtonTapped{
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    [UndoManager.sharedInstance undoEditingPhotoWithBlock:^(UIImage * _Nonnull image) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize originalSize = CGSizeMake(self.photoImageView.image.size.width * self.photoImageView.image.scale, self.photoImageView.image.size.height * self.photoImageView.image.scale);
            CGSize finalImageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
            float widthDeltaRatio = finalImageSize.width/originalSize.width;
            float heightDeltaRatio = finalImageSize.height/originalSize.height;
            self.photoImageView.frameWidth *= widthDeltaRatio;
            self.photoImageView.frameHeight *= heightDeltaRatio;
            self.photoImageView.image = image;
            self.photoImageView.center = self.originalCenter;
            editingVC.currentPhoto.photoImageView.frameSize = self.photoImageView.frameSize;
            editingVC.currentPhoto.photoImageView.image = image;
            editingVC.currentPhoto.imageData = UIImagePNGRepresentation(image);
            
        });
        
    }];
    
}

-(void)redoButtonTapped{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    [UndoManager.sharedInstance redoEditingPhotoWithBlock:^(UIImage * _Nonnull image) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize originalSize = CGSizeMake(self.photoImageView.image.size.width * self.photoImageView.image.scale, self.photoImageView.image.size.height * self.photoImageView.image.scale);
            CGSize finalImageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
            float widthDeltaRatio = finalImageSize.width/originalSize.width;
            float heightDeltaRatio = finalImageSize.height/originalSize.height;
            self.photoImageView.frameWidth *= widthDeltaRatio;
            self.photoImageView.frameHeight *= heightDeltaRatio;
            self.photoImageView.image = image;
            self.photoImageView.center = self.originalCenter;
            editingVC.currentPhoto.photoImageView.frameSize = self.photoImageView.frameSize;
            editingVC.currentPhoto.photoImageView.image = image;
            editingVC.currentPhoto.imageData = UIImagePNGRepresentation(image);
        });
        
    }];

}


#pragma mark - include Button

-(void)includeButtonTapped:(UIButton *)sender{
    
    
}

#pragma mark - erase Button

-(void)eraseButtonTapped:(UIButton *)sender{
    
    if (sender.selected) {
        
    } else {
        
    }
}

@end
