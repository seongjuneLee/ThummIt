//
//  AccountViewController.h
//  ThummIt
//
//  Created by 조재훈 on 2021/01/06.
//

#import <UIKit/UIKit.h>
#import "AccountTableController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountViewController : UIViewController

// account View
@property (strong, nonatomic) AccountTableController *accountTableController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;

// sign In View
@property (weak, nonatomic) IBOutlet UIView *signInView;

@property (weak, nonatomic) IBOutlet UIView *kakaoSignInView;
@property (weak, nonatomic) IBOutlet UIView *facebookSignInView;
@property (weak, nonatomic) IBOutlet UIView *googleSignInView;
@property (weak, nonatomic) IBOutlet UIView *appleSignInView;
@property (weak, nonatomic) IBOutlet UIView *emailSignInView;

@property (weak, nonatomic) IBOutlet UIButton *kakaoSignInButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookSignInButton;
@property (weak, nonatomic) IBOutlet UIButton *googleSignInButton;
@property (weak, nonatomic) IBOutlet UIButton *appleSignInButton;
@property (weak, nonatomic) IBOutlet UIButton *emailSignInButton;

@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;

@end

NS_ASSUME_NONNULL_END
