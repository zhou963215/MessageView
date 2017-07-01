//
//  MessageView.m
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "MessageView.h"
#import "FaceKeyboardView.h"
#import "UIVoiceKeyboardView.h"
#import "Mp3Recorder.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

#define KeyboardOtherViewHeight     210.f

@interface MessageView ()<UITextViewDelegate,FaceKeyboardViewDelegate>

{
    BOOL isbeginVoiceRecord;
    BOOL isFaceView;
    UILabel *placeHold;

}
@property (strong, nonatomic) NSString *inputText;
@property (strong, nonatomic) Mp3Recorder *mp3Recorder;

@property (strong, nonatomic) FaceKeyboardView * faceView;

@end

@implementation MessageView




- (instancetype)initWithSuperVC:(UIViewController *)superVC{
    
    
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];

    if (self) {
        
        
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];
        
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(45, 5, Main_Screen_Width-3*45, 30);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [self.btnVoiceRecord setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        
        [self.btnVoiceRecord setTitle:@"按住  说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"松开  结束" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-3*45, 30)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.font = [UIFont systemFontOfSize:15];
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        
        self.faceViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.faceViewBtn.frame = CGRectMake(Main_Screen_Width-80, 5 , 30, 30);
        [self.faceViewBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateNormal];
        [self.faceViewBtn setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateSelected];
        [self.faceViewBtn addTarget:self action:@selector(faceClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.faceViewBtn];
        //输入框的提示语
        placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 200, 30)];
        placeHold.text = @" 说点什么吧 ";
        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    
    return self;
}

- (Mp3Recorder *)mp3Recorder{
    
    if (!_mp3Recorder) {
        
        _mp3Recorder = [[Mp3Recorder alloc]init];
    }
    
    return _mp3Recorder;
}
//表情界面
- (void)faceClick:(UIButton *)button{
    
    button.selected  = !button.selected;
    [self.TextViewInput resignFirstResponder];
    self.TextViewInput.hidden = NO;
    self.btnVoiceRecord.hidden = YES;
    isbeginVoiceRecord = NO;
      [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
    [self showFaceView:button.selected];
    
}


- (void)showFaceView:(BOOL)show{

    if (show) {
        
        isFaceView = YES;
        [self.superview addSubview:self.faceView];
        [UIView animateWithDuration:.25 animations:^{
            [self setFrame:CGRectMake(0, Main_Screen_Height- KeyboardOtherViewHeight - 40, Main_Screen_Width, 40)];
            [self.faceView setFrame:CGRectMake(0, Main_Screen_Height - KeyboardOtherViewHeight, self.frame.size.width, KeyboardOtherViewHeight)];
        } completion:nil];
    }else{
        
        isFaceView = NO;
        [self.TextViewInput becomeFirstResponder];
        [UIView animateWithDuration:.25 animations:^{
            
//            [self setFrame:CGRectMake(0, Main_Screen_Height - 40, Main_Screen_Width, 40)];
            
            [self.faceView setFrame:CGRectMake(0, Main_Screen_Height, self.frame.size.width, KeyboardOtherViewHeight)];
        } completion:^(BOOL finished) {
            [self.faceView removeFromSuperview];
        }];
    }

}

- (UIView *)faceView{
    
    if (!_faceView) {
        
        _faceView = [[FaceKeyboardView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, self.frame.size.width,KeyboardOtherViewHeight)];
        _faceView.delegate = self;
//        _faceView.backgroundColor = [UIColor redColor];
    }
    
    
    return _faceView;
}


#pragma mark - 表情获取


- (void)faceViewSendFace:(NSString *)faceName{
    
    
    placeHold.hidden = self.TextViewInput.text.length > 0;

    
    if ([faceName isEqualToString:@"[删除]"]) {
        NSString * newStr = @"";
        NSLog(@"%lu",(unsigned long)self.TextViewInput.text.length);
        NSString *text = self.TextViewInput.text;
        if (text.length>0) {
            
            if (text.length >3) {
                if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                    newStr=[text substringToIndex:text.length-1];
                }else if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                    newStr=[text substringToIndex:text.length-2];
                }else if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                    newStr=[text substringToIndex:text.length-3];
                }else  if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-4]]) {
                    newStr=[text substringToIndex:text.length-4];
                }else{
                    newStr=[text substringToIndex:text.length-1];
                }
                
            }else if (text.length >2) {
                
                if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                    newStr=[text substringToIndex:text.length-1];
                }else if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                    newStr=[text substringToIndex:text.length-2];
                }else if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                    newStr=[text substringToIndex:text.length-3];
                }else{
                    newStr=[text substringToIndex:text.length-1];
                }
            }else   if (text.length >1) {
                if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                    newStr=[text substringToIndex:text.length-1];
                }else if ([MessageView stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                    newStr=[text substringToIndex:text.length-2];
                }else{
                    newStr=[text substringToIndex:text.length-1];
                }
                
            }else {
                
                
                
            }
            
        }
        self.TextViewInput.text = newStr;
        [self textViewDidChange:self.TextViewInput];
    }else if ([faceName isEqualToString:@"发送"]){
        NSString *text = self.TextViewInput.text;
        if (!text || text.length == 0) {
            return;
        }
        self.inputText = @"";
        self.TextViewInput.text = @"";
        [self textViewDidChange:self.TextViewInput];
        if (self.delegate && [self.delegate respondsToSelector:@selector(MessageView:sendMessage:)]) {
            [self.delegate MessageView:self sendMessage:text];
        }
        
    }else{
        self.TextViewInput.text = [self.TextViewInput.text stringByAppendingString:faceName];
        [self textViewDidChange:self.TextViewInput];
    }
    self.inputText = self.TextViewInput.text;
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{


    [UIVoiceKeyboardView showVoiceHUD];
    [self.mp3Recorder startRecord];
    __block MessageView *wealSelf = self;

    [_mp3Recorder setDidFinishRecorded:^(NSString *filePath, NSTimeInterval time){
       
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        if (wealSelf.delegate && [wealSelf.delegate respondsToSelector:@selector(MessageView:sendVoice:time:)]) {
            
            [wealSelf.delegate MessageView:wealSelf sendVoice:data time: time];
        }
        
        
    }];
}

