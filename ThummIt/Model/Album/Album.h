//
//  Album.h
//  Vlogr
//
//  Created by 이성준 on 22/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface Album : NSObject

/**
 @brief 앨범안에 있는 PHAsset 정보들을 담고 있습니다.
 */
@property (strong, nonatomic) PHAssetCollection *phAssetCollection;
/**
 @brief 앨범안에 있는 PHAsset 정보들을 담고 있습니다.
 */
@property (strong, nonatomic) PHFetchResult *phFetchResult;
/**
@brief 앨범의 제목입니다.
*/
@property (strong, nonatomic) NSString *albumTitle;
/**
@brief 앨범 안에 있는 어셋들의 수 입니다.
*/
@property (nonatomic) NSUInteger assetCountOfAlbum;

@end

NS_ASSUME_NONNULL_END
