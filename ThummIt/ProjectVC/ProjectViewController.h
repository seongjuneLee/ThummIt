//
//  ProjectViewController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import <UIKit/UIKit.h>
#import "ProjectTableController.h"
#import "MoreProjectViewController.h"
#import "MoreProjectTableController.h"
#import "ProjectManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ProjectTableController *projectTableController;
@property (strong, nonatomic) NSMutableArray *projectSnapShots;
@property (strong, nonatomic) MoreProjectViewController *moreProjectVC;
-(void)pushEditingVC;

@end

NS_ASSUME_NONNULL_END
