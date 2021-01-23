//
//  ViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "HomeViewController.h"
#import "HomeViewController+TableControllerDelegate.h"
#import "Project.h"
#import "ProjectManager.h"
#import "SaveManager.h"
#import "GuideLineView.h"
#import "DashedGuideLineView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self connectHomeTableController];
    
}

-(void)connectHomeTableController{
    
    self.homeTableController = [[HomeTableController alloc] initWithTableView:self.tableView];
    self.homeTableController.delegate = self;

}

@end
