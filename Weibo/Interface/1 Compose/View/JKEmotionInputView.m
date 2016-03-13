//
//  JKEmotionInputView.m
//  Weibo
//
//  Created by HiJack on 16/3/5.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKEmotionInputView.h"
#import <YYKit/YYKit.h>
#import "JKStatusHelper.h"
#import "JKStatusModel.h"
#import "FullyHorizontalFlowLayout.h" // 调整表情布局顺序

// 高度
#define kViewHeight 216  // emotionInputView总高度
#define kEmotionTableHeight 37 // table高度
#define kEmotionCollectionViewHeight kOneEmoticonHeight * 3 // 表情scrollView高度
#define kOneEmoticonHeight 50.0 // 单个表情高度




#define kEmotionTableColumnCount 3  // 表情组数

#define kEmotionCollectionViewSidePadding 5.0                          // scrollView左右留白
#define kOneEmoticonWidth (kScreenWidth - kEmotionCollectionViewSidePadding *2) / kOnePageColumnCount // 单个表情宽度
#define kOnePageCount 20                                          // 单页表情总数
#define kOnePageColumnCount 7.0                                     // 单页表情列数
#define kOnePageRowCount  ceil(kOnePageCount / kOnePageColumnCount) // 单页表情行数

// 字体
#define kComposeTextFont 




@interface JKEmotionCollectionCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) JKEmotion *emotion;
@end

@implementation JKEmotionCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.imageView = imageView;
    return self;
    
    
}

- (void)layoutSubviews
{
    self.imageView.size = CGSizeMake(32, 32);
    self.imageView.center = CGPointMake(self.width / 2, self.height /2);
    
}

- (void)setEmotion:(JKEmotion *)emotion
{
    _emotion = emotion;
    
    if (self.isDelete) { // 删除按钮
        [self.imageView setImage:[JKStatusHelper imageNamed:@"compose_emotion_delete"] ];
    } else { // 表情
       
    
        if (emotion.type == JKEmotionGroupEmoji) { // emoji表情
            
            UIImage *emojiImage = [UIImage imageWithEmoji:emotion.code size:self.imageView.width];
            [self.imageView setImage:emojiImage];
        } else if(emotion.type == JKEmotionGroupImage && emotion.png.length) { // 图片表情
            [self.imageView setImage:[JKStatusHelper imageWithPath:emotion.png]];
        } else if(emotion.type == JKEmotionGroupImage ) {
            [self.imageView setImage:[JKStatusHelper imageNamed:@"compose_emoticonbutton_background"]];
        } else {
        self.imageView.image = nil;
        }

    }
}
@end




@interface JKEmotionCollectionView : UICollectionView
@end

@implementation JKEmotionCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    return self;
    
}
@end



@protocol JKEmotionTableDelegate <NSObject>
- (void)selectedEmotionTableButton:(UIButton *)button;
@end

@interface JKEmotionTable : UIView
@property (nonatomic, weak) id<JKEmotionTableDelegate> delegate;
@property (nonatomic, strong) UIButton *selectedButton;
@end
@implementation JKEmotionTable
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kEmotionTableHeight;
        frame.origin.x = 0;
        frame.origin.y = kViewHeight - kEmotionTableHeight;
    }
    if (self = [super initWithFrame:frame]) {
        // 设置表情分组按钮
        for (NSInteger index; index < [JKStatusHelper emoticonGroups].count; index++) {
            JKEmotionGroup *group = [JKStatusHelper emoticonGroups][index];
            [self _addButtonWithTitle:group.groupNameCN tag:index];
        }

    }
    return self;
    
}

