//
//  EditingViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/14.
//

#import "EditingViewController.h"
#import "EditingViewController+GestureControllerDelegate.h"
#import "EditingViewController+Buttons.h"
#import "EditingViewController+Text.h"
#import "UIImage+Additions.h"
@interface EditingViewController ()

@end

@implementation EditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
        if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (PhotoManager.sharedInstance.phassets.count == 0) {
                    PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
                }
            });
        }
        
    }];


    [self basicUIUXSetting];

    [self connectControllers];
    
    [self addExtraGestureToButtons];
    
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(respondToUndoRedo) name:@"isUndoRedoAvailable" object:nil];
    
    [self setUpSlider];

}

-(void)setUpPhotoAlbums{
    
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
         if (status == PHAuthorizationStatusAuthorized)
         {
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                 PhotoManager.sharedInstance.phassets = [PhotoManager.sharedInstance fetchPhassets];
             });
         }
    }];

}

-(void)viewDidLayoutSubviews{
    if (!self.itemLoaded) {
        [self loadItems];
        [SaveManager.sharedInstance saveAndAddToStack];
    }
    float imageViewBottomY = self.bgView.frameY + self.bgView.frameHeight;
    self.itemCollectionVC.view.frame = CGRectMake(0, imageViewBottomY, self.view.frameWidth, self.view.frameHeight - imageViewBottomY);
    if (self.itemCollectionVC.itemType == TextType) {
        self.itemCollectionVC.view.frame = CGRectMake(0, self.view.frameHeight - (AppManager.sharedInstance.keyboardSize.height + self.itemCollectionVC.collectionView.frameY), self.view.frameWidth, AppManager.sharedInstance.keyboardSize.height + self.itemCollectionVC.collectionView.frameY);
    }

    float bgColorCollectionCellHeight = self.view.frameWidth/8 - 5;
    float inset = 40;
    float bgColorVCHeight = bgColorCollectionCellHeight + inset + self.bgColorVC.cancelButton.frameHeight;
    self.bgColorVC.view.frame = CGRectMake(0, self.view.frameHeight - bgColorVCHeight, self.view.frameWidth, bgColorVCHeight);

}

