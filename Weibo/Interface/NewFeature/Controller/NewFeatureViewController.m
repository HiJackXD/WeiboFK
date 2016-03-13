//
//  NewFeatureViewController.m
//  Weibo
//
//  Created by HiJack on 16/1/8.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "NewFeatureViewController.h"

#define NEWFUEATURECOUNT  4

@interface NewFeatureViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControll;

@property (assign, nonatomic) int screenWith;
@property (assign, nonatomic) int screenHeight;


@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 读取屏幕尺寸
    self.screenWith = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 创建UIScrollView
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(_screenWith * NEWFUEATURECOUNT, _screenHeight);
    self.scrollView.delegate = self;
    
    // 创建若干个imageView,做从左到右依次排列
    for (int i; i < NEWFUEATURECOUNT ; i++) {
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i+1];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(_screenWith * i, 0, _screenWith, _screenHeight);
        imageView.image = [UIImage imageNamed:imageName];
        [self.scrollView addSubview:imageView];
    }
    
    // 创建pageCOntroll
    self.pageControll = [[UIPageControl alloc]init];
    self.pageControll.numberOfPages = NEWFUEATURECOUNT;
    self.pageControll.center = CGPointMake(_screenWith * 0.5, _screenHeight * 0.8);
  
  
}

#pragma mark 懒加载


#pragma mark - UIScrollViewDelegate

// 当移动scrollView时调用
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int page = self.scrollView.contentOffset /
//}

@end
