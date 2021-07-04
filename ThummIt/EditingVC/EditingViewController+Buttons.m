//
//  EditingViewController+Buttons.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "EditingViewController+Buttons.h"
#import "EditingViewController+AlbumVCDelegate.h"
#import "EditingViewController+GestureControllerDelegate.h"
#import "TextCollectionController.h"
#import "PhotoFrameCollectionController.h"
#import "StickerCollectionController.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "ExportManager.h"
@import Parse;
#import <Parse/PFFileObject.h>
@implementation EditingViewController (Buttons)

- (IBAction)rightItemTapped:(id)sender {
        
    [self exportThumbnail];
    if (self.interstitial) {
      [self.interstitial presentFromRootViewController:self];
    } else {
      NSLog(@"Ad wasn't ready");
    }
    
}

-(void)exportThumbnail{
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ExportManager.sharedInstance savePreviewImageWithResolution:CGSizeMake(2048.f, 1152.f) withProject:SaveManager.sharedInstance.currentProject];
            
            [ExportManager.sharedInstance exportImageWithBlock:^(BOOL success) {
            }];

        });
    } else {
        [PhotoManager.sharedInstance requstGoingToSettingWithVC:self];
    }

}
-(void)setThumbnailAndResolution:(CGSize)resolution{
    UIImage *viewImage = [self.view toImage];
    UIImage *croppedImage = [viewImage crop:self.bgView.frame];
    [ExportManager.sharedInstance setResolutionToExportingImage:croppedImage withResolution:resolution];
}


- (IBAction)leftItemTapped:(id)sender {
    [SaveManager.sharedInstance save];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeEditingVC];
    });
}

-(void)closeEditingVC{
    
    [self.navigationController popViewControllerAnimated:true];
    [UndoManager.sharedInstance initUndoRedo];

}

#pragma mark - 포토 버튼

- (IBAction)photoButtonTapped:(UIButton *)sender {
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (PhotoManager.sharedInstance.phassets.count == 0) {
                PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
            }
            [self photoButtonTappedTaskWhenAuthorized];
            self.modeController.editingMode = AddingItemMode;
        });
    } else {
        [self taskWhenDenied];
    }
    
}

-(void)photoButtonTappedTaskWhenAuthorized{
    
    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    [self addAlbumVC];
    [self.albumVC showWithAnimation];
    
    if (!self.recentPHAsset) {
        self.recentPHAsset = PhotoManager.sharedInstance.phassets[0];
    }
    Photo *photo = [[Photo alloc] init];
    [photo loadView];
    photo.baseView.center = self.bgView.center;
    self.currentItem = photo;
    self.currentPhoto = photo;
    [self.view insertSubview:photo.baseView belowSubview:self.gestureView];
    [self didSelectPhotoWithPHAsset:self.recentPHAsset];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLabel.alpha = 0.0;
        self.categoryButton.alpha = 1.0;
    }];
    
}

#pragma mark - 포토 프레임 버튼

- (IBAction)photoFrameButtonTapped:(UIButton *)sender {
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (PhotoManager.sharedInstance.phassets.count == 0) {
                PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
            }
            [self photoFrameButtonTappedTaskWhenAuthorized];
            self.modeController.editingMode = AddingItemMode;
        });
    } else {
        [PhotoManager.sharedInstance requstGoingToSettingWithVC:self];
    }
    
}

-(void)photoFrameButtonTappedTaskWhenAuthorized{
    
    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    self.itemCollectionVC.itemType = PhotoFrameType;
    [self showItemCollectionVC];
    [self addAlbumVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.albumVC showWithAnimation];
    });

    PhotoFrame *recentPhotoFrame = [BasicCirclePhotoFrame basicCirclePhotoFrame];
    for (NSArray *photoFrames in ItemManager.sharedInstance.photoFrameDatas) {
        for (PhotoFrame *photoFrame in photoFrames) {
            if ([photoFrame isKindOfClass:self.recentPhotoFrame.class]) {
                recentPhotoFrame = photoFrame;
                break;
            }
        }
    }
    [self.itemCollectionVC.photoFrameCollectionController didSelectPhotoFrame:recentPhotoFrame];
    
    if (!self.recentPHAsset) {
        self.recentPHAsset = PhotoManager.sharedInstance.phassets[0];
    }
    [self didSelectPhotoWithPHAsset:self.recentPHAsset];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLabel.alpha = 0.0;
        self.categoryButton.alpha = 1.0;
    }];

}
-(void)taskWhenDenied{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *settingAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Go to setting", @"#-세팅으로 가기 - #") message:NSLocalizedString(@"You should agree photo access request for this function.", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *goToSetting = [UIAlertAction actionWithTitle:NSLocalizedString(@"Setting", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        
        [settingAlertController addAction:cancel];
        [settingAlertController addAction:goToSetting];
        [self presentViewController:settingAlertController animated:true completion:nil];
    });
    
}


