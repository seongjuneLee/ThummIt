//
//  ItemManager.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import "ItemManager.h"
#import "SaveManager.h"
#import "PhotoFrameHeader.h"
#import "StickerHeader.h"

@implementation ItemManager

+ (ItemManager *)sharedInstance {
    static ItemManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ItemManager alloc] init];
        sharedInstance.fetchedTypoDatas = [sharedInstance typoDatas];
    });
    
    return sharedInstance;
}

#pragma mark - 포토 프레임

-(NSArray *)photoFrameCategories{
    
    // 여기 카테고리의 순서와 아래 아이템 데이타에서 해당 카테고리 아이템 어레이의 순서를 맞춰주어야 함.
    NSString *circle = NSLocalizedString(@"circle", nil);
    NSArray *categories = @[circle];
    
    return categories;
}

-(NSArray *)photoFrameDatas{
    
    BasicCirclePhotoFrame *basicCircle = [BasicCirclePhotoFrame basicCirclePhotoFrame];
    ChristmasCircle *christmasCircle = [ChristmasCircle christmasCircle];
    CebuRectangle *cebuRect = [CebuRectangle cebuRectangle];
    PolaroidRectangle *polaroidRect = [PolaroidRectangle polaroidRectangle];
    NSArray *photoFrames = @[basicCircle, christmasCircle,  cebuRect, polaroidRect];
    return @[photoFrames];
}

-(NSArray *)photoFrameCategoriesForFreeFormProject{
    
    // 여기 카테고리의 순서와 아래 아이템 데이타에서 해당 카테고리 아이템 어레이의 순서를 맞춰주어야 함.
    NSString *circle = NSLocalizedString(@"Basic", nil);
    NSString *screen = NSLocalizedString(@"Screen", nil);
    NSArray *categories = @[circle,screen];
    
    return categories;
}


-(NSArray *)photoFrameDatasForFreeFormProject{
    
    BasicCirclePhotoFrame *basicCircle = [BasicCirclePhotoFrame basicCirclePhotoFrame];
    ChristmasCircle *christmasCircle = [ChristmasCircle christmasCircle];
    CebuRectangle *cebuRect = [CebuRectangle cebuRectangle];
    PolaroidRectangle *polaroidRect = [PolaroidRectangle polaroidRectangle];
    FullRectangle *fullRect = [FullRectangle fullRectangle];
    VerticalHalfRectangle *verticalHalfRect = [VerticalHalfRectangle verticalHalfRectangle];
    HorizontalHalfRectangle *horizontalHalfRect = [HorizontalHalfRectangle horizontalHalfRectangle];
    OneThirdRectangle *oneThirdRect = [OneThirdRectangle oneThirdRectangle];
    QuarterRectangle *quarterRect = [QuarterRectangle quarterRectangle];
    NSArray *basicPhotoFrames = @[basicCircle, christmasCircle,  cebuRect, polaroidRect,];
    NSArray *screenPhotoFramse = @[fullRect,verticalHalfRect,horizontalHalfRect,oneThirdRect,quarterRect];
    return @[basicPhotoFrames,screenPhotoFramse];
}

#pragma mark - 텍스트

-(NSArray *)typoCategories{
    
    NSString *circle = NSLocalizedString(@"circle", nil);
    NSArray *categories = @[circle];
    
    return categories;
}


