//
//  ThankYouTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "ThankYouTypo.h"

@implementation ThankYouTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"감사합니다",nil);
        self.fontName = @"Cafe24Ohsquareair";
        self.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        self.fontSize = 100;
        
        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
        bgTextAttribute1.borderColor = [UIColor colorWithRed:141/255.0f green:245/255.0f blue:127/255.0f alpha:1];
        bgTextAttribute1.borderWidth = 10;

//        BGTextAttribute *bgTextAttribute2 = [[BGTextAttribute alloc] init];
//        bgTextAttribute2.borderColor = [UIColor colorWithRed:141/255.0f green:245/255.0f blue:127/255.0f alpha:1];
//        bgTextAttribute2.borderWidth = 17;

        self.bgTextAttributes = @[bgTextAttribute1];
    }
    
    return self;
}

+(ThankYouTypo*) thankYouTypo{
    
    ThankYouTypo* thankYouTypo = [[self alloc] init];
    return thankYouTypo;
    
}

@end