// 增加表情分组按钮
- (void)_addButtonWithTitle:(NSString *)title tag:(NSUInteger)tag
{
    
    // button frame
    NSUInteger index = self.subviews.count;
    CGFloat buttonWidth = kScreenWidth / kEmotionTableColumnCount;
    CGFloat buttonHeight = kEmotionTableHeight;
    CGFloat buttonX = buttonWidth * index;
    CGFloat buttonY = 0;
    
     UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    // 设置按钮名称为tag
    button.tag = tag;
   
    // 设置按钮名称
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(5D5C5a) forState:UIControlStateSelected];
    // 设置按钮背景图片
    UIImage *img;
    if (index == 0) {
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_left_normal"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 2) resizingMode:UIImageResizingModeStretch];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_left_selected"];
        [button setBackgroundImage:img forState:UIControlStateSelected];
    } else if (index == kEmotionTableColumnCount - 1) {
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_right_normal"];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_right_selected"];
        [button setBackgroundImage:img forState:UIControlStateSelected];

    } else {
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_mid_normal"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 2) resizingMode:UIImageResizingModeStretch];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        img = [JKStatusHelper imageNamed:@"compose_emotion_table_mid_selected"];
        [button setBackgroundImage:img forState:UIControlStateSelected];

    }
    button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    // 取消高亮操作
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(selectedBtton:) forControlEvents:UIControlEventTouchDown];
}


// select按钮,并通知代理点击事件(自动滚动collectionView至响应表情组)
- (void)selectedBtton:(UIButton *)button
{
    // 切换按钮选择状态
    [self switchSeletedStatusForButton:button];
    
    if ([self.delegate respondsToSelector:@selector(selectedEmotionTableButton:)] ) {
        [self.delegate selectedEmotionTableButton:button];
    }
    
    // emotionCollectionView换到对应页
    
}

// 仅仅切换按钮select状态
- (void)switchSeletedStatusForButton:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}

@end





@interface JKEmotionInputView () <UICollectionViewDelegate, UICollectionViewDataSource, JKEmotionTableDelegate>
@property (nonatomic, weak) JKEmotionCollectionView *collectionView;
@property (nonatomic, weak) JKEmotionTable *table;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageIndexs;
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageCounts;
@property (nonatomic, assign) NSUInteger emotionGroupTotalPageCount;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@end

@implementation JKEmotionInputView

+ (instancetype)sharedView
{
    static JKEmotionInputView *inputView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputView = [self new];
    });
    return inputView;

}

#pragma mark 初始化表情键盘
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kViewHeight;
    }
    if (self = [super initWithFrame:frame]) {
        [self _initTable];
        [self _initEmotionCollectionView];
        [self _initPageControl];
        [self _initGroups];
        // 自动高亮"默认"按钮
        [self.table selectedBtton:self.table.subviews[0]];

        

    }
    
    return self;
    
             
}

// 实现切换table按钮选择状态及pageControl状态
- (void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    NSUInteger i = 0;
    for (i = 0 ; i < self.emoticonGroupPageCounts.count ; i++) {
        NSUInteger pageIndex = self.emoticonGroupPageIndexs[i].unsignedIntegerValue;
        NSUInteger pageCount = self.emoticonGroupPageCounts[i].unsignedIntegerValue;
        if (currentPage >= pageIndex && currentPage < pageIndex + pageCount) {
            // 切换table相应按钮选择状态
            [self.table switchSeletedStatusForButton:(UIButton *)self.table.subviews[i]];
            // 切换pageControl状态
            self.pageControl.numberOfPages = pageCount;
            self.pageControl.currentPage = currentPage - pageIndex;
        }
    }
}


// 实现ollectionView自动跳转到对应表情首页
- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    CGFloat contentOffsetX = currentPageIndex * self.collectionView.width;
    self.collectionView.contentOffset = CGPointMake (contentOffsetX, 0);
}



- (void)_initTable
{
    JKEmotionTable *emotionTable = [JKEmotionTable new];
    emotionTable.delegate = self;
    [self addSubview:emotionTable];
    self.table = emotionTable;
    self.backgroundColor = [UIColor whiteColor];
   

}


