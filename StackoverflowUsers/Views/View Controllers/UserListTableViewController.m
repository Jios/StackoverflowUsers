//
//  UserListTableViewController.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "UserListTableViewController.h"
#import "UserViewModel.h"
#import "SelfMacros.h"
#import "Colors.h"
#import "UIImageView+NWHttps.h"
#import "UserTableViewCell.h"
#import "TitleView.h"



@interface UserListTableViewController ()
<
    UISearchResultsUpdating
>

@property (nonatomic, strong) UserViewModel *userViewModel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UISearchController *searchController;

@end



@implementation UserListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItems];
    [self setupTableView];
    
    [self updateTableViewWithUserNumber: self.userViewModel.numberOfUsers];
    
    [self fetchUsers];
}


// MARK: - # setup

-(void)setupNavigationItems
{
    self.navigationItem.titleView = [[TitleView alloc] initWithImage: [UIImage imageNamed: @"stackoverflow"]
                                                               title: @"Users"];
    
    UIBarButtonItem *sortingButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"sorting"]
                                                                      style: UIBarButtonItemStylePlain
                                                                     target: self
                                                                     action: @selector(sortingButtonTouched)];
    self.navigationItem.rightBarButtonItem = sortingButton;
    self.navigationItem.rightBarButtonItem.tintColor = kStackOverflowColor;
}

-(void)setupTableView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    self.tableView.backgroundView  = self.activityIndicatorView;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}


// MARK: - # update

-(void)updateTableViewWithUserNumber: (NSInteger)number
{
    if (number == 0)
    {
        [self.activityIndicatorView startAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        [self.activityIndicatorView stopAnimating];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


// MARK: - # selector

-(void)sortingButtonTouched
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Sort users by"
                                                                   message: nil
                                                            preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reputationAction = [UIAlertAction actionWithTitle: @"Reputation"
                                                               style: UIAlertActionStyleDefault
                                                             handler: ^(UIAlertAction * action) {
                                                                 
                                                                 [self.userViewModel sortByReputation];
                                                             }];
    UIAlertAction *badgeScoreAction = [UIAlertAction actionWithTitle: @"Badge Score"
                                                               style: UIAlertActionStyleDefault
                                                             handler: ^(UIAlertAction * action) {
                                                                 
                                                                 [self.userViewModel sortByBadgeScore];
                                                             }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"Cancel"
                                                           style: UIAlertActionStyleCancel
                                                         handler: nil];
    
    [alert addAction: reputationAction];
    [alert addAction: badgeScoreAction];
    [alert addAction: cancelAction];
    
    [self presentViewController: alert
                       animated: YES
                     completion: nil];
}


// MARK: - # getter

-(UserViewModel *)userViewModel
{
    if (!_userViewModel)
    {
        weakify(self);
        
        _userViewModel = [[UserViewModel alloc] initWithUpdateBlock: ^{
            
            strongify(self);
            [self updateTableViewWithUserNumber: self.userViewModel.numberOfUsers];
            [self.tableView reloadData];
        }
                                                         errorBlock: ^(NSError * _Nonnull error) {
                                                             // TODO: handle error from UserModelView
                                                         }];
    }
    
    return _userViewModel;
}

-(UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController: nil];

        _searchController.searchResultsUpdater                 = self;
        _searchController.searchBar.placeholder                = @"Search Users";
        _searchController.obscuresBackgroundDuringPresentation = NO;
    }
    
    return _searchController;
}


// MARK: - # fetch

-(void)fetchUsers
{
    [self.userViewModel fetchUsers];
}


// MARK: - # UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.userViewModel filterUsersForName: searchController.searchBar.text];
}


// MARK: - # Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.userViewModel.numberOfUsers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"userTableViewCell"
                                                              forIndexPath: indexPath];
 
    NSInteger index = indexPath.row;
    [cell setGravatarURL: [self.userViewModel profileURLAtIndex: index]];
    [cell setName: [self.userViewModel nameAtIndex: index]];
    [cell setReputation: [self.userViewModel reputationAtIndex: index]];
    
    [cell.goldMetalView setMetals: [self.userViewModel numberOfGoldsAtIndex: index]
                             type: GoldMetal];
    [cell.silverMetalView setMetals: [self.userViewModel numberOfSilversAtIndex: index]
                               type: SilverMetal];
    [cell.bronzeMetalView setMetals: [self.userViewModel numberOfBronzesAtIndex: index]
                               type: BronzeMetal];
    
    float score = [self.userViewModel badgeScoreAtIndex: index];
    [cell.scoreBarView setScore: score];
    
    return cell;
}

-(void)         tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath
                             animated: YES];
}



@end
