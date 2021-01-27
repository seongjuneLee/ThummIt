//
//  CircleTemplate.m
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import "CircleTemplate.h"

@implementation CircleTemplate
-(id)init{
    
    self = [super init];
    if(self){
        
        self.templateName = @"circleTemplate";
        self.previewImageName = @"circleImage";
        self.category = NSLocalizedString(@"Entertain", nil);
        self.backgroundColor = UIColor.blackColor;
        self.backgroundImageName = @"";
        
    }
    return self;
    
}

+(CircleTemplate*)circleTemplate{
    
    CircleTemplate* circleTemplate = [[self alloc] init];
    
    return circleTemplate;
    
}

-(void)setUpPhotoFrame{
    
    PhotoFrame *photoFrame = [BasicCircle basicCircle];
    photoFrame.isTemplateItem = true;
    photoFrame.baseView.backgroundColor = UIColor.whiteColor;
    [self.photoFrames addObject:photoFrame];
    
    
}

-(void)setUpTexts{
    
}

@end
