//
//  SZUserDefaultsVC.m
//  SZDebugBall_Example
//
//  Created by Will on 2019/7/10.
//  Copyright © 2019 willzh. All rights reserved.
//

#import "SZUserDefaultsVC.h"

@interface SZUserDefaultsVC ()

@property (nonatomic, strong) NSDictionary *datas; //!< 数据

@end

@implementation SZUserDefaultsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"User Defaults";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1111" forKey:@"aaaa"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.datas = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ViewCell"];
    }
    
    NSString *key = self.datas.allKeys[indexPath.row];
    id obj = self.datas[key];
    cell.textLabel.text = [obj description];
    cell.detailTextLabel.text = key;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
