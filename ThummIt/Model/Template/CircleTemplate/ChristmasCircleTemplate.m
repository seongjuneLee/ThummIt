//
//  ChristmasCircleTemplate.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import "ChristmasCircleTemplate.h"

@implementation ChristmasCircleTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"christmasTemplate";
        self.category = NSLocalizedString(@"Entertain", nil);
        self.templateName = @"christmasCircleTemplate";
        self.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:229.0/255.0 blue:205.0/255.0 alpha:1.0];
        self.backgroundImageName = @"";
        [self addPhotoFrames];
        
    }
    return self;
    
}

+(ChristmasCircleTemplate*)christmasCircleTemplate{
    
    ChristmasCircleTemplate* christmasCircleTemplate = [[self alloc] init];
    
    return christmasCircleTemplate;
    
}

-(void)addPhotoFrames{
    
    self.photoFrames = [NSMutableArray new];
    PhotoFrame *firstPhotoFrame = [ChristmasCircle christmasCircle];
    firstPhotoFrame.isTemplateItem = true;
    
    firstPhotoFrame.relativeCenter = CGPointMake(0.32, 0.5);
    
    [self.photoFrames addObject:firstPhotoFrame];

    
}

@end
