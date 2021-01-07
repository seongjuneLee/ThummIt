//
//  ProjectTableController.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import "MoreProjectTableController.h"
#import "EditingViewController.h"
#import "ProjectManager.h"
#import "SaveManager.h"
#import "MoreProjectTableViewCell.h"
#import "MoreProjectViewController.h"
#import "ProjectViewController.h"

@implementation MoreProjectTableController

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
    
}

-(id)initWithTableView:(UITableView *)tableView{
    
    self = [super init];
    if (self) {
        
        NSDictionary *editingDict = @{@"edit":@"editImage"};
        NSDictionary *copyDict = @{@"copy":@"copyImage"};
        NSDictionary *folderDict = @{@"moveToFolder":@"folderImage"};
        NSDictionary *downloadDict = @{@"download":@"downloadImage"};
        NSDictionary *deleteDict = @{@"delete":@"deleteImage"};
        self.datas = @[editingDict,copyDict,folderDict,downloadDict,deleteDict];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"MoreProjectTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"MoreProjectTableViewCell"];
        
    }
    return self;
    
}

#pragma mark - 테이블 뷰 데이터 소스

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreProjectTableViewCell *cell = (MoreProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MoreProjectTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.datas[indexPath.row];
    NSString *key = dict.allKeys[0];
    NSString *value = [dict objectForKey:key];
    cell.titleLabel.text = key;
    cell.iconImageView.image = [UIImage imageNamed:value];
    if(indexPath.row == 2 || indexPath.row == 3){
        cell.arrowImageView.image = [UIImage imageNamed: @"rightImage"];
    } else {
        cell.arrowImageView.image = nil;
    }
    return cell;
}

#pragma mark - 테이블 뷰 델리게이트

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreProjectViewController *moreProjectVC = (MoreProjectViewController *)self.moreProjectVC;
    ProjectViewController *projectVC = (ProjectViewController *)moreProjectVC.projectVC;
    if(indexPath.row == 0) {
        
        [projectVC pushEditingVC];
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 350;
}

@end
