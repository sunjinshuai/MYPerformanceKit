//
//  MYSoundService.m
//  MYUtils
//
//  Created by sunjinshuai on 2018/3/20.
//  Copyright © 2018年 com.51fanxing. All rights reserved.
//

#import "MYSoundService.h"
#import "MYVolumeManager.h"
#import "MYTeleponyManager.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MYSoundService () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfSoundNameId;
@property (nonatomic, strong) NSString *cacheSoundName;
@property (nonatomic, strong) NSString *cacheSoundType;
@property (nonatomic, strong) NSMutableArray<NSString *> *cacheSounds;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, assign) BOOL isInterrupt;

@end

@implementation MYSoundService

+ (instancetype)sharedInstance {
    static MYSoundService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MYSoundService alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        
        self.cacheSounds = [NSMutableArray array];
        self.canShake = YES;
        self.needCache = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playCacheSoundWhenApplicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(interrupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object: [AVAudioSession sharedInstance]];
    }
    return self;
}

- (void)playSoundWithName:(NSString *)soundName ofType:(NSString*)type {
    if ([[MYTeleponyManager sharedInstance] isConnected]) {
        [self shakeWhenPlaying];
        if (self.needCache == YES) {
            self.cacheSoundType = type;
            [self.cacheSounds addObject:soundName];
            return;
        }
    }
    if (self.isPlaying == YES) {
        if (self.needCache == YES) {
            self.cacheSoundType = type;
            [self.cacheSounds addObject:soundName];
        }
        return;
    }
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self setOutputWith: [AVAudioSession sharedInstance]];
    [[AVAudioSession sharedInstance]setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:type]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.delegate = self;
    [self setAudioPlayerVolume];
    [self.audioPlayer prepareToPlay];
    [self shakeWhenPlaying];
    [self.audioPlayer play];
}

// 控制扬声器输出还是默认
// https://developer.apple.com/library/content/qa/qa1754/_index.html
- (void)setOutputWith:(AVAudioSession *)session {
    if ([[MYVolumeManager shareInstance] isHeadsetPluggedIn]) {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    } else {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

// 控制声音大小
- (void)setAudioPlayerVolume {
    if ([[MYVolumeManager shareInstance] isHeadsetPluggedIn]) {
        self.audioPlayer.volume = [[MYVolumeManager shareInstance] getCurrentVolume];
    } else {
        self.audioPlayer.volume = [[MYVolumeManager shareInstance] volumeValue];
    }
}

// 控制播放时候震动
// 若无震动: https://www.zhihu.com/question/51285954?from=profile_question_card
- (void)shakeWhenPlaying {
    if (self.canShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

//回到前台以后检查时候需要播放缓存
- (void)playCacheSoundWhenApplicationDidBecomeActive {
    if (![[MYTeleponyManager sharedInstance] isConnected]) {
        [[MYSoundService sharedInstance] playCacheSound];
    }
}

//播放完成回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (flag && self.audioPlayer == player) {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
            NSLog(@"sound finish");
            NSError *error;
            [[AVAudioSession sharedInstance] setActive:NO
                                                 error:&error];
            if (error) {
                NSLog(@"%@",error.localizedDescription);
            }
            if (self.isPlaying) {
                self.isPlaying = NO;
                [self playCacheSound];
            }
        } else {
            self.isPlaying = NO;
        }
    });
}

- (void)openShake:(BOOL)canshake {
    self.canShake = canshake;
}

- (void)needCache:(BOOL)isNeed {
    self.needCache = isNeed;
}

- (void)playCacheSound {
    self.isPlaying = NO;
    NSArray *cache = [NSArray arrayWithArray: self.cacheSounds];
    for (NSString *soundName in cache) {
        [self.cacheSounds removeObjectAtIndex: 0];
        [self playSoundWithName:soundName ofType:self.cacheSoundType];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if (error) {
        // log
        [self playSoundWithName:self.cacheSoundName ofType:self.cacheSoundType];
    }
}

- (void)interrupted:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo) { return; }
    
    if ([[userInfo objectForKey:AVAudioSessionInterruptionTypeKey] isKindOfClass:[NSNumber class]]) {
        AVAudioSessionInterruptionType typeValue = [[userInfo objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
        if (typeValue == AVAudioSessionInterruptionTypeBegan) {
            self.isInterrupt = YES;
            if([self.audioPlayer isPlaying]) {
                [self.audioPlayer pause];
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"playing");
                if (![self.audioPlayer isPlaying]) {
                    [self.audioPlayer play];
                }
                self.isInterrupt = NO;
            });
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
