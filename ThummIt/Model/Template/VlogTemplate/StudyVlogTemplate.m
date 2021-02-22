//
//  StudyVlogTemplate.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/02.
//

#import "StudyVlogTemplate.h"

@implementation StudyVlogTemplate

-(id)init{
    
    self = [super init];
    if(self){
           
        self.previewImageName = @"studyVlogPreview";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"StudyVlogTemplate";
        self.mainFrameImageName = @"";
        self.backgroundColor = [UIColor colorWithRed:177/255.0 green:149/255.0 blue:153/255.0 alpha:1];
        
    }
    return self;
    
}

+(StudyVlogTemplate*)studyVlogTemplate{
    
    StudyVlogTemplate* studyVlogTemplate = [[self alloc] init];
    
    return studyVlogTemplate;
    
}

-(void)setUpPhotoFrame{
    
//    PhotoFrame *photoFrame1 = [[PhotoFrame alloc] init];
//    photoFrame1.isTemplateItem = true;
//    photoFrame1.isFixedPhotoFrame = true;
//    float screenWidth = UIScreen.mainScreen.bounds.size.width;
//    float frameWidth = screenWidth;
//    photoFrame1.baseView.frameSize = CGSizeMake(frameWidth * 0.68, screenWidth * 9/16 * 0.73);
//    photoFrame1.center = CGPointMake(0.5, 0.5);
//    [self.photoFrames addObject:photoFrame1];
    
    PhotoFrame *photoFrame1 = [StudyTemplateRectangle studyTemplateRectangle];
    photoFrame1.isTemplateItem = true;
    photoFrame1.isFixedPhotoFrame = true;
    photoFrame1.center = CGPointMake(0.5, 0.5);
    [self.photoFrames addObject:photoFrame1];
  
}

-(void)setUpTexts{
    
    Text *vlogText = [[Text alloc] init];
    VlogStudy *vlog = [VlogStudy vlogStudy];
    vlogText.scale = 0.30;
    vlogText.center = CGPointMake(0.5, 0.93);
    vlogText.isTemplateItem = true;
    vlogText.indexInLayer =@"0";
    vlogText.text = @"Study With Me";
    vlogText.textView.text = @"Study With Me";
    vlogText.typo = vlog;
    [self.texts addObject:vlogText];
    
    Text *epVlogText = [[Text alloc] init];
    VlogStudy *epvlog = [VlogStudy vlogStudy];
    epVlogText.scale = 0.09;
    epVlogText.center = CGPointMake(0.5, 0.07);
    epVlogText.isTemplateItem = true;
    epVlogText.indexInLayer =@"1";
    epVlogText.text = @"EP-1";
    epVlogText.textView.text = @"EP-1";
    epVlogText.typo = epvlog;
    [self.texts addObject:epVlogText];
    
    Text *Vlog365Text = [[Text alloc] init];
    Vlog365 *vlog365 = [Vlog365 vlog365];
    Vlog365Text.scale = 0.12;
    Vlog365Text.center = CGPointMake(0.93, 0.05);
    Vlog365Text.isTemplateItem = true;
    Vlog365Text.indexInLayer =@"2";
    Vlog365Text.text = @"D-365";
    Vlog365Text.textView.text = @"D-365";
    Vlog365Text.typo = vlog365;
    [self.texts addObject:Vlog365Text];
    
}

-(void)setUpStickers{
    
    VlogTapeSticker *upTapeSticker = [VlogTapeSticker vlogTapeSticker];
    upTapeSticker.indexInLayer =@"3";
    upTapeSticker.scale = 0.225;
    upTapeSticker.isTemplateItem = true;
    upTapeSticker.center = CGPointMake(0.17, 0.18);

    [self.stickers addObject:upTapeSticker];
    
    VlogTapeSticker *underTapeSticker = [VlogTapeSticker vlogTapeSticker];
    underTapeSticker.indexInLayer =@"4";
    underTapeSticker.scale = 0.225;
    underTapeSticker.isTemplateItem = true;
    underTapeSticker.center = CGPointMake(0.83, 0.82);

    [self.stickers addObject:underTapeSticker];
    
}

@end
