//
//  VisitingCompanyTemplate.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/30.
//

#import "VisitingCompanyVlogTemplate.h"

@implementation VisitingCompanyVlogTemplate

-(id)init{
    
    self = [super init];
    if(self){
        
        self.previewImageName = @"visitingCompanyPreview";
        self.category = NSLocalizedString(@"Vlog", nil);
        self.templateName = @"visitingCompanyVlogTemplate";
        self.backgroundImageName = @"visitingCompanyVlogFrame";
        
    }
    return self;
    
}

+(VisitingCompanyVlogTemplate*)visitingCompanyVlogTemplate{
    
    VisitingCompanyVlogTemplate* visitingCompanyVlogTemplate = [[self alloc] init];
    
    return visitingCompanyVlogTemplate;
    
}

-(void)setUpPhotoFrame{
    
    FullRectangle *fullRectPhotoFrame = [FullRectangle fullRectangle];
    fullRectPhotoFrame.isTemplateItem = true;
    fullRectPhotoFrame.isFixedPhotoFrame = true;
    fullRectPhotoFrame.center = CGPointMake(0.5, 0.5);
    fullRectPhotoFrame.baseView.backgroundColor = UIColor.lightGrayColor;
    [self.photoFrames addObject:fullRectPhotoFrame];
    
}

-(void)setUpTexts{
    
    //YouTube Originals
    Text *originalsText = [[Text alloc] init];
    VlogOriginal *originals = [VlogOriginal vlogOriginal];
    originalsText.scale = 0.75;
    originalsText.center = CGPointMake(0.17, 0.1);
    originalsText.isTemplateItem = true;
    originalsText.text = @"YouTube Originals";
    originalsText.textView.text = originalsText.text;
    [originalsText applyTypo:originals];
    [self.texts addObject:originalsText];
    
    //MAKING FILM
    Text *makingFilmText = [[Text alloc] init];
    VlogMakingFilmTypo *makingFilm = [VlogMakingFilmTypo vlogMakingFilmTypo];
    makingFilmText.scale = 0.56;
    makingFilmText.center = CGPointMake(0.885, 0.43);
    makingFilmText.isTemplateItem = true;
    makingFilmText.text = @"MAKING\nFILM";
    makingFilmText.textView.text = makingFilmText.text;
    [makingFilmText applyTypo:makingFilm];
    [self.texts addObject:makingFilmText];
    
    //은우의
    Text *eunwooText = [[Text alloc] init]; //타이포 변경
    VlogVisitingCompanyTypo *eunwoo = [VlogVisitingCompanyTypo vlogVisitingCompanyTypo];
    eunwoo.borderWidth = 3;
    eunwoo.borderColor = UIColor.whiteColor;
    eunwooText.scale = 1.71;
    eunwooText.center = CGPointMake(0.175, 0.665);
    eunwooText.isTemplateItem = true;
    eunwooText.text = @"은우의";
    eunwooText.textView.text = eunwooText.text;
    [eunwooText applyTypo:eunwoo];
    [self.texts addObject:eunwooText];
    
    //회사탐방 VLOG
    Text *visitingCompanyText = [[Text alloc] init];
    VlogVisitingCompanyTypo *visitingCompany = [VlogVisitingCompanyTypo vlogVisitingCompanyTypo];
    visitingCompanyText.scale = 1.71;
    visitingCompanyText.center = CGPointMake(0.365, 0.86);
    visitingCompanyText.isTemplateItem = true;
    visitingCompanyText.text = @"회사탐방VLOG";
    visitingCompanyText.textView.text = visitingCompanyText.text;
    [visitingCompanyText applyTypo:visitingCompany];
    [self.texts addObject:visitingCompanyText];
    
}

-(void)setUpStickers{

    VlogVideoSticker *vlogVideoSticker = [VlogVideoSticker vlogVideoSticker];
    vlogVideoSticker.scale = 0.7;
    vlogVideoSticker.isTemplateItem = true;
    vlogVideoSticker.center = CGPointMake(0.93, 0.28);
    [self.stickers addObject:vlogVideoSticker];
    
}

@end