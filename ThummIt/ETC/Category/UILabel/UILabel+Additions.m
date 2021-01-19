//
//  UILabel+Additions.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/08.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];

    NSRange glyphRange;

    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];

    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

@end
