//
//  HomeTableViewCell.h
//  Thummit
//
//  Created by 이성준 on 2020/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeTableViewCellDelegate <NSObject>

-(void)didSelectItemWithCell:(UITableViewCell *)cell withCollectionViewIndex:(NSUInteger)index;
-(NSIndexPath *)getTableViewIndexPath:(UITableViewCell *)cell;

@end
@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) id<HomeTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
