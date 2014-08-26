//
//  MMResultsViewController.m
//  Hackathon
//
//  Created by Roberto on 11/8/13.
//  Copyright (c) 2013 Medallia. All rights reserved.
//

#import "MMResultsViewController.h"
#import "MMData.h"

@interface MMResultsViewController ()

@end

@implementation MMResultsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
		//self.className = @"Response";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"JobFair"];
	
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
	
    [query orderByDescending:@"createdAt"];
	
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
	
    // Configure the cell to show todo item with a priority at the bottom
	NSMutableString *text = [NSMutableString string];
	for (NSString *key in [MMData sharedData].titles) {
		if ([text length] > 0)
			[text appendString:@" - "];
		[text appendFormat:@"%@", [object objectForKey:key]];
	}
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created at: %@",
                                 object.createdAt];
	
    return cell;
}
@end
