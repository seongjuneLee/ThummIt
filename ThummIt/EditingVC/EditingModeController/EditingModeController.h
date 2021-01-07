//
//  EditingContentModeController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    NormalMode = 0,
    AddPhotoFrameMode = 1,
    EditingPhotoFrameMode = 2,
} EditingMode;

@protocol EditingModeControllerDelegate <NSObject>


@end
//상태에 따른 기본적인 UI 컨트롤러
@interface EditingModeController : NSObject

@property (weak, nonatomic) id<EditingModeControllerDelegate> delegate;
@property (nonatomic) EditingMode editingMode;
@property (weak, nonatomic) UIViewController *editingVC;

-(void)setUpEditingMode:(EditingMode)editingMode;

@end

NS_ASSUME_NONNULL_END
