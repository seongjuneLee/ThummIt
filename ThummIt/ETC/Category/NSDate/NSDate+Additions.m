//
//  NSDate+Additions.m
//  Thummit
//
//  Created by 이성준 on 2020/12/20.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+(NSString*)localizedDateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *start = [NSDate date];
    NSString *localizedDateString = [dateFormatter stringFromDate:start];
    
    return localizedDateString;
}
+(NSString*)ISO8601DateStringFromDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *start;
    if (date == nil) {
        start = [NSDate date];
    } else {
        start = date;
    }
    
    NSString *localizedDateString = [dateFormatter stringFromDate:start];
    
    return localizedDateString?:@"";
}

+(NSDate*)dateFromString:(NSString*)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+(int)daysFromTime:(double)time {
    
    double daysInDouble = (time / 1000) / (3600*24);
    int remainingDays = round(daysInDouble);
    
    return remainingDays;
}

+(int)daysAgoFromTime:(double)time {
    
    double value = (time / 1000) - [NSDate date].timeIntervalSince1970;
    
    double daysInDouble = value / (3600*24);
    int remainingDays = round(daysInDouble);
    
    return abs(remainingDays);
}

@end
