//
//  SZLocalFilesVC.m
//  SZDebugBall
//
//  Created by Will on 2019/6/3.
//

#import "SZLocalFilesVC.h"
#import "ZSLocalFileSearcher.h"

@interface SZLocalFilesVC ()

@property (nonatomic, strong) NSMutableArray <ZSLocalFile *> *datas; //!< 数据
@property (nonatomic, copy) NSString *currentPath;   //!< 当前路径

@end


@implementation SZLocalFilesVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[SZFileCell class] forCellReuseIdentifier:@"SZFileCell"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZFileCell"];
    [cell config:self.datas[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZSLocalFile *model = _datas[indexPath.row];
    if (model.isDirectory)
    {
        SZLocalFilesVC *vc = [[SZLocalFilesVC alloc] init];
        vc.currentPath = model.path;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        
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



#pragma mark - Priva Methods
- (void)searchFiles
{
    NSArray *files = [ZSLocalFileSearcher contentsOfDirectory:_currentPath sortBy:ZSLocalFileSort_FileName ascending:YES];
    
    [_datas removeAllObjects];
    [_datas addObjectsFromArray:files];
    [self.tableView reloadData];
    
}


@end







@implementation SZFileCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.label_title];
        [self.contentView addSubview:self.label_detail];
        [self.contentView addSubview:self.imgv_icon];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imgv_icon.frame = CGRectMake(10, 10, 30, 30);
    _label_title.frame = CGRectMake(50, 10, CGRectGetWidth(self.contentView.frame) - 120, 30);
    _label_detail.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 60, 10, 50, 30);
    
}


- (void)config:(ZSLocalFile *)model
{
    _label_title.text = model.fileName;
    if (model.isDirectory)
    {
        _imgv_icon.image = [self folderImage];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _label_detail.text = [NSString stringWithFormat:@"%ld", model.numberOfFiles];
    }else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        _imgv_icon.image = [self fileImage];
        _label_detail.text = nil;
    }
}


- (UIImageView *)imgv_icon
{
    if (!_imgv_icon)
    {
        _imgv_icon = [[UIImageView alloc] init];
        _imgv_icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgv_icon;
}

- (UILabel *)label_title
{
    if (!_label_title)
    {
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, CGRectGetWidth(self.contentView.frame) - 60, 30)];
        _label_title.font = [UIFont systemFontOfSize:14];
        _label_title.textColor = [UIColor blackColor];
    }
    return _label_title;
}

- (UILabel *)label_detail
{
    if (!_label_detail)
    {
        _label_detail = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, CGRectGetWidth(self.contentView.frame) - 60, 30)];
        _label_detail.font = [UIFont systemFontOfSize:12];
        _label_detail.textColor = [UIColor grayColor];
        _label_detail.textAlignment = NSTextAlignmentRight;
    }
    return _label_detail;
}