//
- (void)endRecordVoice:(UIButton *)button
{

    [UIVoiceKeyboardView hideVoiceHUD];
    [_mp3Recorder stopRecord];


}

- (void)cancelRecordVoice:(UIButton *)button
{

    [UIVoiceKeyboardView hideVoiceHUD];
    [_mp3Recorder stopRecord];
    _mp3Recorder.didFinishRecorded = nil;

}

- (void)RemindDragExit:(UIButton *)button
{
    [UIVoiceKeyboardView showCancelSendVoiceHUD];
    _mp3Recorder.didFinishRecorded = nil;

}

- (void)RemindDragEnter:(UIButton *)button
{
    [UIVoiceKeyboardView showVoiceHUD];
    __block MessageView *wealSelf = self;
    
    [_mp3Recorder setDidFinishRecorded:^(NSString *filePath, NSTimeInterval time){
        
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        if (wealSelf.delegate && [wealSelf.delegate respondsToSelector:@selector(MessageView:sendVoice:time:)]) {
            
            [wealSelf.delegate MessageView:wealSelf sendVoice:data time: time];
        }
        
        
    }];
}





//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    if (isFaceView) {
        
        [self showFaceView:NO];
        self.faceViewBtn.selected = NO;
        
    }
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }
    
    
    
}

//选择图片

- (void)sendMessage:(UIButton *)sender
{

        [self.TextViewInput resignFirstResponder];
    
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册",nil];
        [actionSheet showInView:self.window];
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
    
    if (isFaceView) {
        self.faceViewBtn.selected = NO;
        [self showFaceView:NO];
 
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    placeHold.hidden = textView.text.length>0;
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
//        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate MessageView:self sendMessage:self.TextViewInput.text];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate MessageView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//判断是否是 emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}



- (void)endEdit{
    
    if (isFaceView) {
        
        
        [UIView animateWithDuration:.25 animations:^{
            
            [self setFrame:CGRectMake(0, Main_Screen_Height - 40, Main_Screen_Width, 40)];
            
            [self.faceView setFrame:CGRectMake(0, Main_Screen_Height, self.frame.size.width, KeyboardOtherViewHeight)];
        } completion:^(BOOL finished) {
            [self.faceView removeFromSuperview];
            self.faceViewBtn.selected = NO;
        }];

        
        
    }else{
        
        [self.TextViewInput resignFirstResponder];
    }
    
    
}

@end
