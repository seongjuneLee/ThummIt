//
//  AccountViewController.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/06.
//

#import "AccountViewController.h"
#import "UILabel+Additions.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signInView.alpha = 0; //
    [self setSignInWithViewLayer];
    [self addButtonToPrivacyPolicyLabel];
    [self connectAccountTableController];
    
}

-(void)connectAccountTableController{
    self.accountTableController = [[AccountTableController alloc] initWithTableView:self.tableView];
    
    self.accountTableController.accountVC = self;
    [self.accountTableController setAccountVCHeader];
}

-(void)setSignInWithViewLayer{
    
    self.kakaoSignInView.layer.cornerRadius = 5;
    self.facebookSignInView.layer.cornerRadius = 5;
    self.googleSignInView.layer.cornerRadius = 5;
    self.appleSignInView.layer.cornerRadius = 5;
    self.emailSignInView.layer.cornerRadius = 5;
    
    self.kakaoSignInView.layer.borderWidth = 0.5;
    self.facebookSignInView.layer.borderWidth = 0.5;
    self.googleSignInView.layer.borderWidth = 0.5;
    self.appleSignInView.layer.borderWidth = 0.5;
    self.emailSignInView.layer.borderWidth = 0.5;

    self.kakaoSignInView.layer.borderColor = UIColor.blackColor.CGColor;
    self.facebookSignInView.layer.borderColor = UIColor.blackColor.CGColor;
    self.googleSignInView.layer.borderColor = UIColor.blackColor.CGColor;
    self.appleSignInView.layer.borderColor = UIColor.blackColor.CGColor;
    self.emailSignInView.layer.borderColor = UIColor.blackColor.CGColor;
    
}

-(void)addButtonToPrivacyPolicyLabel{
    
    NSString *privacyPolicyLabelText = self.privacyPolicyLabel.text;
    NSRange termsOfUsesRange = [privacyPolicyLabelText rangeOfString:@"terms of uses"];
    
    CGRect termsOfUsesRect = [self.privacyPolicyLabel boundingRectForCharacterRange:termsOfUsesRange];
    UIButton *termsOfUsesButton = [[UIButton alloc]init];
    termsOfUsesButton.frame = termsOfUsesRect;
    termsOfUsesButton.frameY += 1;
//    termsOfUsesButton.backgroundColor = UIColor.blueColor;
//    termsOfUsesButton.alpha = 0.5;
    [termsOfUsesButton addTarget:self action:@selector(termsOfUsesButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.privacyPolicyLabel addSubview:termsOfUsesButton];
    
    NSRange privacyPolicyRange = [privacyPolicyLabelText rangeOfString:@"privacy policy"];
    CGRect privacyPolicyRect = [self.privacyPolicyLabel boundingRectForCharacterRange:privacyPolicyRange];
    UIButton *privacyPolicyButton = [[UIButton alloc]init];
    privacyPolicyButton.frame = privacyPolicyRect;
    privacyPolicyButton.frameY += 1;
//    privacyPolicyButton.backgroundColor = UIColor.redColor;
//    privacyPolicyButton.alpha = 0.5;
    [privacyPolicyButton addTarget:self action:@selector(privacyPolicyButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.privacyPolicyLabel addSubview:privacyPolicyButton];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString: self.privacyPolicyLabel.attributedText];
    
    
    [attributedText addAttributes:@{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"applesdgothicneo-bold" size:10.0] } range:termsOfUsesRange];
    [attributedText addAttributes:@{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"applesdgothicneo-bold" size:10.0]} range:privacyPolicyRange];
    
    [self.privacyPolicyLabel setAttributedText: attributedText];
    
}

-(void)termsOfUsesButtonTouched:(id)sender{
    
    self.signInView.alpha = 0.1; //
    
}

-(void)privacyPolicyButtonTouched:(id)sender{
    
    self.signInView.alpha = 1; //
    
}

@end
