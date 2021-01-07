//
//  QuarterDivisionTemplate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "QuarterDivisionTemplate.h"

@implementation QuarterDivisionTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"quarterDivisionVlog";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"quarterDivisionTemplate";
        self.backgroundImageName = @"";
        [self addPhotoFrames];
        
    }
    return self;
    
}

+(QuarterDivisionTemplate*)quarterDivisionTemplate{
    
    QuarterDivisionTemplate* quarterDivisionTemplate = [[self alloc] init];
    
    return quarterDivisionTemplate;
    
}

-(void)addPhotoFrames{
//    self.photoFrames = [NSMutableArray new];
//    PhotoFrame *phoroFrame = [BasicCircle basicCircle];
//    [self.photoFrames addObject:phoroFrame];
}


@end
