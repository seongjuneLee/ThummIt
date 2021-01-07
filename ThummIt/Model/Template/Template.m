//
//  Template.m
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import "Template.h"

@implementation Template

-(id)init{
    
    self = [super init];
    if(self){
        
    }
    return self;
}

-(NSMutableArray *)items{
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObjectsFromArray:self.photoFrames];
    return items;
    
}

-(void)centerLabel:(PhotoFrame *)photoFrame withSizeDelta:(float)delta{
    
    photoFrame.plusLabel.frameX -= delta/2;
    photoFrame.plusLabel.frameY -= delta/2;
    
}


@end
