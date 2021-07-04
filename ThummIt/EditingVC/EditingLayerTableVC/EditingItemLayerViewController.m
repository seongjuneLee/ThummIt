//
//  EditingItemLayerViewController.m
//  ThummIt
//
//  Created by 이성준 on 2021/03/07.
//

#import "EditingItemLayerViewController.h"
#import "EditingViewController.h"
#import "EditingViewController+GestureControllerDelegate.h"
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

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5; //seconds
    [self.tableView addGestureRecognizer:longPress];
    
    self.impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [self.impactFeedbackGenerator prepare];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.sortedItems = [[[SaveManager.sharedInstance.sortedItems reverseObjectEnumerator] allObjects] mutableCopy];
    return self.sortedItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditingItemLayerTableViewCell *cell = (EditingItemLayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditingItemLayerTableViewCell"];
    Item *item = self.sortedItems[indexPath.row];
    Item *copied = [item copy];
    if ([copied isKindOfClass:PhotoFrame.class]) {
        PhotoFrame *copiedPhotoFrame = (PhotoFrame *)copied;
        [copiedPhotoFrame makeBaseView];
        [copiedPhotoFrame addSubViewsToBaseViewImageSize:CGSizeMake(100, 100) withBlock:^(BOOL success) {
            
            UIImage *itemImage = [item.baseView toImage];
            cell.itemLayerImageView.image = itemImage;
        }];

    } else {
        [copied loadView];
        [copied setItemCenterAndScale];
        UIImage *itemImage = [item.baseView toImage];
        cell.itemLayerImageView.image = itemImage;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float rowHeight = self.view.frameHeight/6;
    
    return rowHeight - 10;
}


#pragma mark - 롱프레스

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    
    CGPoint currentPoint = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentPoint];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (!indexPath) {
            return;
        }
        
        self.previousPoint = [sender locationInView:self.tableView];
        self.currentPinchingCell = (EditingItemLayerTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        self.currentItem = self.sortedItems[indexPath.row];
        self.originalIndex = self.currentItem.indexInLayer;
        [self.impactFeedbackGenerator performSelector:@selector(impactOccurred) withObject:nil afterDelay:0.0f];

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (!indexPath) {
            return;
        }

        if (currentPoint.y <= 0) {
            [self.tableView reloadData];
            return;
        } else if (currentPoint.y >= self.tableView.frameHeight) {
            [self.tableView reloadData];
            return;
        }
        
        self.currentPinchingCell.centerY = currentPoint.y;
        self.currentIndexPath = [self.tableView indexPathForRowAtPoint:currentPoint];
        
        float deltaY = currentPoint.y - self.previousPoint.y;
        self.previousPoint = [sender locationInView:self.tableView];

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
        if (![self.originalIndex isEqualToString:self.currentItem.indexInLayer]) {
            [SaveManager.sharedInstance saveAndAddToStack];
        }
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


#pragma mark - delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    Item *item = self.sortedItems[indexPath.row];
    [editingVC didSelectItem:item];
    
    
}

@end
