//
//  UIVoiceKeyboardView.h
//  Baseframework
//
//  Created by Zanilia on 16/8/15.
//

#import <UIKit/UIKit.h>

@interface UIVoiceKeyboardView : UIView

//The volume average volatility
@property (nonatomic, assign) float averagePower;

//The recording time
@property (nonatomic, assign) NSTimeInterval timeLength;


//Initialize a unique view of the volume fluctuations
+ (instancetype)shareVoiceView;

//According to the volume fluctuations view
+ (void)showVoiceHUD;

//According to cancel sending
+ (void)showCancelSendVoiceHUD;

//According to the recording failure
+ (void)showFailVoiceHUD;

//To hide or delete the volume fluctuations
+ (void)hideVoiceHUD;

//Set the volume fluctuations and recording time, need the fluctuations of the mean and the recording time
- (void)setAveragePower:(float)averagePower andTimeLength:(NSTimeInterval)timeLenth;
@end
