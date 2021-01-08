//
//  AccountTableController.h
//  ThummIt
//
//  Created by 조재훈 on 2021/01/06.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountTableController : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;
@property (weak, nonatomic) UIViewController *accountVC;

-(id)initWithTableView:(UITableView *)tableView;
-(void)setAccountVCHeader;

@end

NS_ASSUME_NONNULL_END
