//
//  SignInEmailViewController.h
//  ThummIt
//
//  Created by 이성준 on 2021/02/04.
//

#import <UIKit/UIKit.h>
#import <UIKit/UINavigationController.h>
NS_ASSUME_NONNULL_BEGIN

@interface SignInEmailViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end

NS_ASSUME_NONNULL_END