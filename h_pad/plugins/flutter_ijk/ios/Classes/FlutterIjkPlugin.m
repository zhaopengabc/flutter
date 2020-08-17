#import "FlutterIjkPlugin.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <libkern/OSAtomic.h>
//#import <Reachability.h>

int64_t FLTIJKCMTimeToMillis(CMTime time) { return time.value * 1000 / time.timescale; }

int flag = 0;
int stop_flag = 0;
int start_flag = 0;
@interface FLTIJKFrameUpdater : NSObject
@property(nonatomic) int64_t textureId;
@property(nonatomic, readonly) NSObject<FlutterTextureRegistry>* registry;
- (void)onDisplayLink:(CADisplayLink*)link;
@end


@implementation FLTIJKFrameUpdater
- (FLTIJKFrameUpdater*)initWithRegistry:(NSObject<FlutterTextureRegistry>*)registry {
    NSAssert(self, @"super init cannot be nil");
    if (self == nil) return nil;
    _registry = registry;
    return self;
}

- (void)onDisplayLink:(CADisplayLink*)link {
    [_registry textureFrameAvailable:_textureId];
}
@end

@interface FLTIJKVideoPlayer : NSObject <FlutterTexture, FlutterStreamHandler>
@property(readonly, strong) id<IJKMediaPlayback> player;
@property(readonly, nonatomic) CADisplayLink* displayLink;
@property(nonatomic) FlutterEventChannel* eventChannel;
@property(nonatomic) FlutterEventSink eventSink;
@property(nonatomic, readonly) bool disposed;
@property(nonatomic, readonly) bool isPlaying;
@property(nonatomic, readonly) bool isLooping;
@property(nonatomic) int myPlaybackState;
// @dynamic playbackState;
@property(nonatomic, readonly) bool isInitialized;
- (instancetype)initWithURL:(NSURL*)url frameUpdater:(FLTIJKFrameUpdater*)frameUpdater;
- (void)play;
- (void)pause;
- (void)setIsLooping:(bool)isLooping;
- (void)updatePlayingState;
@end

@implementation FLTIJKVideoPlayer
- (instancetype)initWithAsset:(NSString*)asset frameUpdater:(FLTIJKFrameUpdater*)frameUpdater {
    NSString* path = [[NSBundle mainBundle] pathForResource:asset ofType:nil];
    return [self initWithURL:[NSURL fileURLWithPath:path] frameUpdater:frameUpdater];
}

