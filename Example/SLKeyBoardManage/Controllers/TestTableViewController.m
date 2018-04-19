//
//  TestTableViewController.m
//  TestTableView
//
//  Created by Touker on 2018/4/19.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import "TestTableViewController.h"


@implementation TestTableViewCell
@end

@interface TestTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
@property(nonatomic,strong)NSTimer *timer; // timer
@property(nonatomic, strong)NSArray *titleArray;
@end

@implementation TestTableViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.testTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.testTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.testTableView respondsToSelector:@selector(setLayoutManager:)]) {
        [self.testTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.testTableView.tableFooterView = [[UIView alloc] init];
    self.testTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.titleArray=@[@"scrollView-textField"];
}
#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    NSLog(@"%@",cell);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"two" sender:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark -private
+ (id)createTestTableViewController{
    TestTableViewController * rootViewController =[TestTableViewController createFromStoryboardWithStoryboardID:@"TestTableViewController" storyboardName:@"TestTableViewController" bundleName:nil];
    return rootViewController;
}
+ (instancetype)createFromStoryboardWithStoryboardID:(NSString *)aStoryboardID storyboardName:(NSString *)aStoryboardName  bundleName:(NSString *)aBundleName {
    NSBundle *bundle = [self getBundleWithBundleName:aBundleName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:aStoryboardName bundle:bundle];
    return [storyboard instantiateViewControllerWithIdentifier:aStoryboardID];
}

+ (NSBundle *)getBundleWithBundleName:(NSString *)aBundleName {
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    return bundle;
}
@end