#pragma mark - 텍스트 버튼

- (IBAction)textButtonTapped:(UIButton *)sender {
    
    self.modeController.editingMode = AddingItemMode;
    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    self.itemCollectionVC.itemType = TextType;
    [self showItemCollectionVC];
    if (self.recentTypo == nil) {
        self.recentTypo = [NormalTypo normalTypo];
    }
    self.itemCollectionVC.typoButton.selected = true;
    self.itemCollectionVC.typoButton.alpha = 1.0;
    self.itemCollectionVC.textButton.selected = false;
    self.itemCollectionVC.textButton.alpha = 0.4;
    [self.itemCollectionVC.textCollectionController didSelectTypo:self.recentTypo];
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonScrollView.alpha = 0.0;
    }];
    
}

#pragma mark - 스티커 버튼

- (IBAction)stickerButtonTapped:(UIButton *)sender {
    
    self.modeController.editingMode = AddingItemMode;
    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    self.itemCollectionVC.itemType = StickerType;
    [self showItemCollectionVC];
    // 추가 필요
    Sticker *recentSticker = [CircleSticker1 circleSticker1];
    for (NSArray *stickers in ItemManager.sharedInstance.stickerDatas) {
        for (Sticker *sticker in stickers) {
            if ([sticker isKindOfClass:self.recentSticker.class]) {
                recentSticker = sticker;
            }
        }
    }

    [self.itemCollectionVC.stickerCollectionController didSelectSticker:[CircleSticker1 circleSticker1]];
   
}

#pragma mark - 메인프레임 버튼

- (IBAction)mainFrameButtonTapped:(UIButton *)sender {
    
    self.modeController.editingMode = MainFrameOrBGColorMode;
    [self hideItemsForItemMode];
    self.itemCollectionVC.itemType = MainFrameType; //type에 따라 올라오는 Collectionview종류가 달라서 필요
    [self showItemCollectionVC];
    //추가필요
    self.originalMainFrameImageName = SaveManager.sharedInstance.currentProject.mainFrameImageName;
}

#pragma mark - 보더칼라 버튼

- (IBAction)bgColorButtonTapped:(id)sender {
    
    self.modeController.editingMode = MainFrameOrBGColorMode;
    [self hideItemsForItemMode];
    self.originalColor = self.bgView.backgroundColor;
    
    // scrollView 가려주기
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonScrollView.alpha = 0.0;
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgColorTopConstraint.constant = -self.bgColorContainerView.frameHeight;
        [self.view layoutIfNeeded];
    }];
    
}



#pragma mark - 버튼 컨테이너 알파 애니메이션

-(void)photoFrameButtonHoldDown{
    
    self.photoFrameButtonContentView.alpha = 0.6;
    
}

-(void)photoFrameButtonHoldRelease{
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoFrameButtonContentView.alpha = 1.0;
        
    } completion:nil];
    
    
}

-(void)textButtonHoldDown{
    
    self.textButtonContentView.alpha = 0.6;
    
}

-(void)textButtonHoldRelease{
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.textButtonContentView.alpha = 1.0;
        
    } completion:nil];
    
    
}

-(void)stickerButtonHoldDown{
    
    self.stickerButtonContentView.alpha = 0.6;
    
}

-(void)stickerButtonHoldRelease{
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.stickerButtonContentView.alpha = 1.0;
        
    } completion:nil];
    
    
}

-(void)bgColorButtonHoldDown{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgColorButtonContentView.alpha = 0.6;
    }];

}

-(void)bgColorButtonHoldRelease{
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgColorButtonContentView.alpha = 1.0;
        
    } completion:nil];
    
    
}

#pragma mark - undo redo


- (IBAction)undoButtonTapped:(UIButton *)sender {
    
    [self clearProjectContents];
    [UndoManager.sharedInstance undo];
    [self loadItems];
        
}

- (IBAction)redoButtonTapped:(UIButton *)sender {
    
    [self clearProjectContents];
    [UndoManager.sharedInstance redo];
    [self loadItems];

}

-(void)clearProjectContents{
    
    for (Item *item in SaveManager.sharedInstance.currentProject.items) {
        [item.baseView removeFromSuperview];
    }
        
}

#pragma mark - slider

