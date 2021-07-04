//
//  AlbumManager.h
//  Vlogr
//
//  Created by TaejunLee on 2019. 5. 3..
//  Copyright © 2019년 TaejunLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
@class AlbumCellModel;
@import Photos;
typedef void (^MutableArrayCompletionBlock)(NSMutableArray* mutableArray);

@interface AlbumManager : NSObject

+(AlbumManager *)sharedInstance;

/**
 @brief phAssetMediaType과 phAssetcollection을 바탕으로 가져온 PHAsset 데이터들의 Array를  block을 통해 넘겨줍니다.
 @discussion 넘겨 받은 phAssetCollection을 통해 PHAsset 속성의 PHFetchResult를 생성합니다.\n 이 result에서 PHAsset을 받아오며 날짜 별로 정렬해줍니다.(이 때 makeAlbumCellModelsArray가 사용됩니다.)
 @param type  PHAsset의 MediaType 정보를 받습니다. Vlogr에선 현재 PHAssetMediaTypeImage와 PHAssetMediaTypeVideo 둘만을 사용합니다.
 @param phAssetCollection PHAssetCollection은 PHAsset들이 담겨있는 앨범입니다. property중 type과 subType을 이용하여 어떤 앨범인지 확인하실 수 있습니다.(유저 커스텀 앨범은 PHCollection의 localizedTitle을 통해 확인가능합니다.)  estimatedCount는 정확한 앨범 어셋 수를 넘겨주지 않을 때가 있습니다. 정확한 값을 얻기 위해선 fetch를 해주어야 합니다.
 @param block 최종적으로 phasset들이 담겨있는 array를 전달합니다.
 
 */
-(void)isiCloudVideo:(PHAsset*)asset withIsIcloud:(void(^) (BOOL isIcloud))block;

@property (strong, nonatomic) PHFetchResult *videoAssets;
@property (strong, nonatomic) PHFetchResult *imageAssets;
@property (strong, nonatomic) NSMutableDictionary *iCloudDict;
/**
@brief 앨범 카테고리에 사용되는 데이터들을 셋 업해 줍니다. 카메라롤과 비디오 앨범을 맨 위에 올릴 때를 위해 index가 필요합니다.
@param album  앨범 모델을 받아옵니다.
*/
-(void)setAlbumCategoryDatasWithAlbum:(Album *)album;

/**
@brief 앨범 데이터를 초기화 해줍니다.
*/
-(void)clearAlbumData;
#pragma mark - category
@property (strong, nonatomic) NSMutableArray *albums;
/**
 @brief 모든 페치 리절트들을 담고있습니다. 
 */
-(NSArray *)categoryFetchResults;

//@property (nonatomic) BOOL videoModelStatus;
//@property (nonatomic) BOOL isModelingVideos;

@end
