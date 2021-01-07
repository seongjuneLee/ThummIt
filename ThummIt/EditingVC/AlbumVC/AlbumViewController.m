//
//  AlbumViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"AlbumCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AlbumCollectionViewCell"];
    
    [self setCollectionViewFlowLayout];
    self.phAssets = PhotoManager.sharedInstance.phassets;
    [self.collectionView reloadData];
    
}

-(void)dismissSelf{
    
    float screenHeight = UIScreen.mainScreen.bounds.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.frameY = screenHeight;
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


@end
