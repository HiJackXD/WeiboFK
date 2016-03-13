
//
//  JKHomeViewController.m
//  Weibo
//
//  Created by HiJack on 16/1/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusCell.h"
#import "JKStatusFooterView.h"
#import "JKHomeViewController.h"
#import "JKPopoverController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JKAccountTool.h"
#import "JKAccount.h"
#import <YYKit/YYKit.h>
#import "JKStatusModel.h"
#import "JKTableView.h"
#import "JKStatusComposeController.h"
#import "JKNavigationController.h"


@interface JKHomeViewController () <UIPopoverPresentationControllerDelegate, JKStatusCellDelegate, JKStatusComposeControllerDelegate>

@property (strong, nonatomic) NSMutableArray *layouts;

@property (nonatomic, strong) UIButton *nameButton; ///< 顶部ID按钮
@property (nonatomic, strong) UIRefreshControl *statusRefreshControl; ///< 微博下拉刷新
@property (nonatomic, strong) JKStatusFooterView *footerView;


@property (nonatomic, strong) NSString* statusSinceID; ///< 当前屏幕最新微博的ID
@property (nonatomic, strong) NSString* statusMaxID; ///< 当前屏幕最旧微博的ID



@end

@implementation JKHomeViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delaysContentTouches = NO;
    self.tableView.canCancelContentTouches = YES;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置导航栏
    [self setupNavigationItem];
    // 设置用户信息显示
    [self setupUserInfo];
    // 创建下拉控件,并自动刷新微博
    [self refreshStatus];
    
    
    
   
  

    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.nameButton.imageView.frame.size.width, 0, self.nameButton.imageView.frame.size.width);
    self.nameButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.nameButton.titleLabel.frame.size.width + 10, 0, -self.nameButton.titleLabel.frame.size.width);
}


# pragma 懒加载

- (NSMutableArray *)layouts
{
    if (_layouts == nil) {
        _layouts= [NSMutableArray array];
    }
    return _layouts;
}

- (NSString *)statusSinceID
{
    if (_statusSinceID == nil) {
        _statusSinceID = [NSString new];
    }
    return _statusSinceID;
}

- (NSString *)statusMaxID
{
    if (_statusMaxID == nil) {
        _statusMaxID = [NSString new];
    }
    return _statusSinceID;
}

# pragma mark - Action

// 点击顶部昵称弹出列表
- (void)titleClick:(UIButton *)nameButton {
    
    JKPopoverController *popoverController = [[JKPopoverController alloc]init];
    popoverController.modalPresentationStyle = UIModalPresentationPopover ;
    popoverController.popoverPresentationController.sourceView = nameButton;
    popoverController.popoverPresentationController.sourceRect = nameButton.bounds;
    popoverController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverController.preferredContentSize = CGSizeMake(100, 44 * popoverController.friendGroups.count);
    popoverController.popoverPresentationController.delegate = self;
    [self presentViewController:popoverController animated:NO completion:nil];
    
}


# pragma mark - 自定义方法
/**
 *  设置导航栏
 
 */
- (void)setupNavigationItem {
    // 创建并配置friednGroupsButton
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    NSString *localName = [JKAccountTool account].name;  // 从沙盒读取帐号信息
    NSString *name = localName ? localName : self.navigationItem.title; // 若沙河无帐号文件,则显示"首页"
    [self.nameButton setTitle:name forState:UIControlStateNormal];
    [self.nameButton setTitleColor:[UIColor blackColor  ] forState:UIControlStateNormal];
    
    [self.nameButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [self.nameButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    self.nameButton.frame = CGRectMake(0, 0, 120, 30);
    [self.nameButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView =  self.nameButton;
    
    // 右上角创建写微博按钮
   
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[JKStatusHelper imageNamed:@"navigationbar_compose_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   style:0 target:nil action:nil];
    rightItem.target = self;
    rightItem.action = @selector(composeStatus);
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 左上角创建扫一扫
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[JKStatusHelper imageNamed:@"navigationbar_pop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:nil action:nil];
    
}


/**
 *  显示用户信息
 */

- (void)setupUserInfo
{
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];

    
    // 2.设置请求体参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送get请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //更新置顶昵称
        // - 从服务器获取昵称
        NSString *name = responseObject[@"name"];
        
        // - 存储服务器昵称到本地
        account.name = name;
        [JKAccountTool saveAccout:account];
        // - 设置顶部按钮文字为昵称,
        [self.nameButton setTitle:name forState:UIControlStateNormal];
        // - 更新昵称与箭头的位置关系
        [self.nameButton setNeedsDisplay];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
    
}

/**
 *  创建微博刷新控件
 */
- (void)refreshStatus
{
    self.statusRefreshControl = [[UIRefreshControl alloc]init];
    
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString : @"刷新中"
                                                                    attributes : @{
                                                                                   NSFontAttributeName : [UIFont systemFontOfSize:8],
                                                                                   }];
    self.statusRefreshControl.attributedTitle = labelText;
    [self.view addSubview:self.statusRefreshControl];
    [self.statusRefreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    if (self.statusRefreshControl.refreshing == NO) {
        // 进入刷新状态(但是只有手动下拉才能触发ValueChanged)
        [self.statusRefreshControl beginRefreshing];
        // 载入最新微博
        [self loadNewStatus];
    }
   
}

/**
 *  刷新微博
 */
- (void)refreshing
{
    if (self.statusRefreshControl.refreshing == YES) {
        [self loadNewStatus];
    }
}


/**
 *  载入最新微博数据
 */
- (void)loadNewStatus
{
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.设置请求体参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    if (self.statusSinceID.length) {
        params[@"since_id"] = self.statusSinceID;
    }
    
    
    // 3.发送get请求,获得最新timeline
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    // 请求成功
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if ([(NSArray *)responseObject[@"statuses"] count] == 0) {
            // 关闭下啦刷新
            [self.statusRefreshControl endRefreshing];
            // 显示"无最新微博"
            [self showNewStatusCount:0];
            return;
        }
        
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           // 获取最新微博数据流
           JKTimelineItem *timelineItem = [JKTimelineItem modelWithDictionary:responseObject];
           // 获取SiceID
           self.statusSinceID = timelineItem.sinceID;
           self.statusMaxID = timelineItem.maxID;
           // 输出最新layouts
           NSMutableArray *newLayouts = [NSMutableArray array];
           for (JKStatus *status in timelineItem.statuses) {
               JKStatusLayout *layout = [[JKStatusLayout alloc] initWithStatus:status];
               [newLayouts addObject:layout];
           }
           // 将最新layouts装入总layouts
           [self.layouts insertObjects:newLayouts atIndex:0];
           
           dispatch_async_on_main_queue(^{
                 // 刷新数据
               [self.tableView reloadData];
               // 关闭下啦刷新
               [self.statusRefreshControl endRefreshing];
               // 显示最新微博数量
               [self showNewStatusCount:newLayouts.count];
           });
       });
        
        
    // 请求失败
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        [self.statusRefreshControl endRefreshing];
    }];
    
}

