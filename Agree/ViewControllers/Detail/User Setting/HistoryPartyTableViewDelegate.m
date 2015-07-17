//
//  HistoryPartyTableViewDelegate.m
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "HistoryPartyTableViewDelegate.h"

#import "Model_Party.h"
#import "GroupPartyTableViewCell.h"
@implementation HistoryPartyTableViewDelegate




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Model_Party *theParty = [self.schAry objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"HISTORYPATYCELL";
    
    GroupPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[GroupPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell initWithParty:theParty];
    return cell;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.schAry.count) {
        return self.schAry.count;
    }
    return 0;
}

@end
