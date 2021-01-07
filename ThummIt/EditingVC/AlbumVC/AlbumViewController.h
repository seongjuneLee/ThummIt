//
//  AlbumViewController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "AlbumCollectionViewCell.h"
#import "PhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlbumViewControllerDelegate <NSObject>

-(void)didSelectPhoto;

@end

@interface AlbumViewController : UIViewController
@property (weak, nonatomic) id<AlbumViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *phAssets;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)dismissSelf;

@end

NS_ASSUME_NONNULL_END
