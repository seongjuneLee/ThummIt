//
//  EditingContentModeController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import "EditingModeController.h"
#import "EditingViewController.h"

@implementation EditingModeController // 네비게이션 바 아이템들에 대한 컨트롤만.

-(id)init{
    
    self = [super init];
    if(self){
        
    }
    return self;
    
}

-(void)setUpEditingMode:(EditingMode)editingMode{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    self.editingMode = editingMode;
    if (self.editingMode == NormalMode) {
        [editingVC.leftItem setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [UIView transitionWithView:editingVC.leftItem duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [editingVC.leftItem setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        } completion:nil];
        editingVC.leftItemWidthConstraint.constant = 25;
        [editingVC.rightItem setTitle:NSLocalizedString(@"Export", nil) forState:UIControlStateNormal];
    } else if (self.editingMode == AddPhotoFrameMode){
        
        [editingVC.leftItem setImage:nil forState:UIControlStateNormal];
        [UIView transitionWithView:editingVC.leftItem duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [editingVC.leftItem setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        } completion:nil];
        editingVC.leftItemWidthConstraint.constant = 60;
        [editingVC.rightItem setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];

    }else if (self.editingMode == EditingPhotoFrameMode){
        [editingVC.leftItem setImage:nil forState:UIControlStateNormal];
        [UIView transitionWithView:editingVC.leftItem duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [editingVC.leftItem setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        } completion:nil];
        editingVC.leftItemWidthConstraint.constant = 60;
        [editingVC.rightItem setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    }
    
}


@end
