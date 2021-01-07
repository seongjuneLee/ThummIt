//
//  HomeCollectionController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionController : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) NSIndexPath *tableViewIndexPath;
@property (strong, nonatomic) NSString *currentCategory;

@end

NS_ASSUME_NONNULL_END
