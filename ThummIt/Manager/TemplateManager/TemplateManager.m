//
//  TemplateManager.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "TemplateManager.h"

@implementation TemplateManager


+ (TemplateManager *)sharedInstance {
    static TemplateManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TemplateManager alloc] init];
    });
    
    return sharedInstance;
}

-(NSArray *)templates{
    
    
    Template *circleTemplate = [CircleTemplate circleTemplate];
    Template *christmasCircle = [ChristmasCircleTemplate christmasCircleTemplate];
    Template *doubleCircleTemplate = [DoubleCircleTemplate doubleCircleTemplate];
    Template *twoDivisionTemplate = [TwoDivisionTemplate twoDivisionTemplate];
    Template *quarterDivisionTemplate = [QuarterDivisionTemplate quarterDivisionTemplate];
    NSArray *templates = @[circleTemplate,christmasCircle, doubleCircleTemplate,twoDivisionTemplate,quarterDivisionTemplate];
    return templates;
}

-(NSArray *)templateDatas{
    
    Template *circleTemplate = [CircleTemplate circleTemplate];
    Template *christmasCircle = [ChristmasCircleTemplate christmasCircleTemplate];
    Template *doubleCircleTemplate = [DoubleCircleTemplate doubleCircleTemplate];

    NSArray *entertainTemplates = @[circleTemplate,christmasCircle,doubleCircleTemplate];
    
    Template *twoDivisionTemplate = [TwoDivisionTemplate twoDivisionTemplate];
    Template *quarterDivisionTemplate = [QuarterDivisionTemplate quarterDivisionTemplate];
    NSArray *vlogTemplates = @[twoDivisionTemplate,quarterDivisionTemplate];
    
    NSArray *templates = @[entertainTemplates, vlogTemplates];
    return templates;

    
}

//if (indexPath.row == 0) {
//    for (Template *template in TemplateManager.sharedInstance.templates) {
//        if ([template.category isEqualToString:NSLocalizedString(@"Entertain", nil)]) {
//            [self.homeCollectionController.entertainTemplates addObject:template];
//        }
//    }
//    [self.homeCollectionController.collectionView reloadData];
//} else if (indexPath.row == 1){
//    for (Template *template in TemplateManager.sharedInstance.templates) {
//        if ([template.category isEqualToString:NSLocalizedString(@"Vlog", nil)]) {
//            [self.homeCollectionController.vlogTemplates addObject:template];
//        }
//    }
//    [self.homeCollectionController.collectionView reloadData];
//}


@end
