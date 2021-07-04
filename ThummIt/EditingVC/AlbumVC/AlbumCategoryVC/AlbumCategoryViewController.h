//
//  AlbumCategoryViewController.h
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "AlbumCategoryCollectionViewCell.h"
#import "AlbumManager.h"
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlbumCategoryVCDelegate <NSObject>

/**
@brief UICollectionViewDelegate인 didSelectCellAtIndexPath: 메소드 안에서 불리며 phAssetCollection을 넘겨주는 delegate 메소드입니다. \n 현재 AlbumViewController+AlbumCategoryVCDelegate에서만 위임받습니다.
@discussion 넘겨 받은 phAssetCollection을 통해 선택된 앨범의 어셋들로 AlbumVC collectionView를 reload 해줍니다.
@param phAssetCollection PHAssetCollection은 PHAsset들이 담겨있는 앨범입니다. property중 type과 subType을 이용하여 어떤 앨범인지 확인하실 수 있습니다.(유저 커스텀 앨범은 PHCollection의 localizedTitle을 통해 확인가능합니다.)  estimatedCount는 정확한 앨범 어셋 수를 넘겨주지 않을 때가 있습니다. 정확한 값을 얻기 위해선 fetch를 해주어야 합니다.
*/
-(void)didSelectCategoryWithPHAssetCollection:(PHAssetCollection *)phAssetCollection;

@end

@interface AlbumCategoryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<AlbumCategoryVCDelegate> delegate;
-(void)setUpData;
@end

NS_ASSUME_NONNULL_END
