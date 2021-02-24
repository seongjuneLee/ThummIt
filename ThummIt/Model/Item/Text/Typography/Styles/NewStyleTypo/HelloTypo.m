//
//  HelloTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "HelloTypo.h"

@implementation HelloTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"안녕하세요",nil);
        self.fontName = @"MaplestoryOTFLight";
        self.fontSize = 100;
        self.textFromColor = [UIColor colorWithRed:65/255.0 green:68/255.0 blue:232/255.0 alpha:1.0];
        self.textToColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:self.fontName size:self.fontSize]};
        CGSize stringBoundingBox = [@"안녕하세요" sizeWithAttributes:attr];
        self.textGradientHeight = stringBoundingBox.height + 4.5;

        self.textColor = [UIColor diagonalGradientFromColor:self.textFromColor toColor:self.textToColor withHeight:self.textGradientHeight];
        self.cannotChangeColor = true;
        
        BGTextAttribute *borderAtt = [[BGTextAttribute alloc] init];
        borderAtt.borderColor = [UIColor blackColor];
        borderAtt.borderWidth = 7;
        self.bgTextAttributes = @[borderAtt];
    }
    
    return self;
}

+(HelloTypo*) helloTypo{
    
    HelloTypo* helloTypo = [[self alloc] init];
    return helloTypo;
    
}

@end
