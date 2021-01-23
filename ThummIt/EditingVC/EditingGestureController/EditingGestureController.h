//
//  EditingGestureController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "PhotoFrame.h"
#import "Text.h"
#import "Sticker.h"
#import "EditingModeController.h"
#import "EditingModeController.h"
#import "GuideLine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditingGestureControllerDelegate <NSObject>

-(void)didSelectItem:(Item *)item;
-(void)changeCurrentItem:(Item *)item;
-(void)didTapPhotoFrameWhileAdding;
-(void)didTapTextWhileAdding;

// 노멀 모드 팬제스쳐
-(void)readyUIForPanning;
-(void)deleteImageRespondToCurrentPointY:(float)currentPointY;
-(void)panGestureEndedForItem:(Item *)item withFingerPoint:(CGPoint)fingerPoint;

@end

@interface EditingGestureController : NSObject <UIGestureRecognizerDelegate>

-(id)initWithView:(UIView *)view;

@property (weak, nonatomic) id<EditingGestureControllerDelegate> delegate;

@property (nonatomic) EditingMode editingMode;
@property (weak, nonatomic) UIViewController *editingVC;
@property (weak, nonatomic) UIView *gestureView;

@property (weak, nonatomic) Item *currentItem;
@property (nonatomic) BOOL isPinching;

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

// 가이드 라인
@property (strong, nonatomic, nullable) GuideLine *centerXLine;
@property (strong, nonatomic, nullable) GuideLine *centerYLine;
@property (strong, nonatomic, nullable) GuideLine *topLine;
@property (strong, nonatomic, nullable) GuideLine *bottomLine;
@property (strong, nonatomic, nullable) GuideLine *leadingLine;
@property (strong, nonatomic, nullable) GuideLine *trailingLine;
@property (strong, nonatomic, nullable) GuideLine *degreeLine;
@property (strong, nonatomic, nullable) GuideLine *itemFrameLine;
@property (strong, nonatomic, nullable) GuideLine *bgViewFrameLine;

@property (strong ,nonatomic, nullable) UINotificationFeedbackGenerator *feedbackGenerator;

-(void)addGestureRecognizers;

@end

NS_ASSUME_NONNULL_END
