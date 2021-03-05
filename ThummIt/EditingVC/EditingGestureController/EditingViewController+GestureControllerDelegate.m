//
//  EditingViewController+GestureControllerDelegate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import "EditingViewController+GestureControllerDelegate.h"
#import "EditingViewController+AlbumVCDelegate.h"
#import "ItemCollectionViewController+Button.h"
#import "EditingViewController+Buttons.h"


@implementation EditingViewController (GestureControllerDelegate)

#pragma mark - 탭
-(void)didSelectItem:(Item *)item{
    
    self.modeController.editingMode = EditingItemMode;

    if ([item isKindOfClass:Photo.class]) {
        if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
            if (PhotoManager.sharedInstance.phassets.count == 0) {
                PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
            }
            [self didTapPhoto:item];
            
            [self hideItemsForItemMode];
            [self showItemCollectionVC];

        } else {
            [PhotoManager.sharedInstance requstGoingToSettingWithVC:self];
        }
    } else if ([item isKindOfClass:PhotoFrame.class]) {
        
        if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
            if (PhotoManager.sharedInstance.phassets.count == 0) {
                PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
            }
            [self didTapPhotoFrame:item];
            [self hideItemsForItemMode];
            [self showItemCollectionVC];

        } else {
            [self taskWhenDenied];
        }
        
    } else if([item isKindOfClass:Text.class]){
        [self didTapText:item];
        
        [self hideItemsForItemMode];
        [self showItemCollectionVC];

    } else if([item isKindOfClass:Sticker.class]){        
        [self didTapSticker:item];
        
        [self hideItemsForItemMode];
        [self showItemCollectionVC];

    }

    for(ItemLayer *itemLayer in SaveManager.sharedInstance.currentProject.itemLayers){
        
        if ([self.currentItem isKindOfClass:PhotoFrame.class]) {
            if(itemLayer.item == self.originalPhotoFrame){
                self.layerController.currentItemLayer = itemLayer;
            }
        } else {
            if(itemLayer.item == self.currentItem){
                self.layerController.currentItemLayer = itemLayer;
            }
        }
    }

}

#pragma mark - 포토

-(void)didTapPhoto:(Item *)item{
    
    Photo *photo = (Photo *)item;
    
    Photo *copied = [photo copy];
    self.currentItem = copied;
    self.currentPhoto = copied;
    self.originalPhoto = photo;
    self.originalPhoto.baseView.hidden = true;
    self.originalIndexInLayer = photo.indexInLayer.integerValue;
    
    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    
    [self.layerController bringCurrentItemToFront];
    self.itemCollectionVC.itemType = PhotoType;
    
    [self showItemCollectionVC];
    [self addAlbumVC];
    [self.albumVC showWithAnimation];
    
    for(ItemLayer *itemLayer in SaveManager.sharedInstance.currentProject.itemLayers){
        
        if ([self.currentItem isKindOfClass:PhotoFrame.class]) {
            if(itemLayer.item == self.originalPhotoFrame){
                self.layerController.currentItemLayer = itemLayer;
            }
        } else {
            if(itemLayer.item == self.currentItem){
                self.layerController.currentItemLayer = itemLayer;
            }
        }
    }//photoframe일 경우 self.currentitem에 copy객체가 들어있어서 주소값이 달라서 currentitemlayer가 안바뀜
    
}

#pragma mark - 포토프레임

-(void)didTapPhotoFrame:(Item *)item{
    
    PhotoFrame *photoFrame = (PhotoFrame *)item;
    
    PhotoFrame *copied = [photoFrame copy];
    self.currentItem = copied;
    self.currentPhotoFrame = copied;
    self.originalPhotoFrame = photoFrame;
    self.originalPhotoFrame.baseView.hidden = true;
    self.originalIndexInLayer = photoFrame.indexInLayer.integerValue;

    [self.layerController showTransparentView];
    [self hideItemsForItemMode];
    
    [self.layerController bringCurrentItemToFront];
    self.itemCollectionVC.itemType = PhotoFrameType;
    
    if (photoFrame.isFixedPhotoFrame) {
        [self fixedPhotoFrameTapped];
    } else {
        [self showItemCollectionVC];
        [self addAlbumVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.albumVC showWithAnimation];
        });

    }
    [self setCurrentPhotoSelectedOnAlbumVC];
}

-(void)fixedPhotoFrameTapped{
    
    [self showItemCollectionVC];
    [self addAlbumVC];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.albumVC showWithAnimation];
    });
    self.itemCollectionVC.photoFramePhotoButton.selected = true;
    
}

-(void)setCurrentPhotoSelectedOnAlbumVC{
    
    if (self.itemCollectionVC.itemType == PhotoFrameType) {
        PhotoFrame *photoFrame = self.currentPhotoFrame;

        NSUInteger index = 0;
        NSArray *phassets = PhotoManager.sharedInstance.phassets;
        for (int i = 0; i < phassets.count; i++) {
            PHAsset *phAsset = phassets[i];
            if ([photoFrame.phAsset.localIdentifier isEqualToString:phAsset.localIdentifier]) {
                index = i;
            }
        }
        
        self.albumVC.selectedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.albumVC.collectionView reloadData];
        PHAsset *selectedPHAsset = phassets[index];
        if (!photoFrame.photoImageView.image) {
            [self didSelectPhotoWithPHAsset:selectedPHAsset];
        }
    }
    
}

#pragma mark -텍스트

