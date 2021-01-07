//
//  TemplateManager.h
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import <Foundation/Foundation.h>
#import "TemplateHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface TemplateManager : NSObject

-(NSArray *)templates;
-(NSArray *)templateDatas;
+(TemplateManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
