//
//  GuideLine.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/21.
//

#import "GuideLineView.h"
#import "Item.h"
@implementation GuideLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:120.0/255.0 blue:180.0/255.0 alpha:1.0];
    }
    return self;
}


@end
