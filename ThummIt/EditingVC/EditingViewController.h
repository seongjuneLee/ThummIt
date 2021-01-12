//
//  EditingViewController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "Template.h"
#import "AlbumViewController.h"
#import "EditingGestureController.h"
#import "EditingModeController.h"
#import "EditingLayerController.h"
#import "ItemCollectionViewController.h"
#import "SaveManager.h"
#import "ItemManager.h"
#import "Typography.h"
NS_ASSUME_NONNULL_BEGIN
@interface EditingViewController : UIViewController

// 컨트롤러
@property (strong, nonatomic) EditingModeController *editingModeController;
@property (strong, nonatomic) EditingGestureController *editingGestureController;
@property (strong, nonatomic) EditingLayerController *editingLayerController;

@property (strong, nonatomic) ItemCollectionViewController *itemCollectionVC;

// 모델
@property (strong, nonatomic) Template *selectedTemplate;
@property (strong, nonatomic, nullable) Item *currentItem;
@property (strong, nonatomic, nullable) Text *currentText;
@property (strong, nonatomic, nullable) PhotoFrame *currentPhotoFrame;
@property (strong, nonatomic, nullable) Typography *recentTypo;

@property (strong, nonatomic, nullable) AlbumViewController *albumVC;
@property (strong, nonatomic, nullable) UIImage *originalPhotoFrameImage;
@property (strong, nonatomic, nullable) PHAsset *originalPHAsset;
@property (nonatomic) CGPoint originalImageViewCenter;
@property (nonatomic) CGAffineTransform originalTransform;

@property (weak, nonatomic) IBOutlet UIView *gestureView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *leftItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftItemWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *rightItem;
@property (weak, nonatomic) IBOutlet UIView *photoFrameButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *deleteButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *underAreaView;
@property (weak, nonatomic) IBOutlet UIView *textButtonContainerView;

@property (weak, nonatomic) IBOutlet UIButton *photoFrameButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *stickerButton;
@property (weak, nonatomic) IBOutlet UIButton *bgColorButton;
@property (weak, nonatomic) IBOutlet UIView *stickerButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *bgColorButtonContainerView;

@end

NS_ASSUME_NONNULL_END
