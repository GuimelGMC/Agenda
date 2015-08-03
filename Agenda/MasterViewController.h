//
//  MasterViewController.h
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) UISearchController *searchController;

@end

