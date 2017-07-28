//
//  ViewController.m
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "ViewController.h"
#import "MessageView.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "MessageFrame.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<MessageViewDelegate,MessageCellDelegate,UITableViewDelegate,UITableViewDataSource>
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
    self.dataArray = [[NSMutableArray alloc]init];

    [self creatData];
      messageView = [[MessageView alloc]initWithSuperVC:self];
//    messageView.backgroundColor = [UIColor whiteColor];
    messageView.delegate = self;
    [self.view addSubview:messageView];
    
//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//
//    BOOL res3 = [(id)[MessageView class] isKindOfClass:[MessageView class]];
//    BOOL res4 = [(id)[MessageView class] isMemberOfClass:[MessageView class]];
//
//    NSLog(@"1--%d--2--%d--3--%d--4--%d",res1,res2,res3,res4);
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];

    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"cell"];
    [self tableViewScrollToBottom];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataArray[indexPath.row] cellHeight];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.delegate = self;
    [cell setMessageFrame:self.dataArray[indexPath.row]];
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
    
    
}

#pragma mark - InputFunctionViewDelegate
//文字消息

- (void)MessageView:(MessageView *)funcView sendMessage:(NSString *)message
{
    NSLog(@"%@",message);
    
    
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(MessageTypeText)};
    funcView.TextViewInput.text = @"";
    [self addObject:dic];

}

//图片消息

- (void)MessageView:(MessageView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(MessageTypePicture)};
    [self addObject:dic];
}
//语音消息
- (void)MessageView:(MessageView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(MessageTypeVoice)};
    [self  addObject:dic];

}

//更改聊天视图表单高度
- (void)faceViewChange:(MessageView *)funcView{
    
    CGFloat h = Main_Screen_Height - funcView.frame.origin.y;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomConstraint.constant = h;

        [self.view layoutIfNeeded];
        [self tableViewScrollToBottom];

    }];
    
    
    
}
static NSString * previousTime = nil;

- (void)addObject:(NSDictionary * )dic{
    

    MessageFrame *messageFrame = [[MessageFrame alloc]init];
    MessageModel * message = [[MessageModel alloc]init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    [dataDic setObject:@(MessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"Hello,Sister" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataArray addObject:messageFrame];

//    
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
    
}
//static int dateNum = 10;

- (void)creatData{
    
    
    NSString *time1 = @"2017-06-23 12:18";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:time1];
    
    
    for (int i = 0 ; i < 5 ; i ++) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc]init];
        MessageModel * message = [[MessageModel alloc]init];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(MessageTypeText),@"strContent" : [self getRandomString]}];
        
        NSString *URLStr = @"http://cdn.duitang.com/uploads/item/201211/24/20121124074205_5LPfy.jpeg";
        [dataDic setObject:@(MessageFromOther) forKey:@"from"];
//        NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
        [dataDic setObject:[date description] forKey:@"strTime"];
        [dataDic setObject:@"狗蛋" forKey:@"strName"];
        [dataDic setObject:URLStr forKey:@"strIcon"];
      
        [message setWithDict:dataDic];
        
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [self.dataArray addObject:messageFrame];

        
        
    }
    
    [self.tableView reloadData];
    
    
}
- (NSString *)getRandomString {
    
    NSString *lorumIpsum = @"我的志愿是做一个工程师,每天会做很多工程,下班后,我倒超级超市,买一大瓶可乐,一包卤水蛋,还有一包火腿,因为,减价啊!我的志愿是做一个消防队长,每天,我会扑灭很多火,下班后,我和我的队员小强,小明,芙蓉姐他们一起吃个套餐,有虾有鱼,还有可以选择冬瓜蛊代替例汤,可是要加三十元";
    
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@","];
    
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(12, r);
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@","]];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(MessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"头像点击" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
