//
//  Border.m
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import "PhotoFrame.h"

@implementation PhotoFrame

-(id)init{
    
    self = [super init];
    if(self){
        self.itemType = 0;
        self.relativeCenter = CGPointMake(0.5, 0.5);
        self.scale = 1;
        self.rotationDegree = 0;
        
        float screenWidth = UIScreen.mainScreen.bounds.size.width;
        float circleViewWidth = screenWidth*0.8/2;
        self.baseView = [[UIView alloc] init];
        self.baseView.frameSize = CGSizeMake(circleViewWidth, circleViewWidth);
        self.baseView.clipsToBounds = true;
        self.baseView.layer.cornerRadius = self.baseView.frameWidth/2;
        self.baseView.backgroundColor = UIColor.whiteColor;
        [self addSubViewsToBaseView];
    }
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    PhotoFrame *copied = [super copyWithZone:zone];
    copied.baseView.layer.cornerRadius = copied.baseView.frameWidth/2;
    
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

-(void)addCircleImageWithName:(NSString *)imageName{
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frameSize = self.baseView.frameSize;
    self.backgroundImageView.center = CGPointMake(self.baseView.frameWidth/2, self.baseView.frameHeight/2);
    self.backgroundImageView.backgroundColor = UIColor.clearColor;
    self.backgroundImageView.clipsToBounds = true;
    self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frameWidth/2;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (imageName) {
        self.backgroundImageView.image = [UIImage imageNamed:imageName];
        [self.baseView addSubview:self.backgroundImageView];
    }

}

-(void)addSubViewsToBaseView{
    
    self.plusLabel = [[UILabel alloc] init];
    self.plusLabel.text = NSLocalizedString(@"+ Photo", nil);
    self.plusLabel.textColor = UIColor.blackColor;
    [self.plusLabel sizeToFit];
    self.plusLabel.center = CGPointMake(self.baseView.frameWidth/2, self.baseView.frameHeight/2);
    [self.baseView addSubview:self.plusLabel];
    
    self.photoImageView = [[UIImageView alloc] init];
    self.photoImageView.frameSize = self.baseView.frameSize;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.photoImageView];
    
}

-(void)scaleItem{
    
    [super scaleItem];
    self.baseView.layer.cornerRadius = self.baseView.frameWidth/2;
    self.plusLabel.center = CGPointMake(self.baseView.frameWidth/2, self.baseView.frameHeight/2);
    self.photoImageView.center = CGPointMake(self.baseView.frameWidth/2, self.baseView.frameHeight/2);

}

@end
