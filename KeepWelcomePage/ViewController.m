//
//  ViewController.m
//  KeepWelcomePage
//
//  Created by lingaofei on 16/6/27.
//  Copyright © 2016年 lemang. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#define kLabelNumber 4
@interface ViewController ()<UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong) UIScrollView* scrollView;
/**
 *  翻页控件
 */
@property (nonatomic,strong) UIPageControl* pageControl;
/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer* timer;
/**
 *  显示的文字label
 */
@property (nonatomic,strong) UILabel* label;
/**
 *  label.text的相关数据
 */
@property (nonatomic,strong) NSArray* labelArray;
@property (nonatomic,strong) UIImageView* imageView;

/**
 *  播放音频
 */
@property(nonatomic ,strong)AVAudioSession *avaudioSession;
@property (nonatomic,strong) AVPlayer* player;

@end

@implementation ViewController


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        CGRect iFrame = CGRectZero;
        iFrame.origin.x = self.view.center.x - 50;
        iFrame.origin.y = self.view.center.y - 100;
        
        iFrame.size = CGSizeMake(100, 80);
        _imageView.frame = iFrame;
        _imageView.image = [UIImage imageNamed:@"keep6plus@3x"];
        [self.view insertSubview:_imageView aboveSubview:self.scrollView];
        
        

    }
    return _imageView;
    
}

- (UILabel *)label
{
    if (!_label) {
        self.labelArray = @[@"每个动作都精确规范",@"规划陪伴你的训练过程",@"分享汗水后你的性感",@"全程记录你的健身数据"];
       
        
        for (int i = 0; i < kLabelNumber; i++) {
            _label = [[UILabel alloc]init];
            CGRect iFrame = CGRectZero;
            iFrame.origin = CGPointMake(i * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height/4*3);
            iFrame.size = CGSizeMake(self.view.bounds.size.width, 50);
            _label.frame = iFrame;
            _label.text = self.labelArray[i];
     
            _label.font = [UIFont systemFontOfSize:22];
            
            _label.textColor = [UIColor whiteColor];
            _label.textAlignment = NSTextAlignmentCenter;

            [self.scrollView addSubview:_label];
            
            
            

        }
        
    }
    return _label;
    
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [[NSTimer alloc]init];
        
    }
    return _timer;
    
}
#pragma mark---------------------图片轮播

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height-150, self.view.bounds.size.width, 30)];
        _pageControl.numberOfPages = kLabelNumber;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.userInteractionEnabled = NO;
        
        [self.view addSubview:_pageControl];
        
        
    }
    return _pageControl;
    
}
//创建滚动视图
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.view.bounds;
        
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kLabelNumber * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view insertSubview:_scrollView atIndex:0];
        
    }return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

  
    //self.headerImageView.hidden = NO;

    self.scrollView.hidden = NO;
    self.pageControl.hidden = NO;
    self.label.hidden = NO;
    self.imageView.hidden = NO;
    
    [self loadTimer];
    
    
    /**
     *  设置其他音乐软件播放的音乐不被打断
     */
    
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    //播放视频

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
    
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    self.player = player;
    
    
    [player play];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}
#pragma mark------------------------------------循环播放
- (void)runLoopTheMovie:(NSNotification *)n{
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    
    AVPlayerItem * p = [n object];
    //关键代码（从0开始）
    [p seekToTime:kCMTimeZero];
    
    [self.player play];
    NSLog(@"重播");
}
#pragma mark----------------------------无限轮播图片
//加载定时器
- (void)loadTimer{
    //设置定时器,使其1秒钟切换一次,且不断重复切换(repeats:YES)
    self.timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(pageChanged:) userInfo:nil repeats:YES];
    
    //取得主循环
    NSRunLoop *mainLoop=[NSRunLoop mainRunLoop];
    //将其添加到运行循环中(监听滚动模式)
    [mainLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//当页码发生改变的时候调用
- (void)pageChanged:(id)sender{
    
    //获取当前页面的索引
    NSInteger currentPage=self.pageControl.currentPage;
    //获取偏移量
    CGPoint offset=self.scrollView.contentOffset;
    //
    if (currentPage >= kLabelNumber - 1) {
        //将其设置首张图片的索引
        currentPage=0;
        //恢复偏移量
        offset.x = 0;
        //DDLogVerbose(@"offset%f",offset.x);
    }else{
        //当前索引+1
        currentPage ++;
        //设置偏移量
        
        offset.x += self.scrollView.bounds.size.width;
        
        //DDLogVerbose(@"offset.x====%f",offset.x);
    }
    //设置当前页
    self.pageControl.currentPage=currentPage;
    //设置偏移后的位置 加上动画过度
    [self.scrollView setContentOffset:offset animated:NO];
    
}

#pragma mark ---------UIScrollViewDelegate 协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //round函数功能是四舍五入,超过父视图的宽度的一半实现翻页功能
    int index = round(scrollView.contentOffset.x / self.view.bounds.size.width);
    self.pageControl.currentPage = index;
    
}


//设置代理方法,当开始拖拽的时候,让计时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //使定时器失效
    [self.timer invalidate];
}

//设置代理方法,当拖拽结束的时候,调用计时器,让其继续自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //重新启动定时器
    [self loadTimer];
}

//ios以后隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
