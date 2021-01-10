//
//  CustomerFeedbackViewController.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/09.
//

#import "CustomerFeedbackViewController.h"

@interface CustomerFeedbackViewController ()

@end

@implementation CustomerFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.closeButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [self setSendFeedbackTextView];
    [self setSubmitViewUI];

}

- (void)setSendFeedbackTextView {
    
    self.sendFeedbackTextView.text = @"Please let me know the detailed steps as possible to reproduce the problem.";
    self.sendFeedbackTextView.textColor = [UIColor lightGrayColor];
    self.sendFeedbackTextView.delegate = self;
    self.sendFeedbackTextView.layer.cornerRadius = 5;
    self.sendFeedbackTextView.layer.borderWidth = 1;
    self.sendFeedbackTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.sendFeedbackTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.sendFeedbackTextView.text != nil) {
        self.sendFeedbackTextView.text = @"";
        self.sendFeedbackTextView.textColor = [UIColor blackColor];
        self.submitView.backgroundColor = [UIColor blackColor];
    }
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView {

    if(self.sendFeedbackTextView.text.length == 0) {
        self.sendFeedbackTextView.textColor = [UIColor lightGrayColor];
        self.sendFeedbackTextView.text = @"Please let me know the detailed steps as possible to reproduce the problem.";
        [self.sendFeedbackTextView resignFirstResponder];
        self.submitView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)setSubmitViewUI {
    
    self.submitView.backgroundColor = [UIColor lightGrayColor];
    self.submitView.layer.cornerRadius = 8;

}

- (IBAction)submitButtonTapped:(UIButton *)sender {

    //
    
}

- (IBAction)closeButtonTapped:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
}
@end
