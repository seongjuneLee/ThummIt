//
//  AlbumCollectionViewCell.h
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *stateCircleImageView;
@property (weak, nonatomic) IBOutlet UIView *transparentView;

@end

NS_ASSUME_NONNULL_END