- (void)loadOlderStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JKStatusFooterView *footer = [JKStatusFooterView footerView];
        self.tableView.tableFooterView = footer;
    });
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.设置请求体参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    if (_statusMaxID.length) {
        NSLog(@"%@",_statusMaxID);
        params[@"max_id"] = _statusMaxID;
    }
    
    
    // 3.发送get请求,获得最新timeline
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 请求成功
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if ([(NSArray *)responseObject[@"statuses"] count] == 0) {
           return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 获取最新微博数据流
            JKTimelineItem *timelineItem = [JKTimelineItem modelWithDictionary:responseObject];
            // 获取maxID
            self.statusMaxID = timelineItem.maxID;
            // 输出最新layouts
            NSMutableArray *newLayouts = [NSMutableArray array];
            for (JKStatus *status in timelineItem.statuses) {
                JKStatusLayout *layout = [[JKStatusLayout alloc] initWithStatus:status];
                [newLayouts addObject:layout];
            }
            // 将最新layouts装入总layouts
//            [self.layouts insertObjects:newLayouts atIndex:0];
            [self.layouts addObjectsFromArray:newLayouts ];
            
            dispatch_async_on_main_queue(^{
                // 刷新数据
                [self.tableView reloadData];
            
            });
        });
        
        
        // 请求失败
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
       
    }];
    
}
/**
 *  显示刷出最新微博数
 *
 *  @param count 刷出最新微博数
 */
- (void)showNewStatusCount:(NSUInteger)count
{
    UILabel *countLabel = [[UILabel alloc] init];
    // 设置frame
    int countLabelW = [UIScreen mainScreen].bounds.size.width;
    int countLabelH = 32;
    int countLabelX = 0;
    int countLabelY = 64 - countLabelH;
    countLabel.frame = CGRectMake(countLabelX, countLabelY, countLabelW, countLabelH);
    // 设置文字
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont italicSystemFontOfSize:13];
    // 设置橙色背景
    countLabel.backgroundColor = [UIColor orangeColor];
    // 设置居中
    countLabel.textAlignment = NSTextAlignmentCenter;
    // 设置文字
    if (count == 0) {
        countLabel.text = @"没有更多数据,请稍候再试";
    } else if(count > 0) {
        countLabel.text = [NSString stringWithFormat:@"共有%zd条新微博",count];
    }
    
    // 添加label到NavigationBar
    [self.navigationController.view insertSubview:countLabel belowSubview:self.navigationController.navigationBar];
    // 设置动画
    [UIView animateWithDuration:0.5 animations:^{
        countLabel.transform = CGAffineTransformMakeTranslation(0, countLabelH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
            countLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [countLabel removeFromSuperview];
        }];
    }];
    
}

- (void)composeStatus {
    
    JKStatusComposeController *composeController = [[JKStatusComposeController alloc] init];
    composeController.delegate = self;
    JKNavigationController *nav = [[JKNavigationController alloc] initWithRootViewController:composeController];
    [self presentViewController:nav animated:YES completion:nil]
    ;}

- (void)statusComposeSuccess
{
    [self refreshStatus];
    
}

# pragma mark - UIPopoverPresentationControllerDelegate 代理方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
    self.nameButton.selected = YES;
}


- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    self.nameButton.selected = NO;
    return YES;
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.footerView.hidden = (_layouts.count == 0);
    return _layouts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    cell.statusFrame = _statuseFrames[indexPath.row];
    JKStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JKStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    
    }
    
    [cell setlayout:_layouts[indexPath.row]];
     return cell;
}



#pragma mark - Table view delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 30;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((JKStatusLayout *)_layouts[indexPath.row]).height ;
}

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    self.tableView.bounces = YES;
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height -20) {
        // we are at the end
        self.tableView.bounces = NO;
        // 加载更旧微博
        [self loadOlderStatus];
    
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        self.tableView.bounces = NO;

           }
    else {
        self.tableView.bounces = YES;
    }
}







@end
