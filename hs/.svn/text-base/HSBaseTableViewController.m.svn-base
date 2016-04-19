//
//  HSBaseTableViewController.m
//  EGOTableViewPullRefreshDemo
//
//  Created by gg on 15/5/8.
//
//

#import "HSBaseTableViewController.h"
#import "HSTableViewCell.h"

@interface HSBaseTableViewController ()


@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSArray *cellDataArray;

@end

@implementation HSBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pullTableView = [[PullTableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
    _pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    _pullTableView.pullBackgroundColor = [UIColor clearColor];
    _pullTableView.pullTextColor = [UIColor blackColor];
    _pullTableView.pullDelegate = self;
    _pullTableView.delegate = self;
    _pullTableView.dataSource = self;
    self.tableView = _pullTableView;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - set property

- (void)setPullDownRefresh:(BOOL)pullDownRefresh
{
    _pullDownRefresh = pullDownRefresh;
    _pullTableView.pullDownTableRefresh = _pullDownRefresh;
}

- (void)setPullUpRefresh:(BOOL)pullUpRefresh
{
    _pullUpRefresh = pullUpRefresh;
    _pullTableView.pullUpTableRefresh = _pullUpRefresh;
}

- (void)setCellClassString:(NSString *)className
{
    self.className = [className copy];
}

- (void)setCellDisplayData:(id )cellDataArray
{
    self.cellDataArray = [cellDataArray copy];
    [_pullTableView reloadData];
}

- (void)setHeaderArray:(NSArray *)array
{
    _headerArray = array;
}

- (Class)getCellClass
{
    Class cellClass = nil;
    if ([self.className length]) {
        cellClass = NSClassFromString(self.className);
    }else{
        cellClass = NSClassFromString(@"UITableViewCell");
    }
    return cellClass;
}

- (void)setIsExistSectionHead:(BOOL)isExistSectionHead
{
    _isExistSectionHead = isExistSectionHead;
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    _pullTableView.pullLastRefreshDate = [NSDate date];
    _pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    _pullTableView.pullTableIsLoadingMore = NO;
}


- (void)tableView:(UITableView *)tableView clickTableViewCell:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView clickTableViewCell:indexPath];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * labView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    labView.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 1);
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [self.headerArray objectAtIndex:section];
    [titleLab setFont:[UIFont systemFontOfSize:12]];
    [labView addSubview:titleLab];
    return labView;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeigth > 0) {
        return self.cellHeigth;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!_isExistSectionHead) {
        return 0;
    }
    return 30;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellDataArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    Class cellClass = [self getCellClass];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
    //cell.delegate = self;
    CMLog(@"%ld",indexPath.row);
    if([self.cellDataArray count] > indexPath.row)
    {
            cell.dict = [self.cellDataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"Section %i begins here!", section];
//}
//
//- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"Section %i ends here!", section];
//    
//}

- (void)setNavRigthBut:(NSString *)titleStr butImage:(UIImage *)butImage butHeigthImage:(UIImage *)heigtLigthImage select:(SEL)selector
{
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
    CGSize strSize = [titleStr sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    [rightBut setFrame:CGRectMake(0, 0, strSize.width+10, 30)];
    if(butImage)[rightBut setFrame:CGRectMake(0, 0, butImage.size.width, butImage.size.height)];
    if(butImage)[rightBut setImage:butImage forState:UIControlStateNormal];
    if(heigtLigthImage)[rightBut setImage:heigtLigthImage forState:UIControlStateHighlighted];
    if(titleStr)[rightBut setTitle:titleStr forState:UIControlStateNormal];
    [rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
}

- (void)setNavLeftBut
{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"return_2.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonPressed)];
    [image addGestureRecognizer:tap];
    
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 165,44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:NavigationTitleFont];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    self.navigationItem.titleView = label;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refreshData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreData];
}

- (void)refreshFinish
{
    [self refreshTable];
    
}

- (void)loadMoreFinish
{
    [self loadMoreDataToTable];
}

- (void)loadMoreData
{
    
}

- (void)refreshData
{
}


@end
