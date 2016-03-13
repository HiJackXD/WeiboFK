//
//  JKDiscoverViewController.m
//  Weibo
//
//  Created by HiJack on 16/1/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKDiscoverViewController.h"

@interface JKDiscoverViewController ()

@end

@implementation JKDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建searchView
    UITextField *searchView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 50, 32)];
    searchView.background = [UIImage imageNamed:@"searchbar_teUsershijackDownloadssearchbar_pulse.pngxtfield_search_icon"];
    searchView.placeholder = [NSString stringWithFormat:@"大家都在搜: Jack嫁我!!"];
    searchView.font = [UIFont systemFontOfSize:14];
    self.navigationItem.titleView = searchView;
    
    // 创建searchView左侧放大镜
    searchView.leftView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"] ];
    searchView.leftViewMode = UITextFieldViewModeAlways;
    searchView.leftView.frame = CGRectMake(0, 0, 30, 30);
    searchView.leftView.contentMode = UIViewContentModeCenter;
    
    // 创建searchView右侧的语音输出
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchbar_pulse"] style:UIBarButtonItemStyleDone target:nil action:nil  ];;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
