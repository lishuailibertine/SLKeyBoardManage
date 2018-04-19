//
//  TwoViewController.m
//  SLKeyBoardManage_Example
//
//  Created by Touker on 2018/4/19.
//  Copyright © 2018年 lishuailibertine. All rights reserved.
//

#import "TwoViewController.h"
#import "HBControllSenders.h"

@interface TwoTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (nonatomic, strong)UIView *(^event)(void);
@end
@implementation TwoTableViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)addEvent{
    self.twoTextField.hb_Listening =YES;
    self.twoTextField.hb_MoveView = self.event();
    self.twoTextField.hb_KeyBoardDistance =30.f;
}
@end


@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *twoScrollView;

@end

@implementation TwoViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    UITextField * textField =[[UITextField alloc] init];
    textField.backgroundColor =[UIColor redColor];
    textField.frame =CGRectMake(100, 600, 200, 30);
    [self.twoScrollView addSubview:textField];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TwoTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TwoTableViewCell"];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.event = ^UIView *{
        return self.twoScrollView;
    };
    [cell addEvent];
    NSLog(@"%@",cell);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
