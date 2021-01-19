//
//  PartialTransparentView.m
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//

#import "PartialTransparentView.h"

@implementation PartialTransparentView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.backgroundColor setFill];
    UIRectFill(rect);

    // clear the background in the given rectangles
    for (NSValue *holeRectValue in self.rectsArray) {
        CGRect holeRect = [holeRectValue CGRectValue];
        CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
        [[UIColor clearColor] setFill];
        UIRectFill(holeRectIntersection);
    }

}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects
{
    self.backgroundColor = color;
    self.rectsArray = rects;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
    }
    return self;
}

@end
