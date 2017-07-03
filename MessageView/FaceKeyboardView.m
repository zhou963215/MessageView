//
//  FaceKeyboardView.m
//  MessageView
//
//  Created by zhou on 2017/6/29.
//  Copyright © 2017年 zhou. All rights reserved.
//

#import "FaceKeyboardView.h"


@interface FaceKeyboardView ()<UIScrollViewDelegate>
{
    
    NSArray *_faceMap;
    NSMutableArray *_faceArray;
    NSMutableDictionary *_faceData;
}


@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
//@property (strong, nonatomic) UIFacePreviewView *facePreviewView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *emojiButton;

@property (assign, nonatomic, readonly) NSUInteger maxPerLine;
@property (assign, nonatomic, readonly) NSUInteger maxLine;
@property (assign, nonatomic) NSUInteger facePage;

@property (nonatomic, strong)NSString *bundleName;
@property (nonatomic, strong)NSString *bundleFilePath;

@end


@implementation FaceKeyboardView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.bottomView];

        [self setupEmojiFaces];
    }
    return self;
}


- (void)setupEmojiFaces{
    self.backgroundColor = [UIColor colorWithRed:0.9355 green:0.9355 blue:0.9355 alpha:1.0];
    
    _faceMap = [[NSArray alloc]initWithObjects:@"😊",@"😨",@"😍",@"😳",@"😎",@"😭",@"😌",@"😵",@"😴",@"😢",@"😅",@"😡",@"😜",@"😀",@"😲",@"😟",@"😤",@"😞",@"😫",@"😣",@"😈",@"😉",@"😯",@"😕",@"😰",@"😋",@"😝",@"😓",@"😃",@"😂",@"😘",@"😒",@"😏",@"😶",@"😱",@"😖",@"😩",@"😔",@"😑",@"😚",@"😪",@"😇",@"🙊",@"👊",@"👎",@"☝️",@"✌️",@"😬",@"😷",@"🙈",@"👌",@"👏",@"✊",@"💪",@"😆",@"☺️",@"🙉",@"👍",@"🙏",@"✋",@"☀️",@"☕️",@"⛄",@"📚",@"🎁",@"🎉",@"🍦",@"☁️",@"❄️",@"⚡️",@"💰",@"🎂",@"🎓",@"🍖",@"☔️",@"⛅",@"✏️",@"💩",@"🎄",@"🍷",@"🎤",@"🏀",@"🀄",@"💣",@"📢",@"🌏",@"🍫",@"🎲",@"🏂",@"💡",@"💤",@"🚫",@"🌻",@"🍻",@"🎵",@"🏡",@"💢",@"📞",@"🚿",@"🍚",@"👪",@"👼",@"💊",@"🔫",@"🌹",@"🐶",@"💄",@"👫",@"👽",@"💋",@"🌙",@"🍉",@"🐷",@"💔",@"👻",@"👿",@"💍",@"🌲",@"🐴",@"👑",@"🔥",@"⭐",@"⚽",@"🕖",@"⏰",@"😁",@"🚀",@"⏳",nil];
    
    if (!_faceArray) {
        
        _faceArray = [[NSMutableArray alloc]init];
    }else{
        [_faceArray removeAllObjects];
    }
    [_faceArray addObjectsFromArray:_faceMap];
    
    //    for (int i = 0; i < _faceMap.count; i++) {
    //
    ////        NSMutableString *faceName = [[NSMutableString alloc]initWithFormat:@"%03d",i+1];
    //    }
    //
    NSInteger pageItemCount = (self.maxPerLine + 1) * self.maxLine - 1;
    
    NSUInteger pageCount = [_faceArray count] % pageItemCount == 0 ? [_faceArray count] / pageItemCount : ([_faceArray count] / pageItemCount) + 1;
    
    self.pageControl.numberOfPages = pageCount;
    
    for (int i = 0; i < pageCount; i++) {
        if (pageCount - 1 == i) {
            [_faceArray addObject:@"[删除]"];
        }else{
            [_faceArray insertObject:@"[删除]" atIndex:(i + 1) * pageItemCount + i];
        }
    }
    
    NSUInteger maxPerLine = self.maxPerLine;
    NSUInteger line = 0;
    NSUInteger column = 0;
    NSUInteger page = 0;
    CGFloat itemWidth = (self.scrollView.frame.size.width - 20) / (self.maxPerLine + 1);
    NSInteger deleteIndex = 0;
    for (int i = 0; i < _faceArray.count;i++) {
        NSString *faceImageName = _faceArray[i];
        if (column > maxPerLine) {
            line ++ ;
            column = 0;
        }
        if (line > 2) {
            line = 0;
            column = 0;
            page ++ ;
        }
        CGFloat startX = 10 + column * itemWidth + page * self.frame.size.width;
        CGFloat startY = line * itemWidth;
//        NSLog(@"%@",faceImageName);
        if ([faceImageName isEqualToString:@"[删除]"]) {
            deleteIndex++;
//            if (!self.bundleFilePath) {
//                self.bundleFilePath = [[NSBundle mainBundle] pathForResource:self.bundleName ofType:@"bundle"];
//            }
//            NSString *fileName = [self.bundleFilePath stringByAppendingPathComponent:@"DeleteEmoticonBtn_ios7@2x"];
//            UIImage *image = [UIImage imageWithContentsOfFile:fileName];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Delete"]];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 0;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.layer.masksToBounds=YES;
            //添加图片的点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tap];
            [imageView setFrame:CGRectMake(startX, startY, itemWidth, itemWidth)];
            [self.scrollView addSubview:imageView];
            
        }else{
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.userInteractionEnabled = YES;
            titleLabel.tag = i+1-deleteIndex;
            titleLabel.text = _faceArray[i];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:28];
            //添加图片的点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [titleLabel addGestureRecognizer:tap];
            [titleLabel setFrame:CGRectMake(startX, startY, itemWidth, itemWidth)];
            [self.scrollView addSubview:titleLabel];
        }
        
        column ++ ;
    }
    //重新配置下scrollView的contentSize
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * (page + 1), self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.facePage * self.frame.size.width, 0)];
    self.pageControl.currentPage = self.facePage;
    
    self.userInteractionEnabled = YES;
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [self.scrollView addGestureRecognizer:longPress];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    NSString *faceName = _faceArray[tap.view.tag];
    NSInteger i = tap.view.tag;
    if (i == 0) {
        faceName = @"[删除]";
    }else{
        faceName = [_faceMap objectAtIndex:i-1];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceViewSendFace:)]) {
        [self.delegate faceViewSendFace:faceName];
    }
    
