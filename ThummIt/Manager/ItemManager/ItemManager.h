//
//  ItemManager.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import "Item.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemManager : NSObject

+ (ItemManager *)sharedInstance;

-(NSArray *)photoFrameCategories;
-(NSArray *)stickerCategories;

-(NSArray *)circlePhotoFrames;
-(NSArray *)rectanglePhotoFrames;
-(NSArray *)basicCircleStickers;
-(NSArray *)basicArrowStickers;
-(NSArray *)xStickers;
-(NSArray *)exclamationMark;

-(void)addItem:(Item *)item withView:(UIView *)view underView:(UIView *)gestureView withCriteriaView:(UIImageView *)imageView;
-(void)deleteItem:(Item *)item;
-(void)addItem:(Item *)item;

@end

NS_ASSUME_NONNULL_END
