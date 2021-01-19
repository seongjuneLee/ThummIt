//
//  CustomerFeedbackViewController.h
//  ThummIt
//
//  Created by 조재훈 on 2021/01/09.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerFeedbackViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *sendFeedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *submitView;
- (IBAction)closeButtonTapped:(UIButton *)sender;
- (IBAction)submitButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
