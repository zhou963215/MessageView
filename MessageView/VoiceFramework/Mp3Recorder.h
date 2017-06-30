//
//  Mp3Recorder.h
//  artExamAssistant
//
//  Created by Zanilia on 15/12/11.
//  Copyright © 2015年 北京知远信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UIVoiceKeyboardView.h"
#import "NSVoiceConverter.h"

@interface Mp3Recorder : NSObject

@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong)void (^ didFinishRecorded)(NSString *filePath, NSTimeInterval time);

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
