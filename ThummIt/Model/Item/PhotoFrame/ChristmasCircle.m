//
//  ChristmasCircle.m
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import "ChristmasCircle.h"

@implementation ChristmasCircle

-(id)init{
    
    self = [super init];
    if(self){
        
        self.itemName = @"BasicCircle";
        self.backgroundImageName = @"christmasCircle";
        [self addCircleImageWithName:self.backgroundImageName];
    }
    return self;
    
}

+(ChristmasCircle*)christmasCircle{
    
    ChristmasCircle* christmasCircle = [[self alloc] init];
    return christmasCircle;
    
}
@end
