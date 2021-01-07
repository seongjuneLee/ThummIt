//
//  ProjectTableViewCell.m
//  ThummIt
//
//  Created by 이성준 on 2020/12/22.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundImageView.layer.cornerRadius = 10.0;
    self.moreButton.layer.cornerRadius = 3.0;
    self.downloadButton.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadButtonTapped:(id)sender {
    
    
    
}

- (IBAction)moreButtonTapped:(UIButton *)sender {
    
    [self.delegate moreButtonTappedWithIndex:sender.tag];
    
}

@end
