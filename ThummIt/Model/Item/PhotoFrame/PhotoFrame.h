//
//  Border.h
//  Thummit
//
//  Created by 이성준 on 2020/12/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Item.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotoFrame : Item

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) UIButton *plusPhotoButton;
@property (strong, nonatomic) UILabel *plusLabel;

-(void)addSubViewsToBaseView;
-(void)addCircleImageWithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
