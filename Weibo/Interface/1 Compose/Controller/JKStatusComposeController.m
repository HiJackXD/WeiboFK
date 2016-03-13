//
//  JKStatusComposeController.m
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusComposeController.h"
#import "JKStatusLayout.h"
#import "JKAccountTool.h"
#import <YYKit/YYKit.h>
#import "JKComposeToolbar.h"
#import "JKEmotionInputView.h"
#import "JKStatusHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"

#define kStatusComposeFont [UIFont systemFontOfSize: 17];

@interface JKStatusComposeController () <JKComposeToolbarDelegate, UITextViewDelegate, UIScrollViewDelegate, JKEmotionInputViewDelegate>
@property (nonatomic, weak) YYTextView *textView;
@property (nonatomic, strong) UIButton *emotionInputViewSelectedButton;


@end

@implementation JKStatusComposeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTextView];
    
}

- (void)setupNavigationBar
{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:1 target:self action:@selector(sendStatus)];
   
    // 设置标题Text
        // 标题(上):发微博
    NSMutableAttributedString *prefixText = [[NSMutableAttributedString alloc] initWithString:@"发微博\n"];
    prefixText.font = [UIFont systemFontOfSize:14];
        // 标题(下): 用户名
    NSMutableAttributedString *userNameText = [[NSMutableAttributedString alloc] initWithString:[JKAccountTool account].name];
    userNameText.color = [UIColor grayColor];
    userNameText.font = [UIFont systemFontOfSize:10];
        // 标题Text
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] init];
    [titleText appendAttributedString:prefixText];
    [titleText appendAttributedString:userNameText];
    
    // 设置标题Label
    YYLabel *titleLabel = [YYLabel new];
    titleLabel.attributedText = titleText;
    titleLabel.numberOfLines = 0 ;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.size = CGSizeMake(kScreenWidth, 44);
    self.navigationItem.titleView = titleLabel;
    
}

- (void)setupTextView
{
    YYTextView *textView = [[YYTextView alloc] init];
    textView.frame = [UIScreen mainScreen].bounds;
    textView.backgroundColor = [UIColor whiteColor];

    // 设置toolbar
    JKComposeToolbar *toolbar = [[JKComposeToolbar alloc] init];
    toolbar.delegate = self;
    textView.inputAccessoryView = toolbar;
    
    // 设置正文及占位符文字
    textView.placeholderText = @"请输入微博...";
    textView.font = textView.placeholderFont = kStatusComposeFont;
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    self.textView = textView;
    
}


- (void)clickCancel
{
    [self.textView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendStatus
{
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.设置请求体参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.text;
   [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params progress:nil
                                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                           if ([self.delegate respondsToSelector:@selector(statusComposeSuccess)]) {
                                                                               [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                                                                               [SVProgressHUD setMinimumDismissTimeInterval:2];
                                                                               [SVProgressHUD setSuccessImage:nil];
                                                                               [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, kScreenHeight / 2.0)];
                                                                               [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                                                                               [self.delegate statusComposeSuccess];
                                                                              

                                                                            };
                                                                }
                                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                        [SVProgressHUD showErrorWithStatus:@"发送失败"]; ;
                                                                   }];
   [self.textView endEditing:YES];
   [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark  JKComposeToolbarDelegate
- (void)composeToolBar:(JKComposeToolbar *)toolBar didClickButton:(UIButton *)button
{
    switch (button.tag) {
        case JKComposeToolBarTypePicture:
            NSLog(@"2222");
            break;
        case JKComposeToolBarTypeMention:
        {
            NSArray *atArray = @[@"@iOS ", @"@王菲 ", @"@成龙 ", @"@HiJack ", @"@Google "];
            u_int32_t randomIndex = arc4random_uniform((u_int32_t)atArray.count);
            NSString *atString = atArray[randomIndex];
            [self.textView replaceRange:_textView.selectedTextRange withText:atString];
        
        }
            break;
        case JKComposeToolBarTypeTrend:
        {
            NSArray *atArray = @[@"#WCG赛事# ", @"#王菲今天发微博了吗# ", @"#天上掉下个林妹妹# ", @"#我的中国心# ", @"#Google今天回归了吗# "];
            u_int32_t randomIndex = arc4random_uniform((u_int32_t)atArray.count);
            NSString *atString = atArray[randomIndex];
            [self.textView replaceRange:_textView.selectedTextRange withText:atString];
        }
            break;
        case JKComposeToolBarTypeEmotion:{
            if (self.textView.inputView == nil) {
                JKEmotionInputView *emotionInputeView =  [JKEmotionInputView sharedView];
                emotionInputeView.delegate = self;
                // 代理,监听表情键盘表情输入
                self.textView.inputView = emotionInputeView;
                [self.textView reloadInputViews];
            } else {
                self.textView.inputView = nil;
                [self.textView reloadInputViews];
            }
            
            break;
        }
        case JKComposeToolBarTypeAdd:
            NSLog(@"2222");
            break;
            
    
   
    }
}

#pragma mark JKEmotionInputViewDelegate
- (void)tapCollectionViewForEmotion:(JKEmotion *)emotion
{
    if (emotion.chs.length) {
        [self.textView insertText:emotion.chs];
    } else if (emotion.code.length) {
        [self.textView insertText:emotion.code];
    }
}

- (void)tapCollectionViewForDelete
{
    [self.textView deleteBackward];
}

    
@end
