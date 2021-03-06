//
//  ViewController.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "CTRefreshKit.h"
#import "CTRefreshHeaderView.h"
#import "CTRefreshFooterView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataSource = @[@"data1",@"data2"].mutableCopy;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.menuView];
    
    self.menuView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView ct_addHeaderRefresh:[CTRefreshHeaderView class] handle:^(UIView *headerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView ct_endHeaderRefresh];
            weakSelf.dataSource = @[@"data",@"data"].mutableCopy;
            [weakSelf.tableView reloadData];
        });
    }];
    
    [self.tableView ct_beginHeaderRefresh];
    
    [self.tableView ct_addFooterRefresh:[CTRefreshFooterView class] handle:^(UIView *footerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView ct_endFooterRefresh];
            [self.dataSource addObject:@"data"];
            [self.dataSource addObject:@"data"];
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %zd",self.dataSource[indexPath.row],indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewController *view = [TableViewController new];
    [self.navigationController pushViewController:view animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (UIView *)menuView{
    if (_menuView == nil) {
        _menuView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuView.backgroundColor = [UIColor grayColor];
    }
    return _menuView;
}


@end
