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
    
    [self getSnapShotFromProject];
    self.projectTableController.snapShots = self.projectSnapShots;
    [self.tableView reloadData];

}

-(void)viewWillLayoutSubviews{
    
    self.moreProjectVC.view.frame = self.view.frame;
    
}

-(void)getSnapShotFromProject{
    
    self.projectSnapShots = [NSMutableArray array];
    NSArray *projects = [ProjectManager.sharedInstance getAllProjectsFromCoreData];
    self.projectTableController.projects = [NSMutableArray arrayWithArray:projects];
    for (Project *project in projects) {
        
        UIScreen *screen = UIScreen.mainScreen;
        UIImageView *imageView = [[UIImageView alloc] init];
        float imageViewWidth = screen.bounds.size.width;
        imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth*9/16);
        imageView.backgroundColor = UIColor.blackColor;
        
        for (Item *item  in project.items) {
            
            Item *copiedItem = [item copy];
            copiedItem.baseView.center = CGPointMake(item.center.x * imageView.frameWidth, item.center.y * imageView.frameHeight);
            [imageView addSubview:copiedItem.baseView];
            
        }
        
        UIImage *snapShot = [UIImage imageWithView:imageView];
        [self.projectSnapShots addObject:snapShot];
    }
    
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
