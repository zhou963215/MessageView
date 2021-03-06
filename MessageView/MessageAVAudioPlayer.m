//
//  MessageAVAudioPlayer.m
//  MessageView
//
//  Created by zhou on 2017/7/11.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "MessageAVAudioPlayer.h"

@interface MessageAVAudioPlayer ()<AVAudioPlayerDelegate>

@end

@implementation MessageAVAudioPlayer
+ (MessageAVAudioPlayer *)sharedInstance
{
    static MessageAVAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    
    dispatch_async(dispatch_queue_create("playSoundFromUrl", NULL), ^{
        [self.delegate MMAVAudioPlayerBeiginLoadVoice];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSoundWithData:data];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}

-(void)playSoundWithData:(NSData *)soundData{
    if (_player) {
        [_player stop];
        _player.delegate = nil;
        _player = nil;
    }
    NSError *playerError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];
    _player.volume = 1.0f;
    if (_player == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    _player.delegate = self;
    [_player play];
    [self.delegate MMAVAudioPlayerBeiginPlay];

}

-(void)setupPlaySound{
    UIApplication * app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate MMAVAudioPlayerDidFinishPlay];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    
    
}
- (void)stopSound
{
    if (_player && _player.isPlaying) {
        [_player stop];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [self.delegate MMAVAudioPlayerDidFinishPlay];
}

@end
