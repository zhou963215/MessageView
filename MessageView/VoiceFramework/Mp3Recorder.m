//
//  Mp3Recorder.m
//  artExamAssistant
//
//  Created by Zanilia on 15/12/11.
//  Copyright © 2015年 北京知远信息科技有限公司. All rights reserved.
//

#import "Mp3Recorder.h"
#define ReordTimemMAX   60.0
#define XMAXVALUE_VOICE       40

@interface Mp3Recorder ()<AVAudioRecorderDelegate>
{
    AVAudioRecorder * _audioRecorder;  //  录音器
    AVAudioSession *_audioSession;
    NSDictionary *_settings;
    
    NSTimer * _recorderTimer;          //  录音计时器
    NSString* _lastRecordFile;         //  最后 录音的文件名字
    NSDate              *_recorderStartDate;
    NSDate              *_recorderEndDate;
    NSString *_pathURL;
    NSTimeInterval  _recordTime;

}
@end

@implementation Mp3Recorder

- (instancetype)init{
    if (self = [super init]) {
        _lastRecordFile = nil;
        _recordTime = 0;
        _isRecording = NO;
        _audioSession = [AVAudioSession sharedInstance];

        _settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                nil];
        [_audioSession setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [_audioSession setActive:YES error:nil];
        
    }
    return self;
}

- (void)startRecord{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    if(session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    [UIVoiceKeyboardView showVoiceHUD];
    
    if (_isRecording) {
        return;
    }
    _isRecording = YES;
    _recordTime = 0;

    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    NSString *recordPath = NSHomeDirectory();
    recordPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer/%@",recordPath,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [fm createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    NSString *wavFilePath = [[recordPath stringByDeletingPathExtension]
                             stringByAppendingPathExtension:@"wav"];
    _pathURL = wavFilePath;
    // ---- 基本设置 ----
    NSError *error;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_pathURL] settings:_settings error:&error];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;
    _recorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_updateTime) userInfo:nil repeats:YES];
    [_recorderTimer fire];
    [_audioRecorder prepareToRecord];
    [_audioRecorder peakPowerForChannel:0];
    [_audioRecorder record]; // 开始

}

- (void)stopRecord{
    [_audioRecorder stop];
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    _audioRecorder = nil;
    if (_recordTime<1) {
        [UIVoiceKeyboardView showFailVoiceHUD];
        _isRecording = NO;
        return;
    }
    [self finishedRecord];
    
}

- (void)cancelRecord{
    _isRecording = NO;
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    [_audioRecorder stop];
}

- (void)_updateTime{
    _recordTime+=0.02;
    if (_recordTime >= ReordTimemMAX) {
        [UIVoiceKeyboardView hideVoiceHUD];
        [_recorderTimer invalidate];
        _recorderTimer = nil;
        _isRecording = NO;
        [_audioRecorder stop];
        _audioRecorder = nil;
        [self finishedRecord];
        return;
    }
    [_audioRecorder updateMeters];
    float avg = [_audioRecorder averagePowerForChannel:0];
    float valueInfo = (XMAXVALUE_VOICE + avg)/XMAXVALUE_VOICE;
    
    [[UIVoiceKeyboardView shareVoiceView] setAveragePower:valueInfo andTimeLength:fabs(_recordTime)];
}

- (void)finishedRecord{
    if (_isRecording) {
        NSString *amrFilePath = [[_pathURL stringByDeletingPathExtension]
                                 stringByAppendingPathExtension:@"amr"];
        BOOL convertResult = [self convertWAV:_pathURL toAMR:amrFilePath];
        if (convertResult) {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:_pathURL error:nil];
            if (_didFinishRecorded) {
                _didFinishRecorded(amrFilePath, _recordTime);
            }
        }
    }
    _isRecording = NO;
}

- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [NSVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (!isFileExists) {
            
        } else {
            ret = YES;
        }
    }
    
    return ret;
}

@end
