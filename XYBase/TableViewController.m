//
//  TableViewController.m
//  XYBase
//
//  Created by 徐晓烨 on 16/7/12.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
{
    NSArray* records;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    XYBaseTvcItem* item = [[XYBaseTvcItem alloc] initWithIdentifer:@"default" view:nil height:44];
    item.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        baseCell.textLabel.text = @"test 1";
        return baseCell;
    };
    
    
    XYBaseTvcItem* item2 = [[XYBaseTvcItem alloc] initWithIdentifer:@"default" view:nil height:44];
    item2.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        baseCell.textLabel.text = @"test 2";
        return baseCell;
    };
    
    sections = @[
                 @[item, item2]
                 ];
    self.tableView.tableFooterView = [UIView new];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor greenColor];
    
//    self.noDataView = view;
//    [self.view addSubview:self.noDataView];
//    [self setNoDataViewHidden:NO];
    
    records = @[@"a",@"b",@"c",@"d",@"e"];
}

//-(UIView*)noDataView{
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    view.backgroundColor = [UIColor greenColor];
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    return view;
//}

//-(void)handleCorrectResponse:(XYProcessResult *)result{
//    NSArray* records = [result.params objectForKey:@"records"];
//    [self setNoDataViewHidden:records != 0];
//    [self.tableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return records.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"default" forIndexPath:indexPath];
    cell.textLabel.text = [records objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    v.backgroundColor = [UIColor greenColor];
    return v;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
