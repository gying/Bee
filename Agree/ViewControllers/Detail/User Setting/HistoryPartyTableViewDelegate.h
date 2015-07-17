//
//  HistoryPartyTableViewDelegate.h
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>

@interface HistoryPartyTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *schAry;

@end
