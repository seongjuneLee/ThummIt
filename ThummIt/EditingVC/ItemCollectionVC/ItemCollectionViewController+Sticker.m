//
//  ItemCollectionViewController+Sticker.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/13.
//

#import "ItemCollectionViewController+Sticker.h"
#import "EditingViewController.h"

@implementation ItemCollectionViewController (Sticker)

#pragma mark - 스티커 컨트롤러

-(void)didSelectSticker:(Sticker *)sticker{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    sticker.baseView.center = editingVC.bgView.center;
    sticker.backgroundImageView.image = [UIImage imageNamed:sticker.backgroundImageName];
    if (editingVC.currentItem) {
        // 위치, 크기,사진 유지
        sticker.baseView.frame = editingVC.currentItem.baseView.frame;
        sticker.backgroundImageView.frame = editingVC.currentItem.backgroundImageView.frame;
        [editingVC.currentItem.baseView removeFromSuperview];// 기존 것 떼어주고
    }
    
    [editingVC.editingLayerController bringCurrentItemToFront:sticker];
    
    editingVC.currentItem = sticker;
    editingVC.currentSticker = sticker;
    editingVC.editingGestureController.currentItem = sticker;
    
}

@end