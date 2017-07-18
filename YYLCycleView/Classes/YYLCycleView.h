//
//  YYLCycleView.h
//  YYLCycleView
//
//  Created by yyl on 2017/7/18.
//  Copyright © 2017年 yanyulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYLCycleView;

//分页控件位置的枚举
typedef enum : NSUInteger {
    YYLCycleViewPageControlAlimentRight,
    YYLCycleViewPageControlAlimentCenter,
} YYLCycleViewPageControlAliment;

@interface YYLCycleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end


@protocol YYLCycleViewDelegate <NSObject>

- (void)cycleView:(YYLCycleView *)cycleView didSelectItemAtindex:(NSInteger)index;

@end

@interface YYLCycleView : UIView


@property (nonatomic, weak) id<YYLCycleViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^cycleViewDidClickBlock)(NSInteger currentIndex);

/**
 是否自动轮播 默认 Yes
 */
@property (nonatomic, assign) BOOL autoCycle;
    
/**
 是否无限循环 默认 Yes
 */
@property (nonatomic, assign) BOOL infiniteCycle;
    
/**
 自动循环滚动间隔时间， 默认2s
 */
@property (nonatomic, assign) CGFloat autoCycleTimeInterval;
    

/**
 图片滚动方向 默认水平滚动
 */
@property (nonatomic,assign) UICollectionViewScrollDirection cycleDirection;


/**
 是否显示分页控件
 */
@property (nonatomic,assign) BOOL showPageControl;
 
/**
 是否在只有一张图时隐藏 pagecontroler 默认为 YES
 */
@property (nonatomic,assign) BOOL hidesForSinglePage;
    
/**
 分页控件的位置
 */
@property (nonatomic, assign) YYLCycleViewPageControlAliment cycleViewPageControlAliment;
    
    
/**
 分页控件小圆标的颜色
 */
@property (nonatomic,assign) CGSize pageControlDotSize;
    

/**
 分页控件距离轮播图底部间距（在默认间距基础上）的偏移量
 */
@property (nonatomic,assign) CGFloat pageControlBottomOffset;
    

/**
 分页控件距离轮播图右边的间距（在默认的基础上）的偏移量
 */
@property (nonatomic,assign) CGFloat pageControlRightOffset;
    
/**
 当前分页控件小圆标的颜色
 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/**
 其它分页控件小圆标的颜色
 */
@property (nonatomic, strong) UIColor *pageDotColor;
    
/**
 轮播图片的 ContentModel，默认为UIViewContentModeScaleToFill
 */
@property (nonatomic,assign) UIViewContentMode bannerImageViewContentMode;

/**
 占位图， 用于网络未加载到图片时
 */
@property (nonatomic, strong) UIImage *placeholderImage;
    
    
/**************数据源**************/
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

@end
