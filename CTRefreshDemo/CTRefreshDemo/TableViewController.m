//
//  TableViewController.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/28.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "TableViewController.h"
#import "CTRefreshKit.h"
#import "CTRefreshHeaderView.h"
#import "CTRefreshFooterView.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView ct_addHeaderRefresh:[CTRefreshHeaderView class] handle:^(UIView *headerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.dataSource = @[@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data"].mutableCopy;
            [weakSelf.tableView ct_endHeaderRefresh];
            [weakSelf.tableView reloadData];
        });
        
    }];
    
    [self.tableView ct_beginHeaderRefresh];
    
    [self.tableView ct_addFooterRefresh:[CTRefreshFooterView class] handle:^(UIView *footerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView ct_endFooterRefresh];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)dealloc{
    NSLog(@" %@ dealloc ", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    cell.textLabel.text = @"test";
    return cell;
}




@end
