//
//  AlbumViewController+Button.m
//  ThummIt
//
//  Created by 이성준 on 2021/07/04.
//

#import "AlbumViewController+Button.h"
#import "EditingViewController.h"
#import "EditingViewController+Buttons.h"

@implementation AlbumViewController (Button)


- (IBAction)editButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.albumVC hideWithAnimation];
    [self addEditingPhotoVC];
    
}

- (IBAction)photoButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (!sender.selected) {
        sender.selected = true;

        self.styleButton.selected = false;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            sender.alpha = 1.0;
            self.styleButton.alpha = 0.4;
        }];
        [editingVC.albumVC showWithAnimation];
    }
    
}


- (IBAction)styleButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (!sender.selected) {
        sender.selected = true;
        
        self.editButton.selected = false;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            self.editButton.alpha = 0.4;
            sender.alpha = 1.0;
        }];
        [editingVC.albumVC hideWithAnimation];
    }

}


- (IBAction)doneButtonTapped:(UIButton *)sender {
    
    self.photoButton.selected = true;
    [self photoButtonTapped:self.photoButton];
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    if ([editingVC.currentItem isKindOfClass:Photo.class]) { // 사진
        
        if (editingVC.modeController.editingMode == AddingItemMode) { // 새로운 아이템 추가중
            
            [editingVC.editingPhotoVC dismissSelf];
            [editingVC.editingPhotoButtonVC dismissSelf];
            [editingVC.layerController hideTransparentView];
            [self dismissSelf];
            [SaveManager.sharedInstance addItem:editingVC.currentPhoto];
            for (Item *item in SaveManager.sharedInstance.currentProject.items) {
                item.indexInLayer = [NSString stringWithFormat:@"%ld",[editingVC.view.subviews indexOfObject:item.baseView]];
            }
            [SaveManager.sharedInstance saveAndAddToStack];
            editingVC.modeController.editingMode = NormalMode;
     
            
        } else {
            
            Photo *photo = (Photo *)editingVC.currentPhoto;

            // 원래거 삭제하고 지금 편집하던거 넣기
            [SaveManager.sharedInstance deleteItem:editingVC.originalPhoto];
            [editingVC.originalPhoto.baseView removeFromSuperview];
            [SaveManager.sharedInstance addItem:photo];
            
            // 레이어 되돌려 놓기
            [editingVC.layerController recoverOriginalLayer];
            photo.indexInLayer = [NSString stringWithFormat:@"%ld",editingVC.originalIndexInLayer];
            [editingVC.view insertSubview:photo.baseView atIndex:editingVC.originalIndexInLayer];

            // VC들 없애주기
            [editingVC.editingPhotoVC dismissSelf];
            [editingVC.editingPhotoButtonVC dismissSelf];
            [editingVC.layerController hideTransparentView];
            [self dismissSelf];
            [SaveManager.sharedInstance saveAndAddToStack];
            
            editingVC.modeController.editingMode = NormalMode;

        }
        
    } else { // 포토 프레임
        
        if (editingVC.modeController.editingMode == AddingItemMode) { // 새로운 아이템 추가중
            
            [editingVC.layerController hideTransparentView];
            [self dismissSelf];
            [SaveManager.sharedInstance addItem:editingVC.currentPhotoFrame];
            for (Item *item in SaveManager.sharedInstance.currentProject.items) {
                item.indexInLayer = [NSString stringWithFormat:@"%ld",[editingVC.view.subviews indexOfObject:item.baseView]];
            }
            editingVC.currentPhotoFrame.plusPhotoImageView.hidden = true;
            [SaveManager.sharedInstance saveAndAddToStack];
            editingVC.modeController.editingMode = NormalMode;
            
        } else {
            
            EditingViewController *editingVC = (EditingViewController *)self.editingVC;
            PhotoFrame *photoFrame = (PhotoFrame *)editingVC.currentPhotoFrame;

            // 원래거 삭제하고 지금 편집하던거 넣기
            [SaveManager.sharedInstance deleteItem:editingVC.originalPhotoFrame];
            [editingVC.originalPhotoFrame.baseView removeFromSuperview];
            [SaveManager.sharedInstance addItem:photoFrame];
            
            //    // 레이어 되돌려 놓기
            editingVC.layerController.originalIndex = editingVC.originalIndexInLayer;
            [editingVC.layerController recoverOriginalLayer];
            [editingVC.view insertSubview:photoFrame.baseView atIndex:editingVC.originalIndexInLayer];
            
            editingVC.currentPhotoFrame.plusPhotoImageView.hidden = true;
            // VC들 없애주기
            [self dismissSelf];
            [SaveManager.sharedInstance saveAndAddToStack];
            
            editingVC.modeController.editingMode = NormalMode;

        }

    }
    
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

- (IBAction)closeButtonTapped:(id)sender {
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    self.photoButton.selected = true;
    [self photoButtonTapped:self.photoButton];

    if ([editingVC.currentItem isKindOfClass:Photo.class]) {
        
        [editingVC.editingPhotoVC dismissSelf];
        [editingVC.editingPhotoButtonVC dismissSelf];
        [self dismissSelf];

        if (editingVC.modeController.editingMode == AddingItemMode) { // 새로운 아이템 추가중
            
            [editingVC.layerController hideTransparentView];
            [editingVC.albumVC dismissSelf];
            
            [editingVC.currentItem.baseView removeFromSuperview];
            editingVC.modeController.editingMode = NormalMode;

        } else { // 기존 아이템 편집중
            
            

            [editingVC.currentPhoto.baseView removeFromSuperview];
            editingVC.originalPhoto.baseView.hidden = false;
            [editingVC.layerController hideTransparentView];
            editingVC.modeController.editingMode = NormalMode;
            
        }
        
        
    } else {
        if (editingVC.modeController.editingMode == AddingItemMode) { // 새로운 아이템 추가중
            
            [self cancelAddingPhotoFrame];
        } else {
            [self cancelEditingPhotoFrame];
        }
    }
    
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

-(void)cancelAddingPhotoFrame{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    [editingVC.layerController hideTransparentView];
    [self dismissSelf];
    [editingVC.editingPhotoVC dismissSelf];
    [editingVC.editingPhotoButtonVC dismissSelf];
    [editingVC.currentPhotoFrame.baseView removeFromSuperview];
    editingVC.modeController.editingMode = NormalMode;

}

-(void)cancelEditingPhotoFrame{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;

    [editingVC.currentPhotoFrame.baseView removeFromSuperview];
    editingVC.originalPhotoFrame.baseView.hidden = false;
    [editingVC.layerController hideTransparentView];
    [self dismissSelf];
    [editingVC.editingPhotoVC dismissSelf];
    [editingVC.editingPhotoButtonVC dismissSelf];
    editingVC.modeController.editingMode = NormalMode;

}


-(void)addEditingPhotoVC{

    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    float screenHeight = UIScreen.mainScreen.bounds.size.height;
    float buttonViewHeight = screenHeight*0.2;
    float editingPhotoVCHeight = screenHeight*0.8;
    editingVC.editingPhotoVC.view.frame = CGRectMake(0, 0, editingVC.view.frameWidth, editingPhotoVCHeight);
    editingVC.editingPhotoButtonVC.view.frame = CGRectMake(0, editingPhotoVCHeight, editingVC.view.frameWidth, buttonViewHeight);

    editingVC.editingPhotoVC.view.alpha = 0;
    editingVC.editingPhotoButtonVC.view.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        editingVC.editingPhotoVC.view.alpha = 1.0;
        editingVC.editingPhotoButtonVC.view.alpha = 1.0;
        [editingVC.view layoutIfNeeded];
    }];
    
    UIImage *photoImage = editingVC.currentPhoto.photoImageView.image;
    editingVC.editingPhotoVC.editingVC = editingVC;
    editingVC.editingPhotoVC.photoImageView = [[UIImageView alloc] init];
    editingVC.editingPhotoVC.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    editingVC.editingPhotoVC.photoImageView.image = photoImage;
    [editingVC.editingPhotoVC.contentView addSubview:editingVC.editingPhotoVC.photoImageView];
    
    editingVC.editingPhotoButtonVC.delegate = editingVC.editingPhotoVC;
    editingVC.editingPhotoVC.includeButton = editingVC.editingPhotoButtonVC.includeButton;
    editingVC.editingPhotoVC.eraseButton = editingVC.editingPhotoButtonVC.eraseButton;
    [editingVC addChildViewController:editingVC.editingPhotoVC];
    [editingVC.view insertSubview:editingVC.editingPhotoVC.view belowSubview:editingVC.itemCollectionContainerView];
    
    [editingVC addChildViewController:editingVC.editingPhotoButtonVC];
    [editingVC.view insertSubview:editingVC.editingPhotoButtonVC.view aboveSubview:editingVC.itemCollectionContainerView];

}

@end
