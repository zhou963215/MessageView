//
//  FaceKeyboardView.h
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FaceKeyboardViewDelegate <NSObject>

- (void)faceViewSendFace:(NSString *)faceName;
@end
@interface FaceKeyboardView : UIView
@property (nonatomic) id<FaceKeyboardViewDelegate> delegate;

@end
