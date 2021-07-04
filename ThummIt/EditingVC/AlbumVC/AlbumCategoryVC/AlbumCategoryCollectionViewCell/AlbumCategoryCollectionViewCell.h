//
//  AlbumCategoryCollectionViewCell.h
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCategoryCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
