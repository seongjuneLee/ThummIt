//
//  PhotoManager.m
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import "PhotoManager.h"

@implementation PhotoManager

+ (PhotoManager *)sharedInstance {
    static PhotoManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotoManager alloc] init];
        sharedInstance.phassets = [sharedInstance fetchPhassets];
    });
    
    return sharedInstance;
}

-(void)getImageFromPHAsset:(PHAsset *)phAsset withPHImageContentMode:(PHImageContentMode)contentMode withSize:(CGSize)size WithCompletionBlock:(void(^)(UIImage *image))block{
    
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = YES;
    
    [manager requestImageForAsset:phAsset
                       targetSize:size
                      contentMode:contentMode
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
        block(image);
    }];
    
}

-(void)getFirstPhotoFromAlbumWithContentMode:(PHImageContentMode)contentMode withSize:(CGSize)size WithCompletionBlock:(void(^)(UIImage *image))block{
    
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    // this one is key
    requestOptions.synchronous = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [manager requestImageForAsset:self.phassets.firstObject
                           targetSize:size
                          contentMode:contentMode
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
            block(image);
        }];
    });
            
}

-(NSMutableArray *)fetchPhassets{
    
    __block NSMutableArray* phAssets = [NSMutableArray array];
    NSArray* fetchResults = [self categoryFetchResults];
    
    for (int i = 0; i < fetchResults.count; i ++) {
        PHFetchResult *fetchResult = fetchResults[i];
        for (int x = 0; x < fetchResult.count; x ++) {
            PHCollection *collection = fetchResult[x];
            PHAssetCollection *phAssetCollection = fetchResult[x];
            if ([collection.localizedTitle isEqualToString:NSLocalizedString(@"Recent", nil)]) {
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
                
                fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %ld ",PHAssetMediaTypeImage];
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:fetchOptions];
                [result enumerateObjectsUsingBlock:^(PHAsset *phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
                    [phAssets addObject:phAsset];
                }];
            }
        }
    }

    return phAssets;
}


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

-(void)requstGoingToSettingWithVC:(UIViewController*)viewController{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *settingAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Go to setting", @"#-세팅으로 가기 - #") message:NSLocalizedString(@"You should agree photo access request for this function.", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *goToSetting = [UIAlertAction actionWithTitle:NSLocalizedString(@"Setting", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        
        [settingAlertController addAction:cancel];
        [settingAlertController addAction:goToSetting];
        [viewController presentViewController:settingAlertController animated:true completion:nil];
    });
    
}


@end