/// 文件夹图标
- (UIImage *)folderImage
{
    return [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"iVBORw0KGgoAAAAEQ2dCSVAAIAIr1bN/AAAADUlIRFIAAABsAAAAbAgGAAAAj2ZXzQAAAARnQU1BAACxjwv8YQUAAAABc1JHQgCuzhzpAAAAIGNIUk0AAHomAACAhAAA+gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAcaURPVAAAAAIAAAAAAAAANgAAACgAAAA2AAAANgAAAqAyYZ6OAAACbElEQVTsmD1rFFEUhp8km6yFQTSFIEQIWAiCohH8CVr7C0SEiJWVYCOWFjZGxIUUVmJtqaWWWlkIgmIjihYqih/JZkebc+FwyezMZjIzd7PvAy+77Ncd7rPn3jsHhBBCCCGEEEIIIYQQQgghhBB5TDUYUYE5S6fBzErc9phpcexpSRt9+QM4BtwAesB9Sy96jF/rRe/Fyfv+PeABcCESJ0pW1nlgE/jXQm4mUunJE/7R88Bbm7w/Jq7fQDactFvuujpSM1zYSZu0gaXJ6tp0Y666a5uVnnxhyzZhmaXpJXHgluM1SasuLNvh5Enr2/OHWh63Lyyrsaq2+mOEfe2xO72q0kassN/AN+D7DuSr+91+gbSndiOPe5SwHGGZm9Cr9rkFYF+F7LeJPwv8tN/+WyDtObDXxu9KWDlhl2oY+4xV7TBp6/b8BXBA0soLu+z2kmmqN3zDpJ8AvtgY6zl7XZD5CjjopHUSzFzdh6SywlZqOLEFaUeBDyWlvQEOj1Eh7Cph/iCxBLwrkBZefw/cBu7ajXbbuWNZBa4BR1yPdtcJ89IOAa9dRW11Wu231OscJRvAubr6oikI89IWgJcF0kJXJLUMgF9uv+3WUWmpCPPS5oFnBctjqvHNgON17GcpCfPSusATt8SMizA/f6cnQZiXNmPtqSBtkFiyAmGnJkVY3Dt8lHhF5QlbniRhsbQ1a2V9BD4nkE/Aj4IKmzhh8bF40W6aF1vOkvU2r7tbjUzCGugaVOSi218lLGLKlsgUsseu6YoqbDwIy/SKhI0HHQmTMAmTMAmTMAmTMAmTMAmTMAmTMAmTMAkbxn8AAAD//+GwdEUAAAFbSURBVO2YQWrCUBRFj9Y6aAcduIpCBwW30VHXINihCyh0Gc3KCl1FHVkwqenkBeQ3Bg2JhHoOXP4nfnlyjxEMHMc41jlQArtItc9jv4xzE6TqYBnd5Eln1X6edNwJClOYwhSmMIUpTGEKU5jCFKYwhSlMYQpTmMIUpjCFKUxhClOYwhSmMIUpTGEKU5jCFKYwhf0DYS9x7jreM7rQjKMDopPBClt4Y/1hMWRhqzg3A+4uPLPoYjU0YfvZAF/A2rCOLjY1PQ1CWJ1AU9/NYO6wnalNOVRh5vg77izCHmPID1BYfOsU0WEZnfYm7Bb4jEHfMTg3J6WI7krgA7jpQxjAVazPe98O0z5b4CnptlOqf/EAD8AbkAHvkSxZ02tZ8lqaprNZw5qePzSr6Vp24PNkDTNOmZXuX4H7ml57YYx0/avVO9N4VjYxrTKNnJ2RaRURERERERERERERERERqeEXyOfetgAAAABJRU5ErkJggg==" options:0]];
}

/// 文件图标
- (UIImage *)fileImage
{
    return [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"iVBORw0KGgoAAAAEQ2dCSVAAIAIr1bN/AAAADUlIRFIAAABsAAAAbAgGAAAAj2ZXzQAAABxpRE9UAAAAAgAAAAAAAAA2AAAAKAAAADYAAAA2AAABbxKXEmwAAAE7SURBVOzawU3DQBBA0V+CS6AEl0AHuARKoINsB1ACJdBB3EHoJHQAh/jAJTZJpLAz87+0V2vXT7uWbIOZmZmZmZmZ/XtPwCuwDzCeqyINwA44At/BRjm0ETgEhCqJNgbdVSXRHhJhlUDbJ8NKjfa4segv4ANoHYxZtBPGucV+LsdlL7XqO23YwBo6m++1YGnQ1o7DqcP5ngObgfcKaNPK4ggGRgW0lgwsPVpGsNRoWcHSomUGS4mWHSwdWgWwVGhVwNKgVQJLgVYNLDxaFrDjhdcJixYNbFqZ764CWjSwYeMGH7jsT6u/vOWfBLutmft+tW6C3dYoWCwwlmeLYIHAAF4EiwUGpy/ms2BxwH4/1xrwtgBeMwQLlmCCCSaYYIIJJphgggkmmGCCCSaYYIIJJphgggkmmGD9gP0AAAD//90u7a4AAADzSURBVO3Yyw2CUBBA0SmBEiyBEiiBjqQEO4ES7EBLoQPdoAsTPguj73NuMis3gwceCRHfaYiIx8rU1tr/MKS0JDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwbsB/XAdsH6lJbscln0jzdul9Kizcait+X30muWa83mpJl20E4FY512sKYUl946Fl8zRsS5sBkPXHeX6p12PbB8bXNN/RyfIb1nzuH93UJ7Y7W5vITbiLhXjHXPCevzC8hc2VM1RAH1EXFZXsAlzqWyDwSSJEmSJKXZE5SsJHsAAAAASUVORK5CYII=" options:0]];
}



@end
