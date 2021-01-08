//
//  AccountTableViewCell.h
//  ThummIt
//
//  Created by 조재훈 on 2021/01/06.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

NS_ASSUME_NONNULL_END
