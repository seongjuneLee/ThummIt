//
//  ItemLayer.m
//  ThummIt
//
//  Created by 이성준 on 2021/02/24.
//

#import "ItemLayer.h"
#import "UIImage+Additions.h"


@implementation ItemLayer

-(id)init{
    
    self = [super init];
    if(self){
    }
    return self;
    
}

-(void)loadView{//make bar base view
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    float barBaseViewWitdth = window.frameWidth*2/3;
    float barBaseViewHeight = window.frameWidth*2/3*0.08;

    self.barBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barBaseViewWitdth, barBaseViewHeight)]; //3경우 모두 공통적으로 barbaseview 생성

    if ([self.item isKindOfClass:PhotoFrame.class]) {
//        PhotoFrame *photoFrame = (PhotoFrame *)self.item; //project의 item이 이 itemlayer객체에 담기고 photoframe일 경우
        
        UIImageView *photoFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barBaseViewWitdth, barBaseViewHeight)]; //가져온 item을 얹을 뷰
        photoFrameView.image = [UIImage imageWithView:self.item.baseView];
        [photoFrameView setContentMode:UIViewContentModeScaleAspectFit];
        photoFrameView.backgroundColor = UIColor.clearColor;

        [self.barBaseView addSubview:photoFrameView];
        self.barBaseView.backgroundColor = UIColor.cyanColor;
        
     


    } else if([self.item isKindOfClass:Text.class]){
        Text *text = (Text *)self.item;

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, barBaseViewWitdth, barBaseViewHeight)];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
//        [textLabel setTextColor:UIColor.whiteColor];
        textLabel.backgroundColor = UIColor.clearColor;
        textLabel.text = text.text;

        [self.barBaseView addSubview:textLabel];
        self.barBaseView.backgroundColor = UIColor.greenColor;
        
        
        
    } else if([self.item isKindOfClass:Sticker.class]){
        
        UIImageView *stickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barBaseViewWitdth, barBaseViewHeight)];
        
        stickerImageView.image = [UIImage imageWithView:self.item.baseView];
        [stickerImageView setContentMode:UIViewContentModeScaleAspectFit];
        stickerImageView.backgroundColor = UIColor.clearColor;

        [self.barBaseView addSubview:stickerImageView];
        self.barBaseView.backgroundColor = UIColor.blueColor;

    }
    
} 


@end