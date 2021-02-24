//
//  MbcTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "MbcTypo.h"

@implementation MbcTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"NBC\n뉴스데스크",nil);
        self.fontName = @"OTMBC-1961M";
        self.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        self.fontSize = 100;
        
    }
    
    return self;
}

+(MbcTypo*) mbcTypo{
    
    MbcTypo* mbcTypo = [[self alloc] init];
    return mbcTypo;
    
}

@end
