//
//  YYLCycleView.h
//  YYLCycleView
//
//  Created by yyl on 2017/7/18.
//  Copyright © 2017年 yanyulin. All rights reserved.
//

#import <UIKit/UIKit.h>

//分页控件位置的枚举
typedef enum : NSUInteger {
    YYLCycleViewPageControlAlimentRight,
    YYLCycleViewPageControlAlimentCenter,
} YYLCycleViewPageControlAliment;

//分页控件
typedef enum : NSUInteger {
    YYLCycleViewPageControlStyleClassic,   //系统自带经典样式
    YYLCycleViewPageControlStyleAnimated,  //动画效果 pagecontrol
    YYLCycleViewPageControlStyleNone,      //不显示 pagecontrol
} YYLCycleViewPageControlStyle;

@interface YYLCycleView : UIView
 
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
 pagecontrol 样式 默认为动画样式
 */
@property (nonatomic,assign) YYLCycleViewPageControlStyle cycleViewPageControlStyle;
    

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
 轮播文字 label 字体的颜色
 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;
    

/**
 轮播文字 label 背景颜色
 */
@property (nonatomic, strong) UIColor *titlelabelBackgroundColor;
    

/**
 轮播文字 label 字体大小
 */
@property (nonatomic, strong) UIFont *titleLabelTextFont;
    
/**
 轮播文字 label 的高度
 */
@property (nonatomic, assign) CGFloat titleLabelHeight;
    

/**
 轮播文字 label 的对齐方式
 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;
    

@end
