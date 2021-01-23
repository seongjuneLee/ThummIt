//
//  Text.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/08.
//

#import "Text.h"
#import "UITextView+Additions.h"

@implementation Text
-(id)init{
    
    self = [super init];
    if(self){
        
        self.text = [[NSString alloc] init];
        self.attributedText = [[NSAttributedString alloc] init];
        self.backgroundAttributedTexts = [NSMutableArray array];
        self.typoRangeArray = [NSMutableArray array];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.textView = [self makeTextView];
        self.textViewContainer = [self makeTextViewContainerWithTextView:self.textView];
        self.baseView = self.textViewContainer;

        self.center = CGPointMake(0,0);
        self.rotationDegree = 0;
        self.scale = 1;
        
    }
    return self;
}

-(id)initWithTypo:(Typography *)typo{
    
    self = [self init];
    if(self){
        
        [self applyTypo:typo];
        
    }
    return self;
    
}

@synthesize textView  = _textView;

- (void)setTextView:(AdvancedTextView *)textView{
    _textView = textView;
}

- (AdvancedTextView *)textView{
    return _textView;
}

@synthesize attributedText  = _attributedText;

- (void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
}

- (NSAttributedString *)attributedText{
    return _attributedText;
}



#pragma mark - encode, decode

-(void)encodeWithCoder:(NSCoder *)encoder {
    
    [super encodeWithCoder:encoder];

    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.typoRangeArray forKey:@"typoRangeArray"];
    NSData* typoData = [NSKeyedArchiver archivedDataWithRootObject:self.typo];
    [encoder encodeObject:typoData forKey:@"typo"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.textAlignment] forKey:@"textAlignment"];
    [encoder encodeObject:[NSValue valueWithCGPoint:self.center] forKey:@"center"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.scale] forKey:@"scale"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.rotationDegree] forKey:@"rotation"];

}


-(id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super initWithCoder:decoder])) {
        
        // 컨텐츠
        self.typoRangeArray = [decoder decodeObjectForKey:@"typoRangeArray"];
        self.text = [decoder decodeObjectForKey:@"text"];
        NSData* typoData = [decoder decodeObjectForKey:@"typo"];
        if (typoData) {
            self.typo = [NSKeyedUnarchiver unarchiveObjectWithData:typoData];
        }
        self.typoRangeArray = [decoder decodeObjectForKey:@"typoRangeArray"];
        
        // 위치, 크기, 각도
        self.center = [[decoder decodeObjectForKey:@"center"] CGPointValue];
        self.textAlignment = [[decoder decodeObjectForKey:@"textAlignment"] integerValue];
        self.rotationDegree = [[decoder decodeObjectForKey:@"rotation"] floatValue];
        self.scale = [[decoder decodeObjectForKey:@"scale"] floatValue];
        
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    
    Text *copied = [super copyWithZone:zone];
    
    copied.text = self.text;
    copied.attributedText = [self.attributedText copy];
    copied.backgroundAttributedTexts = [self.backgroundAttributedTexts copy];
    copied.typo = [self.typo copy];
    copied.typoRangeArray = [self.typoRangeArray copy];
    copied.textAlignment = self.textAlignment;
    copied.center = self.center;
    copied.scale = self.scale;
    copied.rotationDegree = self.rotationDegree;
    
    return copied;
}

#pragma mark - 타이포 적용

-(void)applyTypo:(Typography *)typo{
    
    NSRange prevRange = self.textView.selectedRange;
    NSRange range = NSMakeRange(prevRange.location, prevRange.length);
    if (range.length == 0) {
        range = NSMakeRange(0, self.textView.text.length);
    }
    [self applyTypo:typo forRange:range];
    
    self.textView.selectedRange = prevRange;
}

