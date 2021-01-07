//
//  ProjectTableController.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import "ProjectTableController.h"
#import "EditingViewController.h"
#import "ProjectManager.h"
#import "SaveManager.h"

@implementation ProjectTableController

-(instancetype)init{ 
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithTableView:(UITableView *)tableView{
    
    self = [super init]; 
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"ProjectTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"ProjectTableViewCell"];
    }
    return self;
    
}

#pragma mark - 테이블 뷰 데이터 소스

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.snapShots.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell" forIndexPath:indexPath];
    UIImage *snapShot = self.snapShots[indexPath.row];
    cell.backgroundImageView.image = snapShot;
    cell.moreButton.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - 테이블 뷰 델리게이트

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Project *project = self.projects[indexPath.row];
    SaveManager.sharedInstance.currentProject = project;
    UIStoryboard *editing = [UIStoryboard storyboardWithName:@"Editing" bundle:NSBundle.mainBundle];
    EditingViewController *editingVC = (EditingViewController *)[editing instantiateViewControllerWithIdentifier:@"EditingViewController"];
    [self.navigationController pushViewController:editingVC animated:true];

    [SaveManager.sharedInstance save];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 350;
}


#pragma mark - 셀 델리게이트

-(void)moreButtonTappedWithIndex:(NSUInteger)index{
    
    
    float originalMoreViewFrameY = self.moreProjectVC.moreView.frameY;
    [self.projectVC.tabBarController addChildViewController:self.moreProjectVC];
    [self.projectVC.tabBarController.view addSubview:self.moreProjectVC.view];
    self.moreProjectVC.moreView.frameY = self.projectVC.view.frameHeight;
    self.moreProjectVC.transparnetView.alpha =0.0;
    self.moreProjectVC.previewImageView.alpha =0.0;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.moreProjectVC.moreView.frameY = originalMoreViewFrameY;
        self.moreProjectVC.transparnetView.alpha = 0.4;
        self.moreProjectVC.previewImageView.alpha = 1;
    } completion:nil];
    
}

@end
