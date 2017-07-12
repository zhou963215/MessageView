//
//  MessageModel.h
//  MessageView
//
//  Created by zhou on 2017/7/10.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , MessageType){
  
    MessageTypeText     = 0 , // 文字
    MessageTypePicture  = 1 , // 图片
    MessageTypeVoice    = 2   // 语音
    
    
};

typedef NS_ENUM(NSInteger, MessageFrom) {
    MessageFromMe    = 0,   // 自己发的
    MessageFromOther = 1    // 别人发得
};


@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;

@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;

@property (nonatomic, assign) BOOL showDateLabel;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;




@end
