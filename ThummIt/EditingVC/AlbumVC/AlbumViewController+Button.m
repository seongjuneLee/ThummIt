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
    if (!sender.selected) {
        [editingVC.albumVC hideWithAnimation];
        [self addEditingPhotoVC];
        sender.selected = true;
        self.photoButton.selected = false;
        [UIView animateWithDuration:0.2 animations:^{
            self.photoButton.alpha = 0.4;
            sender.alpha = 1.0;
        }];
    }

}

- (IBAction)photoButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (!sender.selected) {
        sender.selected = true;
        [editingVC.editingPhotoVC dismissSelf];
        [editingVC.editingPhotoButtonVC dismissSelf];

        self.editButton.selected = false;
        [editingVC.albumVC showWithAnimation];
        [UIView animateWithDuration:0.2 animations:^{
            editingVC.itemCollectionContainerTopConstraint.constant = 0;
            [editingVC.view layoutIfNeeded];
            self.photoButton.alpha = 1.0;
            self.editButton.alpha = 0.4;
        }];
    }

}


- (IBAction)doneButtonTapped:(UIButton *)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.editingPhotoVC dismissSelf];
    [editingVC.editingPhotoButtonVC dismissSelf];
    [editingVC.layerController hideTransparentView];
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

- (IBAction)closeButtonTapped:(id)sender {
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    [editingVC.editingPhotoVC dismissSelf];
    [editingVC.editingPhotoButtonVC dismissSelf];
    [self dismissSelf];
    [editingVC.layerController hideTransparentView];
    [editingVC.albumVC dismissSelf];
    
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
        editingVC.itemCollectionContainerTopConstraint.constant = editingVC.underAreaView.frameHeight - buttonViewHeight - self.cancelButton.frameHeight;
        [editingVC.view layoutIfNeeded];
    }];
    
    UIImage *photoImage = editingVC.currentPhoto.photoImageView.image;

    editingVC.editingPhotoVC.photoImageView = [[UIImageView alloc] init];
    editingVC.editingPhotoVC.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    editingVC.editingPhotoVC.photoImageView.image = photoImage;
    editingVC.editingPhotoVC.photoImageView.center = editingVC.editingPhotoVC.view.center;

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
