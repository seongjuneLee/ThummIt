//
//  Item.m
//  Thummit
//
//  Created by 이성준 on 2020/12/17.
//

#import "Item.h"
#import "PhotoManager.h"
#import "UIImage+Additions.h"
@implementation Item

-(id)init{
    
    self = [super init];
    if (self) {
        self.baseView.layer.cornerRadius = self.baseView.frameWidth/2;
        self.baseView.clipsToBounds = true;
        self.scale = 1.0;
    }
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    Item * copied = [[self.class alloc] init];
    UIView *copiedBaseView = [[UIView alloc] initWithFrame:self.baseView.frame];
    copiedBaseView.backgroundColor = self.baseView.backgroundColor;
    copiedBaseView.clipsToBounds = self.baseView.clipsToBounds;
    copied.baseView = copiedBaseView;
    UIImageView *copiedImageView = [[UIImageView alloc] initWithFrame:self.photoImageView.frame];
    copiedImageView.image = [self.photoImageView.image copy];
    copied.photoImageView = copiedImageView;
    copiedImageView.contentMode = self.photoImageView.contentMode;
    copied.itemName = [NSString stringWithString:self.itemName];
    [copied.baseView addSubview:copied.photoImageView];
    copied.backgroundImageView = [[UIImageView alloc] initWithFrame:self.backgroundImageView.frame];
    copied.backgroundImageView.image = [UIImage imageNamed:self.backgroundImageName];
    [copied.baseView addSubview:copied.backgroundImageView];
    copied.rotationDegree = self.rotationDegree;
    copied.scale = self.scale;
    copied.imageViewCenter = self.imageViewCenter;
    copied.imageViewRotationDegree = self.imageViewRotationDegree;
    copied.imageViewScale = self.imageViewScale;

    
    return copied;
}

-(id)initWithCoder:(NSCoder *)decoder{
    if((self = [super init])) {
        
        self.baseView = [decoder decodeObjectForKey:@"baseView"];
        self.baseView.layer.cornerRadius = self.baseView.frameWidth/2;
        self.baseView.clipsToBounds = true;
        
        self.backgroundImageView = [decoder decodeObjectForKey:@"backgroundImageView"];
        self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frameWidth/2;
        self.backgroundImageView.clipsToBounds = true;
        self.backgroundImageName = [decoder decodeObjectForKey:@"backgroundImageName"];
        self.backgroundImageView.image = [UIImage imageNamed:self.backgroundImageName];

        self.itemName = [decoder decodeObjectForKey:@"itemName"];
        
        NSString *phAssetLocalIdentifier = [decoder decodeObjectForKey:@"localIdentifier"];
        for (PHAsset *phAsset in PhotoManager.sharedInstance.phassets) {
            if ([phAsset.localIdentifier isEqualToString:phAssetLocalIdentifier]) {
                self.phAsset = phAsset;
            }
        }
        self.photoImageView = [decoder decodeObjectForKey:@"photoImageView"];
        
        NSString *imageURL = [decoder decodeObjectForKey:@"imageURL"];
        if (imageURL.length) {
            NSData *data = [[NSData alloc]initWithBase64EncodedString:imageURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.photoImageView.image = [UIImage imageWithData:data];
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{

    [encoder encodeObject:self.baseView forKey:@"baseView"];
    [encoder encodeObject:self.itemName forKey:@"itemName"];
    [encoder encodeObject:self.backgroundImageView forKey:@"backgroundImageView"];
    [encoder encodeObject:self.backgroundImageName forKey:@"backgroundImageName"];
    [encoder encodeObject:self.phAsset.localIdentifier forKey:@"localIdentifier"];
    NSString *imageURL = [UIImagePNGRepresentation(self.photoImageView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [encoder encodeObject:self.photoImageView forKey:@"photoImageView"];
    [encoder encodeObject:imageURL forKey:@"imageURL"];
    

}

-(void)scaleItem{
    
    self.baseView.frameWidth *= self.scale;
    self.baseView.frameHeight *= self.scale;
        
}

@end
