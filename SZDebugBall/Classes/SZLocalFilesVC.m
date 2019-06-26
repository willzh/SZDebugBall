//
//  SZLocalFilesVC.m
//  SZDebugBall
//
//  Created by Will on 2019/6/3.
//

#import "SZLocalFilesVC.h"

@interface SZLocalFilesVC ()

@property (nonatomic, strong) NSMutableArray *datas; //!< 数据
@property (nonatomic, copy) NSString *currentPath;   //!< 当前路径

@end


@implementation SZLocalFilesVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FileCell"];
    self.datas = [NSMutableArray array];
    
    if (!_currentPath) {
        self.currentPath = NSHomeDirectory();
    }
    
    self.title = [_currentPath lastPathComponent];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self searchFiles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
    
    id obj = _datas[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [(NSString *)obj lastPathComponent];
    }else if ([obj isKindOfClass:[NSURL class]]) {
        cell.textLabel.text = [[(NSURL *)obj path] lastPathComponent];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *path = nil;
    id obj = _datas[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        path = (NSString *)obj;
    }else if ([obj isKindOfClass:[NSURL class]]) {
        path = [(NSURL *)obj path];
    }
    
    if (path)
    {
        BOOL isDir = YES;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        if (isExist)
        {
            if (isDir)
            {
                SZLocalFilesVC *vc = [[SZLocalFilesVC alloc] init];
                vc.currentPath = path;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                
            }
        }
    }
}

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



#pragma mark -
- (void)searchFiles
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *files = [fileMan contentsOfDirectoryAtURL:[NSURL fileURLWithPath:_currentPath] includingPropertiesForKeys:nil options:0 error:&error];
    if (error)
    {
        NSLog(@"search files error:%@", error);
        return;
    }
    NSLog(@"files:%@", files);
    
    [_datas removeAllObjects];
    [_datas addObjectsFromArray:files];
    [self.tableView reloadData];
    
}

@end
