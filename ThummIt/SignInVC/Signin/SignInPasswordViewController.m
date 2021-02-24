//
//  SignInPasswordViewController.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/04.
//

#import "SignInPasswordViewController.h"
#import "UserManager.h"
#import "NSString+Additions.h"
@import Parse;
#import <Reachability/Reachability.h>
@interface SignInPasswordViewController ()

@end

@implementation SignInPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nextButton.layer.cornerRadius = 5.0;
    
    self.passwordTextField.layer.cornerRadius = 5.0;
    self.passwordTextField.layer.borderColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0].CGColor;
    self.passwordTextField.delegate = self;

    self.passwordTextField.layer.borderWidth = 0.6;
    self.reEnterTextField.layer.borderWidth = 0.6;
    self.reEnterTextField.layer.cornerRadius = 5.0;
    self.reEnterTextField.layer.borderColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0].CGColor;
    UIColor *color = [UIColor lightGrayColor];
    self.reEnterTextField.delegate = self;

    self.reEnterTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.reEnterTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    [self.passwordTextField becomeFirstResponder];

    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.reEnterTextField addTarget:self action:@selector(reEnterTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

-(void)passwordTextFieldidChange:(UITextField *)textField{
    
    BOOL validate = [NSString isValidPassword:textField.text];
    if (validate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.passwordWarningLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.passwordWarningLabel.alpha = 1.0;
        }];
    }
    
    if (textField.text.length == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.reenterWarningLabel.alpha = 0.0;
        }];
    }

    
}

-(void)reEnterTextFieldDidChange:(UITextField *)textField{
    
    BOOL validate = [self isReenterPasswordValid] && [NSString isValidPassword:self.passwordTextField.text];
    if (validate) {
        self.nextButton.enabled = true;
        self.nextButton.alpha = 1.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.reenterWarningLabel.alpha = 0.0;
        }];
    } else {
        self.nextButton.enabled = false;
        self.nextButton.alpha = 0.4;
        [UIView animateWithDuration:0.2 animations:^{
            self.reenterWarningLabel.alpha = 1.0;
        }];
    }
    if (textField.text.length == 0) {
        self.nextButton.enabled = false;
        self.nextButton.alpha = 0.4;
        [UIView animateWithDuration:0.2 animations:^{
            self.reenterWarningLabel.alpha = 0.0;
        }];
    }

    
}

-(BOOL)isReenterPasswordValid{
    
    if ([self.reEnterTextField.text isEqualToString:self.passwordTextField.text]) {
        return true;
    }
    
    return false;
    
}

- (IBAction)nextButtonTapped:(id)sender {
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];

    NetworkStatus netStatus = [reach currentReachabilityStatus];
    //See if the reachable object status is "ReachableViaWifi"
 if (netStatus==NotReachable) {
     //If not
     [self.view makeToast:NSLocalizedString(@"Internet is not connected. please check and try again.", comment: @"") duration:4.0 position:CSToastPositionCenter];
     
     //Alert the user about the Internet cnx
     return;//Exit the method
 }

    PFUser *newUser = [PFUser user];
    newUser[@"username"] = UserManager.sharedInstance.email;
    newUser[@"email"] = UserManager.sharedInstance.email;
    newUser[@"nickname"] = UserManager.sharedInstance.nickname;
    newUser[@"password"] = self.passwordTextField.text;
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideAllToasts];
        });
        if (succeeded) {
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
    
}

- (IBAction)backButtonTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
}
@end
