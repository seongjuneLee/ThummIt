//
//  GuideLine.h
//  ThummIt
//
//  Created by 이성준 on 2021/01/21.
//
typedef enum {
    GuideTypeCenterX = 0,
    GuideTypeCenterY = 1,
    GuideTypeTop = 2,
    GuideTypeBottom = 3,
    GuideTypeLeading = 4,
    GuideTypeTrailing = 5,
    GuideTypeDegree = 6,
    GuideTypeFrame = 7
}GuideType;

#import <Foundation/Foundation.h>
#import "GuideLineView.h"
#import "DashedGuideLineView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GuideLine : NSObject

@property (nonatomic) GuideType guideType;

@property (strong, nonatomic) GuideLineView *horizontalGuideView;
@property (strong, nonatomic) GuideLineView *verticalGuideView;
@property (strong, nonatomic) GuideLineView *horizontalGuideView2;
@property (strong, nonatomic) GuideLineView *verticalGuideView2;

@property (strong, nonatomic) DashedGuideLineView *degreeDashedGuideView;
@property (strong, nonatomic) DashedGuideLineView *horizontalDashedGuideView;
@property (strong, nonatomic) DashedGuideLineView *verticalDashedGuideView;

-(id)initWithType:(GuideType)type withView:( UIView *)bgView;

-(void)addSubViewToSuperView:(UIView *)view;
-(void)removeFromSuperView;

@end

NS_ASSUME_NONNULL_END
