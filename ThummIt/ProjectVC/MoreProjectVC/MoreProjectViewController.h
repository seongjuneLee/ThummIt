//
//  MoreProjectViewController.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "MoreProjectTableController.h"

//#import <QuartzCore/QuartzCore.h> // not necessary for 10 years now  :)
NS_ASSUME_NONNULL_BEGIN

@interface MoreProjectViewController : UIViewController

@property (strong, nonatomic) MoreProjectTableController *moreProjectTableController;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *transparnetView;
@property (weak, nonatomic) UIViewController *projectVC;

-(void)connectProjectTableController;

@end

NS_ASSUME_NONNULL_END