- (IBAction)sliderValueChanged:(UISlider *)sender{
    
    //thumbPoint 정의
    CGRect trackRect = [self.hueSlider trackRectForBounds:self.hueSlider.bounds];
    CGRect thumbRect = [self.hueSlider thumbRectForBounds:self.hueSlider.bounds trackRect:trackRect value:self.hueSlider.value];
    CGPoint thumbCenter = CGPointMake(thumbRect.origin.x + 15.5, 15);
    
    self.thumbCircleView.center = [self.view convertPoint:thumbCenter fromView:self.hueSlider];
    UIImage *image = [UIImage imageNamed:@"hueSlider"];
    float scale = image.size.width*image.scale/(self.hueSlider.bounds.size.width - thumbRect.size.width);

    CGPoint thumbPoint =  CGPointMake(thumbRect.origin.x * scale, thumbRect.origin.y+self.hueSlider.frameHeight/2);

    UIColor *currentPointColor = [UIColor pixelColorInImage:[UIImage imageNamed:@"hueSlider"] atPoint:thumbPoint];
    
    if ([self.currentItem isKindOfClass:Text.class]){
        self.currentText.textView.textColor = currentPointColor;
        self.currentText.typo.textColor = currentPointColor;
        if(self.currentText.typo.backgroundColorAlsoChange){
            UIImage *image = [UIImage imageNamed:self.currentText.typo.bgImageName];
            self.currentText.backgroundImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.currentText.backgroundImageView setTintColor:currentPointColor];
        }
    } else if ([self.currentItem isKindOfClass:Sticker.class]){
        Sticker *sticker = (Sticker *)self.currentItem;
        sticker.tintColor = currentPointColor;
        [self.currentItem.backgroundImageView setTintColor:currentPointColor];
    };
    self.thumbCircleView.backgroundColor = currentPointColor;
    
};
    
-(void)hideAndInitSlider{
    
    [self.hueSlider setValue:0];

    CGRect trackRect = [self.hueSlider trackRectForBounds:self.hueSlider.bounds];
    CGRect thumbRect = [self.hueSlider thumbRectForBounds:self.hueSlider.bounds trackRect:trackRect value:self.hueSlider.value];
    CGPoint thumbCenter = CGPointMake(thumbRect.origin.x + 15.5, 15);
    self.thumbCircleView.alpha = 0.0;

    self.thumbCircleView.center = [self.view convertPoint:thumbCenter fromView:self.hueSlider];
    [UIView animateWithDuration:0.2 animations:^{
        self.hueSlider.alpha = 0.0;
    }];
}

#pragma  mark - VC 띄우고, 내리기

-(void)showItemCollectionVC{
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    
    [self.itemCollectionVC connectCollectionController];
    
    float constant = 0;
    if (self.itemCollectionVC.itemType == PhotoType) {
        self.itemCollectionVC.collectionView.hidden = true;
    } else {
        self.itemCollectionVC.collectionView.hidden = false;
    }
    if (self.itemCollectionVC.itemType == TextType) {
        if (AppManager.sharedInstance.keyboardSize.height != 0) {
            //50은 언두버튼 + 위아래인셋
            constant = self.underAreaView.frameHeight - (AppManager.sharedInstance.keyboardSize.height-window.safeAreaInsets.bottom) - 50;
        }
    }
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.itemCollectionContainerTopConstraint.constant = constant;
        [self.view layoutIfNeeded];
        
    } completion:nil];

    
}

-(void)addAlbumVC{
    
    self.albumVC.view.hidden = true;
    [self addChildViewController:self.albumVC];
    [self.view addSubview:self.albumVC.view];
    
    float imageViewBottomY = self.bgView.frameY + self.bgView.frameHeight;
    self.albumVC.view.frameSize = CGSizeMake(self.view.frameWidth, self.view.frameHeight - imageViewBottomY - self.itemCollectionVC.collectionView.frameY);
    self.albumVC.view.frameOrigin = CGPointMake(0, imageViewBottomY);
    
    self.albumVC.delegate = self;
//    self.albumVC.collectionViewTopConstraint.constant = self.albumVC.view.frameHeight;
    
}

- (IBAction)categoryButtonTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString* title = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@"▾" withString:@"▴"];
        //blackDownArrow
        
        [UIView animateWithDuration:0.3 animations:^{
            self.albumVC.categoryContainerTopConstraint.constant = 0;
            [self.albumVC.view layoutIfNeeded];
            [self.categoryButton setTitle:title forState:UIControlStateNormal];
        }];
    } else {
        NSString* title = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@"▴" withString:@"▾"];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.albumVC.categoryContainerTopConstraint.constant = self.albumVC.view.frameHeight;
            [self.albumVC.view layoutIfNeeded];
            [self.categoryButton setTitle:title forState:UIControlStateNormal];
        }];
    }


}



@end
