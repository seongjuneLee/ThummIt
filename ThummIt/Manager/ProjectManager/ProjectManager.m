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
            project = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
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

- (NSArray*)getRecentTenProjectsFromCoreDataWithOffset:(NSUInteger)offSet {
    
    NSArray<CoreDataProject*>* coreDataProjects = [CoreDataStack fetchWithFetchOffSet:offSet];
    
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

-(NSUInteger)fetchProjectsCount{
    
    NSUInteger projectsCount = [CoreDataStack fetchProjectsCount];

    return projectsCount;
    
}

-(NSString *)generateProjectID{
    
    NSString *dateString = [NSDate localizedDateString] ?: @"";
    NSString *randomString = [NSString randomStringWithLength:4] ?: @"";

    NSString *projectID = [NSString stringWithFormat:@"%@_%@",dateString,randomString];

    return projectID;
}


-(NSMutableArray *)loadProjectSnapshots:(NSUInteger)offSet{
    
    self.projectSnapShots = [NSMutableArray array];
    NSArray *projects = [ProjectManager.sharedInstance getRecentTenProjectsFromCoreDataWithOffset:offSet];
    for (Project *project in projects) {
        UIScreen *screen = UIScreen.mainScreen;
        UIImageView *imageView = [[UIImageView alloc] init];
        float imageViewWidth = screen.bounds.size.width;
        imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth*9/16);
        imageView.backgroundColor = UIColor.blackColor;
        
        NSMutableArray *indexes = [NSMutableArray array];
        for (Item *item in project.items) {
            [indexes addObject:[NSNumber numberWithInteger:[item.indexInLayer integerValue]]];
        }
        NSNumber* smallest = [indexes valueForKeyPath:@"@min.self"];
        for (Item *item  in project.items) {
            
            [item loadView];
            item.baseView.centerY -= 100;
            
            [imageView insertSubview:item.baseView atIndex:[item.indexInLayer integerValue] - [smallest integerValue]];
            
        }
        
        UIImage *snapShot = [UIImage imageWithView:imageView];
        [self.projectSnapShots addObject:snapShot];
    }
    return self.projectSnapShots;
}

@end
