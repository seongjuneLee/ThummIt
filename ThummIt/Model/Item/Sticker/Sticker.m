//
//  Sticker.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/12.
//

#import "Sticker.h"

@implementation Sticker

-(id)init{
    self = [super init];
    if(self){
        
        // 템플릿에서만 필요
        self.center = CGPointMake(0.5, 0.5);
        self.scale = 0.5;
        self.rotationDegree = 0;
        
    }
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    Sticker *copied = [super copyWithZone:zone];
    
    UIView *copiedBaseView = [[UIView alloc] initWithFrame:self.baseView.frame];
    copiedBaseView.backgroundColor = self.baseView.backgroundColor;
    copiedBaseView.clipsToBounds = self.baseView.clipsToBounds;
    copied.baseView = copiedBaseView;
    copied.backgroundImageView = [[UIImageView alloc] initWithFrame:self.backgroundImageView.frame];
    copied.backgroundImageView.image = [UIImage imageNamed:self.backgroundImageName];
    [copied.baseView addSubview:copied.backgroundImageView];
    copied.rotationDegree = self.rotationDegree;
    copied.baseView.transform = CGAffineTransformMakeRotation(copied.rotationDegree);
    if (self.itemName) {
        copied.itemName = [NSString stringWithString:self.itemName];
    }

    return copied;
}


-(id)initWithCoder:(NSCoder *)decoder{
    
    if((self = [super initWithCoder:decoder])) {
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    
    [super encodeWithCoder:encoder];

}

#pragma mark - helper

-(void)loadView{
    
    [self makeBaseView];
    [self addBackgroundImageView];
    
}

-(void)makeBaseView{
    
    UIImage *image = [UIImage imageNamed:self.backgroundImageName];
    float ratio = image.size.height/image.size.width;
    if (isnan(ratio)) {
        ratio = 1;
        NSLog(@"ratio is nan");
        NSLog(@"imageimageimageimage %@",image);
    }
    NSLog(@"ratio %f",ratio);
    self.baseView = [[UIView alloc] init];
    self.baseView.clipsToBounds = true;
    float screenWidth = UIScreen.mainScreen.bounds.size.width;
    float circleViewWidth = screenWidth*0.8/2;
    self.baseView.frameSize = CGSizeMake(circleViewWidth, circleViewWidth * ratio);
    self.baseView.backgroundColor = UIColor.clearColor;
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degreesToRadians(self.rotationDegree));
    float width = UIScreen.mainScreen.bounds.size.width;
    float scale = width/self.baseView.frameWidth;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale * self.scale, scale * self.scale);
    NSLog(@"scale * self.scale %f",scale * self.scale);
    self.baseView.transform = CGAffineTransformConcat(rotationTransform, scaleTransform);
    self.baseView.center = self.center;
}

-(void)addBackgroundImageView{
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frameSize = self.baseView.frameSize;
    self.backgroundImageView.center = CGPointMake(self.baseView.frameWidth/2, self.baseView.frameHeight/2);
    self.backgroundImageView.backgroundColor = UIColor.clearColor;
    self.backgroundImageView.clipsToBounds = true;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageNamed:self.backgroundImageName];
    
    if(self.tintColor){
        self.backgroundImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.backgroundImageView.tintColor = self.tintColor;
    } else {
        self.backgroundImageView.image = image;
    }
    
    [self.baseView addSubview:self.backgroundImageView];
    
}

@end
