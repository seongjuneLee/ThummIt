//
//  EditingViewController+Buttons.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "EditingViewController+Buttons.h"

@implementation EditingViewController (Buttons)

#pragma mark - 네비게이션 버튼


#pragma mark - left item 탭

- (IBAction)leftItemTapped:(id)sender {
    
    if (self.editingModeController.editingMode == NormalMode) {
        [self closeEditingVC];
    } else if (self.editingModeController.editingMode == AddPhotoFrameMode){
        [self.editingModeController setUpEditingMode:NormalMode];
        [self dismissItemCollectionVC];
    } else if (self.editingModeController.editingMode == EditingPhotoFrameMode){
        [self.editingModeController setUpEditingMode:NormalMode];
        [self dismissAlbumVC];
    }

}

-(void)closeEditingVC{
    
    [self.navigationController popViewControllerAnimated:true];

}

-(void)dismissAlbumVC{
    
    // 변경 취소하고, 원래 이미지 다시 넣어주기.
    self.selectedItem.photoImageView.image = self.originalPhotoFrameImage;
    // 취소시 이미지 뷰 센터 다시 돌려놓기.
    self.selectedItem.photoImageView.center = self.originalImageViewCenter;
    self.selectedItem.photoImageView.transform = self.originalTransform;
    
    // 레이어 되돌려 놓기
    [self.editingLayerController recoverOriginalLayer];
    
    // albumVC 없애주기
    [self.albumVC dismissSelf];
    self.selectedItem = nil;
    self.albumVC = nil;

}

-(void)dismissItemCollectionVC{
    
    [self.itemCollectionVC dismissSelf];
    [ItemManager.sharedInstance deleteItem:self.currentItem];
    self.currentItem = nil;
    
}

#pragma mark - right item 탭

- (IBAction)rightItemTapped:(id)sender {
    
    if (self.editingModeController.editingMode == NormalMode) {
        [self exportThumbnail];
    } else if (self.editingModeController.editingMode == AddPhotoFrameMode){
        [self.editingModeController setUpEditingMode:NormalMode];
        [self doneAddingPhoto];
    } else if (self.editingModeController.editingMode == EditingPhotoFrameMode){
        [self.editingModeController setUpEditingMode:NormalMode];
        [self doneSelectingPhoto];
    }

}

-(void)exportThumbnail{
    
    
    
}

-(void)doneSelectingPhoto{
    
    // 레이어 되돌려 놓기
    [self.editingLayerController recoverOriginalLayer];
    
    self.selectedItem.phAsset = PhotoManager.sharedInstance.phassets[self.albumVC.selectedIndexPath.item];
    
    // albumVC 없애주기
    [self.albumVC dismissSelf];
    self.albumVC = nil;

    self.originalPhotoFrameImage = nil;
    self.selectedItem = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SaveManager.sharedInstance save];
    });
    
}

-(void)doneAddingPhoto{
    
    [self.editingLayerController recoverOriginalLayer];
    [self.itemCollectionVC dismissSelf];
    [SaveManager.sharedInstance.currentProject.photoFrames addObject:self.currentItem];
    NSLog(@"self.currentItem imangename %@",self.currentItem.backgroundImageName);
    dispatch_async(dispatch_get_main_queue(), ^{
        [SaveManager.sharedInstance save];
    });
    self.currentItem = nil;
}

#pragma mark - 아이템 버튼

- (IBAction)photoFrameButtonTapped:(id)sender {
    
    [self.editingModeController setUpEditingMode:AddPhotoFrameMode];
    [self addItemCollectionVC];
    
}

-(void)addItemCollectionVC{
    
    [self addChildViewController:self.itemCollectionVC];
    [self.view addSubview:self.itemCollectionVC.view];
    
    self.itemCollectionVC.collectionView.frameY = self.view.frameHeight;
    self.itemCollectionVC.blurView.frameY = self.view.frameHeight;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.itemCollectionVC.collectionView.frameY = 0;
        self.itemCollectionVC.blurView.frameY = 0;
    } completion:nil];
    
}
@end
