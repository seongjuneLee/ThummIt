//
//  PhotoFrameCollectionController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import "PhotoFrame.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PhotoFrameCollectionControllerDelegate <NSObject>

-(void)didSelectPhotoFrame:(PhotoFrame *)photoFrame;

@end

@interface PhotoFrameCollectionController : NSObject <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id<PhotoFrameCollectionControllerDelegate> delegate;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIImage *firstPhoto;

-(id)initWithCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
