//
//  CraftVlog.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/30.
//

#import "CraftVlogTemplate.h"

@implementation CraftVlogTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"craftVlogPreview";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"FourHeartTemplate";
        self.backgroundImageName = @"vlogFrame4";
        [self setUpPhotoFrame];
        [self setUpTexts];
        
    }
    return self;
    
}

+(CraftVlogTemplate*)craftVlogTemplate{
    
    CraftVlogTemplate* craftVlogTemplate = [[self alloc] init];
    
    return craftVlogTemplate;
    
}

-(void)setUpPhotoFrame{
    
    self.photoFrames = [NSMutableArray new];
    FullRectangle *photoFrame = [FullRectangle fullRectangle];
    photoFrame.isTemplateItem = true;
    photoFrame.center = CGPointMake(0.5, 0.5);
    [self.photoFrames addObject:photoFrame];
        
}

-(void)setUpTexts{
    
    Text *vlogText = [[Text alloc] init];
    VlogNanumSquareTypo *vlog = [VlogNanumSquareTypo vlogNanumSquareTypo];
    vlogText.scale = 1.5;
    vlogText.center = CGPointMake(0.5, 0.5);
    vlogText.isTemplateItem = true;
    vlogText.text = @"VLog";
    vlogText.textView.text = @"VLog";
    [vlogText applyTypo:vlog];
    [self.texts addObject:vlogText];
    
}

-(void)setUpStickers{
    
    
    
}


@end