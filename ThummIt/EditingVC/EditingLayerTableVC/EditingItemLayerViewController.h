//
//  EditingItemLayerViewController.h
//  ThummIt
//
//  Created by 이성준 on 2021/03/07.
//

#import <UIKit/UIKit.h>
#import "EditingItemLayerTableViewCell.h"
#import "EditingLayerController.h"
#import "Item.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditingItemLayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIViewController *editingVC;

@property (strong, nonatomic) EditingItemLayerTableViewCell *currentPinchingCell;
@property (strong, nonatomic) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@property (nonatomic) CGPoint previousPoint;
@property (strong, nonatomic) EditingLayerController *layerController;
@property (strong, nonatomic, nullable) NSIndexPath *previousIndexPath;
@property (strong, nonatomic, nullable) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) Item *currentItem;
@property (strong, nonatomic) NSMutableArray *sortedItems;

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender;

@end

NS_ASSUME_NONNULL_END
