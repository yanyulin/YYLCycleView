//
//  YYLCycleView.m
//  YYLCycleView
//
//  Created by yyl on 2017/7/18.
//  Copyright © 2017年 yanyulin. All rights reserved.
//

#import "YYLCycleView.h"
#import "UIImageView+WebCache.h"


@implementation YYLCycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}


#pragma mark - getter and setter methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

@end


NSString * const kCollectionViewCellId = @"collectionViewCellId";

@interface YYLCycleView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
    
@property (nonatomic, strong) UICollectionView *collectionView;
    
@property (nonatomic, strong) NSArray *imagePathGroup;

//总共的图片数
@property (nonatomic, assign) NSInteger totalItemsCount;
    
@property (nonatomic, strong) UIControl *pageControl;
    
// 当imageURLs为空时的背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;
    
@property (nonatomic, weak) NSTimer *timer;
    
@end

@implementation YYLCycleView

#pragma mark - init 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initConfig];
        
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

    
/**
 初始化配置变量信息
 */
- (void)initConfig {
    _cycleViewPageControlAliment = YYLCycleViewPageControlAlimentCenter;
    _autoCycleTimeInterval = 2.0f;
    _autoCycle = YES;
    _infiniteCycle = YES;
    _showPageControl = YES;
    _pageControlDotSize = CGSizeMake(10, 10);
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
}

- (void)initPageControl {
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    if (self.imagePathGroup.count == 0) {
        return;
    }
    if (self.imagePathGroup.count == 1 && self.hidesForSinglePage) {
        return;
    }
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    UIPageControl *pageController = [[UIPageControl alloc] init];
    pageController.numberOfPages = self.imagePathGroup.count;
    pageController.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageController.pageIndicatorTintColor = self.pageDotColor;
    pageController.userInteractionEnabled = NO;
    pageController.currentPage = indexOnPageControl;
    [self addSubview:pageController];
    _pageControl = pageController;
}

- (void)initTimer {
    //创建定时器先停掉定时器
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoCycleTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
    
#pragma mark - private methods
- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return index % self.imagePathGroup.count;
}
    
- (NSInteger)currentIndex {
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (void)scrollToIndex:(NSInteger)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteCycle) {
            targetIndex = self.totalItemsCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
    
- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - event
- (void)automaticScroll {
    if (_totalItemsCount == 0) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}
    
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYLCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    NSInteger itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    NSString *imagePath = self.imagePathGroup[itemIndex];
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cycleView:didSelectItemAtindex:)]) {
        [self.delegate cycleView:self didSelectItemAtindex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.cycleViewDidClickBlock) {
        self.cycleViewDidClickBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imagePathGroup.count) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    ((UIPageControl *)self.pageControl).currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoCycle) {
        [self initTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoCycle) {
        [self initTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathGroup.count) {
        return;
    }
}
    
- (void)layoutSubviews {
    [super layoutSubviews];
    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.frame = self.bounds;
    
    if (self.collectionView.contentOffset.x == 0 && _totalItemsCount) {
        NSInteger targetIndex = 0;
        if (self.infiniteCycle) {
            targetIndex = _totalItemsCount * 0.5;
        } else {
            targetIndex = 0;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    CGSize size = CGSizeMake(self.imagePathGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    if (self.cycleViewPageControlAliment == YYLCycleViewPageControlAlimentRight) {
        x = self.collectionView.frame.size.width - size.width - 10;
    }
    CGFloat y = self.collectionView.frame.size.height - size.height - 10;
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}
    
#pragma mark - getter and setter methods
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
    
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[YYLCycleCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _collectionView;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    NSMutableArray *temp = [NSMutableArray array];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            urlString = [(NSURL *)obj absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathGroup = [temp copy];
}
    
- (void)setImagePathGroup:(NSArray *)imagePathGroup {
    _imagePathGroup = imagePathGroup;
    _totalItemsCount = self.infiniteCycle ? self.imagePathGroup.count * 100 : self.imagePathGroup.count;
    if (imagePathGroup.count > 1) {
        //由于 !=1 包含 count == 0等情况
        self.collectionView.scrollEnabled = YES;
        [self setAutoCycle:self.autoCycle];
    } else {
        self.collectionView.scrollEnabled = NO;
        [self setAutoCycle:NO];
    }
    [self initPageControl];
    [self.collectionView reloadData];
}
    
- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self initPageControl];
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    ((UIPageControl *)self.pageControl).currentPageIndicatorTintColor = currentPageDotColor;
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    ((UIPageControl *)self.pageControl).pageIndicatorTintColor = pageDotColor;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.collectionView];
        self.backgroundImageView = bgImageView;
    }
    self.backgroundImageView.image = placeholderImage;
}

- (void)setInfiniteCycle:(BOOL)infiniteCycle {
    _infiniteCycle = infiniteCycle;
    if (self.imagePathGroup.count) {
        self.imagePathGroup = self.imagePathGroup;
    }
}

- (void)setAutoCycle:(BOOL)autoCycle {
    _autoCycle = autoCycle;
    [self invalidateTimer];
    if (_autoCycle) {
        [self initTimer];
    }
}
    
@end
