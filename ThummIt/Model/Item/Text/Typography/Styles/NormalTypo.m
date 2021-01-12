//
//  NormalTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/08.
//

#import "NormalTypo.h"

@implementation NormalTypo

-(id)init{
    self = [super init];
    if (self) {

        self.name = NSLocalizedString(@"NormalTypo",nil);
        self.fontName = @"HelveticaNeue-Bold";
        self.fontSize = 30;
        self.textColor = [UIColor whiteColor];
        
    }
    return self;
}

+(NormalTypo*)normalTypo{
    
    NormalTypo* normalTypo = [[self alloc] init];
    return normalTypo;
    
}

@end