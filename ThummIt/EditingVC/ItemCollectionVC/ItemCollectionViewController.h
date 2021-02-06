//
//  ItemCollectionViewController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "PhotoFrameCollectionController.h"
#import "TextCollectionController.h"
#import "StickerCollectionController.h"
#import "Item.h"
#import "PhotoManager.h"
#import "ItemManager.h"
#import "Text.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    PhotoFrameType = 0,
    TextType = 1,
    StickerType = 2
}ItemType;

@interface ItemCollectionViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic) ItemType itemType;
@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) PhotoFrameCollectionController *photoFrameCollectionController;
@property (strong, nonatomic) TextCollectionController *textCollectionController;
@property (strong, nonatomic) StickerCollectionController *stickerCollectionController;

@property (weak, nonatomic) UIViewController *editingVC;

-(void)dismissSelf;

@end

NS_ASSUME_NONNULL_END
