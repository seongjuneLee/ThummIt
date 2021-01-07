//
//  ProjectTableController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "ProjectTableViewCell.h"
#import "MoreProjectViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectTableController : NSObject <UITableViewDelegate, UITableViewDataSource,ProjectTableViewCellDelegate>

// viewcontroller로 부터 받아오기.
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIViewController *projectVC;
@property (weak, nonatomic) MoreProjectViewController *moreProjectVC;

@property (strong, nonatomic) NSMutableArray *snapShots;
@property (strong, nonatomic) NSMutableArray *projects;
-(id)initWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
