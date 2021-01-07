//
//  ProjectTableViewCell.h
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ProjectTableViewCellDelegate <NSObject>

-(void)moreButtonTappedWithIndex:(NSUInteger)index;

@end

@interface ProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ProjectTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

- (IBAction)moreButtonTapped:(UIButton *)sender;
- (IBAction)downloadButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
