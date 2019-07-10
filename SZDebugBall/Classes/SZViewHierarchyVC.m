//
//  SZViewHierarchyVC.m
//  Pods-SZDebugBall_Example
//
//  Created by Will on 2019/6/3.
//

#import "SZViewHierarchyVC.h"

@interface SZViewHierarchyVC ()

@property (nonatomic, strong) NSArray *datas; //!< 数据

@end


@implementation SZViewHierarchyVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_rootView) {
        _rootView = [UIApplication sharedApplication].keyWindow;
    }
    
    self.title = NSStringFromClass([_rootView class]);
    
    self.datas = _rootView.subviews;
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ViewCell"];
    }
    
    UIView *tv = self.datas[indexPath.row];
    if (tv.subviews.count) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = NSStringFromClass([tv class]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIView *tv = self.datas[indexPath.row];
    if (tv.subviews.count)
    {
        SZViewHierarchyVC *vc = [[SZViewHierarchyVC alloc] init];
        vc.rootView = self.datas[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



@end
