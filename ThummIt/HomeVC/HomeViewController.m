//
//  ViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "HomeViewController.h"
#import "IAPViewController.h"
#import "HomeViewController+TableControllerDelegate.h"
#import "Project.h"
#import "ProjectManager.h"
#import "SaveManager.h"
#import "GuideLine.h"
#import "DashedGuideLineView.h"
#import "NSString+Additions.h"
@import Parse;

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.makeNewImageView.layer.cornerRadius = 5.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self connectHomeTableController];
    
}

-(void)connectHomeTableController{
    
    self.homeTableController = [[HomeTableController alloc] initWithTableView:self.tableView];
    self.homeTableController.delegate = self;
    
}


- (IBAction)newProjectButtonTapped:(UIButton *)sender {
    
    Project *project = [ProjectManager.sharedInstance generateNewProjectWithTemplate:nil];
    
    [SaveManager.sharedInstance applyCurrentProject:project];
    
    UIStoryboard *editing = [UIStoryboard storyboardWithName:@"Editing" bundle:NSBundle.mainBundle];
    EditingViewController *editingVC = (EditingViewController *)[editing instantiateViewControllerWithIdentifier:@"EditingViewController"];
    [self.navigationController pushViewController:editingVC animated:true];
    [UndoManager.sharedInstance initUndoRedo];
    [SaveManager.sharedInstance saveAndAddToStack];

    
}

@end
