//
//  FLImageView.m
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/4.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import "FLImageView.h"


@interface FLImageView () <UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *imageView;

@end


@implementation FLImageView
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame bigUrl:(NSURL *)bgUrl smImage:(UIImage *)defaultImage{
    if (self =[super initWithFrame:frame]) {
        self.delegate = self;
        self.maximumZoomScale=2.0f;
        self.minimumZoomScale=1.0f;
        self.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImageWithUrl:bgUrl placeholderImage:defaultImage];
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    
    
    [self.imageView sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        (CGFloat)receivedSize / expectedSize; 进度
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.currentImage = self.imageView.image;
    }];
}

@end
