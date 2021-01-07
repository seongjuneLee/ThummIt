//
//  Template.h
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import <Foundation/Foundation.h>
#import "PhotoFrameHeader.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface Template : NSObject <NSCopying,NSCoding>


@property (strong, nonatomic) NSString *previewImageName;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *templateName;

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NSMutableArray *texts;
@property (strong, nonatomic) NSMutableArray *photoFrames;


-(NSMutableArray *)items;
-(void)centerLabel:(PhotoFrame *)photoFrame withSizeDelta:(float)delta;

@end

NS_ASSUME_NONNULL_END
