//
//  ViewController.m
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/4.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import "ViewController.h"
#import "FLRuntime.h"


#define kPictureW 80
#define kPictureH 120

@interface ViewController ()

@property(nonatomic,strong) UIView *backgroundView;


@property(nonatomic,copy) NSArray *imageUrlStrs;

@property(nonatomic,strong) NSMutableArray *urls;

@end


@implementation ViewController

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
        _backgroundView.backgroundColor = fColor(22, 32, 24);
    }
    return _backgroundView;
}

- (NSMutableArray *)urls {
    
    if (!_urls) {
        _urls = [NSMutableArray arrayWithCapacity:0];
    }
    return _urls;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self addImgeViews];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    _imageUrlStrs = @[@"http://b.zol-img.com.cn/sjbizhi/images/5/320x510/1377075778565.jpg",@"http://imgsrc.baidu.com/forum/pic/item/3b292df5e0fe992520a4a1b734a85edf8cb171a9.jpg",@"http://www.jmnews.com.cn/a/pic/attachement/jpg/site2/20140308/A071394233224513_change_JMRBA9308C001_b.jpg",@"http://img.ph.126.net/oNAw-JQDT-69nloHtzUc_A==/3277213153842854628.jpg"];
    [_imageUrlStrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kWeakSelf
        [weakSelf.urls addObject:[NSURL URLWithString:[_imageUrlStrs[idx] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }];
    
    
}

- (void)addImgeViews {
    [_imageUrlStrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+(idx+kPictureW + 30)*(idx%3), 20+(idx +15+ kPictureH)*(idx/3), kPictureW, kPictureH);
        [btn setBackgroundImage:[UIImage imageNamed:@"ms.jpg"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(previewPictures:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [_backgroundView addSubview:btn];
        
    }];
    
    
}

- (void)previewPictures:(UIButton *)sender {
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.tag = 1008;
    [self.view addSubview:mask];
    
    FLBrowsePhotoView *flb = [[FLBrowsePhotoView alloc] initWithFrame:self.view.bounds fromView:_backgroundView urls:_urls currentIndex:sender.tag delegate:self];
    [self.view addSubview:flb];
}


#pragma mark - FLBrowsePhotoViewDelegate

- (NSURL *)flbrowsePhotoView:(FLBrowsePhotoView *)flbrowsePhotoView bigCurrentIndex:(NSUInteger)currentIndex {
    return [NSURL URLWithString:_imageUrlStrs[currentIndex]];
}

- (UIImage *)flbrowsePhotoView:(FLBrowsePhotoView *)flbrowsePhotoView smlCurrentIndex:(NSUInteger)currentIndex {
    return [UIImage imageNamed:@"ms.jpg"];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
