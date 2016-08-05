//
//  FLBrowsePhotoView.m
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/4.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import "FLBrowsePhotoView.h"
#import "FLImageView.h"


@implementation FLModel

@end


@interface FLBrowsePhotoViewCell () 

@end

@implementation FLBrowsePhotoViewCell

{
    FLImageView *_imageView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
       
    }
    return self;
}

- (void)setModel:(FLModel *)model {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    FLImageView *imgView = [[FLImageView alloc] initWithFrame:fKeyWindow.frame bigUrl:model.bigUrl smImage:model.smlImage ];
    _imageView = imgView;
    imgView.contentSize = self.frame.size;
    [self.contentView addSubview:imgView];
}


@end


@interface FLBrowsePhotoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) UICollectionView *pbView;

@property (nonatomic,copy)NSArray *urls;

@property (nonatomic,assign)NSUInteger index;

@property (nonatomic,copy)NSArray *defaultImages;

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,copy)NSArray *rects;

@property (nonatomic,strong)UIView *fromView;

@property(nonatomic,copy) NSIndexPath *currentIndexPath;

@property(nonatomic,strong) UIPageControl *pc;


@end

@implementation FLBrowsePhotoView

- (instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)fromView urls:(NSArray *)urls currentIndex:(NSUInteger)index  delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.frame = frame;
        _fromView = fromView;
        _urls = urls;
        _index = index;
        _currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self addSubview:self.pbView];
        self.pbView.hidden = YES;
        [self setup];
        [self addGes];
        [self createPageControl:urls.count];
    }
    return self;
}


- (void)createPageControl:(NSInteger)pageNum{
    //分页控件
    UIPageControl *pc = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    pc.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 20);
    pc.hidesForSinglePage = YES; 
    pc.alpha = 1;
    pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    pc.hidesForSinglePage = YES;
    pc.currentPageIndicatorTintColor = [UIColor whiteColor];
    //设置页数
    pc.numberOfPages = pageNum;
    pc.currentPage = _index;
    pc.enabled = NO;
    [self addSubview:pc];
    _pc =pc;
}


- (void)addGes {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.8;
    press.numberOfTouchesRequired = 1;
    press.delegate = self;
    [self addGestureRecognizer:press];
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)dealloc {
    
}

- (UIImage *)getSmlPhotoUrlWithCurrentIndex:(NSUInteger)currentIndex {
    if (_delegate && [_delegate respondsToSelector:@selector(flbrowsePhotoView:smlCurrentIndex:)]) {
       return [_delegate flbrowsePhotoView:self smlCurrentIndex:currentIndex];
    }
    return nil;
}

- (NSURL *)getBigPhotoUrlWithCurrentIndex:(NSUInteger)currentIndex {
    if (_delegate && [_delegate respondsToSelector:@selector(flbrowsePhotoView:bigCurrentIndex:)]) {
        return [_delegate flbrowsePhotoView:self bigCurrentIndex:currentIndex];
    }
    return nil;
}
- (void)setup {
    NSMutableArray *smlImages = [NSMutableArray array];
    for (int i=0; i<_urls.count; i++) {
        [smlImages addObject:[self getSmlPhotoUrlWithCurrentIndex:i]];
    }
    for (int i=0; i<_urls.count; i++) {
        FLModel *model = [FLModel new];
        model.bigUrl = _urls[i];
        model.smlImage = smlImages[i];
        [self.dataSource addObject:model];
    }
    [_pbView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
    UIView *sourceView = _fromView.subviews[_index];
    CGRect rect = [_fromView convertRect:sourceView.frame toView:self];
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:rect];
    
    tempView.image = [self getSmlPhotoUrlWithCurrentIndex:_index];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:tempView];
    
    CGRect targetTemp = self.bounds;
    _pbView.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        [tempView removeFromSuperview];
        _pbView.hidden = NO;
        UIView *mask = [self.superview viewWithTag:1008];
        [mask removeFromSuperview];
    }];
    
    
}

- (UICollectionView *)pbView {
    if (!_pbView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pbView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [_pbView registerClass:[FLBrowsePhotoViewCell class] forCellWithReuseIdentifier:@"myCell"];
        _pbView.backgroundColor = [UIColor blackColor];
        [_pbView setContentOffset:CGPointMake(_index*self.width, 0)];
        _pbView.pagingEnabled = YES;
        _pbView.delegate = self;
         _pbView.dataSource = self;
        [self addSubview:_pbView];
    }
    return _pbView;
}


- (void)dismiss {
    FLImageView *iv = [[FLImageView alloc] initWithFrame:self.frame bigUrl:[self getBigPhotoUrlWithCurrentIndex:_index] smImage:nil];

    
    //没有加载成功时点击
    if (iv.currentImage == nil) {
        iv.currentImage = [self getSmlPhotoUrlWithCurrentIndex:_index];
    }
    
    /**
     *  这里仅仅是为了效果好看，本来后台给大图的时候会有尺寸的 ，这里没有，就加上了
     */
    
    CGFloat picWdivH = iv.currentImage.size.width/iv.currentImage.size.height;
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:iv.currentImage];

    CGRect frame;
    frame.size = CGSizeMake(self.width, self.width/picWdivH);
    tempImageView.frame = frame;
    tempImageView.center = self.center;
    [self addSubview:tempImageView];
    
    UIView *toView = _fromView.subviews[_index];
    CGRect rect = [_fromView convertRect:toView.frame toView:self];
    [UIView animateWithDuration:0.5 animations:^{
        tempImageView.frame = rect;
        _pbView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
        [self removeFromSuperview];
        [_pbView removeFromSuperview];
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _urls.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FLBrowsePhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[FLBrowsePhotoViewCell alloc] initWithFrame:self.frame];
    }
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    FLBrowsePhotoViewCell *cell = (FLBrowsePhotoViewCell*)[_pbView cellForItemAtIndexPath:_currentIndexPath];
    if (cell) {
        if (cell.imageView.zoomScale > 1) {
            [cell.imageView setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:cell.imageView];
            CGFloat newZoomScale = cell.imageView.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [cell.imageView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"began");
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地",@"举报", nil];
        
        [act showInView:self];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"保存");
        UIImageWriteToSavedPhotosAlbum([self getCurrentCell].imageView.currentImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"error";
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }else
    {
        message = [error description];
        [SVProgressHUD showErrorWithStatus:message];
    }
}

- (FLBrowsePhotoViewCell *)getCurrentCell {
    FLBrowsePhotoViewCell *cell = (FLBrowsePhotoViewCell*)[_pbView cellForItemAtIndexPath:_currentIndexPath];
    return cell;
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer{

    FLBrowsePhotoViewCell *cell = [self getCurrentCell];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            NSLog(@"%f",recognizer.scale);
            cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, recognizer.scale, recognizer.scale);
            recognizer.scale=1;
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat scale = cell.imageView.width/_pbView.width;
        if (scale > 1) {
            cell.imageView.contentSize = CGSizeMake(_pbView.width*scale, _pbView.height*scale);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前显示的cell的下标
    NSIndexPath *firstIndexPath = [[_pbView indexPathsForVisibleItems] firstObject];
    // 赋值给记录当前坐标的变量
    self.currentIndexPath = firstIndexPath;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.x);
    NSUInteger index = scrollView.contentOffset.x/self.width;
    _index = index;
    _pc.currentPage = _index;
}


@end
