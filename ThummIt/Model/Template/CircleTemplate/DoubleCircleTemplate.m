//
//  DoubleCircleTemplate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "DoubleCircleTemplate.h"

@implementation DoubleCircleTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"doubleCircleImage";
        self.category = NSLocalizedString(@"Entertain", nil);
        self.templateName = @"doubleCircleTemplate";
        self.backgroundColor = UIColor.blackColor;
        self.backgroundImageName = @"";
        [self addPhotoFrames];
        
    }
    return self;
    
}

+(DoubleCircleTemplate*)doubleCircleTemplate{
    
    DoubleCircleTemplate* doubleCircleTemplate = [[self alloc] init];
    
    return doubleCircleTemplate;
    
}

-(void)addPhotoFrames{
    
    self.photoFrames = [NSMutableArray new];
    PhotoFrame *firstPhotoFrame = [BasicCircle basicCircle];
    PhotoFrame *secondPhotoFrame = [BasicCircle basicCircle];
    
    firstPhotoFrame.relativeCenter = CGPointMake(0.32, 0.5);
    firstPhotoFrame.isTemplateItem = true;
    secondPhotoFrame.relativeCenter = CGPointMake(0.68, 0.5);
    secondPhotoFrame.scale = 0.9;
    secondPhotoFrame.isTemplateItem = true;
    
    [self.photoFrames addObject:firstPhotoFrame];
    [self.photoFrames addObject:secondPhotoFrame];

    
}


@end
