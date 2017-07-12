//
//  MessageAVAudioPlayer.h
//  MessageView
//
//  Created by zhou on 2017/7/11.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol MMAVAudioPlayerDelegate <NSObject>

- (void)MMAVAudioPlayerBeiginLoadVoice;
- (void)MMAVAudioPlayerBeiginPlay;
- (void)MMAVAudioPlayerDidFinishPlay;

@end

@interface MessageAVAudioPlayer : NSObject

@property (nonatomic ,strong)  AVAudioPlayer *player;
@property (nonatomic, assign)id <MMAVAudioPlayerDelegate>delegate;
+ (MessageAVAudioPlayer *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
