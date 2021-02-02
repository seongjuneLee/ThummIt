//
//  RunningMan1.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/27.
//

#import "RunningMan1Template.h"

@implementation RunningMan1Template

-(id)init{
    
    self = [super init];
    if(self){
        
        self.templateName = @"runningMan1Template";
        self.previewImageName = @"runningManPreview1";
        self.category = NSLocalizedString(@"Entertain", nil);
        self.backgroundImageName = @"runningMan1Frame";
    }
    return self;
    
}

+(RunningMan1Template*)runningMan1Template{
    
    RunningMan1Template* runningMan1Template = [[self alloc] init];
    
    return runningMan1Template;
    
}

-(void)setUpPhotoFrame{
    
    PhotoFrame *photoFrame1 = [[PhotoFrame alloc] init];
    photoFrame1.isTemplateItem = true;
    photoFrame1.isFixedPhotoFrame = true;
    float screenWidth = UIScreen.mainScreen.bounds.size.width;
    float frameWidth = screenWidth * 0.6;
    photoFrame1.baseView.backgroundColor = UIColor.grayColor;
    photoFrame1.baseView.frameSize = CGSizeMake(frameWidth, screenWidth * 9/16);
    photoFrame1.center = CGPointMake(0.3, 0.5);
    [self.photoFrames addObject:photoFrame1];
    
    
    PhotoFrame *photoFrame2 = [[PhotoFrame alloc] init];
    photoFrame2.isTemplateItem = true;
    photoFrame2.isFixedPhotoFrame = true;
    float frameWidth2 = screenWidth * 0.4;
    photoFrame2.baseView.backgroundColor = UIColor.lightGrayColor;
    photoFrame2.baseView.frameSize = CGSizeMake(frameWidth2, screenWidth * 9/16);
    photoFrame2.center = CGPointMake(0.8, 0.5);
    [self.photoFrames addObject:photoFrame2];
    
}

-(void)setUpTexts{

    //로고
    Text *logoText = [[Text alloc] init];
    RunningManLogoTypo *logo = [RunningManLogoTypo runningManLogoTypo];
    logoText.text = @"러닝맨";
    logoText.textView.text = logoText.text;
    logoText.scale = 0.55;
    logoText.center = CGPointMake(0.08, 0.13);
    logoText.isTemplateItem = true;
    [logoText applyTypo:logo];
    [self.texts addObject:logoText];
    
    //랜덤게임.zip
    Text *randomGameText = [[Text alloc] init];
    YellowGradientTypo *yellowGradientTypo = [YellowGradientTypo yellowGradientTypo];
    randomGameText.text = @"랜덤게임.zip";
    randomGameText.textView.text = randomGameText.text;
    randomGameText.scale = 1.45;
    randomGameText.center = CGPointMake(0.25, 0.89);
    randomGameText.isTemplateItem = true;
    [randomGameText applyTypo:yellowGradientTypo];
    [self.texts addObject:randomGameText];
    
    //러닝맨
    Text *learningManText = [[Text alloc] init];
    WorkingManNameTypo *workingManNameTypo = [WorkingManNameTypo workingManNameTypo];
    learningManText.text = @"러닝맨";
    learningManText.textView.text = learningManText.text;
    learningManText.scale = 1;
    learningManText.center = CGPointMake(0.1, 0.75);
    learningManText.isTemplateItem = true;
    [learningManText applyTypo:workingManNameTypo];
    [self.texts addObject:learningManText];
    
    //(식은땀)
    Text *ddamText = [[Text alloc] init];
    DDamTypo *ddam = [DDamTypo ddamTypo];
    ddamText.text = @"(식은땀)";
    ddamText.textView.text = ddamText.text;
    ddamText.scale = 1.05;
    ddamText.center = CGPointMake(0.71, 0.21);
    ddamText.isTemplateItem = true;
    [ddamText applyTypo:ddam];
    [self.texts addObject:ddamText];
    
    //하고싶은말 있는데
    Text *redshoutingText1 = [[Text alloc] init];
    RedShoutingTypo *redshoutingTypo1 = [RedShoutingTypo redShoutingTypo];
    redshoutingText1.text = @"하고싶은말 있는데\n해도 되나요?";
    redshoutingText1.textView.text = redshoutingText1.text;
    redshoutingText1.scale = 0.8;
    redshoutingText1.rotationDegree = 355;
    redshoutingText1.center = CGPointMake(0.75, 0.72);
    redshoutingText1.isTemplateItem = true;
    [redshoutingText1 applyTypo:redshoutingTypo1];
    [self.texts addObject:redshoutingText1];
    
    //이 형은 룰을
    Text *redshoutingText2 = [[Text alloc] init];
    RedShoutingTypo *redshoutingTypo2 = [RedShoutingTypo redShoutingTypo];
    redshoutingText2.text = @"이 형은 룰을\n아예 모르네";
    redshoutingText2.textView.text = redshoutingText2.text;
    redshoutingText2.scale = 0.65;
    redshoutingText2.rotationDegree = 355;
    redshoutingText2.center = CGPointMake(0.35, 0.52);
    redshoutingText2.isTemplateItem = true;
    [redshoutingText2 applyTypo:redshoutingTypo2];
    [self.texts addObject:redshoutingText2];
    
}

-(void)setUpStickers{
    
    RunningManExcSticker *runningManExcSticker1 = [RunningManExcSticker runningManExcSticker];
    runningManExcSticker1.scale = 0.53;
    runningManExcSticker1.isTemplateItem = true;
    runningManExcSticker1.center = CGPointMake(0.37, 0.36);
    [self.stickers addObject:runningManExcSticker1];
    
    RunningManExcSticker *runningManExcSticker2 = [RunningManExcSticker runningManExcSticker];
    runningManExcSticker2.scale = 0.53;
    runningManExcSticker2.isTemplateItem = true;
    runningManExcSticker2.center = CGPointMake(0.42, 0.36);
    [self.stickers addObject:runningManExcSticker2];

}

@end