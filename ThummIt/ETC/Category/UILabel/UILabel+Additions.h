//
//  UILabel+Additions.h
//  ThummIt
//
//  Created by 조재훈 on 2021/01/08.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Additions)

- (CGRect)boundingRectForCharacterRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
