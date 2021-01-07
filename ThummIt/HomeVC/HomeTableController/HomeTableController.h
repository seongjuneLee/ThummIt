//
//  HomeTableViewController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import <Foundation/Foundation.h>
#import "HomeCollectionController.h"
#import "HomeTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HomeTableControllerDelegate <NSObject>

-(void)didSelectItemAtTableIndex:(NSUInteger)tableIndex withCollectionIndex:(NSUInteger)collectionIndex;

@end
@interface HomeTableController : NSObject <UITableViewDataSource,UITableViewDelegate, HomeTableViewCellDelegate>

-(id)initWithTableView:(UITableView *)tableView;


@property (weak,nonatomic) id<HomeTableControllerDelegate> delegate;
@property (strong, nonatomic) HomeCollectionController *homeCollectionController;
@property (weak, nonatomic) UITableView *tableView;

-(NSIndexPath *)getTableViewIndex:(HomeTableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
