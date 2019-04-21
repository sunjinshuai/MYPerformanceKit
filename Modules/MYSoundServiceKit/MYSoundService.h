//
//  MYSoundService.h
//  MYUtils
//
//  Created by sunjinshuai on 2018/3/20.
//  Copyright © 2018年 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MYSoundService : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL canShake;

/**
 *  @brief play sound with file name. e.m sound.aiff
 */

- (void)playSoundWithName:(NSString *)soundName ofType:(NSString*)type;

/**
 *  @brief control the volume of AudioPlayer
 */

- (void)setAudioPlayerVolume;

/**
 *  @brief control the shake when play the sound
 */
- (void)openShake:(BOOL)canshake;

/**
 *  @brief control the cache sound
 */
- (void)needCache:(BOOL)isNeed;

@end
