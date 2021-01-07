//
//  AlbumViewController+CollectionViewDataSource.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "AlbumViewController+CollectionViewDataSource.h"

@implementation AlbumViewController (CollectionViewDataSource)

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.phAssets.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumCollectionViewCell *cell = (AlbumCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionViewCell" forIndexPath:indexPath];
    
    PHAsset *phAsset = self.phAssets[indexPath.item];
    [PhotoManager.sharedInstance getImageFromPHAsset:phAsset withPHImageContentMode:PHImageContentModeAspectFill withSize:CGSizeMake(200, 200) WithCompletionBlock:^(UIImage * _Nonnull image) {
        if (image) {
            cell.imageView.image = image;
        }

    }];
    if (indexPath == self.selectedIndexPath) {
        cell.transparentView.alpha = 0.3;
        cell.stateCircleImageView.image = [UIImage imageNamed:@"selectedCircle"];
    } else {
        cell.transparentView.alpha = 0;
        cell.stateCircleImageView.image = [UIImage imageNamed:@"emptyCircle"];
    }
    
    
    return cell;
}


@end
