//
//  ViewController.h
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"
#import "HomeTableController.h"
#import "EditingViewController.h"
#import "CategoryManager.h"
#import "TemplateManager.h"
#import "TemplateHeader.h"
@interface HomeViewController : UIViewController

@property (strong, nonatomic) HomeTableController *homeTableController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

