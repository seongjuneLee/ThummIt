//
//  AlbumManager.m
//  Vlogr
//
//  Created by TaejunLee on 2019. 5. 3..
//  Copyright © 2019년 TaejunLee. All rights reserved.
//

#import "AlbumManager.h"

@implementation AlbumManager

+ (AlbumManager *)sharedInstance {
    static AlbumManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AlbumManager alloc] init];
        sharedInstance.albums = [NSMutableArray array];
        sharedInstance.iCloudDict = [NSMutableDictionary dictionary];
    });
    
    return sharedInstance;
}



-(void)setAlbumCategoryDatasWithAlbum:(Album *)album{
    
    [self.albums addObject:album];
    
}

#pragma mark - Helper

-(void)isiCloudVideo:(PHAsset*)asset withIsIcloud:(void (^)(BOOL))block{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = NO;

    [PHImageManager.defaultManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (asset) {
            block(false);
        } else {
            block(true);
        }
    }];
}

// 날짜 계산
- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // 년 월 일 뽑아내기
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // 시 분 초는 0으로 변경
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
    
}

-(void)clearAlbumData{
    self.albums = [NSMutableArray array];

}


#pragma mark - category

-(NSArray *)categoryFetchResults{
    
    PHFetchResult *smartAlbums = [PHAssetCollection       fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *userCollections = [PHAssetCollection       fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSMutableArray *albums = [NSMutableArray array];
    if (smartAlbums.count != 0) {
        [albums addObject:smartAlbums];
    }
    if (userCollections.count != 0) {
        [albums addObject:userCollections];
    }
    return albums;
}

-(void)downloadICloudAsset{
}

@end
