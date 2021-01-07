//
//  ItemManager.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import "ItemManager.h"
#import "SaveManager.h"
#import "PhotoFrameHeader.h"

@implementation ItemManager

+ (ItemManager *)sharedInstance {
    static ItemManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ItemManager alloc] init];
    });
    
    return sharedInstance;
}

-(NSArray *)photoFrameCategories{
    
    NSString *circle = NSLocalizedString(@"circle", nil);
    NSString *rectangle = NSLocalizedString(@"rectangle", nil);
    NSArray *categories = @[circle, rectangle];
    
    return categories;
}

-(NSArray *)circlePhotoFrames{
    
    BasicCircle *basicCircle = [BasicCircle basicCircle];
    ChristmasCircle *christmasCircle = [ChristmasCircle christmasCircle];
    
    NSArray *photoFrames = @[basicCircle, christmasCircle];
    return photoFrames;
}

-(NSArray *)rectanglePhotoFrames{
    
    BasicCircle *basicCircle = [BasicCircle basicCircle];
    ChristmasCircle *christmasCircle = [ChristmasCircle christmasCircle];
    
    NSArray *photoFrames = @[basicCircle, christmasCircle];
    return photoFrames;
}

-(void)addItem:(Item *)item withView:(UIView *)view underView:(nonnull UIView *)gestureView withCriteriaView:(UIImageView *)imageView{
    
    item.baseView.center = CGPointMake(imageView.frameWidth/2, imageView.frameY + imageView.frameHeight/2);
    [view insertSubview:item.baseView belowSubview:gestureView];
    [SaveManager.sharedInstance.currentProject.items addObject:item];
    [SaveManager.sharedInstance save];
    
}

-(void)deleteItem:(Item *)item{
    
    [item.baseView removeFromSuperview];
    [SaveManager.sharedInstance.currentProject.items removeObject:item];
    [SaveManager.sharedInstance save];
    
}

@end
