//
//  GalleryTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "GalleryTypo.h"

@implementation GalleryTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"gallery",nil);
        self.fontName = @"OTJejuGamgyulR";
        self.textColor = [UIColor colorWithRed:209/255.0f green:125/255.0f blue:232/255.0f alpha:1];
        self.fontSize = 100;
        
        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
        bgTextAttribute1.borderColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
        bgTextAttribute1.borderWidth = 5;
        
//        NSMutableArray *shadowAttributes = [self makeShadowWithColor:[UIColor colorWithRed:127/255.0f green:245/255.0f blue:239/255.0f alpha:1] fromOffset:CGPointMake(1, 1) toOffset:CGPointMake(4, 4)];
//
        self.bgTextAttributes = @[bgTextAttribute1];
    }
    
    return self;
}

+(GalleryTypo*) galleryTypo{
    
    GalleryTypo* galleryTypo = [[self alloc] init];
    return galleryTypo;
    
}

@end