- (void)_initGroups
{
    NSMutableArray *indexs = [NSMutableArray new]; // 各group起始index数组
    NSMutableArray *pageCounts = [NSMutableArray new]; // 各group总页数数组;
    NSUInteger totalPageCount = 0;
    
    NSInteger index = 0; // group的起始index
    
    NSArray * groups = [JKStatusHelper emoticonGroups];
    for (JKEmotionGroup *group in groups) {
        // 插入当前group的起始index(起始为0)
        [indexs addObject:@(index)];
        // 当前group总页数
        NSInteger count = ceil(group.emotions.count / kOnePageCount);
        if (count == 0) count = 1; // (空白组占一页)
        // 插入当前group的总页数;
        [pageCounts addObject:@(count)];
        // 累加所有表情总页数
        totalPageCount += count;

        // 下一组group的起始index
        index += count;
        
    }
    _emoticonGroupPageIndexs = indexs;
    _emoticonGroupPageCounts = pageCounts;
    _emotionGroupTotalPageCount = totalPageCount;
  
}


- (void)_initEmotionCollectionView
{
    FullyHorizontalFlowLayout *layout = [[FullyHorizontalFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kOneEmoticonWidth, kOneEmoticonHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, kEmotionCollectionViewSidePadding, 0, kEmotionCollectionViewSidePadding);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    JKEmotionCollectionView *collectionView = [[JKEmotionCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kEmotionCollectionViewHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[JKEmotionCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)_initPageControl
{
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.pageIndicatorTintColor = UIColorHex(E4E4E4);
    pageControl.currentPageIndicatorTintColor = UIColorHex(FC893A);
    pageControl.top = self.collectionView.bottom + 5;
    pageControl.centerX = self.centerX;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    
    pageControl.numberOfPages = self.emoticonGroupPageCounts[0].unsignedIntegerValue;
}



#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _emotionGroupTotalPageCount;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kOnePageCount + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKEmotionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == kOnePageCount) {
        cell.isDelete = YES;
        cell.emotion = nil;
    } else {
        cell.isDelete = NO;
        cell.emotion = [self _emotionForIndexPath:indexPath];
  
    }
    

    return cell;
}
- (JKEmotion *)_emotionForIndexPath:(NSIndexPath *)indexPath
{

    NSUInteger section = indexPath.section;
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (section >= pageIndex.unsignedIntegerValue) { // section 处于该组范围
            JKEmotionGroup *group = [JKStatusHelper emoticonGroups][i];
            NSUInteger page = section - pageIndex.unsignedIntegerValue;
            NSUInteger index = page * kOnePageCount + indexPath.row;
            
            // 行/列对换
            
            
            if (index < group.emotions.count) {
                return group.emotions[index];
            } else {
                return nil;
            }
        }

        
    }
    return nil;
}



#pragma mark UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // setCurrentPage 懒加载,实现table相应按钮高亮
    self.currentPage = (int) (scrollView.contentOffset.x / scrollView.width + 0.5);
  
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
     if (indexPath.row != 0 && indexPath.row % kOnePageCount  ==  0 ) {
        if ([self.delegate respondsToSelector:@selector(tapCollectionViewForDelete)]) {
            [self.delegate  tapCollectionViewForDelete];
        }
    
     } else if ([self.delegate respondsToSelector:@selector(tapCollectionViewForEmotion:)]) {
         JKEmotion *emotion = [self _emotionForIndexPath:indexPath];
         [self.delegate tapCollectionViewForEmotion:emotion];
     }
        
    
}
#pragma mark JKEmotionTableDelegate
- (void)selectedEmotionTableButton:(UIButton *)button
{
    NSArray *emotionGroups = [JKStatusHelper emoticonGroups];
    for (NSUInteger index = 0 ; index < emotionGroups.count; index++) {
        if (index == button.tag) {
            // setCurrentPageIndex 懒加载,实现collectionView跳转
            self.currentPageIndex = self.emoticonGroupPageIndexs[index].integerValue;
            
        }
    }
}
@end

