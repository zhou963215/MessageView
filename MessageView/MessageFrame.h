//
//  MessageFrame.h
//  MessageView
//
//  Created by zhou on 2017/7/10.
//  Copyright © 2017年 zhou. All rights reserved.
//


#define ChatMargin 10       //间隔
#define ChatIconWH 50       //头像宽高height、width
#define ChatPicWH 200       //图片宽高
#define ChatContentW 180    //内容宽度

#define ChatTimeMarginW 15  //时间文本与边框间隔宽度方向
#define ChatTimeMarginH 10  //时间文本与边框间隔高度方向

#define ChatContentTop 10   //文本内容与按钮上边缘间隔
#define ChatContentLeft 20  //文本内容与按钮左边缘间隔
#define ChatContentBottom 10 //文本内容与按钮下边缘间隔
#define ChatContentRight 10 //文本内容与按钮右边缘间隔

#define ChatTimeFont [UIFont systemFontOfSize:11]   //时间字体
#define ChatContentFont [UIFont systemFontOfSize:14]//内容字体

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class MessageModel;
@interface MessageFrame : NSObject
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect iconF;
@property (nonatomic, assign, readonly) CGRect timeF;
@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) MessageModel *message;
@property (nonatomic, assign) BOOL showTime;



@end
