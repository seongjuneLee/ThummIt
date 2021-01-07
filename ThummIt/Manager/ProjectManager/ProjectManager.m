//
//  ProjectManager.m
//  Thummit
//
//  Created by 이성준 on 2020/12/20.
//

#import "ProjectManager.h"
#import "ThummIt-Swift.h"
#import "NSDate+Additions.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"
@implementation ProjectManager

+ (ProjectManager *)sharedInstance {
    static ProjectManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProjectManager alloc] init];
    });
    
    return sharedInstance;
}

-(Project *)generateNewProjectWithTemplate:(Template *)selectedTemplate{
    
    Project* project = [CoreDataStack newProject];
    project.photoFrames = selectedTemplate.photoFrames;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"stringDate %@",stringDate);
    project.lastEditedDate = stringDate;

    return project;
    
}

- (BOOL)deleteIdOfProject:(NSString*)projectId{
    
    // find the project
    Project * project = [self projectFromProjectID:projectId];
    
    if (project) {
        
        [CoreDataStack deleteProjectWithProject:project];
        
        NSError* error;
        [CoreDataStack saveContextAndReturnError:&error];
        return true;
    }
    
    return false;
    
}

- (Project*)projectFromProjectID:(NSString *)projectId{
    
    
    CoreDataProject* coreDataProject = [CoreDataStack fetchProjectWithProjectId:projectId];
    
    // 정말로 removeEmptyProject()의 실행 결과로 모두 다 날아갔는지 알 수 없고,
    // 이것이 project id없어 크래쉬나고 있는 원인이라 일단 남겨놓음
    if (!coreDataProject){
        return nil;
    }
    
    NSData* projectData;
    if ([MigratorJul.shared isMigrated]) {
        projectData = coreDataProject.projectData;
    } else {
        NSString* filePath = coreDataProject.projectFilePath;
        if (filePath.length > 0) {
            NSError* error;
            projectData = [ProjectFileManager.sharedInstance readWithFilePath:filePath error:&error];
        }
    }
    Project *project;
    if (projectData) {
        @try {
            project = [NSKeyedUnarchiver unarchivedObjectOfClass:Project.class fromData:projectData error:nil];
            project.coreDataStorage = coreDataProject;
            project.projectID = projectId;

            NSString* projectId = project.projectID;
            if (projectId.length == 0) {
                
                projectId = [self generateProjectID];
                
            }
        } @catch (NSException *exception) {

        }
        
    }
    return project;
}

- (NSArray*)getAllProjectsFromCoreData {
    
    NSArray<CoreDataProject*>* coreDataProjects = [CoreDataStack fetchAllProjects];
    
    NSMutableArray<Project*>* projects = [NSMutableArray new];
    for (CoreDataProject* coreDataProject in coreDataProjects) {
        
        NSData* projectData;
        if ([MigratorJul.shared isMigrated]) {
            projectData = coreDataProject.projectData;
        } else {
            NSString* filePath = coreDataProject.projectFilePath;
            if (filePath.length > 0) {
                NSError* error;
                projectData = [ProjectFileManager.sharedInstance readWithFilePath:filePath error:&error];
                
            }
        }
        if (projectData && [projectData isKindOfClass:NSData.class]) {
            NSError* jsonError;
            Project *project = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
            project.projectID = coreDataProject.projectID;

            if (jsonError){
                // 에러
            }
            NSString* projectId = project.projectID;
            if (projectId.length == 0) {
                
                
                projectId = [self generateProjectID];

            }

            if (project) {
                [projects addObject:project];
            }

        } else {
            continue;
        }
    }
    
    [projects sortUsingComparator:^NSComparisonResult(Project*  _Nonnull prj1, Project*  _Nonnull prj2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
        NSDate *date1 = [dateFormatter dateFromString:prj1.lastEditedDate];
        NSDate *date2 = [dateFormatter dateFromString:prj2.lastEditedDate];
        if (date1.timeIntervalSince1970 < date2.timeIntervalSince1970) {
            return NSOrderedDescending;
        }
        if (date1.timeIntervalSince1970 > date2.timeIntervalSince1970) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    return projects;
}

-(NSUInteger)fetchedProjectsCount{
    
    NSArray<CoreDataProject*>* coreDataProjects = [CoreDataStack fetchAllProjects];

    return coreDataProjects.count;
    
}

-(NSString *)generateProjectID{
    
    NSString *dateString = [NSDate localizedDateString] ?: @"";
    NSString *randomString = [NSString randomStringWithLength:4] ?: @"";
    
    NSString *projectID = [NSString stringWithFormat:@"%@_%@",dateString,randomString];

    return projectID;
}


-(void)setUpSnapShotFromProject{
    
    self.projectSnapShots = [NSMutableArray array];
    NSArray *projects = [ProjectManager.sharedInstance getAllProjectsFromCoreData];
    for (Project *project in projects) {
        
        UIScreen *screen = UIScreen.mainScreen;
        UIImageView *imageView = [[UIImageView alloc] init];
        float imageViewWidth = screen.bounds.size.width;
        imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth*9/16);
        imageView.backgroundColor = UIColor.blackColor;
        
        for (Item *item  in project.items) {
            
            Item *copiedItem = [item copy];
            copiedItem.baseView.frameY -= 100;
            [imageView addSubview:copiedItem.baseView];
            
        }
        
        UIImage *snapShot = [UIImage imageWithView:imageView];
        [self.projectSnapShots addObject:snapShot];
    }
    
}

@end
