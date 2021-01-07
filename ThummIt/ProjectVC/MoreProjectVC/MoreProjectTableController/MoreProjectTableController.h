//
//  MoreProjectTableController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreProjectTableController : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UIViewController *moreProjectVC;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;

-(id)initWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
