//
//  AlbumCategoryViewController.m
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import "AlbumCategoryViewController.h"
#import "AlbumCategoryViewController+CollectionViewDelegate.h"
#import "AlbumCategoryViewController+CollectionViewDataSource.h"

@interface AlbumCategoryViewController ()

@end

@implementation AlbumCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AlbumCategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AlbumCategoryCollectionViewCell"];
    [self setUpData];

}

-(void)dealloc{
    [AlbumManager.sharedInstance clearAlbumData];
}

-(void)setUpData{
    if(PHPhotoLibrary.authorizationStatus != PHAuthorizationStatusAuthorized){
        return;
    }
    
    // Add each PHFetchResult to the array
    NSArray* fetchResults = AlbumManager.sharedInstance.categoryFetchResults;
    
    for (int i = 0; i < fetchResults.count; i ++) {
        PHFetchResult *fetchResult = AlbumManager.sharedInstance.categoryFetchResults[i];
        for (int x = 0; x < fetchResult.count; x ++) {
            PHCollection *collection = fetchResult[x];
            
            PHAssetCollection *phAssetCollection = fetchResult[x];
            PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:nil];
            
            if (phAssetFetchResult.count != 0) { // 어셋이 0개인 앨범은 제외해 줍니다.
                if(phAssetCollection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden &&
                   phAssetCollection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumLongExposures &&
                   ![collection.localizedTitle isEqualToString:NSLocalizedString(@"People", nil)] && ![collection.localizedTitle isEqualToString:NSLocalizedString(@"Recently Deleted", nil)] && ![collection.localizedTitle isEqualToString:NSLocalizedString(@"Video", nil)] && ![collection.localizedTitle isEqualToString:@"움직이는 항목"]) {                    // 필요하지 않은 앨범들은 제외해 줍니다.
                    
                    Album *album = [[Album alloc] init];
                    album.albumTitle = collection.localizedTitle;
                    album.assetCountOfAlbum = phAssetFetchResult.count;
                    album.phAssetCollection = phAssetCollection;
                    album.phFetchResult = phAssetFetchResult;
                    
                    [AlbumManager.sharedInstance setAlbumCategoryDatasWithAlbum:album];
                    
                }
            }
        }
    }
    [AlbumManager.sharedInstance.albums sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

        Album * album1= obj1;
        Album * album2= obj2;
        
        NSInteger score1 = (album1.phAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary?2:0)+(album1.phAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos?1:0);
        NSInteger score2 = (album2.phAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary?2:0)+(album2.phAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos?1:0);
        
        return score2 - score1;
    }];
    [self.collectionView reloadData];
    
}

@end
