//
//  DashedGuideLine.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/21.
//

#import "DashedGuideLineView.h"
#import "Item.h"

@implementation DashedGuideLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(instancetype)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = UIColor.clearColor;
        self.frameHeight = 2;
    }
    
    return self;
}


-(id)initWithItem:(Item *)item{
    
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    [self makeViewDashed];
    
    return self;
}

-(void)makeViewDashed{
        
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //draw a line
    
    [path moveToPoint:CGPointMake(0, 0)]; //add yourStartPoint here
    [path addLineToPoint:CGPointMake(self.frameSize.width, 0)];// add yourEndPoint here
    [path stroke];


    UIColor *fill = [UIColor colorWithRed:60.0/255.0 green:120.0/255.0 blue:180.0/255.0 alpha:1.0];
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeColor = fill.CGColor;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.lineJoin = kCALineJoinMiter;
    shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:7], nil];
    shapeLayer.path = path.CGPath;
    
    [[self layer] addSublayer:shapeLayer];
}
@end
