//
//  BasicCircle.m
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import "BasicCircle.h"

@implementation BasicCircle

-(id)init{
    
    self = [super init];
    if(self){
        
        self.itemName = @"BasicCircle";
        self.isCircle = true;
        [self makeBaseView];
        self.baseView.backgroundColor = UIColor.redColor;
    }
    return self;
    
}

-(void)makeBaseView{
    [super makeBaseView];
    float screenWidth = UIScreen.mainScreen.bounds.size.width;
    float circleViewWidth = screenWidth*0.8/2;
    self.baseView.frameSize = CGSizeMake(circleViewWidth, circleViewWidth);
    self.baseView.backgroundColor = UIColor.whiteColor;
}

-(instancetype)initWithCoder:(NSCoder *)decoder{
    if((self = [super initWithCoder:decoder])) {
        
    }
    return self;
}

+(BasicCircle*)basicCircle{
    
    BasicCircle* basicCircle = [[self alloc] init];
    return basicCircle;
    
}


@end
