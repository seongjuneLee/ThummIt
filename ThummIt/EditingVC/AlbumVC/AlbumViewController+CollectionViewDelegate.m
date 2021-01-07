//
//  AlbumViewController+CollectionViewDelegate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "AlbumViewController+CollectionViewDelegate.h"

@implementation AlbumViewController (CollectionViewDelegate)

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexPath = indexPath;
    [self.delegate didSelectPhoto];
    [collectionView reloadData];
    self.nextButton.hidden = false;
    
}

@end
