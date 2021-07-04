//
//  AlbumCategoryViewController+CollectionViewDelegate.m
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import "AlbumCategoryViewController+CollectionViewDelegate.h"


@implementation AlbumCategoryViewController (CollectionViewDelegate)

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Album *album = AlbumManager.sharedInstance.albums[indexPath.item];
    
    PHAssetCollection *phAssetCollection = album.phAssetCollection;
    [self.delegate didSelectCategoryWithPHAssetCollection:phAssetCollection];
    


}

@end
