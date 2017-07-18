//
//  YYLViewController.m
//  YYLCycleView
//
//  Created by yanyulin on 07/18/2017.
//  Copyright (c) 2017 yanyulin. All rights reserved.
//

#import "YYLViewController.h"
#import "YYLCycleView.h"

@interface YYLViewController ()<YYLCycleViewDelegate>
    
@property (nonatomic, strong) YYLCycleView *cycleView;

@end

@implementation YYLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.cycleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (YYLCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[YYLCycleView alloc] initWithFrame:CGRectMake(0 , 100, self.view.frame.size.width, 300)];
        _cycleView.placeholderImage = [UIImage imageNamed:@"pleaceholderimage"];
        _cycleView.infiniteCycle = YES;
        _cycleView.autoCycle = YES;
        _cycleView.delegate = self;
        _cycleView.imageURLStringsGroup = @[
                                            @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1089399937,1684001946&fm=117&gp=0.jpg",
                                            @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=319260780,2414479202&fm=117&gp=0.jpg",
                                            @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=401967138,750679164&fm=117&gp=0.jpg",
                                            @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=4092353190,3027758101&fm=117&gp=0.jpg",
                                            @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1990601815,3596917195&fm=117&gp=0.jpg",
                                            @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4279488454,2375510965&fm=200&gp=0.jpg",
                                            @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1340624740,981264645&fm=117&gp=0.jpg",
                                            ];
        _cycleView.cycleViewDidClickBlock = ^(NSInteger currentIndex) {
            NSLog(@"Block监听 点击了第%zd 张图片", currentIndex);
        };
        
    }
    return _cycleView;
}

- (void)cycleView:(YYLCycleView *)cycleView didSelectItemAtindex:(NSInteger)index {
    NSLog(@"代理监听 点击了第%zd 张图片", index);
}

@end