-(void)setUpSlider{
    
    UIImage *hueSliderImage = [UIImage imageNamed:@"hueSlider"];
    
    UIImage *maxImage = hueSliderImage;
    UIImage *minImage = hueSliderImage;
    [self.hueSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.hueSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    
    self.hueImageView = [[UIImageView alloc] initWithFrame:self.hueSlider.frame];
    self.hueImageView.image = hueSliderImage;
    
    CGRect trackRect = [self.hueSlider trackRectForBounds:self.hueSlider.bounds];
    CGRect thumbRect = [self.hueSlider thumbRectForBounds:self.hueSlider.bounds trackRect:trackRect value:self.hueSlider.value];
    
    self.thumbCircleView = [[UIView alloc] init];
    self.thumbCircleView.userInteractionEnabled = false;
    float scale = 0.7;
    self.thumbCircleView.layer.cornerRadius = (thumbRect.size.width*scale/2);
    self.thumbCircleView.frameWidth = (thumbRect.size.width)*scale;
    self.thumbCircleView.frameHeight = (thumbRect.size.height)*scale;

    [self.view addSubview:self.thumbCircleView];
}

-(void)basicUIUXSetting{
    
    self.bgView.userInteractionEnabled = true;
    
}

#pragma mark - controller 연결

-(void)connectControllers{
    
    [self connectEditingModeController];
    [self connectEditingGestureController];
    [self connectEditingLayerController];
    
    UIStoryboard *editing = [UIStoryboard storyboardWithName:@"Editing" bundle:NSBundle.mainBundle];
    self.itemCollectionVC = (ItemCollectionViewController *)[editing instantiateViewControllerWithIdentifier:@"ItemCollectionViewController"];
    self.itemCollectionVC.editingVC = self;

    self.albumVC = (AlbumViewController *)[editing instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    self.albumVC.editingVC = self;
    
    self.bgColorVC = (BGColorViewController *)[editing instantiateViewControllerWithIdentifier:@"BGColorViewController"];
    self.bgColorVC.editingVC = self;

}

-(void)connectEditingGestureController{
    
    self.gestureController = [[EditingGestureController alloc] init];
    self.gestureController.editingVC = self;
    [self.gestureController addGestureRecognizers];
    
}

-(void)connectEditingModeController{
    
    self.modeController = [[EditingModeController alloc] init];
    self.modeController.editingVC = self;
    
}

-(void)connectEditingLayerController{
    
    self.layerController = [[EditingLayerController alloc] init];
    self.layerController.editingVC = self;
    
}

#pragma mark - load Saved Data

-(void)loadItems{
    
    self.itemLoaded = true;
    Project *project = SaveManager.sharedInstance.currentProject;
    self.bgView.backgroundColor = project.backgroundColor;
    self.backgroundImageView.image = [UIImage imageNamed:project.backgroundImageName];
    for (Item *item in project.items) {
        
        if (item.isTemplateItem) { // 템플릿 상댓값 센터를 절댓값으로.
            float itemX = self.bgView.frameWidth * item.center.x;
            float itemY = self.bgView.frameY + self.bgView.frameHeight * item.center.y;
            CGPoint itemCenter = CGPointMake(itemX, itemY);
            item.center = itemCenter;
        }
        
        [item loadView]; // 뷰 로드하기.
        
        if ([item isKindOfClass:Text.class]){ // 텍스트 해주어야 할 일.
            Text *text = (Text *)item;
            text.textView.delegate = self;
            text.isTypedByUser = true;
        }
        
        if (item.isFixedPhotoFrame) { // fixed포토프레임일 때와 아닐 때
            [self.view insertSubview:item.baseView belowSubview:self.backgroundImageView];
        } else {
            [self.view insertSubview:item.baseView aboveSubview:self.backgroundImageView];
        }

    }
    
    // 인덱스 맞춰주기
    for (Item *item in project.items) {
        if (!item.isFixedPhotoFrame) {
            if (item.isTemplateItem) {
                NSUInteger backgroundImageViewIndex = [self.view.subviews indexOfObject:self.backgroundImageView];
                item.indexInLayer = [NSString stringWithFormat:@"%ld",backgroundImageViewIndex + [item.indexInLayer integerValue] + 1];
                [self.view insertSubview:item.baseView atIndex:item.indexInLayer.integerValue];
            } else {
                [self.view insertSubview:item.baseView atIndex:item.indexInLayer.integerValue];
            }
        }
        
        item.isTemplateItem = false;
    }
    
    UIImage *viewImage = [self.view toImage];
    SaveManager.sharedInstance.currentProject.previewImage = [viewImage crop:self.bgView.frame];
    [SaveManager.sharedInstance.currentProject save];
}

-(void)respondToUndoRedo{
    
    self.undoButton.enabled = UndoManager.sharedInstance.isUndoRemains;
    self.redoButton.enabled = UndoManager.sharedInstance.isRedoRemains;
    
}

-(void)showItemsForNormalMode{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.undoButton.alpha =
        self.redoButton. alpha =
        self.leftItem.alpha =
        self.rightItem.alpha = 1.0;
    }];

}
-(void)hideItemsForItemMode{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.undoButton.alpha =
        self.redoButton. alpha =
        self.leftItem.alpha =
        self.rightItem.alpha = 0;
    }];

}

-(void)addExtraGestureToButtons{
    
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldDown) forControlEvents:UIControlEventTouchDown];
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldDown) forControlEvents:UIControlEventTouchDragEnter];
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldRelease) forControlEvents:UIControlEventTouchDragExit];
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    [self.photoFrameButton addTarget:self action:@selector(photoFrameButtonHoldRelease) forControlEvents:UIControlEventTouchCancel];

    [self.textButton addTarget:self action:@selector(textButtonHoldDown) forControlEvents:UIControlEventTouchDown];
    [self.textButton addTarget:self action:@selector(textButtonHoldDown) forControlEvents:UIControlEventTouchDragEnter];
    [self.textButton addTarget:self action:@selector(textButtonHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.textButton addTarget:self action:@selector(textButtonHoldRelease) forControlEvents:UIControlEventTouchDragExit];
    [self.textButton addTarget:self action:@selector(textButtonHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    [self.textButton addTarget:self action:@selector(textButtonHoldRelease) forControlEvents:UIControlEventTouchCancel];

    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldDown) forControlEvents:UIControlEventTouchDown];
    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldDown) forControlEvents:UIControlEventTouchDragEnter];
    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldRelease) forControlEvents:UIControlEventTouchDragExit];
    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    [self.stickerButton addTarget:self action:@selector(stickerButtonHoldRelease) forControlEvents:UIControlEventTouchCancel];

    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldDown) forControlEvents:UIControlEventTouchDown];
    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldDown) forControlEvents:UIControlEventTouchDragEnter];
    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldRelease) forControlEvents:UIControlEventTouchDragExit];
    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldRelease) forControlEvents:UIControlEventTouchUpOutside];
    [self.bgColorButton addTarget:self action:@selector(bgColorButtonHoldRelease) forControlEvents:UIControlEventTouchCancel];

}


@end
