//
//  ItemCollectionViewController.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import "ItemCollectionViewController.h"
#import "EditingViewController.h"
#import "PhotoManager.h"
#import "ItemManager.h"
@interface ItemCollectionViewController ()

@end

@implementation ItemCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeViewBlurred];
    [self connectCollectionController];
    [self setCollectionViewFlowLayout];

}

-(void)viewWillLayoutSubviews{
    
    
}

-(void)dismissSelf{
    
    float screenHeight = UIScreen.mainScreen.bounds.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.frameY = screenHeight;
        self.blurView.frameY = screenHeight;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];

}

- (void)setCollectionViewFlowLayout {
    
    NSUInteger numberOfColumns = 3;

    // 칼럼 갯수
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    // 중간 스페이싱, 좌우 인셋을 빼고 남은 공간이 셀을 위한 공간
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (numberOfColumns - 1);
    
    // 셀 사이즈
    CGFloat cellWidth = availableWidthForCells / numberOfColumns ;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
}

-(void)makeViewBlurred{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    self.blurView = [[UIVisualEffectView alloc] init];
    self.blurView.frameSize = self.view.frameSize;
    self.blurView.effect = blurEffect;
    [self.view insertSubview:self.blurView atIndex:0];
    
}

-(void)connectCollectionController{
    
    self.collectionController = [[PhotoFrameCollectionController alloc] initWithCollectionView:self.collectionView];
    self.collectionController.delegate = self;
    [PhotoManager.sharedInstance getFirstPhotoFromAlbumWithContentMode:PHImageContentModeAspectFill withSize:CGSizeMake(500, 500) WithCompletionBlock:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collectionController.firstPhoto = image;
        });
    }];

}

#pragma mark - 델리게이트

-(void)didSelectPhotoFrame:(PhotoFrame *)photoFrame{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    if (editingVC.currentItem) {
        [editingVC.currentItem.baseView removeFromSuperview];
    }
    [editingVC.editingLayerController bringSelectedItemToFront:photoFrame];
    photoFrame.baseView.center = editingVC.imageView.center;
    [editingVC.view addSubview:photoFrame.baseView];
    editingVC.currentItem = photoFrame;

}

@end
