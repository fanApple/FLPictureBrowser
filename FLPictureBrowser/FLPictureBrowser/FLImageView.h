//
//  FLImageView.h
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/4.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FLImageView : UIScrollView


@property(nonatomic,copy) UIImage *currentImage;

- (instancetype)initWithFrame:(CGRect)frame bigUrl:(NSURL *)bgUrl smImage:(UIImage *)defaultImage;

@end