-(void)didTapText:(Item *)item{
    
    
    Text *text = (Text *)item;
    self.currentItem = text;
    self.currentText = text;
    
    self.originalCenter = text.baseView.center;
    self.originalTransform = text.baseView.transform;
    self.originalTypo = text.typo;
    self.originalText = text.text;
    
    self.itemCollectionVC.typoButton.selected = false;
    self.itemCollectionVC.typoButton.alpha = 0.4;
    self.itemCollectionVC.textButton.selected = true;
    self.itemCollectionVC.textButton.alpha = 1.0;
    
    [text.textView becomeFirstResponder];
    [self.layerController showTransparentView];
    [self.layerController bringCurrentItemToFront];
    self.itemCollectionVC.itemType = TextType;
    
    if(text.typo.canChangeColor){
        [UIView animateWithDuration:0.2 animations:^{
            self.hueSlider.alpha = 1.0;
        }];
    }

}

#pragma mark - 스티커

-(void)didTapSticker:(Item *)item{
    
    Sticker *sticker = (Sticker *)item;
    self.currentItem = sticker;
    self.currentSticker = sticker;
    self.originalCenter = sticker.baseView.center;
    self.originalTransform = sticker.baseView.transform;
    self.originalStickerBGImageName = sticker.backgroundImageName;
    self.originalTintColor = sticker.tintColor;
    self.originalColorChangable = sticker.canChangeColor;
    self.originalSticker = sticker;
    self.originalIndexInLayer = sticker.indexInLayer.integerValue;
    
    [self.layerController showTransparentView];
    [self.layerController bringCurrentItemToFront];
    self.itemCollectionVC.itemType = StickerType;
    
    if(sticker.canChangeColor){
        [UIView animateWithDuration:0.2 animations:^{
            self.hueSlider.alpha = 1.0;
        }];
    }
    
}

#pragma mark - 팬

// 팬 제스쳐 노멀 모드
-(void)readyUIForPanning{
    
    self.underAreaView.hidden = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.undoButton.alpha = 0.0;
        self.redoButton.alpha = 0.0;
        self.buttonScrollView.alpha = 0.0;
        self.deleteButtonContentView.alpha = 1.0;
        self.albumVC.view.alpha = self.itemCollectionVC.view.alpha = 0;
        self.itemLayerScrollView.alpha = 0.0;
    }];
    
    if([self.currentItem isKindOfClass:Text.class]){
        [self.currentText.textView resignFirstResponder];
    }

}

-(void)deleteImageRespondToCurrentPointY:(float)currentPointY{
    float imageViewBottomY = self.bgView.frameY + self.bgView.frameHeight;
    if (currentPointY >= imageViewBottomY) {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteButtonContentView.alpha = 0.4;
            self.currentItem.baseView.alpha = 0.4;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteButtonContentView.alpha = 1.0;
            self.currentItem.baseView.alpha = 1.0;
        }];
    }
}

//bgview밖으로 나가면 item 지워줌 & 해당 itemlayer 지워줌 등등
-(void)panGestureEndedForItem:(Item *)item withFingerPoint:(CGPoint)fingerPoint{
    
    self.underAreaView.hidden = false;
    float imageViewBottomY = self.bgView.frameY + self.bgView.frameHeight;
    if (fingerPoint.y >= imageViewBottomY) {
        [item.baseView removeFromSuperview];
        [self.currentText.textView resignFirstResponder];
        self.itemCollectionVC.doneButton.enabled = true;
        self.itemCollectionVC.doneButton.alpha = 1.0;
        
        [self.layerController itemLayerDelete];
        
        self.currentItem = nil;
        self.currentText = nil;
        self.currentSticker = nil;
        self.currentPhotoFrame = nil;
        [SaveManager.sharedInstance deleteItem:item];
        for (Item *item in SaveManager.sharedInstance.currentProject.items) {
            if (!item.isFixedPhotoFrame) {
                item.indexInLayer = [NSString stringWithFormat:@"%ld",[self.view.subviews indexOfObject:item.baseView]];
            }
        }
        item.baseView.center = CGPointMake(self.bgView.frameWidth/2, self.bgView.frameY + self.bgView.frameHeight/2);
        [self showItemsForNormalMode];
        [self.layerController hideTransparentView];
        
        [self.itemCollectionVC dismissSelf];
        self.buttonScrollView.hidden = false;
        
    } else{
        if(self.modeController.editingMode == NormalMode){
            self.buttonScrollView.hidden = false;
        }else{
            self.buttonScrollView.hidden = true;
        }
    }
    
    if(self.modeController.editingMode == NormalMode){
        [UIView animateWithDuration:0.2 animations:^{
            self.undoButton.alpha = 1.0;
            self.redoButton.alpha = 1.0;
            self.buttonScrollView.alpha = 1.0;
            self.deleteButtonContentView.alpha = 0.0;
            self.albumVC.view.alpha = self.itemCollectionVC.view.alpha = 1.0;
            self.itemLayerScrollView.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteButtonContentView.alpha = 0.0;
            self.albumVC.view.alpha = self.itemCollectionVC.view.alpha = 1.0;
        }];
    }
}


#pragma mark - 핀치제스쳐

-(void)pinchGestureInNormalModeBeganWithItem:(Item *)item withSender:(UIGestureRecognizer *)sender{
    self.underAreaView.hidden = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.photoFrameButtonContentView.alpha = 0.0;
        self.deleteButtonContentView.alpha = 1.0;
    }];
}



@end
