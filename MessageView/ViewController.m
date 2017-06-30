//
//  ViewController.m
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "ViewController.h"
#import "MessageView.h"
@interface ViewController ()<MessageViewDelegate>
{
    MessageView * messageView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      messageView = [[MessageView alloc]initWithSuperVC:self];
    
    messageView.delegate = self;
    [self.view addSubview:messageView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
//        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = messageView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    messageView.frame = newFrame;
    
    [UIView commitAnimations];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [messageView endEdit];
    
//    [self.view endEditing:YES];
    
}
#pragma mark - InputFunctionViewDelegate
- (void)MessageView:(MessageView *)funcView sendMessage:(NSString *)message
{
    NSLog(@"%@",message);
    
        
//    NSDictionary *dic = @{@"strContent": message,
//                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
//    [funcView changeSendBtnWithPhoto:YES];
    
//    [self dealTheFunctionData:dic];
}

- (void)MessageView:(MessageView *)funcView sendPicture:(UIImage *)image
{
//    NSDictionary *dic = @{@"picture": image,
//                          @"type": @(UUMessageTypePicture)};
//    [self dealTheFunctionData:dic];
}

- (void)MessageView:(MessageView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
//    NSDictionary *dic = @{@"voice": voice,
//                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
//                          @"type": @(UUMessageTypeVoice)};
//    [self dealTheFunctionData:dic];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
