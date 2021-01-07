//
//  HomeTableViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import "HomeTableController.h"
#import "CategoryManager.h"
#import "HomeTableViewCell.h"
#import "Template.h"
#import "TemplateManager.h"

@implementation HomeTableController

-(id)init{
    self = [super init];
    if(self){
        
        self.homeCollectionController = [[HomeCollectionController alloc] init];
        
    }
    return self;

}

-(id)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        
        self.homeCollectionController = [[HomeCollectionController alloc] init];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }

    return self;

}

#pragma mark - 데이타 소스

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return TemplateManager.sharedInstance.templateDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    NSString *category = CategoryManager.sharedInstance.categories[indexPath.row];
    cell.delegate = self;
    cell.categoryLabel.text = category;
    cell.tag = indexPath.row;
    
    // homeCollectionController에 콜랙션뷰 컨트롤 맡기기.
    cell.collectionView.delegate = self.homeCollectionController;
    cell.collectionView.dataSource = self.homeCollectionController;
    self.homeCollectionController.collectionView = cell.collectionView;
    self.homeCollectionController.currentCategory = category;
    [self.homeCollectionController.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];

    return cell;
}

#pragma mark - 델리게이트

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"tableview Indexpath row %ld",indexPath.row);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

-(void)didSelectItemWithCell:(UITableViewCell *)cell withCollectionViewIndex:(NSUInteger)index{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];    
    [self.delegate didSelectItemAtTableIndex:indexPath.row withCollectionIndex:index];
    
}

-(NSIndexPath *)getTableViewIndexPath:(UITableViewCell *)cell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return indexPath;
}

@end
