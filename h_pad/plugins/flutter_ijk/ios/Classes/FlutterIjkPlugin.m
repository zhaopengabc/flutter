#import "FlutterIjkPlugin.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <libkern/OSAtomic.h>


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
    [options setFormatOptionIntValue:100*1000*1000 forKey:@"timeout"];
    [options setFormatOptionIntValue:10240 forKey:@"max-buffer-size"];
    [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
    [options setFormatOptionIntValue:100 forKey:@"analyzemaxduration"];
    [options setFormatOptionIntValue:10 forKey:@"analyzeduration"];
    [options setFormatOptionIntValue:10240 forKey:@"probesize"];
    [options setFormatOptionIntValue:1 forKey:@"flush_packets"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    [options setPlayerOptionIntValue:60 forKey:@"framedrop"];
    [options setPlayerOptionIntValue:1920    forKey:@"videotoolbox-max-frame-width"];

    

    
    [options setFormatOptionIntValue:100 forKey:@"reconnect"];

    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    [self removeMovieNotificationObservers];
    [self installMovieNotificationObservers];

    // [IJKFFMoviePlayerController setLogReport:YES];
    // [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
    if(![_player isPlaying]){
        [_player prepareToPlay];
    }


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
    // IJKMPMovieLoadState loadState = _player.loadState;
    
    // if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
    //     [self updatePlayingState];
    //     if (_eventSink != nil) {
    //         _eventSink(@{@"event" : @"bufferingEnd"});
    //     }
    // }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
    //     if (_eventSink != nil) {
    //         _eventSink(@{@"event" : @"bufferingStart"});
    //     }
    // } else {
    //     NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    // }
}


- (void)moviePlayBackFinish:(NSNotification*)notification {
    /*
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
    */
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    _isInitialized = true;
    // [self sendInitialized];
    [self updatePlayingState];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    _myPlaybackState = _player.playbackState;
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            stop_flag = 2;
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
           
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            if(flag == 1)
            {
                flag = 2;
            }
            stop_flag = 0;
            start_flag = 1;
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            flag = 4;
            stop_flag = 3;
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
    // _displayLink.paused = !_isPlaying;
}

- (void)play {
    _isPlaying = true;
    [self updatePlayingState];
}

- (void)pause {
    _isPlaying = false;

    [self updatePlayingState];
}


- (CVPixelBufferRef)copyPixelBuffer {

    [_player framePixelbufferLock];
    CVPixelBufferRef pixelBuffer = [_player framePixelbuffer];

    if(pixelBuffer != nil){
        // CFRetain(pixelBuffer);
    }
    else
    {
        return nil;
    }
    [_player framePixelbufferUnlock];
    return pixelBuffer;
    
}



- (void)dispose {
    _disposed = true;
    [self removeMovieNotificationObservers];
    if(_player != nil){
        [_player stop];
        [_player shutdown];
        _player = nil;
    }
}

@end

@interface FlutterIjkPlugin ()
@property(readonly, nonatomic) NSObject<FlutterTextureRegistry>* registry;
@property(readonly, nonatomic) NSObject<FlutterBinaryMessenger>* messenger;
@property(readonly, nonatomic) NSMutableDictionary* players;
@property(readonly, nonatomic) FLTIJKVideoPlayer* ijkPlayer;
@property(readonly, nonatomic) FLTIJKFrameUpdater* frameUpdater;
@property(readonly, nonatomic) NSString* dataSource;
@property(readonly, nonatomic) NSObject<FlutterPluginRegistrar>* registrar;
// - (void)networkChanged:(NSNotification *)notification;


// @synthesize remoteHostStatus;


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

   
    if ([@"init" isEqualToString:call.method]) {
        
        // Allow audio playback when the Ring/Silent switch is set to silent
        for (NSNumber* textureId in _players) {
            [_registry unregisterTexture:[textureId unsignedIntegerValue]];
            [[_players objectForKey:textureId] dispose];
        }
        [_players removeAllObjects];
        
         result(@(0));
         return;

    } else if ([@"startTask" isEqualToString:call.method]) {
        
        printf("start task .... \n");
            [_registry unregisterTexture:0];
            [_players removeObjectForKey:@(0)];
            [_ijkPlayer dispose];
        // printf("stop first .... \n");
        NSDictionary* argsMap = call.arguments;
        // FLTIJKFrameUpdater* frameUpdater
        _frameUpdater = [[FLTIJKFrameUpdater alloc] initWithRegistry:_registry];
        _dataSource = argsMap[@"url"];
        _ijkPlayer = [[FLTIJKVideoPlayer alloc] initWithURL:[NSURL URLWithString:_dataSource]
                                            frameUpdater:_frameUpdater];
        [_ijkPlayer play];
        
    result(@(0));
    }
     else if ([@"getImageFrame" isEqualToString:call.method]) {

    if((flag == 2) && (_ijkPlayer.myPlaybackState == IJKMPMoviePlaybackStatePlaying))
    {
        [_registry unregisterTexture:0];
        [_players removeObjectForKey:@(0)];
        [_ijkPlayer dispose];
        sleep(2);

        [_ijkPlayer initWithURL:[NSURL URLWithString:_dataSource] frameUpdater:_frameUpdater];
        [_ijkPlayer play];
        flag = 0;
        stop_flag = 0;
        result(nil);
        return;
    }
    
            
    if(((_ijkPlayer.myPlaybackState == IJKMPMoviePlaybackStateStopped)
              || ((_ijkPlayer.myPlaybackState == IJKMPMoviePlaybackStatePaused) && (start_flag == 0))) && (stop_flag != 0) )
    {
        flag = 0;
        stop_flag = 0;
        start_flag = 0;

        //  for (NSNumber* textureId in _players) {
        //     [_registry unregisterTexture:[textureId unsignedIntegerValue]];
        //     [[_players objectForKey:textureId] dispose];
        // }
        // [_players removeAllObjects];
        [_registry unregisterTexture:0];
        [_players removeObjectForKey:@(0)];
        [_ijkPlayer dispose];
        // _ijkPlayer = nil;
        sleep(1);

        [_ijkPlayer initWithURL:[NSURL URLWithString:_dataSource] frameUpdater:_frameUpdater];
        [_ijkPlayer play];
        _ijkPlayer.myPlaybackState = IJKMPMoviePlaybackStatePlaying;
        result(nil);

        return;
    }

         if(_ijkPlayer.isPlaying == false)
         {
            printf("player.isPlaying : false ... \n");
            result(nil);
            return;
         }
        

         if((_ijkPlayer.myPlaybackState != IJKMPMoviePlaybackStatePlaying))
         {
             if((stop_flag == 0))
             {
                 return ;
             }
             if((_ijkPlayer.myPlaybackState == IJKMPMoviePlaybackStatePaused) && (flag == 4))
             {              
                 flag = 1;
                 stop_flag = 0;
                  return;
             }
              
 
            result (@(0));
             return;
         }

        CVPixelBufferRef pixelBuffer = [_ijkPlayer copyPixelBuffer];
         if(pixelBuffer == nil)
         {
            //  printf("pixel buffer is null ... \n");
            //  CVPixelBufferRelease(pixelBuffer);
             result(nil);
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
                CGImageRef cgImage = CGImageCreate(width,height,8, 32,bytesPerRow,rgbColorSpace,kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host,provider, NULL,true,kCGRenderingIntentDefault);
                
                
                UIImage *image = [UIImage imageWithCGImage:cgImage];

                NSData * imageData = UIImagePNGRepresentation(image);
  

                
                result ? result(imageData) : nil;
                // result(nil);
                imageData = nil;
                image = nil;
                CGImageRelease(cgImage);
                CGDataProviderRelease(provider);
                CGColorSpaceRelease(rgbColorSpace);

                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                CVPixelBufferRelease(pixelBuffer);
                return;                
        }
        
    }
    else if([@"stopTask" isEqualToString:call.method]){


        for (NSNumber* textureId in _players) {
            [_registry unregisterTexture:[textureId unsignedIntegerValue]];
            [[_players objectForKey:textureId] dispose];
        }

        [_players removeAllObjects];
            [_registry unregisterTexture:0];
            [_players removeObjectForKey:@(0)];
            [_ijkPlayer dispose];
            

        result(@(0));
    }
    else
    {
        // result(@(100));
        // result(FlutterMethodNotImplemented);
    }
    
    result(nil);

}

@end



