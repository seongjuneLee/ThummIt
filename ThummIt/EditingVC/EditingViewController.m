//
//  EditingViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/14.
//

#import "EditingViewController.h"
#import "EditingViewController+GestureControllerDelegate.h"

@interface EditingViewController ()

@end

@implementation EditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PhotoManager.sharedInstance fetchPhassets];
    [self loadItems];

    [self basicUIUXSetting];

    [self connectControllers];
    
}

-(void)viewWillLayoutSubviews{

    float imageViewBottomY = self.imageView.frameY + self.imageView.frameHeight;
    self.albumVC.view.frameSize = CGSizeMake(self.view.frameWidth, self.view.frameHeight - imageViewBottomY);
    self.albumVC.view.frameOrigin = CGPointMake(0, imageViewBottomY);
    self.itemCollectionVC.view.frame = CGRectMake(0, imageViewBottomY, self.view.frameWidth, self.view.frameHeight - imageViewBottomY);
    
}


-(void)basicUIUXSetting{
    
    self.imageView.userInteractionEnabled = true;
    
}

-(void)setUpWithTemplate{
    
    // 포토 프레임 올려줌
    self.imageView.backgroundColor = self.selectedTemplate.backgroundColor;
    for (Item *item in self.selectedTemplate.items) {
        [self.view insertSubview:item.baseView belowSubview:self.gestureView];
    }
    [SaveManager.sharedInstance save];

}

#pragma mark - controller 연결

-(void)connectControllers{
    
    [self connectEditingModeController];
    [self connectEditingGestureController];
    [self connectEditingLayerController];
    
    UIStoryboard *editing = [UIStoryboard storyboardWithName:@"Editing" bundle:NSBundle.mainBundle];
    self.itemCollectionVC = (ItemCollectionViewController *)[editing instantiateViewControllerWithIdentifier:@"ItemCollectionViewController"];
    self.itemCollectionVC.editingVC = self;
    
}

-(void)connectEditingGestureController{
    
    self.editingGestureController = [[EditingGestureController alloc] init];
    self.editingGestureController.editingVC = self;
    self.editingGestureController.delegate = self;
    self.editingGestureController.gestureView = self.gestureView;
    [self.editingGestureController addGestureRecognizers];
    
}

-(void)connectEditingModeController{
    
    self.editingModeController = [[EditingModeController alloc] init];
    self.editingModeController.editingVC = self;
    
}

-(void)connectEditingLayerController{
    
    self.editingLayerController = [[EditingLayerController alloc] init];
    self.editingLayerController.editingVC = self;
    
}

#pragma mark - load Saved Data

-(void)loadItems{
    
    Project *project = SaveManager.sharedInstance.currentProject;
    self.imageView.backgroundColor = project.backgroundColor;
    
    float imageViewWidth = self.view.frameWidth;
    float imageViewHeight = imageViewWidth * 9/16;
    for (Item *item in project.items) {
        if (item.isTemplateItem) {
            float itemX = imageViewWidth * item.relativeCenter.x;
            float itemY = imageViewHeight * item.relativeCenter.y + self.imageView.frameY;
            CGPoint itemCenter = CGPointMake(itemX, itemY);
            [item scaleItem];
            item.baseView.center = itemCenter;
        }
        [self.view insertSubview:item.baseView belowSubview:self.gestureView];
    }
    [SaveManager.sharedInstance save];

}

@end
