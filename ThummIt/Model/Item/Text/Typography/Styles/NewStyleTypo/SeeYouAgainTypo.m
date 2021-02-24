//
//  SeeYouAgainTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "SeeYouAgainTypo.h"

@implementation SeeYouAgainTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"다시만나요",nil);
        self.fontName = @"Cafe24Syongsyong";
        self.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        self.fontSize = 100;
        
        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
        bgTextAttribute1.borderColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
        bgTextAttribute1.borderWidth = 9;


        self.bgTextAttributes = @[bgTextAttribute1];
    }
    
    return self;
}

+(SeeYouAgainTypo*) seeYouAgainTypo{
    
    SeeYouAgainTypo* seeYouAgainTypo = [[self alloc] init];
    return seeYouAgainTypo;
    
}

@end
