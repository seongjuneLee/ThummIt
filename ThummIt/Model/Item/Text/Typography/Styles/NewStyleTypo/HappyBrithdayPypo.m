//
//  HappyBrithdayPypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "HappyBrithdayPypo.h"

@implementation HappyBrithdayPypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"happy Brithday",nil);
        self.fontName = @"ROHHOE-CHAN";
        self.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        self.fontSize = 100;
        
//        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
//        bgTextAttribute1.borderColor = [UIColor colorWithRed:84/255.0f green:8/255.0f blue:8/255.0f alpha:1];
//        bgTextAttribute1.borderWidth = 9;
//
//        BGTextAttribute *bgTextAttribute2 = [[BGTextAttribute alloc] init];
//        bgTextAttribute2.borderColor = [UIColor colorWithRed:145/255.0f green:69/255.0f blue:34/255.0f alpha:1];
//        bgTextAttribute2.borderWidth = 17;
//
//        self.bgTextAttributes = @[bgTextAttribute1 , bgTextAttribute2];
    }
    
    return self;
}

+(HappyBrithdayPypo*) happyBrithdayPypo{
    
    HappyBrithdayPypo* happyBrithdayPypo = [[self alloc] init];
    return happyBrithdayPypo;
    
}

@end