- (instancetype)initWithURL:(NSURL*)url frameUpdater:(FLTIJKFrameUpdater*)frameUpdater {
    self = [super init];
    NSAssert(self, @"super init cannot be nil");
    _isInitialized = false;
    _isPlaying = false;
    _disposed = false;
    
    

    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"]; //硬解
    [options setPlayerOptionIntValue:0 forKey:@"mediacodec-hevc"]; //h265硬解
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    [options setFormatOptionValue:@"prefer_tcp" forKey:@"rtsp_flags"];
    [options setFormatOptionValue:@"video" forKey:@"allowed_media_types"];
    [options setFormatOptionIntValue:10*1000*1000 forKey:@"timeout"];
    [options setFormatOptionIntValue:1024 forKey:@"max-buffer-size"];
    [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
    [options setFormatOptionIntValue:100 forKey:@"analyzemaxduration"];
    [options setFormatOptionIntValue:10 forKey:@"analyzeduration"];
    [options setFormatOptionIntValue:10240 forKey:@"probesize"];
    [options setFormatOptionIntValue:1 forKey:@"flush_packets"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    [options setPlayerOptionIntValue:10 forKey:@"framedrop"];
    

    // IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    // [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"]; //硬解
    // [options setPlayerOptionIntValue:0 forKey:@"mediacodec-hevc"]; //h265硬解
    // [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    // [options setFormatOptionValue:@"prefer_tcp" forKey:@"rtsp_flags"];
    // [options setFormatOptionValue:@"video" forKey:@"allowed_media_types"];
    // [options setFormatOptionIntValue:10*1000*1000 forKey:@"timeout"];
    // [options setPlayerOptionIntValue:10240 forKey:@"max-buffer-size"];
    // [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
    // [options setFormatOptionIntValue:100 forKey:@"analyzemaxduration"];
    // [options setFormatOptionIntValue:10 forKey:@"analyzeduration"];
    // [options setFormatOptionIntValue:10240 forKey:@"probesize"];
    // [options setFormatOptionIntValue:1 forKey:@"flush_packets"];
    // [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];  
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    [options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"]; 
    [options setPlayerOptionIntValue:0 forKey:@"skip_loop_filter"]; 
    [options setPlayerOptionValue:@"1" forKey:@"an"];
    // [options setPlayerOptionIntValue:3000 forKey:@"max_cached_duration"];   

    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    [self removeMovieNotificationObservers];
    [self installMovieNotificationObservers];
    
    // [_player setPauseInBackground:NO];

    if(![_player isPlaying]){
        [_player prepareToPlay];
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:frameUpdater
                                               selector:@selector(onDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
        // _displayLink.paused = NO;

    return self;
}

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:self.player];
    
}

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        [self updatePlayingState];
        if (_eventSink != nil) {
            _eventSink(@{@"event" : @"bufferingEnd"});
        }
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        if (_eventSink != nil) {
            _eventSink(@{@"event" : @"bufferingStart"});
        }
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}


- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            if(_isLooping){
                [_player setCurrentPlaybackTime:0];
                [_player play];
            }else{
                if(_eventSink){
                    _eventSink(@{@"event" : @"completed"});
                }
            }
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            if(_eventSink){
                _eventSink(@{@"event" : @"user quit"});
            }
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            if(_eventSink){
                _eventSink([FlutterError
                            errorWithCode:@"VideoError"
                            message:@"Video finished with error"
                            details:nil]);
            }
            break;
            
        default:
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    _isInitialized = true;
    [self sendInitialized];
    [self updatePlayingState];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    _myPlaybackState = _player.playbackState;
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped---------", (int)_player.playbackState);
            stop_flag = 2;
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
           
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing+++++++++", (int)_player.playbackState);
            if(flag == 1)
            {
                flag = 2;
            }
            stop_flag = 0;
            start_flag = 1;
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused--------", (int)_player.playbackState);
            // if(flag == 1)
            // {
            //     flag = 2;
            // }
            flag = 4;
            stop_flag = 3;
            // start_flag = 2;
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


- (void)updatePlayingState {
    if (!_isInitialized) {
        return;
    }
    if (_isPlaying) {
        [_player play];
    } else {
        [_player pause];
    }
    _displayLink.paused = !_isPlaying;
}

- (void)sendInitialized {
    if (_eventSink && _isInitialized) {
        CGSize size = [_player naturalSize];
        _eventSink(@{
                     @"event" : @"initialized",
                     @"duration" : @([self duration]),
                     @"width" : @(size.width),
                     @"height" : @(size.height),
                     });
    }
}

- (void)play {
    _isPlaying = true;
    [self updatePlayingState];
}

- (void)pause {
    _isPlaying = false;

    [self updatePlayingState];
}

- (int64_t)position {
    //update buffer here
    _eventSink(@{@"event" : @"bufferingUpdate", @"values" : @((int64_t)([_player playableDuration] * 1000))}); //to msec ;
    return (int64_t)([_player currentPlaybackTime] * 1000); //to msec ;
}

- (int64_t)duration {
    return [_player duration] * 1000; //to msec
}

- (void)seekTo:(int)location {
    _player.currentPlaybackTime = location/1000; //to sec
}

- (void)setIsLooping:(bool)isLooping {
    _isLooping = isLooping;
}

- (void)setVolume:(double)volume {
    [_player setPlaybackVolume:(volume < 0.0) ? 0.0 : ((volume > 1.0) ? 1.0 : volume)];
}

- (CVPixelBufferRef)copyPixelBuffer {

    [_player framePixelbufferLock];
    CVPixelBufferRef pixelBuffer = [_player framePixelbuffer];

    if(pixelBuffer != nil){
        //CFRetain(pixelBuffer);
    }
    else
    {
        return nil;
    }
    [_player framePixelbufferUnlock];
    return pixelBuffer;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    [self sendInitialized];
    return nil;
}

- (void)dispose {
    _disposed = true;
    [_displayLink invalidate];
    [self removeMovieNotificationObservers];
    if(_player != nil){
        [_player stop];
        [_player shutdown];
        _player = nil;
    }
    //[_eventChannel setStreamHandler:nil];
}

@end

@interface FlutterIjkPlugin ()
@property(readonly, nonatomic) NSObject<FlutterTextureRegistry>* registry;
@property(readonly, nonatomic) NSObject<FlutterBinaryMessenger>* messenger;
@property(readonly, nonatomic) NSMutableDictionary* players;
@property(readonly, nonatomic) FLTIJKVideoPlayer* player;
@property(readonly, nonatomic) FLTIJKFrameUpdater* frameUpdater;
@property(readonly, nonatomic) NSString* dataSource;
@property(readonly, nonatomic) NSObject<FlutterPluginRegistrar>* registrar;

@end

@implementation FlutterIjkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"plugins.video/playerSDK"
                                binaryMessenger:[registrar messenger]];
    FlutterIjkPlugin* instance = [[FlutterIjkPlugin alloc] initWithRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    NSAssert(self, @"super init cannot be nil");
    _registry = [registrar textures];
    _messenger = [registrar messenger];
    _registrar = registrar;
    _players = [NSMutableDictionary dictionaryWithCapacity:1];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // printf("_player.myPlaybackState : %d flag : %d stop_flag : %d start_flag : %d\n",_player.myPlaybackState,flag,stop_flag,start_flag);

    if((flag == 2) && (_player.myPlaybackState == IJKMPMoviePlaybackStatePlaying))
    {
            [_registry unregisterTexture:0];
            [_players removeObjectForKey:@(0)];
            [_player dispose];

      _frameUpdater = [[FLTIJKFrameUpdater alloc] initWithRegistry:_registry];
        // _dataSource = argsMap[@"url"];
        _player = [[FLTIJKVideoPlayer alloc] initWithURL:[NSURL URLWithString:_dataSource]
                                            frameUpdater:_frameUpdater]; 
        // [_player initWithURL:[NSURL URLWithString:_dataSource] frameUpdater:_frameUpdater];

        [_player play];

        flag = 0;
        stop_flag = 0;
        // start_flag = 0;

        result(@(0));
        return;
    }

            
            //   if((_player.myPlaybackState == IJKMPMoviePlaybackStateStopped) && (stop_flag != 0) )
             if(((_player.myPlaybackState == IJKMPMoviePlaybackStateStopped)
              || ((_player.myPlaybackState == IJKMPMoviePlaybackStatePaused) && (start_flag == 0))) && (stop_flag != 0) )
             {
                flag = 0;
                stop_flag = 0;
                start_flag = 0;
                [_registry unregisterTexture:0];
                [_players removeObjectForKey:@(0)];
                [_player dispose];

                _frameUpdater = [[FLTIJKFrameUpdater alloc] initWithRegistry:_registry];
                // _dataSource = argsMap[@"url"];
                _player = [[FLTIJKVideoPlayer alloc] initWithURL:[NSURL URLWithString:_dataSource]
                                                frameUpdater:_frameUpdater]; 
                // [_player initWithURL:[NSURL URLWithString:_dataSource] frameUpdater:_frameUpdater];

                [_player play];
                _player.myPlaybackState = 1;
                return;
                // result(@(0));
             }

    if ([@"init" isEqualToString:call.method]) {
        // Allow audio playback when the Ring/Silent switch is set to silent
        for (NSNumber* textureId in _players) {
            [_registry unregisterTexture:[textureId unsignedIntegerValue]];
            [[_players objectForKey:textureId] dispose];
        }
        [_players removeAllObjects];

         NSLog(@"init : %@--------",_players);
         result(@(0));
    } else if ([@"startTask" isEqualToString:call.method]) {
            [_registry unregisterTexture:0];
            [_players removeObjectForKey:@(0)];
            [_player dispose];

        NSDictionary* argsMap = call.arguments;
        // FLTIJKFrameUpdater* frameUpdater
        _frameUpdater = [[FLTIJKFrameUpdater alloc] initWithRegistry:_registry];
        _dataSource = argsMap[@"url"];
        _player = [[FLTIJKVideoPlayer alloc] initWithURL:[NSURL URLWithString:_dataSource]
                                            frameUpdater:_frameUpdater];
        [_player play];

        result(@(0));
    }
     else if ([@"getImageFrame" isEqualToString:call.method]) {

         if(_player.isPlaying == false)
         {
            printf("player.isPlaying : false ... \n");
            result(@'4');
            return;
         }
        

         if((_player.myPlaybackState != IJKMPMoviePlaybackStatePlaying))
         {
             if((stop_flag == 0))
             {
                 return ;
             }
             if((_player.myPlaybackState == IJKMPMoviePlaybackStatePaused) && (flag == 4))
             {              
                 flag = 1;
                 stop_flag = 0;
                  return;
             }
              
 
            //   result (@'5');
             return;
         }
        else
        {
            // if(flag == 2)
            // {
            //         [_registry unregisterTexture:0];
            //         [_players removeObjectForKey:@(0)];
            //         [_player dispose];

            //         _frameUpdater = [[FLTIJKFrameUpdater alloc] initWithRegistry:_registry];
            //          // _dataSource = argsMap[@"url"];
            //         _player = [[FLTIJKVideoPlayer alloc] initWithURL:[NSURL URLWithString:_dataSource]
            //                                         frameUpdater:_frameUpdater]; 
            //     // [_player initWithURL:[NSURL URLWithString:_dataSource] frameUpdater:_frameUpdater];

            //     [_player play];

            //     flag = 0;
            //     stop_flag = 2;

            //     result(@(0));
            //     return;
            // }
        }
        CVPixelBufferRef pixelBuffer = [_player copyPixelBuffer];

         if(pixelBuffer == nil)
         {
             printf("pixelBuffer : null \n");
             CVPixelBufferRelease(pixelBuffer);
             result(@(6));
            return;
         }
        else
        {
                //  NSLog(@"imageData : %@ \n",pixelBuffer);
                CVPixelBufferRetain(pixelBuffer);
                CVPixelBufferLockBaseAddress(pixelBuffer, 0);
                void *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
                size_t width = CVPixelBufferGetWidth(pixelBuffer);
                size_t height = CVPixelBufferGetHeight(pixelBuffer);
                size_t bufferSize = CVPixelBufferGetDataSize(pixelBuffer);
                size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
                
                CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
                CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
                            //  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, 
                CGImageRef cgImage = CGImageCreate(width,height,8, 32,bytesPerRow,rgbColorSpace,kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host,provider, NULL,true,kCGRenderingIntentDefault);
                
                
                UIImage *image = [UIImage imageWithCGImage:cgImage];

                NSData * imageData = UIImagePNGRepresentation(image);
                //  NSData * imageData = UIImageJPEGRepresentation(image, 0.75);
                // image = [UIImage imageWithData:imageData];

                //   NSLog(@"imageData : %@ \n",imageData);
  
                CGImageRelease(cgImage);
                CGDataProviderRelease(provider);
                CGColorSpaceRelease(rgbColorSpace);

                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                CVPixelBufferRelease(pixelBuffer);
                
                result ? result(imageData) : 7;
                imageData = nil;
                image = nil;
                // return;

                // //Lock the imagebuffer
                // CVPixelBufferLockBaseAddress(pixelBuffer,0);
                // size_t width = CVPixelBufferGetWidth(pixelBuffer);
                // size_t height  = CVPixelBufferGetHeight(pixelBuffer);
                // // Get information about the image
                // uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
                // size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
                // CVPlanarPixelBufferInfo_YCbCrBiPlanar *bufferInfo = (CVPlanarPixelBufferInfo_YCbCrBiPlanar *)baseAddress;
                // // This just moved the pointer past the offset
                // baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
                // CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                // UIImage *image = [NSData makeUIImage:baseAddress bufferInfo:bufferInfo width:width height:height bytesPerRow:bytesPerRow];
                // // return image;
            // CGImageRef image;
            // CVPixelBufferRetain(pixelBuffer);

            // CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            // void *pxdata = CVPixelBufferGetBaseAddress(pixelBuffer);
            // NSParameterAssert(pixelBuffer != NULL);
            // size_t width = CVPixelBufferGetWidth(pixelBuffer);
            // size_t height = CVPixelBufferGetHeight(pixelBuffer);
            // CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

            // CGContextRef context = CGBitmapContextCreate(pixelBuffer, width,
            //         height, 8, 4 * width, rgbColorSpace,
            //         kCGImageAlphaNoneSkipFirst);
            // NSParameterAssert(context);
            // CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
            // CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
            //             CGImageGetHeight(image)), image);
            // CGColorSpaceRelease(rgbColorSpace);
            // CGContextRelease(context);

            // CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            // CVPixelBufferRelease(pixelBuffer);
            // result ? result(image) : 7;
                
        }
    }
    else if([@"stopTask" isEqualToString:call.method]){
            [_registry unregisterTexture:0];
            [_players removeObjectForKey:@(0)];
            [_player dispose];

        result(@(8));
    }
    else
    {
        // result(@(100));
        // result(FlutterMethodNotImplemented);
    }
}

@end