-(void)applyTypo:(Typography *)typo forRange:(NSRange)range{
    
    if (!self.textView){
        return;
    }
    
    self.typo = typo;
    
    // 1. 텍스트뷰에 타이포 적용
    [self.textView setUpTypography:typo range:range]; // 타이포 텍스트뷰에 적용하는 부분
    self.backgroundAttributedTexts = self.textView.backgroundAttributedTexts; // 나중에 복구 위해

    // 2. 배경이미지뷰에 타이포 적용
    if (typo.bgImageName) { // 배경이미지뷰 달아야하면, 달기
        
        if (self.backgroundImageView == nil) {
            self.backgroundImageView = [[UIImageView alloc] init];
            [self.textViewContainer addSubview:self.backgroundImageView];
            [self.textViewContainer sendSubviewToBack:self.backgroundImageView];
        }
        self.backgroundImageView.image = [UIImage imageNamed:typo.bgImageName];
        self.backgroundImageView.contentMode = typo.bgContentMode;
        
        // 크기 및 위치 설정
        [self updateBackgroundImageViewFrame:typo];
        
    } else {
        self.backgroundImageView.image = nil;
    }
    
    // 3. 알파값
    self.textView.alpha = typo.alpha;
    self.backgroundImageView.alpha = typo.alpha;
    
    [self resize];
}

// 부분 타이포 적용
-(void)setUpTypoRangeArray:(NSArray*)typoRangeArray{
    
    NSMutableArray* copiedTypoRangeArray = [NSMutableArray arrayWithArray:[typoRangeArray copy]];
    for (NSArray* typoRange in copiedTypoRangeArray) {
        Typography* typo = typoRange.firstObject;
        NSRange range = NSRangeFromString(typoRange.lastObject);
        [self applyTypo:typo forRange:range];
    }
    self.typoRangeArray = copiedTypoRangeArray;

}

#pragma mark - 배경이미지

-(void)updateBackgroundImageViewFrame:(Typography *)typo{
    
    float widthScale = 1.1;
    float heightScale = 1.2; // 텍스트뷰 감싸주도록 좀 크게
    self.backgroundImageView.frame = CGRectMake(0, 0, self.textView.frameWidth*widthScale + typo.bgWidthPadding, self.textView.frameHeight*heightScale + typo.bgHeightPadding);
    self.backgroundImageView.center = self.textView.center; // 중앙 맞춰주기

    [self.textViewContainer layoutIfNeeded];
    
}

#pragma mark - 뷰 제작

-(AdvancedTextView*)makeTextView{
    
    // 텍스트뷰
    AdvancedTextView* textView = [[AdvancedTextView alloc] initWithFrame:CGRectMake(0, 0, 375, 100)];
    textView.backgroundColor = UIColor.clearColor;
    textView.keyboardAppearance = UIKeyboardAppearanceDark;
    textView.textAlignment = self.textAlignment;
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:TEXT_FONT_SIZE];
    textView.textColor = [UIColor whiteColor];
    textView.scrollEnabled = false;
    textView.clipsToBounds = false;
    textView.userInteractionEnabled = false;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return textView;
}

-(TextViewContainer*)makeTextViewContainerWithTextView:(AdvancedTextView*)textView{
    // 텍스트 컨테이너 뷰
    TextViewContainer* textViewContainer = [[TextViewContainer alloc] initWithFrame:CGRectMake(textView.frameX, textView.frameY, textView.frameWidth, textView.frameHeight)];
    textViewContainer.userInteractionEnabled = false;
    [textViewContainer addSubview:textView];
    textViewContainer.center = textView.center;

    return textViewContainer;
}

+(UIImageView*)makePlaceHolderWithTypo:(Typography*)typo{
    
    Text * placeHolderText = [[Text alloc] init];
    placeHolderText.textView.text = typo.name;
    placeHolderText.text = typo.name;
    placeHolderText.textAlignment = NSTextAlignmentCenter;
    placeHolderText.textView.textAlignment = NSTextAlignmentCenter;

    [placeHolderText applyTypo:typo];
    placeHolderText.textView.font = [UIFont fontWithName:typo.fontName size:typo.fontSize]; // placeholder는 fontName으로.
    [placeHolderText resize];
    
    [placeHolderText.textView setNeedsDisplay];
    UIImageView * imgView = [placeHolderText makePlaceholderImageView];
    
    return imgView;
}