-(NSArray *)typoDatas{
    
    NormalTypo *normal = [NormalTypo normalTypo];
    TrapezoidTypo *trapezoidTypo = [TrapezoidTypo trapezoidTypo];
    RunningManLogoTypo *runningManLogoTypo = [RunningManLogoTypo runningManLogoTypo];
    SeoYuGiLogoTypo *seoYuGiLogoTypo = [SeoYuGiLogoTypo seoYuGiLogoTypo];
    SeoYuGiGagwanTypo *seoYuGiGagwanTypo = [SeoYuGiGagwanTypo seoYuGiGagwanTypo];
    SeoYuGiCloudLogoTypo *seoYuGiCloudLogoTypo = [SeoYuGiCloudLogoTypo seoYuGiCloudLogoTypo];
    SeoYuGiCowRiseTypo *seoYuGiCowRiseTypo = [SeoYuGiCowRiseTypo seoYuGiCowRiseTypo];
    SeoYuGiDawnWatchingTypo *seoYuGiDawnWatchingTypo = [SeoYuGiDawnWatchingTypo seoYuGiDawnWatchingTypo];
    
    WorkManLogo *workManLogo = [WorkManLogo workManLogo];
    WorkManHandWrite *workManHandWrite = [WorkManHandWrite workManHandWrite];
    WorkManTalkWrite *workManTalkWrite = [WorkManTalkWrite workManTalkWrite];
    WorkManRedTitle *workManRedTitle = [WorkManRedTitle workManRedTitle];
    WorkManRightTag *workManRightTag = [WorkManRightTag workManRightTag];
    WorkmanYelloewTitle *workmanYelloewTitle = [WorkmanYelloewTitle workmanYelloewTitle];
    WorkManLogo2 *workManLogo2 = [WorkManLogo2 workManLogo2];
    WorkManLeftTag *workManLeftTag = [WorkManLeftTag workManLeftTag];
    WorkManSecondTitle *workManSecondTitle = [WorkManSecondTitle workManSecondTitle];
    WorkManFast *workManFast = [WorkManFast workManFast];
    WorkManYoutube *workManYoutube =[WorkManYoutube workManYoutube];
    
    InfiniteChallengeLogo *infiniteChallengeLogo = [InfiniteChallengeLogo infiniteChallengeLogo];
    InfiniteChallengeEscapeRoom *infiniteChallengeEscapeRoom = [InfiniteChallengeEscapeRoom infiniteChallengeEscapeRoom];
    InfiniteChallengeWhiteTypo *infiniteChallengeWhiteTypo = [InfiniteChallengeWhiteTypo infiniteChallengeWhiteTypo];
    InfiniteChallengeBlackTypo *infiniteChallengeBlackTypo = [InfiniteChallengeBlackTypo infiniteChallengeBlackTypo];
    InfiniteChallengeBlueTypo *infiniteChallengeBlueTypo = [InfiniteChallengeBlueTypo infiniteChallengeBlueTypo];
    InfiniteChallengeOrangeTypo *infiniteChallengeOrangeTypo = [InfiniteChallengeOrangeTypo infiniteChallengeOrangeTypo];
    InfiniteChallengeLegeno *infiniteChallengeLegeno = [InfiniteChallengeLegeno infiniteChallengeLegeno];
    InfiniteChallengeYellowSpeechBoxWhite *infiniteChallengeYellowSpeechBoxWhite = [InfiniteChallengeYellowSpeechBoxWhite infiniteChallengeYellowSpeechBoxWhite];
    InfiniteChallengeYellowSpeechBoxYellow *infiniteChallengeYellowSpeechBoxYellow = [InfiniteChallengeYellowSpeechBoxYellow infiniteChallengeYellowSpeechBoxYellow];
    InfiniteChallengeTopOfYellow *infiniteChallengeTopOfYellow = [InfiniteChallengeTopOfYellow infiniteChallengeTopOfYellow];
    InfiniteChallengeFiveMinutes *infiniteChallengeFiveMinutes = [InfiniteChallengeFiveMinutes infiniteChallengeFiveMinutes];
    InfiniteChallengeHashTag *infiniteChallengeHashTag = [InfiniteChallengeHashTag infiniteChallengeHashTag];
    InfiniteChallengeSkyBlueBox *infiniteChallengeSkyBlueBox = [InfiniteChallengeSkyBlueBox infiniteChallengeSkyBlueBox];
    InfiniteChallengeCloudBox *infiniteChallengeCloudBox = [InfiniteChallengeCloudBox infiniteChallengeCloudBox];
    
    DinggoSmileTypo *dinggoSmileTypo = [DinggoSmileTypo dinggoSmileTypo];
    DinggoBigEdit *dinggoBigEdit = [DinggoBigEdit dinggoBigEdit];
    DinggoBingoTypo *dinggoBingoTypo = [DinggoBingoTypo dinggoBingoTypo];
    DinggoPotatoTypo *dinggoPotatoTypo = [DinggoPotatoTypo dinggoPotatoTypo];
    DinggoGoodTalk *dinggoGoodTalk = [DinggoGoodTalk dinggoGoodTalk];
    DinggoStarWarsTypo *dinggoStarWarsTypo = [DinggoStarWarsTypo dinggoStarWarsTypo];
    DinggoBehindTypo *dinggoBehindTypo = [DinggoBehindTypo dinggoBehindTypo];
    DinggoMurder *dinggoMurder = [DinggoMurder dinggoMurder];
    DigitalTypo *digitalTypo = [DigitalTypo digitalTypo];
    
    VlogWebWrite *vlogWebWrite = [VlogWebWrite vlogWebWrite];

    VlogLookbookTypo *vlogLookbookTypo = [VlogLookbookTypo vlogLookbookTypo];
    VlogBrushTypo *vlogBrushTypo = [VlogBrushTypo vlogBrushTypo];
    VlogSummerTypo *vlogSummerTypo = [VlogSummerTypo vlogSummerTypo];
    VlogDailyTypo *vlogDailyTypo = [VlogDailyTypo vlogDailyTypo];
    VlogLogoTagTypo *vlogLogoTagTypo = [VlogLogoTagTypo vlogLogoTagTypo];
    VlogCookingTypo *vlogCookingTypo = [VlogCookingTypo vlogCookingTypo];
    VlogHashTagTypo *vlogHashTagTypo = [VlogHashTagTypo vlogHashTagTypo];
    VlogBMDohyunTypo *vlogBMDohyunTypo = [VlogBMDohyunTypo vlogBMDohyunTypo];
    VlogMyeongjoTypo *vlogMyeongjoTypo = [VlogMyeongjoTypo vlogMyeongjoTypo];
    VlogGRWMTypo *vlogGRWMTypo = [VlogGRWMTypo vlogGRWMTypo];
    VlogNanumSquareTypo *vlogNanumSquareTypo = [VlogNanumSquareTypo vlogNanumSquareTypo];
    VlogMakingFilmTypo *vlogMakingFilmTypo = [VlogMakingFilmTypo vlogMakingFilmTypo];

    SeoYuGiInFrontOfGirlTypo *seoYuGiInFrontOfGirlTypo = [SeoYuGiInFrontOfGirlTypo seoYuGiInFrontOfGirlTypo];
    SeoYuGiHungryTypo *seoYuGiHungryTypo = [SeoYuGiHungryTypo seoYuGiHungryTypo];
    
    VlogDesiner *vlogDesiner = [VlogDesiner vlogDesiner];
    VlogCompany *vlogCompany = [VlogCompany vlogCompany];
    VlogNewCampus *vlogNewCampus = [VlogNewCampus vlogNewCampus];
    VlogDog *vlogDog = [VlogDog vlogDog];
    VlogModel *vlogModel = [VlogModel vlogModel];
    VlogSummer *vlogSummer = [VlogSummer vlogSummer];
    VlogOriginal *vlogOriginal = [VlogOriginal vlogOriginal];
    VlogTrip *vlogTrip = [VlogTrip vlogTrip];
    VlogInItaly *vlogInItaly = [VlogInItaly vlogInItaly];
    VlogItaly *vlogItaly = [VlogItaly vlogItaly];
    VlogLongDance *vlogLongDance = [VlogLongDance vlogLongDance];
    VlogShortDance *vlogShortDance = [VlogShortDance vlogShortDance];
    VlogStudy *vlogStudy = [VlogStudy vlogStudy];
    VlogVisitingCompanyTypo *vlogVisitingCompanyTypo = [VlogVisitingCompanyTypo vlogVisitingCompanyTypo];
    VlogFreshmanTypo *vlogFreshmanTypo = [VlogFreshmanTypo vlogFreshmanTypo];
    VlogStudentTypo *vlogStudentTypo = [VlogStudentTypo vlogStudentTypo];
    DDamTypo *ddamTypo = [DDamTypo ddamTypo];
    RedShoutingTypo *redShoutingTypo = [RedShoutingTypo redShoutingTypo];
    YellowGradientTypo *yellowGradientTypo =[YellowGradientTypo yellowGradientTypo];
    WorkingManNameTypo *workingManNameTypo =[WorkingManNameTypo workingManNameTypo];
    BlueMoonTypo *blueMoonTypo = [BlueMoonTypo blueMoonTypo];
    WhatTypo *whatTypo = [WhatTypo whatTypo];
    AtmosphereTypo *atmosphereTypo = [AtmosphereTypo atmosphereTypo];
    WhiteYellowGradientTypo *whiteYellowGradientTypo = [WhiteYellowGradientTypo whiteYellowGradientTypo];
    TikiTypo *tikiTypo = [TikiTypo tikiTypo];
    KnockOutTypo *knockOutTypo = [KnockOutTypo knockOutTypo];
    MatterTypo *matterTypo = [MatterTypo matterTypo];
    SuccessTypo *successTypo = [SuccessTypo successTypo];
    WhyRealTypo *whyrealTypo = [WhyRealTypo whyRealTypo];
    RuleTypo *ruleTypo = [RuleTypo ruleTypo];
    VlogBarunGothicTypo *vlogBarunGothicTypo = [VlogBarunGothicTypo vlogBarunGothicTypo];
    VlogMacaronTypo *vlogMacaronTypo = [VlogMacaronTypo vlogMacaronTypo];
    VlogMomTypo *vlogMomTypo = [VlogMomTypo vlogMomTypo];
    VlogHolidayTypo *vlogHolidayTypo = [VlogHolidayTypo vlogHolidayTypo];
    
    HelloTypo *helloTypo = [HelloTypo helloTypo];
    GoodByeTypo *goodByeTypo = [GoodByeTypo goodByeTypo];
    ThankYouTypo *thankYouTypo = [ThankYouTypo thankYouTypo];
    SeeYouAgainTypo *seeYouAgainTypo = [SeeYouAgainTypo seeYouAgainTypo];
    HappyBrithdayPypo *happyBrithdayPypo = [HappyBrithdayPypo happyBrithdayPypo];
    LifeTypo *lifeTypo = [LifeTypo lifeTypo];
    GalleryTypo *galleryTypo = [GalleryTypo galleryTypo];
    MbcTypo *mbcTypo = [MbcTypo mbcTypo];

    NSArray *typos = @[normal, trapezoidTypo, seoYuGiLogoTypo, seoYuGiGagwanTypo, vlogWebWrite,vlogDesiner,vlogCompany,vlogNewCampus, seoYuGiCloudLogoTypo, seoYuGiInFrontOfGirlTypo, seoYuGiCowRiseTypo,vlogDog,vlogModel,vlogSummer, vlogOriginal, vlogTrip, vlogInItaly, vlogItaly, vlogLongDance, vlogShortDance, vlogStudy,vlogFreshmanTypo,vlogStudentTypo, seoYuGiHungryTypo, seoYuGiDawnWatchingTypo,runningManLogoTypo ,workManLogo, workManHandWrite,  workManTalkWrite, workManRedTitle, workManRightTag,workManYoutube, workmanYelloewTitle,workManLogo2, workManLeftTag, workManSecondTitle, workManFast, infiniteChallengeLogo, infiniteChallengeEscapeRoom, infiniteChallengeWhiteTypo, infiniteChallengeBlackTypo, infiniteChallengeBlueTypo, infiniteChallengeOrangeTypo, infiniteChallengeLegeno, infiniteChallengeYellowSpeechBoxWhite, infiniteChallengeYellowSpeechBoxYellow, infiniteChallengeTopOfYellow, infiniteChallengeFiveMinutes, infiniteChallengeHashTag, infiniteChallengeSkyBlueBox, infiniteChallengeCloudBox, vlogLookbookTypo, vlogBrushTypo, vlogSummerTypo, vlogDailyTypo, vlogLogoTagTypo, vlogCookingTypo, vlogHashTagTypo, vlogBMDohyunTypo, vlogMyeongjoTypo, vlogGRWMTypo, vlogNanumSquareTypo, ddamTypo, redShoutingTypo, yellowGradientTypo, workingManNameTypo, blueMoonTypo, whatTypo, atmosphereTypo, whiteYellowGradientTypo, tikiTypo, knockOutTypo, matterTypo, successTypo, whyrealTypo, ruleTypo, vlogMakingFilmTypo,vlogVisitingCompanyTypo,     vlogBarunGothicTypo, vlogMacaronTypo, vlogMomTypo, vlogHolidayTypo,dinggoSmileTypo,dinggoBigEdit,dinggoBingoTypo,dinggoPotatoTypo,dinggoGoodTalk,dinggoStarWarsTypo,dinggoBehindTypo,dinggoMurder,digitalTypo,helloTypo,thankYouTypo,seeYouAgainTypo,happyBrithdayPypo,lifeTypo,goodByeTypo,galleryTypo,mbcTypo];
    
    return @[typos];
}



