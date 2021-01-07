//
//  EditingGestureController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "EditingModeController.h"
#import "EditingModeController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EditingGestureControllerDelegate <NSObject>

-(void)didSelectItem:(Item *)item;
-(void)changeSelectedItem:(Item *)item;

// 노멀 모드 팬제스쳐
-(void)readyUIForPanning;
-(void)deleteImageRespondToCurrentPointY:(float)currentPointY;
-(void)panGestureEndedForNoramlMode:(Item *)item withFingerPoint:(CGPoint)fingerPoint;

// 아이템 모드 팬 제스쳐
-(void)pangestureChangedInEditingItemMode:(Item *)item withDelta:(CGPoint)delta;

// 핀치 제스쳐
-(void)pinchGestureInNormalModeBeganWithItem:(Item *)item withSender:(UIGestureRecognizer *)sender;
-(void)pinchGestureInNormalModeChangedWithItemMode:(Item *)item withSender:(UIGestureRecognizer *)sender;

// 로테이트
-(void)rotateGestureChangedWithSender:(UIGestureRecognizer *)sender;
-(void)rotateGestureEnded;

@end

@interface EditingGestureController : NSObject <UIGestureRecognizerDelegate>

-(id)initWithView:(UIView *)view;

@property (weak, nonatomic) id<EditingGestureControllerDelegate> delegate;

@property (nonatomic) EditingMode editingMode;
@property (weak, nonatomic) UIViewController *editingVC;
@property (weak, nonatomic) UIView *gestureView;

@property (strong, nonatomic, nullable) Item *currentItem;

@property (nonatomic) CGPoint originalPoint;

@property (nonatomic) float originalScaleRatio;
@property (nonatomic) float originalPinchDistance;
@property (nonatomic) float currentRotation;
@property (nonatomic) float lastRotation;
@property (nonatomic) CGPoint originalPinchCenter;
@property (nonatomic) CGPoint originalFirstFinger;
@property (nonatomic) CGPoint originalSecondFinger;
@property (nonatomic) CGPoint originalItemViewCenter;


@property (nonatomic) BOOL isPinchingItem;

-(void)addGestureRecognizers;

@end

NS_ASSUME_NONNULL_END
