//
//  LifeTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "LifeTypo.h"

@implementation LifeTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"Life",nil);
        self.fontName = @"777Chocolatlatte-";
        self.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        self.fontSize = 100;
        
        NSMutableArray *shadowAttributes = [self makeShadowWithColor:[UIColor colorWithRed:127/255.0f green:245/255.0f blue:239/255.0f alpha:1] fromOffset:CGPointMake(1, 1) toOffset:CGPointMake(4, 4)];
        
        [self.bgTextAttributes addObjectsFromArray:shadowAttributes];
    }
    
    return self;
}

+(LifeTypo*) lifeTypo{
    
    LifeTypo* lifeTypo = [[self alloc] init];
    return lifeTypo;
    
}

@end