#pragma mark - 스티커
-(NSArray *)stickerCategories{

    NSString *basic = NSLocalizedString(@"basic", nil);

    NSArray *categories = @[basic];
    
    return categories;
}

-(NSArray *)stickerDatas{

    RunningManExcSticker* runningManExcSticker =[RunningManExcSticker runningManExcSticker];
    RunningManQuSticker* runningManQuSticker =[RunningManQuSticker runningManQuSticker];
    SinSeoYuGiExc1Sticker* sinSeoYuGiExc1Sticker =[SinSeoYuGiExc1Sticker sinSeoYuGiExc1Sticker];
    SinSeoYuGiExc2Sticker* sinSeoYuGiExc2Sticker =[SinSeoYuGiExc2Sticker sinSeoYuGiExc2Sticker];
    SinSeoYuGiQu1Sticker* sinSeoYuGiQu1Sticker =[SinSeoYuGiQu1Sticker sinSeoYuGiQu1Sticker];
    SinSeoYuGiQu2Sticker* sinSeoYuGiQu2Sticker =[SinSeoYuGiQu2Sticker sinSeoYuGiQu2Sticker];


    WorkManStartleSticker *workManStartleSticker  = [WorkManStartleSticker workManStartleSticker];
    
    InfiniteChallengeSkullSticker *infiniteChallengeSkullSticker = [InfiniteChallengeSkullSticker infiniteChallengeSkullSticker];
    
    VlogVideoSticker *vlogVideoSticker = [VlogVideoSticker vlogVideoSticker];
    VlogMacaronSticker *vlogMacaronSticker = [VlogMacaronSticker vlogMacaronSticker];
    VlogTapeSticker *vlogTapeSticker = [VlogTapeSticker vlogTapeSticker];
    
    CircleSticker1 *circleSticker1 = [CircleSticker1 circleSticker1];
    ArrowSticker1 *arrowSticker1  = [ArrowSticker1 arrowSticker1];
    XSticker1 *xSticker1  = [XSticker1 xSticker1];
    StartleSticker1* startleSticker1 =[StartleSticker1 startleSticker1];
    AngrySticker1 *angrySticker1  = [AngrySticker1 angrySticker1];
    BlinkSticker1 *blinkSticker1 = [BlinkSticker1 blinkSticker1];
    PigtailSticker *pigtailSticker = [PigtailSticker pigtailSticker];
    HeartSticker1 *heartSticker1 = [HeartSticker1 heartSticker1];
    HeartSticker2 *heartSticker2 = [HeartSticker2 heartSticker2];
    HeartSticker3 *heartSticker3 = [HeartSticker3 heartSticker3];
    HeartSticker4 *heartSticker4 = [HeartSticker4 heartSticker4];
    
    
    ArrowSticker2 *arrowSticker2 = [ArrowSticker2 arrowSticker2];
    ArrowSticker3 *arrowSticker3 = [ArrowSticker3 arrowSticker3];
    ArrowSticker4 *arrowSticker4 = [ArrowSticker4 arrowSticker4];
    ArrowSticker5 *arrowSticker5 = [ArrowSticker5 arrowSticker5];
    ArrowSticker6 *arrowSticker6 = [ArrowSticker6 arrowSticker6];
    ArrowSticker7 *arrowSticker7 = [ArrowSticker7 arrowSticker7];
    BlinkSticker3 *blinkSticker3 = [BlinkSticker3 blinkSticker3];
    BulbSticker *bulbSticker = [BulbSticker bulbSticker];
    BurstSticker1 *burstSticker1 = [BurstSticker1 burstSticker1];
    ButtonPauseSticker *buttonPauseSticker = [ButtonPauseSticker buttonPauseSticker];
    ButtonPlaySticker *buttonPlaySticker = [ButtonPlaySticker buttonPlaySticker];
    ButtonStopSticker *buttonStopSticker = [ButtonStopSticker buttonStopSticker];
    CircleSticker2 *circleSticker2 = [CircleSticker2 circleSticker2];
    CloudSticker1 *cloudSticker1 = [CloudSticker1 cloudSticker1];
    CloudSticker2 *cloudSticker2 = [CloudSticker2 cloudSticker2];
    DollarSticker*dollarSticker = [DollarSticker dollarSticker];
    EffectSticker1*effectSticker1 = [EffectSticker1 effectSticker1];
    EffectSticker2*effectSticker2 = [EffectSticker2 effectSticker2];
    EffectSticker3*effectSticker3 = [EffectSticker3 effectSticker3];
    GameSticker*gameSticker = [GameSticker gameSticker];
    GlitterSticker*glitterSticker = [GlitterSticker glitterSticker];
    GoodSticker1*goodSticker1 = [GoodSticker1 goodSticker1];
    HeartSticker5*heartSticker5 = [HeartSticker5 heartSticker5];
    HeartSticker6*heartSticker6 = [HeartSticker6 heartSticker6];
    HeartSticker7*heartSticker7 = [HeartSticker7 heartSticker7];
    HeartSticker8*heartSticker8 = [HeartSticker8 heartSticker8];
    HeartSticker9*heartSticker9 = [HeartSticker9 heartSticker9];
    HeartSticker10*heartSticker10 = [HeartSticker10 heartSticker10];
    KoreanFlagSticker*koreanFlagSticker = [KoreanFlagSticker koreanFlagSticker];
    LockSticker*lockSticker = [LockSticker lockSticker];
    MedalBronzeSticker*medalBronzeSticker = [MedalBronzeSticker medalBronzeSticker];
    MedalSilverSticker*medalSilverSticker = [MedalSilverSticker medalSilverSticker];
    MedalGoldSticker*medalGoldSticker = [MedalGoldSticker medalGoldSticker];
    NoteSticker1*noteSticker1 = [NoteSticker1 noteSticker1];
    NoteSticker2*noteSticker2 = [NoteSticker2 noteSticker2];
    NoteSticker3*noteSticker3 = [NoteSticker3 noteSticker3];
    NuclearSticker*nuclearSticker = [NuclearSticker nuclearSticker];
    RspRockSticker*rspRockSticker = [RspRockSticker rspRockSticker];
    RspScissorsSticker*rspScissorsSticker = [RspScissorsSticker rspScissorsSticker];
    RspPaperSticker*rspPaperSticker = [RspPaperSticker rspPaperSticker];
    SnowflakeSticker1*snowflakeSticker1 = [SnowflakeSticker1 snowflakeSticker1];
    SnowflakeSticker2*snowflakeSticker2 = [SnowflakeSticker2 snowflakeSticker2];
    SnowmanSticker*snowmanSticker = [SnowmanSticker snowmanSticker];
    SpeechBubbleSticker1*speechBubbleSticker1 = [SpeechBubbleSticker1 speechBubbleSticker1];
    SpeechBubbleSticker2*speechBubbleSticker2 = [SpeechBubbleSticker2 speechBubbleSticker2];
    SpeechBubbleSticker3*speechBubbleSticker3 = [SpeechBubbleSticker3 speechBubbleSticker3];
    SpeechBubbleSticker4*speechBubbleSticker4 = [SpeechBubbleSticker4 speechBubbleSticker4];
    StainSticker1 *stainSticker1 =[StainSticker1 stainSticker1];
    StainSticker2 *stainSticker2 =[StainSticker2 stainSticker2];
    StarSticker1 *starSticker1 =[StarSticker1 starSticker1];
    StarSticker2 *starSticker2 =[StarSticker2 starSticker2];
    StarSticker3 *starSticker3 =[StarSticker3 starSticker3];
    StarSticker4 *starSticker4 =[StarSticker4 starSticker4];
    TargetSticker *targetSticker =[TargetSticker targetSticker];
    TagSticker *tagSticker =[TagSticker tagSticker];
    TearsSticker *tearsSticker =[TearsSticker tearsSticker];
    TriangleSticker1 *triangleSticker1 =[TriangleSticker1 triangleSticker1];
    LongRectangleSticker *longRectangleSticker = [LongRectangleSticker longRectangleSticker];
   
    
    
    

    NSArray *basicStickers = @[longRectangleSticker, circleSticker1,arrowSticker1,xSticker1,runningManExcSticker,runningManQuSticker,sinSeoYuGiExc1Sticker,sinSeoYuGiExc2Sticker, sinSeoYuGiQu1Sticker,sinSeoYuGiQu2Sticker,startleSticker1, angrySticker1, workManStartleSticker, infiniteChallengeSkullSticker, vlogVideoSticker,pigtailSticker,heartSticker1,heartSticker2,heartSticker3,heartSticker4,heartSticker5,heartSticker6,heartSticker7,heartSticker8,heartSticker9,heartSticker10, vlogMacaronSticker,vlogTapeSticker,arrowSticker2,arrowSticker3,arrowSticker4,arrowSticker5,arrowSticker6,arrowSticker7,blinkSticker1,blinkSticker3,bulbSticker,burstSticker1,buttonPauseSticker,buttonPlaySticker,buttonStopSticker,circleSticker2,cloudSticker1,cloudSticker2,dollarSticker,effectSticker1,effectSticker2,effectSticker3,gameSticker,glitterSticker,goodSticker1,koreanFlagSticker,lockSticker,medalBronzeSticker,medalSilverSticker,medalGoldSticker,noteSticker1,noteSticker2,noteSticker3,nuclearSticker,rspRockSticker,rspScissorsSticker,rspPaperSticker,snowflakeSticker1,snowflakeSticker2,snowmanSticker,speechBubbleSticker1,speechBubbleSticker2,speechBubbleSticker3,speechBubbleSticker4,stainSticker1,stainSticker2,starSticker1,starSticker2,starSticker3,starSticker4,tagSticker,targetSticker,tearsSticker,triangleSticker1];
    
    return @[basicStickers];
}

-(BOOL)containsItem:(Item *)item{
    
    if ([SaveManager.sharedInstance.currentProject.items containsObject:item]) {
        return true;
    }
    return false;
}

@end
