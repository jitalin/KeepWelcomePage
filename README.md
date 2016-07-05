# KeepWelcomePage
keep 的视频欢迎界面，循环播放视频和无限轮播图片相结合
/**

*设置其他音乐软件播放的音乐不被打断

*/

self.avaudioSession= [AVAudioSessionsharedInstance];

NSError*error =nil;

[self.avaudioSessionsetCategory:AVAudioSessionCategoryAmbienterror:&error];

//播放视频

NSString*filePath = [[NSBundlemainBundle]pathForResource:@"1.mp4"ofType:nil];

NSURL*sourceMovieURL = [NSURLfileURLWithPath:filePath];

AVAsset*movieAsset = [AVURLAssetURLAssetWithURL:sourceMovieURLoptions:nil];

AVPlayerItem*playerItem = [AVPlayerItemplayerItemWithAsset:movieAsset];

AVPlayer*player = [AVPlayerplayerWithPlayerItem:playerItem];

AVPlayerLayer*playerLayer = [AVPlayerLayerplayerLayerWithPlayer:player];

playerLayer.frame=self.view.layer.bounds;

playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;

[self.view.layerinsertSublayer:playerLayeratIndex:0];

self.player= player;

[playerplay];
#pragma mark------------------------------------循环播放

- (void)runLoopTheMovie:(NSNotification*)n{

//注册的通知可以自动把AVPlayerItem对象传过来，只要接收一下就OK

AVPlayerItem* p = [nobject];

//关键代码（从0开始）

[pseekToTime:kCMTimeZero];

[self.playerplay];

NSLog(@"重播");

}
