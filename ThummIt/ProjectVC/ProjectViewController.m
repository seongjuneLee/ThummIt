//
//  ProjectViewController.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import "ProjectViewController.h"
#import "EditingViewController.h"
#import "UIImage+Additions.h"
@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self connectMoreProjectVC];
    [self connectProjectTableController];

}

-(void)viewWillAppear:(BOOL)animated{
    
    if (ProjectManager.sharedInstance.projectSnapShots.count != ProjectManager.sharedInstance.fetchedProjectsCount) { // 프로젝트 갯수에 변화가 있다.
        [ProjectManager.sharedInstance setUpSnapShotFromProject];
    }
    self.projectTableController.snapShots = ProjectManager.sharedInstance.projectSnapShots;
    [self.tableView reloadData];
    
}

-(void)connectProjectTableController{
    
    self.projectTableController = [[ProjectTableController alloc] initWithTableView:self.tableView];
    self.projectTableController.navigationController = self.navigationController;
    self.projectTableController.projectVC = self;
    self.projectTableController.moreProjectVC = self.moreProjectVC;
}

-(void)connectMoreProjectVC{
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    self.moreProjectVC = (MoreProjectViewController *)[main instantiateViewControllerWithIdentifier:@"MoreProjectViewController"];
    self.moreProjectVC.projectVC = self;
}

-(void)pushEditingVC{
    
    // editingVC 푸시해주기
    UIStoryboard *editing = [UIStoryboard storyboardWithName:@"Editing" bundle:NSBundle.mainBundle];
    EditingViewController *editingVC = (EditingViewController *)[editing instantiateViewControllerWithIdentifier:@"EditingViewController"];
    [self.navigationController pushViewController:editingVC animated:true];
    NSLog(@"self.navigationController %@",self.navigationController);
    
}


@end
