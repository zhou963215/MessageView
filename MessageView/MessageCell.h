//
//  MessageCell.h
//  MessageView
//
//  Created by zhou on 2017/7/11.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageContentButton.h"

@class MessageFrame;
@class MessageCell;


@protocol MessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(MessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(MessageCell *)cell image:(UIImage *)contentImage;
@end

@interface MessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)MessageContentButton *btnContent;

@property (nonatomic, retain)MessageFrame *messageFrame;

@property (nonatomic, assign)id<MessageCellDelegate>delegate;



@end
