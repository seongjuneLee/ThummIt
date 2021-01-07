//
//  TwoDivisionTemplate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "TwoDivisionTemplate.h"

@implementation TwoDivisionTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"twoDivisionVlog";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"twoDivisionTemplate";
        self.backgroundImageName = @"";
        [self addPhotoFrames];
        
    }
    return self;
    
}

+(TwoDivisionTemplate*)twoDivisionTemplate{
    
    TwoDivisionTemplate* twoDivisionTemplate = [[self alloc] init];
    
    return twoDivisionTemplate;
    
}

-(void)addPhotoFrames{
//    self.photoFrames = [NSMutableArray new];
//    PhotoFrame *phoroFrame = [BasicCircle basicCircle];
//    [self.photoFrames addObject:phoroFrame];
}


@end
