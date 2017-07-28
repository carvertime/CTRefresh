//
//  ViewController.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "ViewController.h"
#import "CTRefreshProtocol.h"
#import "UIScrollView+CTRefresh.h"
#import "CTRefreshHeaderView.h"
#import "CTRefreshFooterView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataSource = @[].mutableCopy;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.tableView ct_addHeaderRefresh:[CTRefreshHeaderView class] handle:^(UIView *headerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView ct_endHeaderRefresh];
            self.dataSource = @[@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data"].mutableCopy;
            [self.tableView reloadData];
        });
    }];
    
    [self.tableView ct_beginRefresh];
    
//    [self.tableView ct_addFooterRefresh:[CTRefreshFooterView class] handle:^(UIView *footerView) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView ct_refreshFooter];
//            [self.dataSource addObject:@"data"];
//            [self.dataSource addObject:@"data"];
//            [self.dataSource addObject:@"data"];
//            [self.dataSource addObject:@"data"];
//            [self.dataSource addObject:@"data"];
//            [self.tableView reloadData];
//        });
//    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %zd",self.dataSource[indexPath.row],indexPath.row+1];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    }
    return _tableView;
}


@end
