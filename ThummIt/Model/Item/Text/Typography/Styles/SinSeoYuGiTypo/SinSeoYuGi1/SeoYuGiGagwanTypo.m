//
//  SeoYuGiGagwanTypo.m
//  ThummIt
//
//  Created by 이성준 on 2021/01/27.
//

#import "SeoYuGiGagwanTypo.h"

@implementation SeoYuGiGagwanTypo

-(id)init{
    self = [super init];
    if (self) {
        self.name = NSLocalizedString(@"가관이네..",nil);
        self.fontName = @"NotoSansKannada-Bold";
        self.textColor = [UIColor colorWithRed:253/255.0f green:242/255.0f blue:95/255.0 alpha:1 ];
        self.obliqueValue = 0.23;
        
        BGTextAttribute *borderAtt1 = [[BGTextAttribute alloc] init];
        borderAtt1.borderColor = [UIColor colorWithRed:253/255.0f green:242/255.0f blue:95/255.0 alpha:1 ];
        borderAtt1.borderWidth = 3;
        borderAtt1.obliqueValue = 0.23;
        
        BGTextAttribute *borderAtt2 = [[BGTextAttribute alloc] init];
        borderAtt2.borderColor = [UIColor colorWithRed:133/255.0f green:54/255.0f blue:16/255.0f alpha:1];
        borderAtt2.borderWidth = 15;
        borderAtt2.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt1 = [[BGTextAttribute alloc] init];
        shadowAtt1.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt1.shadowOffset = CGPointMake(1, 1);
        shadowAtt1.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt2 = [[BGTextAttribute alloc] init];
        shadowAtt2.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt2.shadowOffset = CGPointMake(1.5, 1.5);
        shadowAtt2.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt3 = [[BGTextAttribute alloc] init];
        shadowAtt3.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt3.shadowOffset = CGPointMake(2, 2);
        shadowAtt3.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt4 = [[BGTextAttribute alloc] init];
        shadowAtt4.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt4.shadowOffset = CGPointMake(2.5, 2.5);
        shadowAtt4.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt5 = [[BGTextAttribute alloc] init];
        shadowAtt5.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt5.shadowOffset = CGPointMake(3, 3);
        shadowAtt5.obliqueValue = 0.23;
        
        BGTextAttribute *shadowAtt6 = [[BGTextAttribute alloc] init];
        shadowAtt6.shadowColor =[UIColor colorWithRed:208/255.0f green:68/255.0f blue:25/255.0f alpha:1];
        shadowAtt6.shadowOffset = CGPointMake(3.5, 3.5);
        shadowAtt6.obliqueValue = 0.23;
        
        
        
        self.bgTextAttributes = @[borderAtt1, borderAtt2, shadowAtt1, shadowAtt2, shadowAtt3, shadowAtt4,shadowAtt5,shadowAtt6];
    }
        //기울이기
    return self;
}

+(SeoYuGiGagwanTypo*) seoYuGiGagwanTypo{
    
    SeoYuGiGagwanTypo* seoYuGiGagwanTypo = [[self alloc] init];
    return seoYuGiGagwanTypo;
    
}
@end
