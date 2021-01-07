//
//  PhotoManager.h
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoManager : NSObject

+ (PhotoManager *)sharedInstance;


@property (strong, nonatomic) NSMutableArray *phassets;

-(void)getImageFromPHAsset:(PHAsset *)phAsset withPHImageContentMode:(PHImageContentMode)contentMode withSize:(CGSize)size WithCompletionBlock:(void(^)(UIImage *image))block;
-(void)getFirstPhotoFromAlbumWithContentMode:(PHImageContentMode)contentMode withSize:(CGSize)size WithCompletionBlock:(void(^)(UIImage *image))block;

-(NSMutableArray *)fetchPhassets;
-(NSArray *)categoryFetchResults;

@end

NS_ASSUME_NONNULL_END
