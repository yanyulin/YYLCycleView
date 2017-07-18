//
//  YYLCycleView.m
//  YYLCycleView
//
//  Created by yyl on 2017/7/18.
//  Copyright © 2017年 yanyulin. All rights reserved.
//

#import "YYLCycleView.h"

@interface YYLCycleView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
    
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YYLCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initConfig];
        
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
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont = [UIFont systemFontOfSize:14];
    _titlelabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _autoCycle = YES;
    _infiniteCycle = YES;
    _showPageControl = YES;
    _pageControlDotSize = CGSizeMake(10, 10);
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _cycleViewPageControlStyle = YYLCycleViewPageControlStyleClassic;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor lightGrayColor];
}


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
    }
    return _collectionView;
}
@end