//    if (self.delegate) {
//        
//        [self.delegate faceViewSendFace:faceName];
//        
//    }

    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pageControl setCurrentPage:scrollView.contentOffset.x / scrollView.frame.size.width];
    self.facePage = self.pageControl.currentPage;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 60)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, self.frame.size.width, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(clickPageController:event:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pageControl;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];       
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, 40)];
        sendButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255.0/255.0f alpha:1.0];

        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton addTarget:self action:@selector(sendWillDownAction:) forControlEvents:UIControlEventTouchDown];
        
        [_bottomView addSubview:self.sendButton = sendButton];
        
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundleFilePath= [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"];
        NSString *filePath = [bundleFilePath stringByAppendingPathComponent:@"ToolViewEmotion@2x"];
        [emojiButton setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        [_bottomView addSubview:self.emojiButton = emojiButton];
        [emojiButton setFrame:CGRectMake(5, 5,30, 30)];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 50, 30)];
        titleLabel.text = @"经典";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:0.6196 green:0.6196 blue:0.6196 alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:titleLabel];
    }
    return _bottomView;
}


//发送
- (void)sendAction:(UIButton *)sender{
    sender.backgroundColor =[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255.0/255.0f alpha:1.0];
    
    if (_delegate && [_delegate respondsToSelector:@selector(faceViewSendFace:)]) {
        [_delegate faceViewSendFace:@"发送"];
    }
}

- (void)sendWillDownAction:(UIButton *)sender{
    sender.backgroundColor = [UIColor whiteColor];
}


- (void)clickPageController:(UIPageControl *)pageController event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches] anyObject];
    CGPoint p = [touch locationInView:_pageControl];
    CGFloat centerX = pageController.center.x;
    CGFloat left = centerX-15.0*6/2;
    [_pageControl setCurrentPage:(int ) (p.x-left)/15];
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage*375, 0)];
//
//    NSLog(@"%f",(p.x-left)/15);
}
- (NSUInteger)maxPerLine{
    CGFloat screenWidth =  [UIScreen mainScreen].bounds.size.width;
    if (screenWidth == 320.0) {
        return 5;
    }
    return 7;
}

- (NSUInteger)maxLine{
    return 3;
}


@end
