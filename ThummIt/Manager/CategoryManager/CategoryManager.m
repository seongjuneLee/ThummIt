//
//  CategoryManager.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "CategoryManager.h"

@implementation CategoryManager

+ (CategoryManager *)sharedInstance {
    static CategoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CategoryManager alloc] init];
        [sharedInstance setUpCategories];
    });
    
    return sharedInstance;
}

-(void)setUpCategories{
    self.categories = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Entertain", nil),NSLocalizedString(@"Vlog", nil)]];
}


@end