-(UIImageView*)makePlaceholderImageView{

    CGSize size = CGSizeMake(self.textViewContainer.boundsWidth, self.textViewContainer.boundsHeight);
    
    UIImage* image;
    if (self.typo.bgImageName == nil) {
        image = [self imageFromView:self.textView];
    } else {
        // backgroundImageView 기준으로 사이즈 설정
        UIImageView* backgroundImageView = self.backgroundImageView;
        size = CGSizeMake(backgroundImageView.boundsWidth, backgroundImageView.boundsHeight);
        
        // 실제 텍스트뷰의 배경이미지뷰에 addsubview 하면 안되니깐, 새로 instance 생성
        UIImageView* backgroundImageViewForSnapshot = [[UIImageView alloc] init];
        backgroundImageViewForSnapshot.bounds = backgroundImageView.bounds;
        backgroundImageViewForSnapshot.image = backgroundImageView.image;
        backgroundImageViewForSnapshot.contentMode = backgroundImageView.contentMode;
        
        // backgroundImageView위에 textView 이미지뷰 얹어서 이미지화
        UIImage* textImage = [self imageFromView:self.textView];
        UIImageView* textViewImageView = [[UIImageView alloc] initWithImage:textImage];
        textViewImageView.bounds = CGRectMake(0, 0, self.textView.boundsWidth, self.textView.boundsHeight);
        textViewImageView.center = CGPointMake(size.width/2.0 - self.typo.bgCenterXDelta, size.height/2.0 - self.typo.bgCenterYDelta);
        [backgroundImageViewForSnapshot addSubview:textViewImageView];
        
        // 최종 이미지 세팅
        image = [self imageFromView:backgroundImageViewForSnapshot];
    }
    
    // 텍스트의 이미지뷰 제작
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.center = self.textViewContainer.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = false;
    imageView.image = image;
        
    return imageView;
}
-(UIImage *)imageFromView:(UIView *)view{
    CGSize size = view.frameSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)loadView{
    
    // 0. 뷰 새로 파기
    self.textView = [self makeTextView];
    self.textViewContainer = [self makeTextViewContainerWithTextView:self.textView];
    self.baseView = self.textViewContainer;
    
    // 1. 텍스트뷰 세팅
    self.textView.parent = self;
    self.textView.text = self.text;
    self.textView.backgroundAttributedTexts = self.backgroundAttributedTexts;
    self.textView.textAlignment = self.textAlignment;
    
    
    // 2. 텍스트뷰컨테이너 세팅
    self.textViewContainer.center = self.center;
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degreesToRadians(self.rotationDegree));
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.scale, self.scale);
    self.textViewContainer.transform = CGAffineTransformConcat(rotationTransform, scaleTransform);
    [self resize]; // 컨테이너뷰가 텍스트뷰 사이즈 따라가도록
    
    // 3. 배경 이미지뷰 세팅
    if (self.backgroundImageView != nil) {
        [self.textViewContainer addSubview:self.backgroundImageView];
        [self.textViewContainer sendSubviewToBack:self.backgroundImageView];
    }
    [self updateBackgroundImageViewFrame:self.typo];
    [self.textViewContainer setNeedsLayout];
    
    [self applyTypo:self.typo];
    
    // 5. 부분 타이포 적용
    [self setUpTypoRangeArray:self.typoRangeArray];
    self.baseView = self.textViewContainer;
}

#pragma mark - 리사이즈

-(void)resize{
    
    // 텍스트뷰 리사이즈
    [self.textView resizeForCurrentFontSize];
    // 컨테이너 리사이즈
    if (self.typo.bgImageName) {
        self.textViewContainer.bounds = self.backgroundImageView.bounds;
        self.textView.center = CGPointMake(self.textViewContainer.frameWidth/2, self.textViewContainer.frameHeight/2);
        self.backgroundImageView.center = CGPointMake(self.textViewContainer.frameWidth/2, self.textViewContainer.frameHeight/2);
    } else {
        self.textViewContainer.bounds = self.textView.bounds;
    }

    // 배경이미지뷰 리사이즈
    [self updateBackgroundImageViewFrame:self.typo];
}

#pragma mark - Helper

-(BOOL)logAttributesOfAttributedText:(NSAttributedString*)string{
    
    __block BOOL contain = false;
    
    // attributedString의 어트리뷰트 복구
    [string enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    }];
    
    return contain;
}


-(BOOL)attributedTextContainsPatternImage{
    
    __block BOOL contain = false;
    
    // attributedString의 어트리뷰트 복구
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        UIColor* textColor = [attrs objectForKey:NSForegroundColorAttributeName];
        if (CGColorGetPattern(textColor.CGColor)) {
            contain = true;
        }
    }];
    
    return contain;
}

-(NSString*)type{
    return @"text";
}


@end
