//
//  RunningManExcSticker.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/28.
//

#import "RunningManExcSticker.h"

@implementation RunningManExcSticker

-(id)init{
    
    self = [super init];
    if(self){
        self.itemName = @"runningManExcSticker";
        self.backgroundImageName = @"runningManExcSticker";
    }
    return self;
}

+(RunningManExcSticker*)runningManExcSticker{
    
    RunningManExcSticker* runningManExcSticker = [[self alloc] init];
    return runningManExcSticker;
}


@end
