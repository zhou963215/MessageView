//
//  MessageView.h
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageView;

@protocol MessageViewDelegate <NSObject>

// 文字
- (void)MessageView:(MessageView *)funcView sendMessage:(NSString *)message;

// 图片
- (void)MessageView:(MessageView *)funcView sendPicture:(UIImage *)image;

// 音频
- (void)MessageView:(MessageView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;
//表情视图变更约束
- (void)faceViewChange:(MessageView *)funcView;

@end

@interface MessageView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, retain) UIButton * faceViewBtn;
@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *TextViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) UIViewController *superVC;

@property (nonatomic, assign) id<MessageViewDelegate>delegate;

- (id)initWithSuperVC:(UIViewController *)superVC;
- (void)endEdit;

@end
