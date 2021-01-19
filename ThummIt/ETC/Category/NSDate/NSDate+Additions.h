//
//  NSDate+Additions.h
//  Thummit
//
//  Created by 이성준 on 2020/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Additions)

+(NSString*)localizedDateString;
+(NSString*)ISO8601DateStringFromDate:(NSDate*)date;
+(NSDate*)dateFromString:(NSString*)dateString;
+(int)daysFromTime:(double)time;
+(int)daysAgoFromTime:(double)time;

@end

NS_ASSUME_NONNULL_END
