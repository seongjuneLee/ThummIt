//
//  AlbumCategoryCollectionViewCell.m
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import "AlbumCategoryCollectionViewCell.h"

@implementation AlbumCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumbnailImageView.layer.cornerRadius = 5.0f;
    self.thumbnailImageView.clipsToBounds = true;
    
}

@end
