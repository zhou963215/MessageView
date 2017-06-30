//
//  UIVoiceKeyboardView.m
//  iFans
//
//  Created by Zanilia on 16/8/15.
//  Copyright © 2016年 王宾. All rights reserved.
//

#import "UIVoiceKeyboardView.h"

#define HUD_WIDTH       130
#define HUD_HEIGHT      130


@interface UIVoiceKeyboardView ()
{
    UIImageView *voiceImage;
    UIImageView *soundImage;
    UILabel * titleLabel;
    UILabel * timeLabel;
}

@property (nonatomic, strong) UIView *superView;

@end

@implementation UIVoiceKeyboardView
+ (instancetype)shareVoiceView
{
    static UIVoiceKeyboardView *voiceView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        voiceView = [[UIVoiceKeyboardView alloc]initWithFrame:CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT)];
        [voiceView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.75]];
        voiceView.alpha = 0.7;
        voiceView.layer.cornerRadius = 10;
        voiceView.layer.masksToBounds = YES;
        voiceView.hidden = YES;
    });
    return voiceView;
}

+ (void)showVoiceHUD{
    
    UIView *window =  [[[UIApplication sharedApplication] delegate] window];
    NSString *bundleFilePath= [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];

    UIVoiceKeyboardView *voiceHud = [UIVoiceKeyboardView shareVoiceView];
    [voiceHud hideHUD];
    voiceHud->voiceImage = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingBkg@3x.png"]]];
    voiceHud->voiceImage.frame = CGRectMake(20, 20, 40, 80);
    voiceHud->voiceImage.alpha = 1.0;
    [voiceHud addSubview:voiceHud->voiceImage];
    
    voiceHud->timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(HUD_WIDTH - 35, 5, 30, 15)];
    voiceHud->timeLabel.text = @"0 \"";
    voiceHud->timeLabel.textAlignment = NSTextAlignmentCenter;
    voiceHud->timeLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    voiceHud->timeLabel.backgroundColor = [UIColor clearColor];
    voiceHud->timeLabel.textColor = [UIColor whiteColor];
    [voiceHud addSubview:voiceHud->timeLabel];
    
    voiceHud->soundImage = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal001@3x.png"]]];
    voiceHud->soundImage.frame = CGRectMake(HUD_WIDTH-65, 27.5, 35, 70);
    [voiceHud addSubview:voiceHud->soundImage];
    
    voiceHud->titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, HUD_WIDTH-20, 18)];
    voiceHud->titleLabel.text = @"上滑，取消发送";
    voiceHud->titleLabel.textAlignment = NSTextAlignmentCenter;
    voiceHud->titleLabel.font = [UIFont boldSystemFontOfSize:12];
    voiceHud->titleLabel.backgroundColor = [UIColor clearColor];
    voiceHud->titleLabel.textColor = [UIColor whiteColor];
    [voiceHud addSubview:voiceHud->titleLabel];
    
    voiceHud.hidden = NO;
    voiceHud.center = window.center;
    voiceHud.superView = window;
    [window addSubview:voiceHud];
}

+ (void)showCancelSendVoiceHUD
{
    UIView *window =  [[[UIApplication sharedApplication] delegate] window];
    UIVoiceKeyboardView *voiceHud = [UIVoiceKeyboardView shareVoiceView];
    [voiceHud hideHUD];
    NSString *bundleFilePath= [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];
    voiceHud->voiceImage = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordCancel@3x.png"]]];
    voiceHud->voiceImage.frame = CGRectMake((HUD_WIDTH - 65)*0.5,(HUD_HEIGHT - 65)*0.5-5, 65, 65);
    [voiceHud addSubview:voiceHud->voiceImage];
    
    voiceHud->titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, HUD_WIDTH-20, 18)];
    voiceHud->titleLabel.text = @"松开 取消发送";
    voiceHud->titleLabel.textAlignment = NSTextAlignmentCenter;
    voiceHud->titleLabel.font = [UIFont boldSystemFontOfSize:12];
    voiceHud->titleLabel.layer.cornerRadius = 5.0;
    voiceHud->titleLabel.layer.masksToBounds = YES;
    voiceHud->titleLabel.backgroundColor = [UIColor redColor];
    voiceHud->titleLabel.textColor = [UIColor whiteColor];
    [voiceHud addSubview:voiceHud->titleLabel];
    
    voiceHud.hidden = NO;
    voiceHud.center = window.center;
    voiceHud.superView = window;
    [window addSubview:voiceHud];
}

+ (void)showFailVoiceHUD
{
    UIView *window =  [[[UIApplication sharedApplication] delegate] window];
    UIVoiceKeyboardView *voiceHud = [UIVoiceKeyboardView shareVoiceView];
    [voiceHud hideHUD];
    NSString *bundleFilePath= [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];
    voiceHud->voiceImage = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordCancel@3x.png"]]];
    voiceHud->voiceImage.frame = CGRectMake((HUD_WIDTH - 65)*0.5,(HUD_HEIGHT - 65)*0.5-5, 65, 65);
    [voiceHud addSubview:voiceHud->voiceImage];
    
    voiceHud->titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, HUD_WIDTH-20, 18)];
    voiceHud->titleLabel.text = @"说话时间太短了";
    voiceHud->titleLabel.textAlignment = NSTextAlignmentCenter;
    voiceHud->titleLabel.font = [UIFont boldSystemFontOfSize:12];
    voiceHud->titleLabel.numberOfLines = 0;
    voiceHud->titleLabel.adjustsFontSizeToFitWidth = YES;
    voiceHud->titleLabel.backgroundColor = [UIColor clearColor];
    voiceHud->titleLabel.textColor = [UIColor whiteColor];
    [voiceHud addSubview:voiceHud->titleLabel];
    
    voiceHud.hidden = NO;
    voiceHud.center = window.center;
    voiceHud.superView = window;
    [window addSubview:voiceHud];
    
    [voiceHud performSelector:@selector(hideHUD) withObject:voiceHud afterDelay:1];
}

+(void) hideVoiceHUD{
    
    UIVoiceKeyboardView *voiceHud = [UIVoiceKeyboardView shareVoiceView];
    [voiceHud hideHUD];
}

- (void)setAveragePower:(float)averagePower andTimeLength:(NSTimeInterval)timeLenth
{
    _timeLength = timeLenth;
    NSString *bundleFilePath= [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];

    self->timeLabel.text = [NSString stringWithFormat:@"%d \"",(int)_timeLength];
    _averagePower = averagePower;
    if (0<_averagePower<=0.15)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal001@3x.png"]]];
    }else if (0.15<_averagePower<=0.30)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal002@3x.png"]]];
    }else if (0.30<_averagePower<=0.45)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal003@3x.png"]]];
    }else if (0.45<_averagePower<=0.60)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal004@3x.png"]]];
    }else if (0.60<_averagePower<=0.75)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal005@3x.png"]]];
    }else if(0.75<_averagePower<=0.875)
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal006@3x.png"]]];
    }else
    {
        [soundImage setImage:[UIImage imageWithContentsOfFile:[bundleFilePath stringByAppendingPathComponent:@"recordingSignal007@3x.png"]]];
    }
}

- (void)hideHUD
{
    [self removeFromSuperview];
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    self.hidden = YES;
}


@end
