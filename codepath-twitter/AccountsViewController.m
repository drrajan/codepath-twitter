//
//  AccountsViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/28/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "AccountsViewController.h"
#import "AccountCell.h"
#import "User.h"

@interface AccountsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"AccountCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table view methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [User accounts].count) {
        [self addAccount];
    } else {
        [self switchAccount:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [User accounts].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [User accounts].count) {
        UITableViewCell *cell = [UITableViewCell new];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        cell.textLabel.text = @"+";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        AccountCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.user = [User accounts][indexPath.row];
        return cell;
    }
}

#pragma mark Private methods

- (void)addAccount {
    [User switchUser:nil];
}

- (void)switchAccount:(NSInteger)index {
    [User switchUser:[User accounts][index]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
