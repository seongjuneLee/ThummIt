//
//  SaveManager.h
//  Thummit
//
//  Created by 이성준 on 2020/12/20.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Template.h"
#import "TemplateManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SaveManager : NSObject

+ (SaveManager *)sharedInstance;

@property (strong, nonatomic) Project *currentProject;
@property (strong, nonatomic) NSMutableArray *tenRecentChanges;
@property dispatch_queue_t savingQueue;

-(Template *)currentTemplate;
-(void)save;
-(void)addItem:(Item *)item;
-(void)deleteItem:(Item *)item;
-(void)applyCurrentProject:(Project *)project;

@end

NS_ASSUME_NONNULL_END
