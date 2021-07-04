//
//  AlbumCategoryViewController+CollectionViewDataSource.m
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import "AlbumCategoryViewController+CollectionViewDataSource.h"

@implementation AlbumCategoryViewController (CollectionViewDataSource)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return AlbumManager.sharedInstance.albums.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumCategoryCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCategoryCollectionViewCell" forIndexPath:indexPath];
    
    // 페치
    Album *album = AlbumManager.sharedInstance.albums[indexPath.item];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:album.phAssetCollection options:fetchOptions];
    
    // 앨범 썸네일 준비위해 첫 옵젝트 가져오기
    PHAsset *asset = fetchResult.firstObject;
    
    // 이미지 생성
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = 80.0f;
    CGSize size = CGSizeMake(dimension*scale, dimension*scale);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 셀에 실제로 넣어주기
            cell.thumbnailImageView.image = result;
            cell.titleLabel.text = album.albumTitle;
            cell.countLabel.text = [NSString stringWithFormat:@"(%ld)",album.assetCountOfAlbum];
        });
    }];
    
    return cell;
}

@end
