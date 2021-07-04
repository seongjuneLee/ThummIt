//
//  AlbumViewController.m
//  Thummit
//
//  Created by 이성준 on 2020/12/12.
//

#import "AlbumViewController.h"
#import "EditingViewController.h"
#import "EditingViewController+Buttons.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"AlbumCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AlbumCollectionViewCell"];
    
    [self setCollectionViewFlowLayout];
    self.phAssets = PhotoManager.sharedInstance.phassets;
    [self.collectionView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"categoryContainer"]) {
        self.albumCategoryVC = segue.destinationViewController;
        self.albumCategoryVC.delegate = self;
    }
}


-(void)showWithAnimation{
    self.view.hidden = false;
    self.collectionViewTopConstraint.constant = self.view.frameHeight;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectionViewTopConstraint.constant = 20;
        [self.view layoutIfNeeded];
    } completion:nil];

}

-(void)hideWithAnimation{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectionViewTopConstraint.constant = self.view.frameHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}



-(void)dismissSelf{
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionViewTopConstraint.constant = self.view.frameHeight;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)setCollectionViewFlowLayout {
    
    NSUInteger numberOfColumns = 3;

    // 칼럼 갯수
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    // 중간 스페이싱, 좌우 인셋을 빼고 남은 공간이 셀을 위한 공간
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (numberOfColumns - 1);
    
    // 셀 사이즈
    CGFloat cellWidth = availableWidthForCells / numberOfColumns ;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
}

#pragma mark - category delegate

- (void)didSelectCategoryWithPHAssetCollection:(PHAssetCollection *)phAssetCollection{
    
    EditingViewController *editingVC = (EditingViewController *)self.editingVC;
    NSMutableArray* phAssets = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %ld ",PHAssetMediaTypeImage];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:fetchOptions];
    [result enumerateObjectsUsingBlock:^(PHAsset *phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
        [phAssets addObject:phAsset];
    }];
    
    // 데이터 모델링 1 : 날짜별 -> @[Asset들]
    self.phAssets = phAssets;
    [self.collectionView reloadData];
    
    [editingVC.categoryButton setTitle:[NSString stringWithFormat:@"%@ ▾",phAssetCollection.localizedTitle] forState:UIControlStateNormal];

    NSString* title = [editingVC.categoryButton.titleLabel.text stringByReplacingOccurrencesOfString:@"▴" withString:@"▾"];
    [editingVC.categoryButton setTitle:title forState:UIControlStateNormal];

    [UIView animateWithDuration:0.3 animations:^{
        self.categoryContainerTopConstraint.constant = self.view.frameHeight;
        [self.view layoutIfNeeded];
    }];

}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // 년 월 일 뽑아내기
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // 시 분 초는 0으로 변경
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
    
}


@end
