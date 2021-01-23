//
//  GuideLine.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/21.
//

#import "GuideLine.h"

@implementation GuideLine

-(id)initWithType:(GuideType)type withView:(UIView *)view{
    
    self = [self init];

    if (self) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        float width = window.bounds.size.width;
        float height = width * 9/16;


        if (type == GuideTypeCenterX) {
            self.verticalGuideView = [[GuideLineView alloc] init];
            self.verticalGuideView.frameWidth = 2;
            self.verticalGuideView.frameHeight = height;

            self.verticalGuideView.center = view.center;
        }
        if (type == GuideTypeCenterY) {
            self.horizontalGuideView = [[GuideLineView alloc] init];
            self.horizontalGuideView.frameWidth = width;
            self.horizontalGuideView.frameHeight = 2;

            self.horizontalGuideView.center = view.center;
        }
        if (type == GuideTypeTop) {
            self.horizontalGuideView = [[GuideLineView alloc] init];
            self.horizontalGuideView.frameWidth = width;
            self.horizontalGuideView.frameHeight = 2;

            self.horizontalGuideView.frameY = view.frameY;
        }
        if (type == GuideTypeBottom) {
            self.horizontalGuideView = [[GuideLineView alloc] init];
            self.horizontalGuideView.frameWidth = width;
            self.horizontalGuideView.frameHeight = 2;

            self.horizontalGuideView.frameY = view.frameY + view.frameHeight - 2;
        }
        if (type == GuideTypeLeading) {
            self.verticalGuideView = [[GuideLineView alloc] init];
            self.verticalGuideView.frameWidth = 2;
            self.verticalGuideView.frameHeight = height;

            self.verticalGuideView.frameX = view.frameX;
            self.verticalGuideView.frameY = view.frameY;
        }
        if (type == GuideTypeTrailing) {
            self.verticalGuideView = [[GuideLineView alloc] init];
            self.verticalGuideView.frameWidth = 2;
            self.verticalGuideView.frameHeight = height;

            self.verticalGuideView.frameX = view.frameX + view.frameWidth -2;
            self.verticalGuideView.frameY = view.frameY;
        }
        if (type == GuideTypeFrame) {
            self.horizontalGuideView = [[GuideLineView alloc] init];
            self.horizontalGuideView.frameHeight = 2;
            self.horizontalGuideView.frameWidth = view.frameWidth;
            self.horizontalGuideView.frameOrigin = CGPointMake(view.frameX, view.frameY);
            
            
            self.horizontalGuideView2 = [[GuideLineView alloc] init];
            self.horizontalGuideView2.frameHeight = 2;
            self.horizontalGuideView2.frameWidth = view.frameWidth;
            self.horizontalGuideView2.frameOrigin = CGPointMake(view.frameX, view.frameY+view.frameHeight);
            
            self.verticalGuideView = [[GuideLineView alloc] init];
            self.verticalGuideView.frameWidth = 2;
            self.verticalGuideView.frameHeight = view.frameHeight;
            self.verticalGuideView.frameOrigin = CGPointMake(view.frameX, view.frameY);

            self.verticalGuideView2 = [[GuideLineView alloc] init];
            self.verticalGuideView2.frameWidth = 2;
            self.verticalGuideView2.frameHeight = view.frameHeight;
            self.verticalGuideView2.frameOrigin = CGPointMake(view.frameX + view.frameWidth, view.frameY);

        }
        
        if (type == GuideTypeDegree) {
            CGRect frame = CGRectMake(view.frameX, view.frameY + view.frameHeight/2, view.frameWidth, 2);
            self.degreeDashedGuideView = [[DashedGuideLineView alloc] initWithFrame:frame];
        }

    }
    return self;
}

-(void)addSubViewToSuperView:(UIView *)view{
    
    if (self.horizontalGuideView) {
        [view addSubview:self.horizontalGuideView];
    }
    if (self.horizontalGuideView2) {
        [view addSubview:self.horizontalGuideView2];
    }
    if (self.verticalGuideView) {
        [view addSubview:self.verticalGuideView];
    }
    if (self.verticalGuideView2) {
        [view addSubview:self.verticalGuideView2];
    }
    if (self.horizontalDashedGuideView) {
        [view addSubview:self.horizontalDashedGuideView];
    }
    if (self.verticalDashedGuideView) {
        [view addSubview:self.verticalDashedGuideView];
    }
    if (self.degreeDashedGuideView) {
        [view addSubview:self.degreeDashedGuideView];
    }
    self.horizontalGuideView.alpha = self.verticalGuideView.alpha = self.horizontalDashedGuideView.alpha = self.verticalDashedGuideView.alpha = self.horizontalGuideView.alpha = self.horizontalGuideView2.alpha = self.verticalGuideView.alpha = self.verticalGuideView2.alpha = 0;

    [UIView animateWithDuration:0.2 animations:^{
        self.horizontalGuideView.alpha = self.verticalGuideView.alpha = self.horizontalDashedGuideView.alpha = self.verticalDashedGuideView.alpha = self.horizontalGuideView.alpha = self.horizontalGuideView2.alpha = self.verticalGuideView.alpha = self.verticalGuideView2.alpha = 1.0;
    }];
    
}

-(void)removeFromSuperView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.horizontalGuideView.alpha =
        self.verticalGuideView.alpha =
        self.horizontalGuideView2.alpha =
        self.verticalGuideView2.alpha =
        self.degreeDashedGuideView.alpha =
        self.horizontalDashedGuideView.alpha =
        self.verticalDashedGuideView.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (self.horizontalGuideView) {
            [self.horizontalGuideView removeFromSuperview];
        }
        if (self.verticalGuideView) {
            [self.verticalGuideView removeFromSuperview];
        }
        if (self.horizontalGuideView2) {
            [self.horizontalGuideView2 removeFromSuperview];
        }
        if (self.verticalGuideView2) {
            [self.verticalGuideView2 removeFromSuperview];
        }
        if (self.horizontalDashedGuideView) {
            [self.horizontalDashedGuideView removeFromSuperview];
        }
        if (self.verticalDashedGuideView) {
            [self.verticalDashedGuideView removeFromSuperview];
        }
        if (self.degreeDashedGuideView) {
            [self.degreeDashedGuideView removeFromSuperview];
        }
    }];
    

}

@end
