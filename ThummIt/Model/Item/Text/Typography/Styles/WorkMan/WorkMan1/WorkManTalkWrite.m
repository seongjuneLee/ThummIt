//
//  WorkManTalkWrite.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/27.
//

#import "WorkManTalkWrite.h"

@implementation WorkManTalkWrite

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"소리질러!!!!!",nil);
        self.fontName = @"NanumSquareOTFB";
        self.textColor = [UIColor whiteColor];
        self.fontSize = TEXT_FONT_SIZE;
        self.bgImageName = @"workManTalkBox";
        self.bgHeightPadding = 30;
        self.bgWidthPadding = 40;
        
        BGTextAttribute *bgTextAttribute1 = [[BGTextAttribute alloc] init];
        bgTextAttribute1.borderColor = [UIColor blackColor];
        bgTextAttribute1.borderWidth = 13;
        
        self.bgTextAttributes = @[bgTextAttribute1];

    }
    return self;
}

+(WorkManTalkWrite *)workManTalkWrite{
    WorkManTalkWrite *workManTalkWrite = [[self alloc] init];
    return workManTalkWrite;
}

@end