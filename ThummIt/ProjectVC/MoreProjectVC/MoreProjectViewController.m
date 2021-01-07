//
//  MoreProjectViewController.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import "MoreProjectViewController.h"
@interface MoreProjectViewController ()

@end

@implementation MoreProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moreView.layer.cornerRadius = 5;
    self.moreView.clipsToBounds = true;
    [self connectProjectTableController];
    // Do any additional setup after loading the view.
}

-(void)connectProjectTableController{
    
    self.moreProjectTableController = [[MoreProjectTableController alloc] initWithTableView:self.tableView];
    self.moreProjectTableController.moreProjectVC = self;
    
    
}

@end
