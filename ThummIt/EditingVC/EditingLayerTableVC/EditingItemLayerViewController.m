//
//  EditingItemLayerViewController.m
//  ThummIt
//
//  Created by 이성준 on 2021/03/07.
//

#import "EditingItemLayerViewController.h"
#import "EditingViewController.h"
#import "SaveManager.h"
#import "UIImage+Additions.h"

@interface EditingItemLayerViewController ()

@end

@implementation EditingItemLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"EditingItemLayerTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"EditingItemLayerTableViewCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [self.impactFeedbackGenerator prepare];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.sortedItems = SaveManager.sharedInstance.sortedItems;
    return SaveManager.sharedInstance.sortedItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditingItemLayerTableViewCell *cell = (EditingItemLayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditingItemLayerTableViewCell"];
    Item *item = SaveManager.sharedInstance.sortedItems[indexPath.row];
    UIImage *itemImage = [item.baseView toImage];
    
    cell.itemLayerImageView.image = itemImage;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float rowHeight = self.view.frameHeight/6;
    
    return rowHeight - 10;
}


#pragma mark - 롱프레스

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    
    CGPoint originalPoint = [sender locationInView:editingVC.gestureView];
    CGPoint currentPoint = [self.tableView convertPoint:originalPoint fromView:editingVC.gestureView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentPoint];
    
    if (!indexPath) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint originalPoint = [sender locationInView:editingVC.gestureView];
        self.previousPoint = [self.tableView convertPoint:originalPoint fromView:editingVC.gestureView];

        self.currentPinchingCell = (EditingItemLayerTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        self.currentItem = SaveManager.sharedInstance.sortedItems[indexPath.row];
        [self.impactFeedbackGenerator performSelector:@selector(impactOccurred) withObject:nil afterDelay:0.0f];

    } else if (sender.state == UIGestureRecognizerStateChanged) {

        self.currentPinchingCell.centerY = currentPoint.y;
        self.currentIndexPath = [self.tableView indexPathForRowAtPoint:currentPoint];
        
        float deltaY = currentPoint.y - self.previousPoint.y;
        CGPoint originalPoint = [sender locationInView:editingVC.gestureView];
        self.previousPoint = [self.tableView convertPoint:originalPoint fromView:editingVC.gestureView];

        BOOL isUp = false;
        if (deltaY < 0) {
            isUp = true;
        }
        if (self.currentIndexPath != self.previousIndexPath && self.previousIndexPath != nil) {
            [self adjacentCellContactedWithDirection:isUp withCurrentPoint:currentPoint];
            [self.impactFeedbackGenerator performSelector:@selector(impactOccurred) withObject:nil afterDelay:0.0f];
        }
        self.previousIndexPath = [self.tableView indexPathForRowAtPoint:currentPoint];

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        self.currentIndexPath = nil;
        self.previousIndexPath = nil;
        [self.tableView reloadData];
        
    }
    
}

-(void)adjacentCellContactedWithDirection:(BOOL)isUp withCurrentPoint:(CGPoint)currentPoint{
    
    EditingItemLayerTableViewCell *adjacentCell = [self getAdjacentCellWithPoint:currentPoint];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:adjacentCell];
    Item *adjacentItem = self.sortedItems[indexPath.row];
    
    if (isUp) {
        self.currentItem.indexInLayer = [NSString stringWithFormat:@"%ld",self.currentItem.indexInLayer.integerValue + 1];
        adjacentItem.indexInLayer = [NSString stringWithFormat:@"%ld",adjacentItem.indexInLayer.integerValue - 1];
        [UIView animateWithDuration:0.3 animations:^{
            adjacentCell.centerY += self.tableView.rowHeight;
        }];
    } else {
        self.currentItem.indexInLayer = [NSString stringWithFormat:@"%ld",self.currentItem.indexInLayer.integerValue - 1];
        adjacentItem.indexInLayer = [NSString stringWithFormat:@"%ld",adjacentItem.indexInLayer.integerValue + 1];
        [UIView animateWithDuration:0.3 animations:^{
            adjacentCell.centerY -= self.tableView.rowHeight;
        }];
    }
    
    [self.layerController updateLayer];
    
}

-(EditingItemLayerTableViewCell *)getAdjacentCellWithPoint:(CGPoint)currentPoint{
    
    EditingItemLayerTableViewCell *theCell;
    for (EditingItemLayerTableViewCell *cell in self.tableView.visibleCells) {
        if (cell != self.currentPinchingCell) {
            if (CGRectContainsPoint(cell.frame, currentPoint)) {
                theCell = cell;
                break;;
            }
        }
    }
    
    return theCell;
}


-(void)goToNearestCenter{
    
    
    
}


@end
