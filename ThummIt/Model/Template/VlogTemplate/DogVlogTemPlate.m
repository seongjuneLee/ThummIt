//
//  DogVlogTemplate.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/14.
//

#import "DogVlogTemplate.h"

@implementation DogVlogTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"dogVlogPreview";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"DogVlogTemplate";
        self.backgroundImageName = @"dogVlogFrame";
        
    }
    return self;
    
}
 
+(DogVlogTemplate*)dogVlogTemPlate{
    
    DogVlogTemplate* dogVlogTemPlate = [[self alloc] init];
    
    return dogVlogTemPlate;
    
}

-(void)setUpPhotoFrame{
    
    QuarterRectangle *firstPhotoFrame = [QuarterRectangle quarterRectangle];
    QuarterRectangle *secondPhotoFrame = [QuarterRectangle quarterRectangle];
    firstPhotoFrame.isTemplateItem = true;
    secondPhotoFrame.isTemplateItem = true;
    firstPhotoFrame.isFixedPhotoFrame = true;
    secondPhotoFrame.isFixedPhotoFrame = true;
   
    firstPhotoFrame.center = CGPointMake(0.25, 0.25);
    secondPhotoFrame.center = CGPointMake(0.75, 0.25);
    [self.photoFrames addObject:firstPhotoFrame];
    [self.photoFrames addObject:secondPhotoFrame];

    PhotoFrame *photoFrame1 = [HorizontalHalfRectangle horizontalHalfRectangle];
    photoFrame1.isTemplateItem = true;
    photoFrame1.isFixedPhotoFrame = true;
    photoFrame1.center = CGPointMake(0.5, 0.75);
    [self.photoFrames addObject:photoFrame1];
}

-(void)setUpTexts{
    
    Text *vlogText = [[Text alloc] init];
    VlogDog *vlog = [VlogDog vlogDog];
    vlogText.scale = 0.23;
    vlogText.center = CGPointMake(0.5, 0.5);
    vlogText.isTemplateItem = true;
    vlogText.indexInLayer =@"0";
    vlogText.text = @"vlog";
    vlogText.textView.text = @"vlog";
    vlogText.typo = vlog;
    [self.texts addObject:vlogText];
    
}

-(void)setUpStickers{
    
}
@end
