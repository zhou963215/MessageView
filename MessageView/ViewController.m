//
//  ViewController.m
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "ViewController.h"
#import "MessageView.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<MessageViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MessageView * messageView;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      messageView = [[MessageView alloc]initWithSuperVC:self];
//    messageView.backgroundColor = [UIColor whiteColor];
    messageView.delegate = self;
    [self.view addSubview:messageView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    

    self.dataArray = [[NSMutableArray alloc]init];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [messageView endEdit];
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
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
        

    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = messageView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    messageView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.dataArray.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
//    
//            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    
    
    
}

#pragma mark - InputFunctionViewDelegate
- (void)MessageView:(MessageView *)funcView sendMessage:(NSString *)message
{
    NSLog(@"%@",message);
    
        
//    NSDictionary *dic = @{@"strContent": message,
//                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [self addObject:message];
//    [funcView changeSendBtnWithPhoto:YES];
    
//    [self dealTheFunctionData:dic];
}

- (void)MessageView:(MessageView *)funcView sendPicture:(UIImage *)image
{
//    NSDictionary *dic = @{@"picture": image,
//                          @"type": @(UUMessageTypePicture)};
//    [self dealTheFunctionData:dic];
    [self addObject:@"图片"];
}

- (void)MessageView:(MessageView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
//    NSDictionary *dic = @{@"voice": voice,
//                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
//                          @"type": @(UUMessageTypeVoice)};
//    [self dealTheFunctionData:dic];
    [self  addObject:@"语音"];

}

- (void)faceViewChange:(MessageView *)funcView{
    
    CGFloat h = Main_Screen_Height - funcView.frame.origin.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomConstraint.constant = h;
        [self.view layoutIfNeeded];

    }];
    
    
    
}

- (void)addObject:(NSString * )message{
    
    [self.dataArray addObject:message];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
