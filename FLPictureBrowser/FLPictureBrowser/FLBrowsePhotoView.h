//
//  FLBrowsePhotoView.h
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/4.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class FLBrowsePhotoView;


//model
@interface FLModel : NSObject

//大图url
@property (nonatomic,copy)NSURL *bigUrl;
//小图
@property (nonatomic,copy)UIImage *smlImage;

@end


@class FLImageView;
//view
@interface FLBrowsePhotoViewCell : UICollectionViewCell

@property (nonatomic,strong)FLModel *model;

@property(nonatomic,strong) FLImageView *imageView;

@end

//controller

@protocol FLBrowsePhotoViewDelegate  <NSObject>

//小图
- (UIImage *)flbrowsePhotoView:(FLBrowsePhotoView *)flbrowsePhotoView smlCurrentIndex:(NSUInteger)currentIndex;
//大图
- (NSURL *)flbrowsePhotoView:(FLBrowsePhotoView *)flbrowsePhotoView bigCurrentIndex:(NSUInteger)currentIndex;



@end

@interface FLBrowsePhotoView : UIView

@property (nonatomic,copy)UIImage *defaultImage;

@property (nonatomic,copy)UIColor *backgroundColor;

@property (nonatomic,assign)id<FLBrowsePhotoViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)fromView urls:(NSArray *)urls currentIndex:(NSUInteger)index delegate:(id)delegate;


@end









