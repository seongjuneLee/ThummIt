//
//  AlbumCollectionViewCellFlowLayout.m
//  Vlogr
//
//  Created by 이성준 on 18/11/2019.
//  Copyright © 2019 TaejunLee. All rights reserved.
//

#import "AlbumCollectionViewCellFlowLayout.h"

@implementation AlbumCollectionViewCellFlowLayout

-(void)awakeFromNib{
    [super awakeFromNib];
    
    float cellWidth = ([UIScreen mainScreen].bounds.size.width - 30)/2 - 10.0;
    self.itemSize = CGSizeMake(cellWidth , cellWidth * 1.2);
    self.minimumInteritemSpacing = 1.0;
    self.minimumLineSpacing = 1.0;
    self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);

}

@end
