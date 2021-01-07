//
//  Project.h
//  Thummit
//
//  Created by 이성준 on 2020/12/19.
//
#import <Foundation/Foundation.h>

#import "Item.h"
#import "PhotoFrame.h"
#import "Template.h"
@class CoreDataProject;


NS_ASSUME_NONNULL_BEGIN

@interface Project : NSObject <NSCoding>

@property (strong, nonatomic) NSString* projectID;
@property (strong, nonatomic) NSString* projectTitle;
@property (strong, nonatomic) NSString* projectFilePath;
@property (strong, nonatomic) NSString* selectedTemplateName;
@property (strong, nonatomic) UIColor * backgroundColor;
@property (strong, nonatomic) NSString *lastEditedDate;
@property (strong, nonatomic) NSMutableArray *photoFrames;
@property (strong, atomic) CoreDataProject* coreDataStorage;

-(NSMutableArray *)items;
-(id)initWithProjectID:(NSString *)projectID;
-(void)save;

@end

NS_ASSUME_NONNULL_END
