//
//  GoodByeTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "GoodByeTypo.h"

@implementation GoodByeTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"잘가",nil);
        self.fontName = @"MaplestoryOTFBold";
        self.textColor = [UIColor colorWithRed:250/255.0f green:12/255.0f blue:179/255.0f alpha:1];
        self.fontSize = 100;
        
        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
        bgTextAttribute1.borderColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
        bgTextAttribute1.borderWidth = 9;

        self.bgTextAttributes = @[bgTextAttribute1];
    }
    
    return self;
}

+(GoodByeTypo*) goodByeTypo{
    
    GoodByeTypo* goodByeTypo = [[self alloc] init];
    return goodByeTypo;
    
}

@end
