//
//  FightManTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/27.
//

#import "FightManTypo.h"

@implementation FightManTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"찌질하게 싸운 남자들의",nil);
        self.fontName = @"NotoSansKannada-Bold";
        self.textColor = [UIColor colorWithRed:253/255.0f green:242/255.0f blue:95/255.0 alpha:1 ];
        self.borderColor = [UIColor colorWithRed:133/255.0f green:54/255.0f blue:16/255.0f alpha:1];
        self.shadowColor = [UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        self.borderWidth = -3;
        self.shadowRadius = 1;
        self.shadowOffset = CGSizeMake(1, 1);
    //  bgTextAttributes.borderWidth =
        self.fontSize = 50;
    }
 //대조작업필요
    
    return self;
}

+(FightManTypo*) fightManTypo{
    
    FightManTypo* fightManTypo = [[self alloc] init];
    return fightManTypo;
    
}


@end